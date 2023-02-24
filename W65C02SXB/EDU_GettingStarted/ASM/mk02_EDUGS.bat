REM Gettings Started Example for the W65C02EDU
REM 09/20/2022

del *.bin
del *.obj
del *.lst

WDC02AS -g -l -DUSING_02 EDUGS.asm
WDCLN -g -sz -t -HZ EDUGS
WDCDB.exe
pause
