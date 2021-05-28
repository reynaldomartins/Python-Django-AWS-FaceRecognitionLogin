# Create your models here.
# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
import os
from datetime import datetime
import random
from django.conf import settings

class Employee(models.Model):
    idemployee = models.AutoField(db_column='idEmployee', primary_key=True)
    firstname = models.CharField(db_column='firstName', max_length=45)
    lastname = models.CharField(db_column='lastName', max_length=45)
    birthdate = models.DateField(db_column='birthDate')
    contractinitialdate = models.DateField(db_column='contractInitialDate')
    contractfinaldate = models.DateField(db_column='contractFinalDate', blank=True, null=True)
    username = models.CharField(db_column='username', max_length=20)

    class Meta:
        managed = False
        db_table = 'tbemployee'

    def getDefaultImage(self):
        querySet = Image.objects.all().filter(employee=self,typeimage="B")
        if querySet:
            return querySet[0]
        else:
            None

    def getNonDefaultImages(self):
        querySet = Image.objects.all().filter(employee=self,typeimage="B")
        lstNonDefaultImage = []
        for image in querySet:
            lstNonDefaultImage.append(image)
        if lstNonDefaultImage:
            lstNonDefaultImage.pop(0)
        return lstNonDefaultImage

    def getAuthenticationImages(self):
        return Image.objects.all().filter(employee=self,typeimage="A").order_by('-date_time')

    def isHR(self):
        currentPosition = Position.objects.all().filter(employee=self, finaldate=None)
        if currentPosition:
            currentPositionType = currentPosition[0].positiontype.positiontype
            # print(currentPositionType)
            if currentPositionType == "HR Admin":
                return True
        return False

    def getDocuments(self):
        return Document.objects.all().filter(employee=self)

    def getBonuses(self):
        return Bonus.objects.all().filter(employee=self)

    def getWages(self):
        return Wage.objects.all().filter(employee=self)

    def getPayments(self):
        return Payment.objects.all().filter(employee=self)

    def getVacationDates(self):
        return VacationDate.objects.all().filter(employee=self)

    def getVacationGrants(self):
        return VacationGrant.objects.all().filter(employee=self)

class Bonus(models.Model):
    idbonus = models.AutoField(db_column='idBonus', primary_key=True)
    employee = models.ForeignKey('Employee', models.DO_NOTHING, db_column='idEmployee')
    bonusvalue = models.DecimalField(db_column='bonusValue', max_digits=10, decimal_places=2)
    bonusdate = models.DateField(db_column='bonusDate')

    class Meta:
        managed = False
        db_table = 'tbbonus'

def document_file_name(instance, infilename):
    outfilename = "%s-%s-%s-%s" % (instance.employee.idemployee,
                                    instance.documenttype.type, datetime.now().strftime("%Y%m%d-%H%M%S"), infilename)
    return os.path.join('document', outfilename)

