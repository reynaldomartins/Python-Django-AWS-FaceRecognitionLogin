from django.shortcuts import render
from django.views.generic import View
from django.contrib.auth.views import LoginView

from django.db import connections
from django.db.utils import OperationalError

from django.conf import settings

from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator

from django.http import HttpResponse, HttpResponseRedirect, HttpRequest

from datetime import datetime
from random import randint
from time import sleep

from .models import *
from .forms import *

from .FaceRecognitionEmployeeSure import *

import boto3

# from django.contrib.auth.forms import AuthenticationForm

from io import BytesIO
from base64 import b64decode
import re
from django.core.files.images import ImageFile

def getLoggedUserId(request):
    if request.user:
        if request.user.is_authenticated:
            username = request.user.username
            if username:
                queryset = Employee.objects.all().filter(username=username)
                if queryset:
                    return queryset[0].idemployee
    return None

def getUserByUserName(username):
    queryset = Employee.objects.all().filter(username=username)
    if queryset:
        return queryset[0]
    return None

def getSubjectEmployeeId(request):
    subjectEmployeeId = request.session.get("subjectEmployeeId", None)
    return subjectEmployeeId

def setSubjectEmployeeId(request,subjectEmployeeId):
    request.session["subjectEmployeeId"] = subjectEmployeeId

def addGlobalContext(context, request):
    loggedUser = Employee.objects.all().get(idemployee=getLoggedUserId(request))
    print(loggedUser.username)
    context["loggedUser"] = loggedUser
    context["subjectEmployee"] = Employee.objects.all().get(idemployee=getSubjectEmployeeId(request))
    context["subjectEmployeeImage"] = context["subjectEmployee"].getDefaultImage()
    context['isHR'] = loggedUser.isHR()
    return context

class loginViewClass(LoginView):
    template_name = 'registration/login.html'
    authentication_form = MyAuthenticationForm

    def post(self, request, *args, **kwargs):
        form = MyAuthenticationForm(data=request.POST)

        if form.is_valid():
            user = form.get_user()
            username = user.username
            tempUser = getUserByUserName(username)
            print("username {}".format(username))

            if username == "test":
                setSubjectEmployeeId(request,tempUser.idemployee)
                return super(loginViewClass, self).post(request, *args, **kwargs)

            picStr =  form.cleaned_data['image_data']
            print("picStr : {}".format(picStr[:30]))
            if picStr:
                base64_data = re.sub('^data:image/.+;base64,', '', picStr)
                byte_data = b64decode(base64_data)
                bytesio_data = BytesIO(byte_data)
                image = ImageFile(bytesio_data, name='temp.jpg')
            else:
                image = None

            if image:
                userImage = Image()
                userImage.employee = tempUser
                userImage.typeimage = "A"
                userImage.date_time = datetime.now()
                userImage.image = image
                userImage.save()

                if hasattr(settings,'AWS_STORAGE_BUCKET_NAME'):
                    s3_client = boto3.client('s3')
                    s3_location = os.path.join("media",userImage.image.name)
                    s3_client.download_file('empsure-static-media', s3_location, 'temp2.jpg')
                    pathImage = 'temp2.jpg'
                else:
                    pathImage = os.path.join(settings.MEDIA_ROOT,userImage.image.name)

                label, confidence = faceVerification(pathImage)

                if label != tempUser.idemployee:
                    message = "The picture taken is not a recognizable face" if label == -1 else "The picture taken does not match the face of the user"
                    context = { "message" : message }
                    userImage.resultauthentication = -1
                    userImage.save()
                    return render(request, "empsureApp/index.html", context=context)

                userImage.resultauthentication = confidence
                userImage.save()

            setSubjectEmployeeId(request,tempUser.idemployee)
        return super(loginViewClass, self).post(request, *args, **kwargs)

    def form_valid(self, form):
        return super(loginViewClass, self).form_valid(form)

