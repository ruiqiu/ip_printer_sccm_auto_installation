REM Printer Install Script
REM 08182014
REM __Rui Qiu__

set Model=xxx
set Name=SPRINT01
set Driver="Gestetner MP C2051 PCL 6"
set IP=10.12.33.44
set Script=%WINDIR%\System32\Printing_Admin_Scripts\en-US

echo Copy Drivers
md "C:\Windows\Printers\%Name%"
IF exist "C:\Windows\Printers\%Name%" xCopy /E /Y %cd% "C:\Windows\Printers\%Name%"


:: Delete old printer 

CD %WINDIR%\system32
cscript %Script%\prnmngr.vbs -d -p "%Name%"

:: Deletes static port of previous printer, in case of mis-configuration
cscript %Script%\prnport.vbs -d -r IP_%IP%

:: Creates TCP/IP port with specified IP address

cscript %Script%\prnport.vbs -a -r IP_%IP% -h %IP% -o raw -n 9100

cscript %Script%\prnmngr.vbs -a -m %Driver% -h c:\windows\printers\%Name% -i c:\windows\printers\%Name%\%Model%\OEMSETUP.INF

cscript %Script%\prnmngr.vbs -a -p %Name% -m %Driver% -r "IP_%IP%"

cscript %Script%\prnmngr.vbs -t -p "%Name%"


echo Importing printer settings
rundll32 printui.dll,PrintUIEntry /Sr /n "%Name%" /a "C:\Windows\Printers\%Name%\PrinterSettings.dat"