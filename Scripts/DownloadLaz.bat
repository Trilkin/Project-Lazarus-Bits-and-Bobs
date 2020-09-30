@ECHO off
cls
echo    Created on September 29, 2020
echo.
echo    Welcome to the semi-easy updater and installer for Project Lazarus.
echo    This file should have only been downloaded via the script available on Trilkin's GitHub.
echo    If you received this file any other way, please delete it and go to
echo    https://github.com/Trilkin/Project-Lazarus-Bits-and-Bobs to download the base script instead.
echo.
echo    It is recommended that you also take a peek at the readme for caveats and information about
echo    the three .exes that come with this package.
echo.
goto savefilecheck

:savefilecheck
if exist InstallerVars.bat (
    ren InstallerVars.bat InstallerVars
)
if exist InstallerVars goto loadvars
goto lazfolder

:loadvars
if exist InstallerVars.bat ren InstallerVars.bat InstallerVars.bak
ren InstallerVars InstallerVars.bat
call installervars
:loadvarsa
echo.
echo    It looks like you've already run this script.
echo    Project Lazarus folder: %lazfolder%
echo.
choice /N /C:YN /m "Would you like to change this? [Y/N]" %1
if ERRORLEVEL ==2 goto newinstallprompt
if ERRORLEVEL ==1 goto lazfolder
echo I didn't understand that.
goto loadvarsa

:lazfolder
echo.
echo    Be default, all client and updated files are copied to /Project Lazarus/ in the same folder as this batch.
echo.
set /p "lazfolder=Enter a different folder if you'd like to change this or just hit enter to accept. [ex. C:\EQ1\ProjLaz] "
if "%lazfolder%"=="" set "lazfolder=Project Lazarus"
goto verifyfolder

:newinstallprompt
echo.
echo    I will download any files you need. If you still have the Project Lazarus.zip, and you would like, I will also reuse it.
echo    If you just want to update the string and spells files, hit n 'to' this prompt.
echo.
choice /N /C:YN /m "Would you like to (re)install Project Lazarus? [Y/N]" %1
if ERRORLEVEL ==2 goto updateprompt
if ERRORLEVEL ==1 goto checkclient
echo I didn't understand that.
goto updateprompt

:updateprompt
echo.
echo    I can download and install any updated text files for you.
echo.
choice /N /C:YN /m "Would you like to update the spells and database strings files? [Y/N]" %1
if ERRORLEVEL ==2 goto mq2prompt
if ERRORLEVEL ==1 goto textupdates
echo I didn't understand that.
goto updateprompt

:verifyfolder
echo.
echo    Project Lazarus Folder: %lazfolder%
echo.
choice /N /C:YN /m "Is this okay? [Y/N]" %1
if ERRORLEVEL ==2 goto lazfolder
if ERRORLEVEL ==1 goto newinstallprompt
echo I didn't understand that.
goto newinstallprompt

:textupdates
echo.
If exist spells_us.zip DEL spells_us.zip
If exist dbstr_us.txt DEL dbstr_us.txt
wget http://192.99.254.193:3000/download/spells -O spells_us.zip
wget https://cdn.discordapp.com/attachments/573969966844346368/742141757692837928/dbstr_us.txt
7za e -o"%lazfolder%" -y spells_us.zip
if exist dbstr_us.txt move /Y dbstr_us.txt "%lazfolder%"
goto zoneupdates

:mq2prompt
echo.
echo    I can download MQ2, E3, and the updates in Sirhopsalot's GitHub repo into a unified package.
echo    I will not move these anywhere for the sanity of people who edit the macro files for their own purposes.
echo    They will instead be downloaded to /E3_RoF2/ in the same folder as this script for you to move manually.
echo.
choice /N /C:YN /m "Would you like me to download MQ2 and E3? [Y/N]" %1
if ERRORLEVEL ==2 goto 4gbpatchprompt
if ERRORLEVEL ==1 goto mq2download
echo I didn't understand that.
goto mq2prompt

:mq2download
echo.
if exist E3_RoF2_7.zip del E3_RoF2_7.zip
if exist master.zip del master.zip
IF EXIST E3_RoF2 rmdir /S /Q E3_RoF2
goodls_windows_386.exe -u https://drive.google.com/file/d/0B4A1w5r540xFbmVTTG5oX01lR0E/view
7za x E3_RoF2_7.zip
wget https://github.com/sirhopsalot/lazarus_mq2_e3/archive/master.zip
7za x master.zip
xcopy /E /Y lazarus_mq2_e3-master E3_RoF2
rmdir /S /Q lazarus_mq2_e3-master
goto 4gbpatchprompt

