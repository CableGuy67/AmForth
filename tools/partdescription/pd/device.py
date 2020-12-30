
import re
from convert_number import *

#################### DEvice Information ++++
def format_device_asm(d):
   partname = d.attributes['name'].value
   defname = ""
   if re.search("atmega", partname.lower()):
    defname = "m"+partname[6:]
   if re.search("at90", partname.lower()):
    defname = partname[4:].lower()
   f = ".nolist\n include \"%sdef.inc\"\n.list\n" % defname
   for mr in d.getElementsByTagName("address-space"):
       memtype = mr.attributes["id"].value.lower()
       if memtype == "prog":
         f += "FLASHSTART = %d\n" % convert_number(mr.attributes["start"].value)
         f += "FLASHSIZE  = %d\n" % convert_number(mr.attributes["size"].value)
       if memtype == "eeprom":
         f += "EEPROMSIZE = %d\n" % convert_number(mr.attributes["size"].value)
       if memtype == "data":
         f += "RAMEND = %d\n" % convert_number(mr.attributes["size"].value)
         for ram in mr.getElementsByTagName("memory-segment"):
           mstype = ram.attributes["type"].value
           msname = ram.attributes["name"].value
           if mstype == "ram":
             f += "%sSTART = %d\n" % (msname, convert_number(ram.attributes["start"].value))
             f += "%sSIZE = %d\n" % (msname, convert_number(ram.attributes["size"].value))
   return f
#    print ASM ".equ SPMEN = SELFPRGEN\n" if $needsdef{"SPMEN"} == 1;
#    print ASM ".equ SPMCSR = SPMCR\n"    if $needsdef{"SPMCSR"} == 1;
#    print ASM ".equ EEPE = EEWE\n"       if $needsdef{"EEPE"} == 1;
#    print ASM ".equ EEMPE = EEMWE\n"     if $needsdef{"EEMPE"}==1;
#    print ASM "\n; controller data area, environment query mcu-info\n";
#    print ASM "mcu_info:\n";
#    print ASM "mcu_ramsize:\n\t.dw $ramsize\n";
#    print ASM "mcu_eepromsize:\n\t.dw $esize\n";
#    print ASM "mcu_maxdp:\n\t.dw $maxdp \n";
#    print ASM "mcu_numints:\n\t.dw $number\n";
#    print ASM "mcu_name:\n\t". fmt_str($partname, "%2d")."\n";
#    print ASM ".set codestart=pc\n";

def format_device_py(d):
   partname = d.attributes['name'].value
   f = "# Partname %s\n\nMCUREGS = {\n" % d.attributes['name'].value
   return f

def end_device_py():
   f = "\n\t  '__amforth_dummy':'0'\n}\n";
   return f
