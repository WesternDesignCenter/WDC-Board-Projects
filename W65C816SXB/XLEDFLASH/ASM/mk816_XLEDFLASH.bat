REM XLEDFLASH Demo for the W65C816SXB
REM 11/8/2019

del *.bin
del *.obj
del *.lst

WDC816AS -g -l -DUSING_816 XLEDFLASH.asm
WDCLN -g -sz -t -HZ XLEDFLASH
WDCDB.exe
pause
