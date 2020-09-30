@ECHO OFF
SETLOCAL EnableDelayedExpansion
cls
:initialsetup
if exist "Play Laz" (
    ECHO.
    ECHO   The "Play Laz" folder already exists. This is likely because you've used this utility before.
    ECHO   We must delete this folder to avoid issues with writing the batch files. 
    ECHO   If there's anything in it you'd like to save, select N and back up whatever you need before continuing.
    ECHO.
    CHOICE /N /C:YN /m "Delete the Play Laz folder?" %1
    IF ERRORLEVEL ==2 GOTO nodeletion
    IF ERRORLEVEL ==1 rmdir /S /Q "Play Laz" & GOTO initialsetup
    ECHO    Please only use Y or N.
    GOTO initialsetup
)
IF NOT EXIST "Play Laz" (
    mkdir "Play Laz" 
) ELSE (
    GOTO initialsetup
)
GOTO checkexistingdata

:checkexistingdata
IF exist "SavedLazVars" GOTO foundsavefile
GOTO introduction

:foundsavefile
ECHO.
ECHO    You have existing data from the last time you ran this.
ECHO.
CHOICE /N /C:YN /m "Do you want to use it? You will be able to edit it later." %1
IF ERRORLEVEL ==2 GOTO plazfoldercollect
IF ERRORLEVEL ==1 GOTO callsavedvars
ECHO    Please only use Y or N.
GOTO foundsavefile

:callsavedvars
IF exist "SavedLazVars.bak" DEL SavedLazVars.bak
ren SavedLazVars SavedLazVars.bat
call SavedLazVars
ren SavedLazVars.bat SavedLazVars.bak
GOTO plazfoldercollect

:nodeletion
ECHO.
ECHO    Save what you'd like from the Play Laz folder, optionally delete or empty it, and start this batch file again when you're ready.
TIMEOUT 5
EXIT

:introduction
ECHO.
ECHO    FOR USE WITH PROJECT LAZARUS! MQ2AutoLogin files will not be usable on other servers. That said, it's easy to edit to work on anything, really.
ECHO.
ECHO    This file will dynamically create batch files that will do the following:
ECHO.
ECHO    1. Provide a single batch file to run and start the game.
ECHO    2. Provide different setups for multiple groups across any number of accounts.
ECHO    3. Provide MQ2AutoLogin files that will automatically be copied to autologin the groups you make.
ECHO.
GOTO plazfoldercollect

:plazfoldercollect
IF NOT "%plazfolder%"=="" GOTO plazfolderverify
ECHO    First, tell me the full path of your Project Lazarus folder. DO NOT use quotation marks even IF the folder has spaces in it. Include the trailing backslash.
ECHO.
SET /P "plazfolder=Where is Project Lazarus? e.x. C:\EQ1\Project Lazarus\ or D:\Surazal Tcejorp\: "
IF "%plazfolder%"=="" (
    ECHO.
    ECHO Please enter a folder name.
    GOTO plazfoldercollect
)
GOTO plazfolderverify

:plazfolderverify
ECHO.
ECHO    Project Lazarus folder: %plazfolder%
ECHO.
CHOICE /N /C:YN /m "Is this okay?" %1
IF ERRORLEVEL ==2 SET "plazfolder=" & GOTO plazfoldercollect
IF ERRORLEVEL ==1 GOTO mq2foldercollect
ECHO Please only use Y or N.
GOTO plazfoldercollect

:mq2foldercollect
IF NOT "%mq2folder%"=="" GOTO mq2folderverify
ECHO    Next, tell me the full path of your MacroQuest2 (plus E3) folder. DO NOT use quotation marks even IF the folder has spaces in it. Include the trailing backslash.
ECHO.
SET /P "mq2folder=Where is MacroQuest2? e.x. C:\TotallyNotMQ2\ or D:\You Arent Even A Real Journalism\: "
ECHO.
IF "%mq2folder%"=="" (
    ECHO.
    ECHO Please enter a folder name.
    GOTO mq2foldercollect
)
GOTO mq2folderverify

