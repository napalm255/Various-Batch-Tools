@ECHO OFF
setlocal

echo.
echo DCHP Backup v1.0
echo ---------------------

::Variables
if %time:~0,2% lss 10 set dTime=%date:~4,2%.%date:~7,2%.%date:~10,4%@0%time:~1,1%%time:~3,2%
if %time:~0,2% geq 10 set dTime=%date:~4,2%.%date:~7,2%.%date:~10,4%@%time:~0,2%%time:~3,2%
set backupNETSH=DHCPBackup_%dTime%.netsh
set backupZIP=DHCPBackup_%dTime%.zip
set backupPath=E:\DHCPBackups
set dhcpPath=%SYSTEMROOT%\SYSTEM32\DHCP
set extPath=\\balt-inf02-srv\DHCPBackup

::Process
echo Dumping NETSH Configuration...
netsh dhcp server \\%computername% dump > %backupPath%\%backupNETSH%
Configuration Dump - %backupPath%\%backupNETSH%
echo.

echo Stopping DHCP Server...
netsvc DHCPServer \\%computername% /stop
:loopStop
for /f "tokens=3" %%s in ('netsvc DHCPServer \\%computername% /query') do if "%%s"=="pending" goto :loopStop
echo.

echo Zipping DHCP Folder and NETSH Dump...
pkzipc.exe -add -directories -dir=relative -rec -silent %backupPath%\%backupZIP% %dhcpPath%\* %backupPath%\%backupNETSH%
echo.

echo Starting DHCP Server...
netsvc DHCPServer \\%computername% /start
:loopStart
for /f "tokens=3" %%s in ('netsvc DHCPServer \\%computername% /query') do if "%%s"=="pending" goto :loopStart
echo.

echo Deleting NETSH Dump...
del /f /s /q %backupPath%\%backupNETSH%
echo.

echo Copying Backup ZIP...
xcopy %backupPath%\%backupZIP% %extPath% /y > nul
Copied ZIP - %extPath%\%backupZIP%
echo.

:end
endlocal