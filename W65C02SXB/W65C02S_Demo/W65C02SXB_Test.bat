REM Make example1 for the W65c02
REM 10/28/2014

del *.bin
del *.obj
del *.lst

WDC02AS -g -l  -DUSING_02 W65C02S_Demo
WDCLN -g -sz -t W65C02S_Demo
WDCDB.exe 
REM WDCSYM -A -L W65C02S_Demo.sym>W65C02S_Demo_sym.txt
REM WDCOBJ exmpl1>exmpl1_obj.txt
pause