:mq2folderverify
ECHO.
ECHO    MacroQuest2 folder: %mq2folder%
ECHO.
CHOICE /N /C:YN /m "Is this okay?" %1
IF ERRORLEVEL ==2 SET "mq2folder=" & GOTO mq2foldercollect
IF ERRORLEVEL ==1 (
    SET "t1=0"
    SET "t2=0"
    GOTO teamlist
)
ECHO Please only use Y or N.
GOTO mq2foldercollect

:teamlist
IF NOT "!team[%t1%].name!"=="" (
    IF "!team[%t1%].name!"=="SCRIPTDUMMIED" (
        SET /a "t1=!t1!+1"
        GOTO teamlist
    )
    ECHO    Team %t1%: !team[%t1%].name!
    SET /a "t1=!t1!+1"
    SET /a "t2=!t2!+1"
    GOTO teamlist
)
GOTO teamlista

:teamlista
ECHO.
ECHO    You have %t2% teams.
IF %t1% EQU 0 (
    ECHO.
    ECHO    You should make one.
)
ECHO.
SET "ts1="
SET /P "ts1=[#=View Team] [n=New Team] [s=Save and Quit] "
IF "%ts1%"=="" ECHO    Please make a selection. & GOTO teamlista
IF "%ts1%"=="n" GOTO newteam
IF "%ts1%"=="s" (
    IF %t2% EQU 0 (
        ECHO.
        ECHO You have no teams to save!
        ECHO.
        GOTO teamlista
    )
GOTO saveteams
)
IF "!team[%ts1%].name!"=="" ECHO    That entry is invalid. & GOTO teamlista
IF "!team[%ts1%].name!"=="SCRIPTDUMMIED" ECHO    That entry is invalid. & GOTO teamlista
SET "a1=0"
SET "a2=0"
GOTO viewteam

:viewteam
ECHO.
ECHO    Team Name: !team[%ts1%].name!
ECHO    Team Description: !team[%ts1%].desc!
ECHO.

:viewteama
IF NOT "!team[%ts1%].account[%a1%].name!"=="" (
    IF "!team[%ts1%].account[%a1%].name!"=="SCRIPTDUMMIED" (
        SET /a "a1=!a1!+1"
        GOTO viewteama
    )
    ECHO    Account [Character] %a1%: !team[%ts1%].account[%a1%].name! [!team[%ts1%].account[%a1%].char!]
    SET /a "a1=!a1!+1"
    SET /a "a2=!a2!+1"
    GOTO viewteama
)
GOTO viewteamb

:viewteamb
ECHO.
ECHO    There are %a2% accounts on this team.
IF %a2% EQU 0 (
    ECHO.
    ECHO    You should add one.
)
SET "as1="
ECHO.
ECHO    Note: You cannot cancel out of adding an account once started.
ECHO          All account text is stored locally in plain text and will be visible on screen.
ECHO          Take proper precautions. This data is not sent anywhere.
ECHO.
SET /P "as1=[#=View Account] [a=Add Account] [d=Delete Team] [t=Team List] "
IF "%as1%"=="a" GOTO addaccount
IF "%as1%"=="d" (
    IF %a1% EQU 0 (
        ECHO.
        ECHO    There are no teams to delete!
        ECHO.
        GOTO viewteamb
    )
    GOTO deleteteam
)
IF "%as1%"=="t" (
    SET "t1=0"
    SET "t2=0"
    GOTO teamlist
)
IF "!team[%ts1%].account[%as1%].name!"=="" ECHO    That entry is invalid. & GOTO viewteamb
IF "!team[%ts1%].account[%as1%].name!"=="SCRIPTDUMMIED" ECHO    That entry is invalid. & GOTO viewteamb
GOTO viewaccount

:deleteteam
ECHO.
CHOICE /N /C:YN /m "Are you sure you want to delete team !team[%ts1%].name! and all of the accounts under it?" %1
IF ERRORLEVEL ==2 SET "a1=0" & GOTO viewteam
IF ERRORLEVEL ==1 GOTO deleteteama
ECHO Please only use Y or N.
GOTO deleteteam

:deleteteama
SET "team[%ts1%].name=SCRIPTDUMMIED"
SET "team[%ts1%].desc=SCRIPTDUMMIED"
SET "dta1=0"
GOTO deleteteamb

