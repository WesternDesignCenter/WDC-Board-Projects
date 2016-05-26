REM Make example1 for the W65c816
REM 01/12/2004

del *.bin
del *.obj
del *.lst

WDC816AS -g -l  -DUSING_816 W65C816S_Demo
WDCLN -g -sz -t W65C816S_Demo
WDCDB.exe
pause