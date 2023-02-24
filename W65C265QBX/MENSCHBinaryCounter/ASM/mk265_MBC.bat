REM W65C265QBX QBX8LEDS.asm Code Example
REM 12/23/2016

del *.bin
del *.obj
del *.lst

WDC816AS -g -l -DUSING_816 MBC.asm
WDCLN -g -sz -t -HI MBC
WDCLN -g -sz -t -HM28 MBC
WDCLN -g -sz -t -HZ MBC
easysxb.exe
pause
