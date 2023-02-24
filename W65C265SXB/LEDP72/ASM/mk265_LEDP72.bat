REM LEDP72 Demo for the W65C265SXB
REM 12/13/2016

del *.bin
del *.obj
del *.lst

WDC816AS -g -l -DUSING_816 LEDP72.asm
WDCLN -g -sz -t -HI LEDP72
WDCLN -g -sz -t -HM28 LEDP72
WDCLN -g -sz -t -HZ LEDP72
easysxb.exe
pause
