@echo off

set mydate=%date:~10,4%%date:~6,2%/%date:~4,2%
set logFile="C:\Users\Alt Account\Documents\scripts\DayZ_Server_Log.txt"

echo "--- %mydate% --- %time% --- SERVER BACKUP ---" >> %logFile%
:: Released by DonkeyPunch Community Gaming for DayZ SA community use
:: The original was from DayZ Epoch Arma 2
:: Modified for use with Arma 3 Epoch Redis DB and Exile MySQL
:: Now utilized for DayZ StandAlone
:: Modified again by Shibdib in 2023 making it a lot easier to use

:::::::::::::: CONFIG ::::::::::::::::::

:: Set your DayZ installation directory.
set dayzserverfolder=F:\SteamLibrary\steamapps\common\DayZServer

:: Set your database backup folder name.
set dayzbackuppath=D:\DayZBackups

:: Set your Profile name (Where your logs are)
set profilename=profile

:: Set the server instanceId
set instanceId=69

:: Delete backups older then how many days?
set backupAge=5

:: Delete Original log files after they have been rotated? This keeps your logs more organized and saves space.
:: This will not work unless the server is stopped first. So coincide it with your restarts.
set deloriglogs=1

:: Delete the dynamic.bins to delete all loot before every restart
:: This will give your server fresh loot every restart
set deldynamicdbs=1

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::  STOP EDITING ::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Set Time and Date
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~-4%%date:~4,2%%date:~7,2%_0%time:~1,1%%time:~3,2%_%time:~6,2%
SET dtStamp24=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%_%time:~6,2%

::Make Date Stamp
if "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) else (SET dtStamp=%dtStamp24%)
ECHO Todays Date and time (%date%)(%time%) / %dtStamp%

echo (%date%) (%time%) Starting Log Rotation.

:: Check for backup directory and make if needed
:maketsdir
if exist "%dayzbackuppath%\%profilename%\%dtStamp%" goto copyfiles
mkdir "%dayzbackuppath%\%profilename%\%dtStamp%"

:: Backup the files
:copyfiles
copy "%dayzserverfolder%\mpmissions\dayzOffline.chernarusplus\storage_%instanceId%\players.db" "%dayzbackuppath%\%profilename%\%dtStamp%\players.db"
copy "%dayzserverfolder%\mpmissions\dayzOffline.chernarusplus\storage_%instanceId%\data\dynamic_*.bin" "%dayzbackuppath%\%profilename%\%dtStamp%\dynamic_*.bin"
copy "%dayzserverfolder%\mpmissions\dayzOffline.chernarusplus\storage_%instanceId%\data\events.bin" "%dayzbackuppath%\%profilename%\%dtStamp%\events.bin"
copy "%dayzserverfolder%\mpmissions\dayzOffline.chernarusplus\storage_%instanceId%\data\types.bin" "%dayzbackuppath%\%profilename%\%dtStamp%\types.bin"
copy "%dayzserverfolder%\mpmissions\dayzOffline.chernarusplus\storage_%instanceId%\data\vehicles.bin" "%dayzbackuppath%\%profilename%\%dtStamp%\vehicles.bin"
copy "%dayzserverfolder%\%profilename%\script.log" "%dayzbackuppath%\%profilename%\%dtStamp%\script.log"
copy "%dayzserverfolder%\%profilename%\crash.log" "%dayzbackuppath%\%profilename%\%dtStamp%\crash.log"
copy "%dayzserverfolder%\%profilename%\serverconsole.log" "%dayzbackuppath%\%profilename%\%dtStamp%\serverconsole.log"
copy "%dayzserverfolder%\%profilename%\DayZServer_x64.ADM" "%dayzbackuppath%\%profilename%\%dtStamp%\DayZServer_x64.ADM"
copy "%dayzserverfolder%\%profilename%\DayZServer_x64*.rpt" "%dayzbackuppath%\%profilename%\%dtStamp%\DayZServer_x64*.rpt"

:: This is for deleting the original logs in the profile folder
:deloriglogs
if %deloriglogs% == 1 (
del "%dayzserverfolder%\%profilename%\script*.log"
del "%dayzserverfolder%\%profilename%\crash*.log"
del "%dayzserverfolder%\%profilename%\serverconsole.log"
del "%dayzserverfolder%\%profilename%\DayZServer_x64.ADM"
del "%dayzserverfolder%\%profilename%\DayZServer_x64*.rpt"
)

:: This is for servers that want to have freshly made dynamic loot every restart
:deldynamicdbs
if %deldynamicdbs% == 1 (
del "%dayzserverfolder%\mpmissions\dayzOffline.chernarusplus\storage_%instanceId%\data\dynamic_*.bin"
)

:: Clean the backups folder
:deloldbackups
Fforfiles /p %dayzbackuppath% /d -%backupAge% /c "cmd /c if @isdir==TRUE rmdir @file /s /q"

:: Done
echo "Backup Succesful" >> %logFile%
exit
