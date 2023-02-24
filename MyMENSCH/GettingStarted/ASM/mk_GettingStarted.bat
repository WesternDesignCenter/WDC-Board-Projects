REM Batch make file for the WDC Debugger
REM 09/14/2016

del *.bin
del *.obj
del *.lst

WDC02AS -g -l GettingStarted.asm
WDCLN -g -sz -t -HZ GettingStarted
rem WDCLN -g -sz -t -HI VIA_Test
WDCSYM -A -L GettingStarted.sym>GettingStarted_sym.txt
WDCOBJ GettingStarted>GettingStarted_obj.txt
C:\wdc\tools\bin\wdc_uploader_term.exe GettingStarted.bin -m write -x -v
rem C:\wdc\tools\bin\wdc_uploader_term.exe GettingStarted.bin -m write -k -x -v
rem - Use the line above if you have a build that runs with FLASH.  
pause