:deleteteamb
IF NOT "!team[%ts1%].account[%dta1%]!"=="" (
    SET "team[%ts1%].account[%dta1%].name=SCRIPTDUMMIED"
    SET "team[%ts1%].account[%dta1%].pass=SCRIPTDUMMIED"
    SET "team[%ts1%].account[%dta1%].char=SCRIPTDUMMIED"
    SET /a "dta1=!dta1!+1"
    GOTO deleteteamb
)
ECHO. Team deleted
SET "t1=0"
SET "t2=0"
GOTO teamlist

:viewaccount
ECHO.
ECHO    Account Name: !team[%ts1%].account[%as1%].name!
ECHO    Account Password: !team[%ts1%].account[%as1%].pass!
ECHO    Account Character: !team[%ts1%].account[%as1%].char!
ECHO.
SET "as2="
SET /p "as2=[e=Edit Account] [d=Delete Account] [a=Account List] "
IF "%as2%"=="e" GOTO editaccount
IF "%as2%"=="d" GOTO deleteaccount
IF "%as2%"=="a" SET "t2=0" & GOTO viewteam
ECHO    That entry is invalid. & GOTO viewaccount

:editaccount
ECHO.
SET "as3="
SET /p "as3=[n=Change Name] [p=Change Password] [c=Change Character] [b=Go Back] "
IF "%as3%"=="" ECHO    That entry is invalid. & GOTO editaccount
IF "%as3%"=="n" SET "asv=name" & GOTO setaccountvalue
IF "%as3%"=="p" SET "asv=pass" & GOTO setaccountvalue
IF "%as3%"=="c" SET "asv=char" & GOTO setaccountvalue
if "%as3%"=="b" GOTO viewaccount
ECHO    That entry is invalid. & GOTO editaccount

:setaccountvalue
ECHO.
IF "%asv%"=="name" SET "asvdesc=name"
IF "%asv%"=="pass" SET "asvdesc=password"
IF "%asv%"=="char" SET "asvdesc=character"
SET "as4="
SET /p "as4=What would you like to set the account %asvdesc% to? [c=Cancel] "
IF "%as4%"=="" ECHO    That entry is invalid. & GOTO setaccountvalue
IF "%as4%"=="c" GOTO viewaccount
SET "team[%ts1%].account[%as1%].%asv%=!as4!"
GOTO viewaccount

:deleteaccount
ECHO.
CHOICE /N /C:YN /m "Are you sure you want to delete account !team[%ts1%].account[%as1%].name!?" %1
IF ERRORLEVEL ==2 (
    SET "a1=0"
    SET "a2=0"
    GOTO viewteam
)
IF ERRORLEVEL ==1 GOTO deleteaccounta
ECHO Please only use Y or N.
GOTO deleteaccount

:deleteaccounta
SET "team[%ts1%].account[%as1%].name=SCRIPTDUMMIED"
SET "team[%ts1%].account[%as1%].pass=SCRIPTDUMMIED"
SET "team[%ts1%].account[%as1%].char=SCRIPTDUMMIED"
SET "a1=0"
SET "a2=0"
GOTO viewteam

:newteam
ECHO.
SET "nt1.name="
SET /p "nt1.name=What would you like to name this team? [c=Cancel] "
IF "!nt1.name!"=="c" (
    SET "t1=0"
    SET "t2=0"
    GOTO teamlist
)
IF "!nt1.name!"=="" ECHO    That entry is invalid. & GOTO newteam
IF "!nt1.name!"=="SCRIPTDUMMIED" (
    ECHO.
    ECHO    Cheeky. Don't do that.
    GOTO newteam
)
GOTO newteama
:newteama
SET "nt1.desc="
ECHO.
SET /p "nt1.desc=How would you like to describe this team? List of classes is a good option! [b=Go Back] "
IF "!nt1.desc!"=="b" GOTO newteam
IF "!nt1.desc!"=="" ECHO    That entry is invalid. & GOTO newteama
:newteamb
ECHO.
ECHO    Team Name: !nt1.name!
ECHO    Team Desc: !nt1.desc!
ECHO.
CHOICE /N /C:YN /m "Are these okay?" %1
IF ERRORLEVEL ==2 GOTO newteam
IF ERRORLEVEL ==1 SET "snt1=0" & GOTO savenewteam
ECHO Please only use Y or N.
GOTO newteamb