class captureViewClass(View):
    @method_decorator(login_required)
    def get(self, request, *args, **kwargs):
        employee = Employee.objects.all().get(idemployee=getSubjectEmployeeId(request))
        capture_form = captureFormClass()
        context = { "employee" : employee,
                    "capture_form" : capture_form }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/capture.html", context=context)

    @method_decorator(login_required)
    def post(self, request, *args, **kwargs):
        employee = Employee.objects.all().get(idemployee=getSubjectEmployeeId(request))
        capture_form = captureFormClass(request.POST)
        num_images = len(capture_form.capture_images)
        num_images_ok = 0
        if capture_form.is_valid():
            for i in range(num_images):
                picStr =  capture_form.cleaned_data[capture_form.capture_images[i]]
                print("picStr : {}".format(picStr[:30]))
                if picStr:
                    base64_data = re.sub('^data:image/.+;base64,', '', picStr)
                    byte_data = b64decode(base64_data)
                    bytesio_data = BytesIO(byte_data)
                    image = ImageFile(bytesio_data, name='temp.jpg')

                    if image:
                        userImage = Image()
                        userImage.image = image
                        userImage.employee = employee
                        userImage.typeimage = "B"
                        userImage.date_time = datetime.now()
                        userImage.save()
                        if i == 0:
                            first_datetime = userImage.date_time.replace(microsecond=0)
                        num_images_ok += 1

            if num_images_ok == num_images:
                # Go over the previous baseline images of a user and delete them
                print(first_datetime)
                qset = Image.objects.all().filter(employee = employee, typeimage="B", date_time__lt=first_datetime)
                print(len(qset))
                for image in qset:
                    print(image.date_time)
                    if hasattr(settings,'AWS_STORAGE_BUCKET_NAME'):
                        nameimage = image.image.name
                        s3 = boto3.resource('s3')
                        s3.Object('empsure-static-media', 'media/' + nameimage).delete()
                    image.delete()

                # Retrain the faces
                training(os.path.join(settings.MEDIA_ROOT,"baseline"))

                return HttpResponseRedirect("/empsureApp/main/")
        context = { "employee" : employee,
                    "capture_form" : capture_form }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/capture.html", context=context)

class changeemployeeViewClass(View):

    @method_decorator(login_required)
    def get(self, request, *args, **kwargs):
        context = {}
        context = addGlobalContext(context, request)
        context['listEmployees'] = Employee.objects.all()
        return render(request, "empsureApp/changeEmployee.html", context=context)

    @method_decorator(login_required)
    def post(self, request, *args, **kwargs):

        keyEmployee = request.POST.get('key-employee')

        try:
            idemployee = int(keyEmployee.split(" ")[0].replace("#",""))
        except:
            return HttpResponseRedirect("../../empsureApp/changeemployee")

        setSubjectEmployeeId(request,idemployee)

        return HttpResponseRedirect("../../empsureApp/personal")

class personalViewClass(View):

    @method_decorator(login_required)
    def get(self, request, *args, **kwargs):
        employee = Employee.objects.all().get(idemployee=getSubjectEmployeeId(request))
        personal_form = personalFormClass(None, instance=employee)
        context = { "employee" : employee,
                    "personal_form" : personal_form }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/personal.html", context=context)

    @method_decorator(login_required)
    def post(self, request, *args, **kwargs):

        if 'cancel' in request.POST:
            return HttpResponseRedirect("../../empsureApp/personal")

        employee = Employee.objects.all().get(idemployee=getSubjectEmployeeId(request))
        personal_form = personalFormClass(request.POST, instance=employee)
        if personal_form.is_valid():
            employee = personal_form.save(commit=False)
            employee.save()

        context = { "employee" : employee,
                    "personal_form" : personal_form }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/personal.html", context=context)

