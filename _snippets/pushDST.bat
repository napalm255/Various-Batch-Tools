@Echo off
if "%1" == "" goto idiot


if exist \\%1\c$\windows\system32\sndrec32.exe goto :XP
if exist \\%1\c$\winnt\system32\sndrec32.exe goto :2k



:XP
echo @Echo Off>\\%1\c$\DST.bat
echo Echo Installing XP DST Patch>>\\%1\c$\DST.bat
echo "\\balt-apps02-srv\Applications\[UPLOAD]\AQT\WindowsXPSP2\WindowsXP-KB928388-x86-ENU.exe" /q >>\\%1\c$\DST.bat
goto :cont

:2k
echo @Echo Off>\\%1\c$\DST.bat
echo Echo Installing 2k DST Patch>>\\%1\c$\DST.bat
echo c:\winnt\system32\cscript.exe "\\balt-apps02-srv\Applications\[UPLOAD]\AQT\WindowsNTand 2000\tzupdate.vbs">>\\%1\c$\DST.bat
goto :cont

:cont
psexec \\%1 -u baltimore\%username% -e  -p Nunnchuck1   c:\DST.bat

gettzstat %1
goto :eof

:idiot
echo Usage: PushDST -machine-
goto :eof
