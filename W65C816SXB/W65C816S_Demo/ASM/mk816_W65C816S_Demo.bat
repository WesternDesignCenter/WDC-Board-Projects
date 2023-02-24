REM 8LED Interface for the W65C02SXB
REM 09/14/2016

del *.bin
del *.obj
del *.lst

WDC02AS -g -l -DUSING_816 W65C816S_Demo.asm
WDCLN -g -sz -t -HZ W65C816S_Demo
WDCDB.exe
pause