class professionalViewClass(View):

    @method_decorator(login_required)
    def get(self, request, *args, **kwargs):
        employee = Employee.objects.all().get(idemployee=getSubjectEmployeeId(request))
        professional_form = professionalFormClass(None, instance=employee)
        context = { "employee" : employee,
                    "professional_form" : professional_form }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/professional.html", context=context)

    @method_decorator(login_required)
    def post(self, request, *args, **kwargs):

        if 'cancel' in request.POST:
            return HttpResponseRedirect("../../empsureApp/professional")

        employee = Employee.objects.all().get(idemployee=getSubjectEmployeeId(request))
        professional_form = professionalFormClass(request.POST, instance=employee)
        if professional_form.is_valid():
            employee = professional_form.save(commit=False)
            employee.save()

        context = { "employee" : employee,
                    "professional_form" : professional_form }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/professional.html", context=context)

class imagesViewClass(View):

    @method_decorator(login_required)
    def get(self, request, *args, **kwargs):
        employee = Employee.objects.get(pk=getSubjectEmployeeId(request))
        context = { 'lstNonDefaultImages' : employee.getNonDefaultImages() }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/images.html", context=context)

class payrollViewClass(View):

    @method_decorator(login_required)
    def get(self, request, *args, **kwargs):
        employee = Employee.objects.get(pk=getSubjectEmployeeId(request))
        listWages = employee.getWages().order_by('initialdate')
        listPayments = employee.getPayments().order_by('paymentdate')
        context = { 'listWages' : listWages,
                    'listPayments' : listPayments }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/payroll.html", context=context)

class bonusViewClass(View):

    @method_decorator(login_required)
    def get(self, request, *args, **kwargs):
        employee = Employee.objects.get(pk=getSubjectEmployeeId(request))
        listBonus = employee.getBonuses().order_by('bonusdate')
        context = { 'listBonus' : listBonus }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/bonus.html", context=context)

class vacationsViewClass(View):

    @method_decorator(login_required)
    def get(self, request, *args, **kwargs):
        employee = Employee.objects.get(pk=getSubjectEmployeeId(request))
        listVacationsDates = employee.getVacationDates().order_by('datevacation')
        listVacationsGrants = employee.getVacationGrants().order_by('year')
        context = { 'listVacationsDates' : listVacationsDates,
                    'listVacationsGrants' : listVacationsGrants }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/vacations.html", context=context)

class documentsViewClass(View):

    @method_decorator(login_required)
    def get(self, request, *args, **kwargs):
        employee = Employee.objects.all().get(idemployee=getSubjectEmployeeId(request))
        documentList =  employee.getDocuments().order_by('date_time')
        document_form = documentFormClass(None)
        context = { "employee" : employee,
                    "documentList" : documentList,
                    "document_form" : document_form }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/documents.html", context=context)

    @method_decorator(login_required)
    def post(self, request, *args, **kwargs):
        employee = Employee.objects.all().get(idemployee=getSubjectEmployeeId(request))

        if 'upload-doc'in request.POST:
            document_form = documentFormClass(request.POST, request.FILES)
            if document_form.is_valid():
                document = document_form.save(commit=False)
                document.document = request.FILES['document']
                document.date_time = datetime.now()
                document.employee =  employee
                document.save()
                document_form = documentFormClass()
        elif 'delete-doc' in request.POST:
            document = Document.objects.all().get(pk=request.POST['doc-tobe-deleted'])
            document.delete()
            document_form = documentFormClass()

        documentList =  employee.getDocuments().order_by('-date_time')
        context = { "employee" : employee,
                    "documentList" : documentList,
                    "document_form" : document_form }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/documents.html", context=context)

class auditViewClass(View):

    @method_decorator(login_required)
    def get(self, request, *args, **kwargs):
        employee = Employee.objects.all().get(idemployee=getSubjectEmployeeId(request))
        lstImage = employee.getAuthenticationImages()
        context = { "lstImage" : lstImage }
        context = addGlobalContext(context, request)
        return render(request, "empsureApp/audit.html", context=context)
