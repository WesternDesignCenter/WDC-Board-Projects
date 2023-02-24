REM 8LED Interface for the 65C02 Simulator
REM 09/14/2016

del *.bin
del *.obj
del *.lst

WDC02AS -g -l -DUSING_02 8LED_CCAH.asm
WDCLN -g -sz -t -HZ 8LED_CCAH
WDCSYM -A -L 8LED_CCAH.sym>8LED_CCAH_sym.txt
WDCOBJ 8LED_CCAH>8LED_CCAH_obj.txt
WDCDB.exe
pause
