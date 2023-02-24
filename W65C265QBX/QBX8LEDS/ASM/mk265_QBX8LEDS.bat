REM W65C265QBX QBX8LEDS.asm Code Example
REM 12/23/2016

del *.bin
del *.obj
del *.lst

WDC816AS -g -l -DUSING_816 QBX8LEDS.asm
WDCLN -g -sz -t -HI QBX8LEDS
WDCLN -g -sz -t -HM28 QBX8LEDS
WDCLN -g -sz -t -HZ QBX8LEDS
easysxb.exe
pause
