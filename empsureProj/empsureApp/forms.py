from django import forms
from django.forms import ModelChoiceField
from django.forms import ValidationError
from django.core import validators
from django.contrib.admin.widgets import AdminDateWidget
from datetime import datetime, timedelta
from .models import *

from django.contrib.auth.forms import AuthenticationForm

# from django.contrib.auth.models import User

class MyAuthenticationForm(AuthenticationForm):
    image_data = forms.CharField(widget=forms.HiddenInput(), required=True,
                        error_messages={'required': 'YOU NEED TO TAKE A PHOTO FOR LOGIN AUTHETICATION' })

    def __init__(self, *args, **kwargs):
        super(MyAuthenticationForm, self).__init__(*args, **kwargs)

class captureFormClass(forms.Form):
    capture_image0 = forms.CharField(widget=forms.HiddenInput(), required=True)
    capture_image1 = forms.CharField(widget=forms.HiddenInput(), required=True)
    capture_image2 = forms.CharField(widget=forms.HiddenInput(), required=True)
    capture_image3 = forms.CharField(widget=forms.HiddenInput(), required=True)
    capture_image4 = forms.CharField(widget=forms.HiddenInput(), required=True)
    capture_images = []

    def __init__(self, *args, **kwargs):
        super(captureFormClass, self).__init__(*args, **kwargs)
        self.capture_images = [ 'capture_image0','capture_image1','capture_image2',
                                'capture_image3','capture_image4'
                                ]

class DateInput(forms.DateInput):
    input_type = 'date'

class personalFormClass(forms.ModelForm):
    firstname = forms.CharField(widget=forms.TextInput, label="First Name", required=True)
    lastname = forms.CharField(widget=forms.TextInput, label="Last Name", required=True)
    birthdate = forms.DateField(widget=DateInput(), label="Birth Date", required=True)
    contractinitialdate = forms.DateField(widget=DateInput(), label="Contract Initial Date", required=True)
    contractfinaldate = forms.DateField(widget=DateInput(), label="Contract Final Date", required=False)

    class Meta:
        model = Employee
        fields = ('firstname','lastname','birthdate','contractinitialdate','contractfinaldate')

    def is_valid(self):
        valid = super().is_valid()
        firstname = self.cleaned_data['firstname']
        lastname = self.cleaned_data['lastname']
        # This is a Creation
        if self.instance.pk == None:
            if Employee.objects.all().filter(firstname = firstname, lastname = lastname):
                self.add_error('firstname',"{} {} already registered !".format(firstname, lastname))
                return False
        # This is an Update
        else:
            pass
        return valid

    def clean_birthdate(self):
        birthdate = self.cleaned_data['birthdate']
        today = datetime.now().date()
        sixteen_years_before = today.replace(year=today.year - 16)
        if birthdate > sixteen_years_before:
                raise ValidationError("We are not supposed to hire somebody younger than 16 years old")
        return birthdate

class professionalFormClass(forms.ModelForm):
    firstname = forms.CharField(widget=forms.TextInput, label="First Name", required=True)
    lastname = forms.CharField(widget=forms.TextInput, label="Last Name", required=True)
    birthdate = forms.DateField(widget=DateInput(), label="Birth Date", required=True)
    contractinitialdate = forms.DateField(widget=DateInput(), label="Contract Initial Date", required=True)
    contractfinaldate = forms.DateField(widget=DateInput(), label="Contract Final Date", required=False)

    class Meta:
        model = Employee
        fields = ('firstname','lastname','birthdate','contractinitialdate','contractfinaldate')

    def clean_contractintialdate(self):
        contractinitialdate = self.cleaned_data['contractinitialdate']
        today = datetime.now().date()
        if contractinitialdate > today + timedelta(months=1):
                raise ValidationError("You cannot register a employee with more than one month in advance")
        return contractinitialdate

    def clean(self):
        cleaned_data = super(professionalFormClass, self).clean()
        contractinitialdate = cleaned_data['contractinitialdate']
        contractfinaldate = cleaned_data['contractfinaldate']
        if contractfinaldate:
            if contractinitialdate > contractfinaldate:
                    raise ValidationError("Final contract date cannot be before the initial date")

class imagesFormClass(forms.ModelForm):
    pass

class payrollFormClass(forms.ModelForm):
    pass

class bonusFormClass(forms.ModelForm):
    pass

class vacationsFormClass(forms.ModelForm):
    pass

class Documenttype_ModelChoiceField(ModelChoiceField):
    def label_from_instance(self, obj):
        return "{}".format(obj.type)

# Improvements - https://stackoverflow.com/questions/45172396/validating-upload-file-type-in-django
class documentFormClass(forms.ModelForm):
    document = forms.FileField(widget=forms.FileInput, label="Upload Document", required=True)
    documenttype = Documenttype_ModelChoiceField(queryset=Documenttype.objects.all(), label="Document Type", required=True, to_field_name="type")
    title = forms.CharField(widget=forms.TextInput, label="Title", required=True)
    comment = forms.CharField(widget=forms.Textarea(attrs={'cols': 60, 'rows': 5}), label="Comment", required=False)

    class Meta:
        model = Document
        fields = ('document','documenttype','title','comment')

class auditFormClass(forms.ModelForm):
    pass
