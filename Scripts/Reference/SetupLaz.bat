rem This script will download the latest updater/installer from my GitHub.
rem This is the only file you should run manually.
rem If you have any issues, let me know in Discord or open a ticket on my GitHub.
rem Have fun.
wget -O DownloadLaz.bat https://raw.githubusercontent.com/Trilkin/Project-Lazarus-Bits-and-Bobs/master/Scripts/DownloadLaz.bat
if exist DownloadLaz.bat DownloadLaz.bat
echo.
echo Pausing for errors.
echo.
pause