class Document(models.Model):
    iddocument = models.AutoField(db_column='idDocument', primary_key=True)
    employee = models.ForeignKey('Employee', models.DO_NOTHING, db_column='idEmployee')
    documenttype = models.ForeignKey('Documenttype', models.DO_NOTHING, db_column='idDocumentType')
    document = models.FileField(db_column='nameDocument', blank=True,upload_to=document_file_name)
    date_time = models.DateTimeField()
    title = models.CharField(max_length=100, blank=True, null=True)
    comment = models.CharField(max_length=400, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tbdocument'

    def delete(self, *args, **kwargs):
        try:
            os.remove(os.path.join(settings.MEDIA_ROOT,self.document.name))
        except:
            pass
        super(Document,self).delete(*args,**kwargs)

class Documenttype(models.Model):
    iddocumenttype = models.AutoField(db_column='idDocumentType', primary_key=True)
    type = models.CharField(max_length=20)
    description = models.CharField(max_length=400)

    class Meta:
        managed = False
        db_table = 'tbdocumenttype'


class Employeesiteoperation(models.Model):
    employee = models.OneToOneField(Employee, models.DO_NOTHING, db_column='idEmployee', primary_key=True)
    siteoperation = models.ForeignKey('SiteOperation', models.DO_NOTHING, db_column='idSiteOperation')
    initialdate = models.DateField(db_column='initialDate')
    finaldate = models.DateField(db_column='finalDate', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tbemployeesiteoperation'
        unique_together = (('employee', 'siteoperation'),)


class Function(models.Model):
    idfunction = models.AutoField(db_column='idFunction', primary_key=True)
    employee = models.ForeignKey(Employee, models.DO_NOTHING, db_column='idEmployee')
    functiontype = models.ForeignKey('FunctionType', models.DO_NOTHING, db_column='idFunctionType')
    initialdate = models.DateField(db_column='initialDate')
    finaldate = models.DateField(db_column='finalDate', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tbfunction'


class FunctionType(models.Model):
    idfunctiontype = models.AutoField(db_column='idFunctionType', primary_key=True)
    functiontype = models.CharField(db_column='functionType', max_length=45)
    description = models.CharField(max_length=400, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tbfunctiontype'

def image_file_name(instance, filename):
    ext = filename.split('.')[-1]
    random_stamp = random.randrange(100000,999999)
    filename = "%s_%s_%s_%s_%s.%s" % (instance.employee.username,instance.employee.idemployee,
                                    instance.typeimage, datetime.now().strftime("%Y%m%d"), random_stamp, ext)
    if instance.typeimage == "A":
        return os.path.join('authentication', filename)
    else:
        return os.path.join('baseline', filename)

class Image(models.Model):
    idimage = models.AutoField(db_column='idImage', primary_key=True)
    employee = models.ForeignKey(Employee, models.DO_NOTHING, db_column='idEmployee')
    image = models.ImageField(db_column='nameImage', blank=True,upload_to=image_file_name)
    typeimage = models.CharField(db_column='typeImage', max_length=1)
    date_time = models.DateTimeField(db_column='date_time')
    resultauthentication = models.FloatField(db_column='resultAuthentication', blank=True, null=True)

    def delete(self, *args, **kwargs):
        try:
            # print(os.path.join(settings.MEDIA_ROOT,self.image.name))
            os.remove(os.path.join(settings.MEDIA_ROOT,self.image.name))
        except:
            pass
            # print(settings.MEDIA_ROOT)
            # print(self.image.name)
        super(Image,self).delete(*args,**kwargs)

    class Meta:
        managed = False
        db_table = 'tbimage'

class Payment(models.Model):
    idpayment = models.AutoField(db_column='idPayment', primary_key=True)
    employee = models.ForeignKey(Employee, models.DO_NOTHING, db_column='idEmployee')
    grosspayment = models.DecimalField(db_column='grossPayment', max_digits=10, decimal_places=2)
    discounts = models.DecimalField(max_digits=10, decimal_places=2)
    paymentdate = models.DateField(db_column='paymentDate')

    class Meta:
        managed = False
        db_table = 'tbpayment'


class Position(models.Model):
    idposition = models.AutoField(db_column='idPosition', primary_key=True)
    employee = models.ForeignKey(Employee, models.DO_NOTHING, db_column='idEmployee')
    positiontype = models.ForeignKey('PositionType', models.DO_NOTHING, db_column='idPositionType')
    initialdate = models.DateField(db_column='initialDate')
    finaldate = models.DateField(db_column='finalDate', blank=True, null=True)
    statusrh = models.IntegerField(db_column='statusRH', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tbposition'


class PositionType(models.Model):
    idpositiontype = models.AutoField(db_column='idPositionType', primary_key=True)
    positiontype = models.CharField(db_column='positionType', max_length=45)
    description = models.CharField(max_length=400, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tbpositiontype'


class SiteOperation(models.Model):
    idsiteoperation = models.AutoField(db_column='idSiteOperation', primary_key=True)
    city = models.CharField(max_length=45)
    country = models.CharField(max_length=45)
    description = models.CharField(max_length=400, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tbsiteoperation'


class VacationDate(models.Model):
    idvacationdate = models.AutoField(db_column='idVacationDate', primary_key=True)
    employee = models.ForeignKey(Employee, models.DO_NOTHING, db_column='idEmployee')
    datevacation = models.DateField(db_column='dateVacation')
    status = models.CharField(max_length=1, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tbvacationdate'

class VacationGrant(models.Model):
    idvacationgrant = models.AutoField(db_column='idVacationGrant', primary_key=True)
    employee = models.ForeignKey(Employee, models.DO_NOTHING, db_column='idEmployee')
    year = models.IntegerField()
    qtydays = models.IntegerField(db_column='qtyDays')

    class Meta:
        managed = False
        db_table = 'tbvacationgrant'

class Wage(models.Model):
    idwage = models.AutoField(db_column='idWage', primary_key=True)
    employee = models.ForeignKey(Employee, models.DO_NOTHING, db_column='idEmployee')
    wagevalue = models.DecimalField(db_column='wageValue', max_digits=10, decimal_places=2)
    initialdate = models.DateField(db_column='initialDate')
    finaldate = models.DateField(db_column='finalDate', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tbwage'
