REM LEDP72 Demo for the W65C265SXB
REM 12/13/2016

del *.bin
del *.obj
del *.lst

WDC816AS -g -l -DUSING_816 8LED_P4xAH.asm
WDCLN -g -sz -t -HI 8LED_P4xAH
WDCLN -g -sz -t -HM28 8LED_P4xAH
WDCLN -g -sz -t -HZ 8LED_P4xAH
easysxb.exe
pause
