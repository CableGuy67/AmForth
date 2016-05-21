
$27 Evalue i2c.pe.hwid

%00010000  Evalue lcd.En \ enable bit
%00100000  Evalue lcd.Rw \ read/write bit
%01000000  Evalue lcd.Rs \ register select bit

: i2c.c!pe ( v -- )
  i2c.lcd.hwid i2c.begin
  i2c.tx
  i2c.end
;

: i2c.lcd.pulse ( n -- )
  dup lcd.En or i2c.c!pe
      lcd.En invert an i2c.c!pe
;

: i2c.lcd.!4bit ( n -- )
  dup i2c.c!pe
      i2c.lcd.pulse
;

: i2c.lcd.send ( c mode -- )
  >r dup >< $0f and r@ or i2c.lcd.!4bit ( high )
            $0f and r> or i2c.lcd.!4bit ( low )
;

: i2c.lcd.cmd ( c -- )
  0 i2c.lcd.send 
;

: i2c.lcd.write ( c -- )
  lcd.Rs i2c.lcd.send
;
