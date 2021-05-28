from django import template

register = template.Library()

def define(val):
  return val;

def money(val):
    return "{:0,.2f}".format(float(val))

def subtract(value, arg):
    return "{:0,.2f}".format(float(value - arg))

def getfilename(value):
    return value.split("/")[-1]

register.simple_tag(define)
register.simple_tag(money)
register.simple_tag(subtract)
register.simple_tag(getfilename);
