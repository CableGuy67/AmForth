
from convert_number import *

def get_all_interrupts(x):
  all_int = []
  for i in x.getElementsByTagName('interrupts').item(0).getElementsByTagName('interrupt'):
    idx = convert_number(i.attributes['index'].value)
    if int(idx)>0:
      all_int.append(i)
  return  all_int

def format_interrupt_forth(all_int):
  f = "\\ Interrupt Vectors"
  for i in all_int:
    idx = convert_number(i.attributes['index'].value)
    nam = i.attributes['name'].value
    cap = i.attributes['caption'].value
    f += "\n#%s constant %sAddr \\ %s" % (idx*2, nam, cap)
  f+="\n";
  return f

def format_interrupt_py(all_int):
  f = "# Interrupt Vectors"
  for i in all_int:
    idx = convert_number(i.attributes['index'].value)
    nam = i.attributes['name'].value
    cap = i.attributes['caption'].value
    f += "\n\t'%sAddr' : '#%s', # %s" % (nam, idx*2, cap)
  f+="\n";
  return f

def format_interrupt_asm(all_int):
  f = "; Interrupt Vectors\n.overlap"
  for i in all_int:
    idx = convert_number(i.attributes['index'].value)
    nam = i.attributes['name'].value
    cap = i.attributes['caption'].value
    f += "\n.org %d \n   rcall isr ; %s" % (idx*2, cap)
  f+="\n.nooverlap\n";
  return f