:4gbpatchprompt
if "%newinstall%"=="" GOTO cleanup
echo.
echo    I can download and apply the 4GB expansion patch for EQ1.
echo    This patch will reduce crashing when zoning, but may cause issues on machines with less than 4gb of physical ram.
echo.
choice /N /C:YN /m "Would you like to download and apply the 4GB Patch? [Y/N]" %1
IF ERRORLEVEL ==2 goto cleanup
IF ERRORLEVEL ==1 goto 4gbdownload
echo I didn't understand that.
goto 4gbpatchprompt

:4gbdownload
echo.
wget https://ntcore.com/files/4gb_patch.zip
7za x 4gb_patch.zip
4gb_patch.exe "%lazfolder%\eqgame.exe"
goto cleanup

:checkclient
set "newinstall=1"
if exist "Project Lazarus.zip" goto checkclienta
goto downloadclient
:checkclienta
echo.
echo    It looks like you've already downloaded the client before. We can skip downloading it if you'd like.
echo    Choosing Y to this option will DELETE Project Lazarus.zip. If you want to keep it, move or copy it before you continue.
echo.
choice /N /C:YN /m "Are you sure you want to redownload the client? [Y/N]" %1
IF ERRORLEVEL ==2 goto unpackclient
IF ERRORLEVEL ==1 goto downloadclient
echo I didn't understand that.
goto checkclienta

:downloadclient
If exist "Project Lazarus.zip" del "Project Lazarus.zip"
echo.
echo    Now downloading the client.
echo    The client is 8gb large, so this will likely take a little while.
echo.
goodls_windows_386.exe -u https://drive.google.com/file/d/1XOdC4uP7Eh_i-UISB1RfqCyl7X0rr6Ub/
echo.
goto unpackclient

:unpackclient
if not exist "%lazfolder%" goto unpackclienta
echo.
echo    The folder you want to install the client in already exists.
echo    If you continue, I will DELETE the contents of the folder. This includes any custom UI files and your layouts.
echo    If you'd like to preserve any user-generated data like this, do so before continuing.
echo.
choice /N /C:YN /m "Are you sure you want to unpack the client [Y/N]" %1
IF ERRORLEVEL ==2 goto downloadclient
IF ERRORLEVEL ==1 goto unpackclienta
echo I didn't understand that.
goto checkclienta

:unpackclienta
echo.
echo    Now unpacking the client files to the folder you gave me earlier.
echo    This is an 8gb file, so this may take some time.
echo.
if exist "%lazfolder%" rmdir /s /q "%lazfolder%"
7za x "Project Lazarus.zip"
if "%lazfolder%"=="Project Lazarus" goto textupdates
ren "Project Lazarus" "%lazfolder%"
if exist "Start EQ1.bat" del "Start EQ1.bat"
(
    ECHO cd /d "%lazfolder%"
    ECHO start eqgame.exe patchme -h
)>>"Start EQ1.bat"
goto textupdates

:zoneupdates
if "%newinstall%"=="1" goto zoneupdatesa
echo.
echo    Project Lazarus has some updated zone files.
echo    As of right now, this only includes The Bazaar. You can skip this if you've already updated it.
echo.
choice /N /C:YN /m "Would you like to update your zone files? [Y/N]" %1
if ERRORLEVEL ==2 goto 4gbpatchprompt
IF ERRORLEVEL ==1 goto zoneupdatesa

:zoneupdatesa
if exist Bazaar.zip del Bazaar.zip
goodls_windows_386.exe -u https://drive.google.com/file/d/1_j-mSqa6pBvEM72rUMHsQTvVWmpY9XrB/
del "%lazfolder%\Bazaar*"
7za e -o"%lazfolder%" -y Bazaar.zip
if "%newinstall%"=="1" goto 4gbpatchprompt
goto cleanup

:cleanup
if exist Bazaar.zip del Bazaar.zip
if exist E3_RoF2_7.zip del E3_RoF2_7.zip
if exist master.zip del master.zip
If exist spells_us.zip DEL spells_us.zip
If exist dbstr_us.txt DEL dbstr_us.txt
if exist InstallerVars del InstallerVars
if exist InstallerVars.bat del InstallerVars.bat
if exist InstallerVars.bak del InstallerVars.bak
echo set "lazfolder=%lazfolder%">>InstallerVars
echo.
echo    The script is now finished. Scroll up and check for any errors you might've encountered.
echo    If this is a new installation, you can use the Play EQ1 batch file this script generated and play.
echo    You can also use my CreateBatches utility available on my GitHub at
echo    https://github.com/Trilkin/Project-Lazarus-Bits-and-Bobs
echo    to easily generate AutoLogin scripts for your team once you get MQ2 set up.
echo    Have fun. If this script gives you any issues, please open a ticket on the above GitHub
echo    or let me know in Discord.
echo.
pause
exit