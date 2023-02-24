REM HelloWorld Demo for the W65C02SXB
REM 11/8/2019

del *.bin
del *.obj
del *.lst

WDC02AS -g -l -DUSING_SXB_02 HelloWorld.asm
WDCLN -g -sz -t -HZ HelloWorld
WDCDB.exe
pause
