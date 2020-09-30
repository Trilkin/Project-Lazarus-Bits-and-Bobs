@echo off
cls
echo.
echo    This script is to launch a single instance of EQ1 with an account of your choice.
echo    The primary purpose is to quickly recover from a crash, but can be used just to log in
echo    a single character for Bazaar or other purposes.
echo.
echo    First, we'll need to know your game folder. Once defined, it will save it
echo    for subsequent launches.
goto savecheck

:savecheck
if exist SavedFolder goto loadfolder
goto inputfolder

:loadfolder
ren SavedFolder SavedFolder.bat
call SavedFolder
del SavedFolder.bat
goto verifyfolder

:inputfolder
echo.
set /p "lazfolder=Where is your game folder? Do not include trailing slashes or quotes. [ex. C:\EQ1\Project Lazarus] "
if "lazfolder"=="" goto blankfolder
goto verifyfolder

:blankfolder
echo.
echo    The folder cannot be blank.
goto inputfolder

:verifyfolder
echo.
echo    Project Lazarus is located at %lazfolder%.
echo.
choice /N /C:YN /m "Is this okay?" %1
if ERRORLEVEL ==2 set "lazfolder=" & goto inputfolder
if ERRORLEVEL ==1 goto inputaccount
goto verifyfolder

:inputaccount
echo.
set /p "accountname=What is the name of the account you want to log in? "
if "accountname"=="" goto blankaccount
goto verifyaccount

:blankaccount
echo.
echo    The account name cannot be blank.
goto inputaccount

:verifyaccount
echo.
echo    The account name is %accountname%.
echo.
choice /N /C:YN /m "Is this okay?" %1
if ERRORLEVEL ==2 set "accountname=" & goto inputaccount
if ERRORLEVEL ==1 goto launch
goto verifyaccount

:launch
if exist SavedFolder del SavedFolder
echo set "lazfolder=%lazfolder%">>SavedFolder
echo.
echo    Now launching the game with your settings.
echo.
cd /d "%lazfolder%"
start eqgame.exe patchme -h /login:%accountname%
echo.
echo    Have fun. Hopefully it doesn't crash again.
echo.
timeout 5