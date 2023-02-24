REM W65C265QBX QBXLEDSCROLL.asm Code Example
REM 12/23/2016

del *.bin
del *.obj
del *.lst

WDC816AS -g -l -DUSING_816 QBXLEDSCROLL.asm
WDCLN -g -sz -t -HI QBXLEDSCROLL
WDCLN -g -sz -t -HM28 QBXLEDSCROLL
WDCLN -g -sz -t -HZ QBXLEDSCROLL
easysxb.exe
pause