:savenewteam
IF NOT "!team[%snt1%].name!"=="" (
    IF "!team[%snt1%].name!"=="SCRIPTDUMMIED" (
        SET "team[%snt1%].name=!nt1.name!"
        SET "team[%snt1%].desc=!nt1.desc!"
        SET "t1=0"
        SET "t2=0"
        GOTO teamlist
    )
    SET /a "snt1=!snt1!+1"
    GOTO savenewteam
)
SET "team[%snt1%].name=!nt1.name!"
SET "team[%snt1%].desc=!nt1.desc!"
ECHO.
ECHO Let's add our first account to this team.
ECHO.
SET "a1=0"
SET "a2=0"
SET "newa1=0"
SET "ts1=%snt1%"
GOTO addaccount

:addaccount
IF %a1% GEQ 7 (
    ECHO.
    ECHO You are only allowed six active - plus one Bazaar trader - boxes on Project Lazarus at a time.
    ECHO.
    GOTO viewteam
)
ECHO.
SET /p "newa1.name=What is the account name you'll be logging in to? "
IF "!newa1.name!"=="" ECHO    That entry is invalid. & GOTO addaccount
IF "!newa1.name!"=="SCRIPTDUMMIED" (
    ECHO.
    ECHO    Cheeky. Don't do that.
    GOTO addaccount
)
ECHO.
SET /p "newa1.pass=What is the password for this account? "
IF "!newa1.pass!"=="" ECHO    That entry is invalid. & GOTO addaccount
ECHO.
SET /p "newa1.char=Which character will you be logging in? "
IF "!newa1.char!"=="" ECHO    That entry is invalid. & GOTO addaccount
:addaccounta
ECHO.
ECHO    Account Name: !newa1.name!
ECHO    Account Password: !newa1.pass!
ECHO    Account Character: !newa1.char!
ECHO.
CHOICE /N /C:YN /m "Are these okay?" %1
IF ERRORLEVEL ==2 GOTO addaccount
IF ERRORLEVEL ==1 SET "sna1=0" & GOTO saveaccount
ECHO Please only use Y or N.
GOTO addaccounta

:saveaccount
IF NOT "!team[%ts1%].account[%sna1%].name!"=="" (
    IF "!team[%ts1%].account[%sna1%].name!"=="SCRIPTDUMMIED" (
        GOTO saveaccounta
    )
    SET /a "sna1=!sna1!+1"
    GOTO saveaccount
)
GOTO saveaccounta

:saveaccounta
SET "team[%ts1%].account[%sna1%].name=!newa1.name!"
SET "team[%ts1%].account[%sna1%].pass=!newa1.pass!"
SET "team[%ts1%].account[%sna1%].char=!newa1.char!"
SET "a1=0"
SET "a2=0"
GOTO viewteam

:saveteams
SET "st1=0"
SET "st2=0"
SET "sa1=0"
GOTO saveteamsa

:saveteamsa
IF "!team[%st1%].name!"=="" GOTO writefiles
IF NOT "!team[%st1%].name!"=="" (
    IF "!team[%st1%].name!"=="SCRIPTDUMMIED" (
        SET /a "st1=!st1!+1"
        GOTO saveteamsa
    )
)
SET "team[%st2%].name=!team[%st1%].name!"
SET "team[%st2%].desc=!team[%st1%].desc!"
GOTO saveteamsb

:saveteamsb
SET "sta1=0"
SET "sta2=0"
GOTO saveteamsba

:saveteamsba
IF "!team[%st1%].account[%sta1%].name!"=="" GOTO saveteamsbc
IF NOT "!team[%st1%].account[%sta1%].name!"=="" (
    IF "!team[%st1%].account[%sta1%].name!"=="SCRIPTDUMMIED" (
        SET /a "sta1=!st1a!+1"
        GOTO saveteamsba
    )  
)
SET "team[%st2%].account[%sta2%].name=!team[%st2%].account[%sta1%].name!"
SET "team[%st2%].account[%sta2%].pass=!team[%st2%].account[%sta1%].pass!"
SET "team[%st2%].account[%sta2%].char=!team[%st2%].account[%sta1%].char!"
SET /a "sta1=!sta1!+1"
SET /a "sta2=!sta2!+1"
GOTO saveteamsba

