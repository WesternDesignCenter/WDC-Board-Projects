REM Gettings Started Example for the W65C02EDU
REM 09/20/2022

del *.bin
del *.obj
del *.lst

WDC02AS -g -l -DUSING_02 EDUGS_FLASH.asm
WDCLN -g -sz -t -HZ EDUGS_FLASH
REM WDCDB.exe
C:\wdc\tools\bin\emc_uploader_term.py EDUGS_FLASH.bin -m write -k -x -t
pause
