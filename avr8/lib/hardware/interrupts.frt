\ initialize interrupt vectors

: initIntVectors
    #int 0 do
	['] noop i int!
    loop
;

\ dump irq counts
 : irqdump #int 0 do 
     i irq[]#    #4 .r space  \ addr
     i 1+        #2 .r space  \ int number
     i irq[]# c@    u. cr     \ count mod $FF
   loop
 ;