:saveteamsbc
SET /a "st1=!st1!+1"
SET /a "st2=!st2!+1"
GOTO saveteamsa

:writefiles
SET "wt1=0"
SET "wa1=0"
GOTO writeplaylaz

:writeplaylaz
(
    ECHO @ECHO off
    ECHO cls
    ECHO :start
    ECHO echo.
)>>"Play Laz\Play Laz.bat"
GOTO writeplaylaza

:writeplaylaza
IF "!team[%wt1%].name!"=="" SET "wt1=0" & GOTO writeplaylazb
ECHO ECHO Team %wt1%: !team[%wt1%].name! [!team[%wt1%].desc!]>>"Play Laz\Play Laz.bat"
SET /a "wt1=!wt1!+1"
GOTO writeplaylaza

:writeplaylazb
(
    ECHO ECHO.
	ECHO set choice=
    ECHO set /p choice=Which team # would you like to log in? %1
    ECHO IF "%%choice%%"=="" ECHO    Please choose a team.
)>>"Play Laz\Play Laz.bat"
SET "wt1=0"
GOTO writeplaylazc

:writeplaylazc
IF "!team[%wt1%].name!"=="" SET "wt1=0" & GOTO writeplaylazd
ECHO IF "%%choice%%"=="%wt1%" GOTO team%wt1%>>"Play Laz\Play Laz.bat"
SET /a "wt1=!wt1!+1"
GOTO writeplaylazc

:writeplaylazd
(
    ECHO ECHO "%%choice%%" is not valid or undefined. Try again.
    ECHO goto start  
)>>"Play Laz\Play Laz.bat"
SET "wt1=0"
GOTO writeplaylaze

:writeplaylaze
IF "!team[%wt1%].name!"=="" SET "wt1=0" & GOTO writeplaylazf
(
    ECHO :team%wt1%
    ECHO start /min PLTeam%wt1%.bat
    ECHO goto cleanup
)>>"Play Laz\Play Laz.bat"
SET /a "wt1=!wt1!+1"
GOTO writeplaylaze

:writeplaylazf
(
    ECHO :cleanup
    ECHO echo.
    ECHO ECHO Keep this batch file open if you'd like to shut MQ2 and bcs2 when you're done.
    ECHO ECHO DO NOT PRESS K UNLESS YOU'RE READY TO STOP PLAYING.
    ECHO CHOICE /N /C:KS /m "Are you ready to [k]ill MQ2 and BCS2 or would you rather just [s]top this batch?"%1
    ECHO IF ERRORLEVEL ==2 goto stop
    ECHO IF ERRORLEVEL ==1 goto kill
    ECHO ECHO I don't understand what you did, so let's try that from the top.
    ECHO goto cleanup
    ECHO :stop
    ECHO ECHO Sure thing. Don't forget to close MQ2 and BCS2 on your own if you play on other servers!
    ECHO TIMEOUT 3
    ECHO exit
    ECHO :kill
    ECHO ECHO Killing the MQ2 and BCS2 processes. See you soon.
    ECHO TIMEOUT 3
    ECHO taskkill -im eqbcs2.exe
    ECHO taskkill -im MacroQuest2.exe
    ECHO exit
)>>"Play Laz\Play Laz.bat"
GOTO writeteambats

:writeteambats
SET "wt1=0"
SET "wa1=0"
GOTO writeteambatsa

:writeteambatsa
IF "!team[%wt1%].name!"=="" SET "wt1=0" & GOTO writeteambatsb
ECHO copy /Y "MQ2AutoLoginTeam%wt1%" "%mq2folder%MQ2AutoLogin.ini">>"Play Laz\PLTeam%wt1%.bat"
SET /a "wt1=!wt1!+1"
GOTO writeteambatsa

:writeteambatsb
IF "!team[%wt1%].name!"=="" SET "wt1=0" & GOTO writeteambatsc
(
    ECHO cd /D "%mq2folder%"
    ECHO start /min eqbcs2.exe
    ECHO start MacroQuest2.exe
    ECHO cd /D "%plazfolder%"
    ECHO TIMEOUT 3
)>>"Play Laz\PLTeam%wt1%.bat"
SET /a "wt1=!wt1!+1"
GOTO writeteambatsb

