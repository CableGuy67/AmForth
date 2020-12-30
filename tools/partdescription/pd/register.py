
from convert_number import *

def get_registergroup_name_for_module(m):
  return m.getElementsByTagName('register-group').item(0)

def get_module(x, m):
  for md  in  x.getElementsByTagName('modules').item(0).getElementsByTagName('module'):
     if md.attributes['name'].value==m:
       return md

def format_register_forth(d):
  f = "\\ " + d.attributes['name'].value
  for reg in d.getElementsByTagName('register'):
     name=reg.attributes['name'].value
     capt=reg.attributes['caption'].value[:30]
     offs=convert_number(reg.attributes['offset'].value)
     f += "\n$%x constant %s \\ %s" % (offs, name, capt)
     for bf in reg.getElementsByTagName('bitfield'):
       bfname=bf.attributes['name'].value
       mask=convert_number(bf.attributes['mask'].value)
       capt=bf.attributes['caption'].value[:30]
       f += "\n  $%x constant %s_%s \\ %s" % (mask, name, bfname, capt)
       # f += "\n  $%x $%x bitmask: %s.%s \\ %s" % (offs, mask, name, bfname, capt)
  f+="\n";
  return f

def format_register_py(d):
  f = "\n# Module %s" % (d.attributes['name'].value)
  for reg in d.getElementsByTagName('register'):
     name=reg.attributes['name'].value
     capt=reg.attributes['caption'].value[:30]
     offs=convert_number(reg.attributes['offset'].value)
     f += "\n\t'%s' : '$%x', # %s" % (name, offs, capt)
     for bf in reg.getElementsByTagName('bitfield'):
       bfname=bf.attributes['name'].value
       mask=convert_number(bf.attributes['mask'].value)
       capt=bf.attributes['caption'].value[:30]
       f += "\n\t  '%s_%s': '$%x', # %s" % (name, bfname, mask, capt)
  f+="\n";
  return f

