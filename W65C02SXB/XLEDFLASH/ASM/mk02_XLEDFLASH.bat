REM XLEDFLASH Demo for the W65C02SXB
REM 11/8/2019

del *.bin
del *.obj
del *.lst

WDC02AS -g -l -DUSING_02 XLEDFLASH.asm
WDCLN -g -sz -t -HZ XLEDFLASH
WDCDB.exe
pause