:writeteambatsc
IF "!team[%wt1%].name!"=="" SET "wt1=0" & GOTO writeteambatsd
IF "!team[%wt1%].account[%wa1%].name!"=="" (
    SET "wa1=0"
    SET /a "wt1=!wt1!+1"
    GOTO writeteambatsc
)
IF %wa1% EQU 3 ECHO TIMEOUT 60>>"Play Laz\PLTeam%wt1%.bat"
ECHO start eqgame.exe patchme -h /login:!team[%wt1%].account[%wa1%].name!>>"Play Laz\PLTeam%wt1%.bat"
SET /a "wa1=!wa1!+1"
GOTO writeteambatsc

:writeteambatsd
IF "!team[%wt1%].name!"=="" SET "wt1=0" & GOTO writeinis
ECHO exit>>"Play Laz\PLTeam%wt1%.bat"
SET /a "wt1=!wt1!+1"
GOTO writeteambatsd

:writeinis
SET wt1=0
SET wa1=0
goto writeinisa

:writeinisa
IF "!team[%wt1%].name!"=="" SET "wt1=0" & GOTO writebackup
(
    ECHO [Settings]
    ECHO UseStationNamesInsteadOfSessions=1
    ECHO KickActiveCharacter=1
    ECHO KickActiveTrader=1
    ECHO Debug=0
    ECHO UseAuth=0
    ECHO UseMQ2Login=0
    ECHO EnableCustomClientIni=1
    ECHO [Servers]
    ECHO laz=[] Project Lazarus
)>>"Play Laz\MQ2AutoLoginTeam%wt1%"
GOTO writeinisb

:writeinisb
IF "!team[%wt1%].account[%wa1%].name!"=="" GOTO writeinisc
(
    ECHO [!team[%wt1%].account[%wa1%].name!]
    ECHO Password=!team[%wt1%].account[%wa1%].pass!
    ECHO Server=laz
    ECHO Character=!team[%wt1%].account[%wa1%].char!
)>>"Play Laz\MQ2AutoLoginTeam%wt1%"
SET /a "wa1=!wa1!+1"
GOTO writeinisb

:writeinisc
(
ECHO [Profiles]
ECHO DefaultEQPath=%plazfolder%
ECHO NumProfiles=0
)>>"Play Laz\MQ2AutoLoginTeam%wt1%"
SET wa1=0
SET /a "wt1=!wt1!+1"
GOTO writeinisa

:writebackup
SET "wt1=0"
SET "wa1=0"
GOTO writebackupa

:writebackupa
IF "!team[%wt1%].name!"=="" SET "wt1=0" & GOTO savefoldervars
(
    ECHO SET "team[%wt1%].name=!team[%wt1%].name!"
    ECHO SET "team[%wt1%].desc=!team[%wt1%].desc!"
)>>"SavedLazVars"
GOTO writebackupb

:writebackupb
IF "!team[%wt1%].account[%wa1%].name!"=="" (
    SET /a "wt1=!wt1!+1"
    SET "wa1=0"
    GOTO writebackupa
)
(
    ECHO SET "team[%wt1%].account[%wa1%].name=!team[%wt1%].account[%wa1%].name!"
    ECHO SET "team[%wt1%].account[%wa1%].pass=!team[%wt1%].account[%wa1%].pass!"
    ECHO SET "team[%wt1%].account[%wa1%].char=!team[%wt1%].account[%wa1%].char!"
)>>"SavedLazVars"
SET /a "wa1=!wa1!+1"
GOTO writebackupb

:savefoldervars
(
ECHO SET "plazfolder=%plazfolder%"
ECHO SET "mq2folder=%mq2folder%"
) >>SavedLazVars
GOTO finish

:finish
ECHO.
ECHO    The script is now finished.
ECHO    You should have a new folder, Play Laz, as well as potentially two new files:
ECHO    SavedLazVars and SavedLazVars.bak
ECHO    The .bak is generated in case something goes wrong.
ECHO    To start playing, goto the Play Laz folder and run Play Laz.bat.
ECHO    If you run into any issues running this script, feel free to let me know on Discord or in game.
ECHO.
pause
exit