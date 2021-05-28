from django.conf.urls import url, include
from django.urls import path

from empsureApp import views
# from .forms import LoginForm

app_name = 'empsureApp'

urlpatterns = [
    url(r'^main/$',views.personalViewClass.as_view(), name='mainURLName'),
    url(r'^changeemployee/$',views.changeemployeeViewClass.as_view(), name='changeEmployeeURLName'),
    url(r'^personal/$',views.personalViewClass.as_view(), name='personalURLName'),
    url(r'^professional/$',views.professionalViewClass.as_view(), name='professionalURLName'),
    url(r'^capture/$',views.captureViewClass.as_view(), name='captureURLName'),
    url(r'^images/$',views.imagesViewClass.as_view(), name='imagesURLName'),
    url(r'^payroll/$',views.payrollViewClass.as_view(), name='payrollURLName'),
    url(r'^bonus/$',views.bonusViewClass.as_view(), name='bonusURLName'),
    url(r'^vacations/$',views.vacationsViewClass.as_view(), name='vacationsURLName'),
    url(r'^documents/$',views.documentsViewClass.as_view(), name='documentsURLName'),
    url(r'^audit/$',views.auditViewClass.as_view(), name='auditURLName'),
    url(r'^login/$',views.loginViewClass.as_view(), name='loginURLName'),
]
