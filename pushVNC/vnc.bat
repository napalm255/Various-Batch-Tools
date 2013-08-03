@echo off
rem VNC Installation Batch
rem Nischan Technology Solutions, LLC
rem
rem Required tools:
rem   REG.EXE
rem   PING.EXE
rem   SC.EXE
rem   NETSVC.EXE

echo.
echo.
echo.
echo ------------------------------------------------------------[ VNC Maintenance ]
echo.
setlocal
if "%1"=="" goto :help
if "%1"=="install" goto :help
if "%1"=="/?" goto :help
if "%2"=="/d" goto :disable
if "%2"=="/D" goto :disable
if not "%1"=="%computername%" set sc=\\%1
if "%2"=="/u" goto :uninstall
echo %1: Validating system
ping -n 1 %1 >%temp%\tmpping.dat
for /f "tokens=1" %%p in (%temp%\tmpping.dat) do if "%%p" == "Reply" set online=true
del %temp%\tmpping.dat
if not "%online%" == "true" echo %1: Error: System is not online! &goto :end
if exist \\%1\c$\windows\explorer.exe goto :continue
if exist \\%1\c$\winnt\explorer.exe goto :continue
echo %1: Error: You do not have admin privs or box isn't proper OS!
goto :end
:continue
if exist \\%1\c$\progra~1\realvnc\vnc4\winvnc4.exe goto :present
if exist \\%1\c$\progra~1\orl\vnc\winvnc.exe goto :present
if exist \\%1\c$\progra~1\ultravnc\winvnc.exe goto :present
echo %1: Creating Directory Structure
md \\%1\c$\progra~1\UltraVNC
echo %1: Copying program files
xcopy bin\*.* /s/e \\%1\c$\progra~1\UltraVNC /y >nul
echo %1: Adding Registry Entries
reg add \\%1\HKLM\SOFTWARE\ORL  /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3\Default /f >nul
reg add \\%1\HKLM\SOFTWARE\UltraVNC  /f >nul
reg add \\%1\HKLM\SOFTWARE\UltraVNC\mslogon /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /v AllowLoopback /t REG_DWORD /d 0 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /v ConnectPriority /t REG_DWORD /d 1 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /v DebugLevel /t REG_DWORD /d 0 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /v DebugMode /t REG_DWORD /d 0 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /v DisableTrayIcon /t REG_DWORD /d 1 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /v DSMPlugin /t REG_BINARY /d 0000400034F912005A5EF7770000400001000000020000005A5FF77714FA12005CA000000000400058E3F77708000000590100000000000008014000FCF8120078019F0078019F0028559F00ECF8120000004000B8F9120028559F00681AF577FFFFFFFF5A5FF777F85FF7770000000068019F0000000000000000000000000088569F0000000000000000000000000000559F000000000000000000C8F91200737CF777B8CB030020559F0078019F00000000000000000000000000E0494C00ACF91200F663E7770300000018000000010000000000000000000000000000003E00000028559F0020C54B000000000040364900781CF577 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /v LoopbackOnly /t REG_DWORD /d 0 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /v MSLogonRequired /t REG_DWORD /d 1 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /v NewMSLogon /t REG_DWORD /d 0 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3 /v UseDSMPlugin /t REG_DWORD /d 0 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3\Default /v Password /t REG_BINARY /d B7197FA86D3043E1 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3\Default /v AllowEditClients /t REG_DWORD /d 0 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3\Default /v AllowProperties /t REG_DWORD /d 1 /f >nul
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3\Default /v AllowShutdown /t REG_DWORD /d 0 /f >nul
reg add \\%1\HKLM\SOFTWARE\UltraVNC\mslogon /v group1 /t REG_BINARY /d 61646d696e6973747261746f7273 /f >nul
reg add \\%1\HKLM\SOFTWARE\UltraVNC\mslogon /v group2 /t REG_BINARY /d 00646d696e6973747261746f727300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d8def50000001500a844f97707000000d80715000000150008f91500b0def50000000000f8e0f500f088fa777038f577ffffffffa844f977707df5773a8af57744e1f50068e1f5 /f >nul
reg add \\%1\HKLM\SOFTWARE\UltraVNC\mslogon /v group3 /t REG_BINARY /d 004e43564945574f4e4c59 /f >nul
reg add \\%1\HKLM\SOFTWARE\UltraVNC\mslogon /v locdom1 /t REG_DWORD /d 1 /f >nul
reg add \\%1\HKLM\SOFTWARE\UltraVNC\mslogon /v locdom2 /t REG_DWORD /d 0 /f >nul
reg add \\%1\HKLM\SOFTWARE\UltraVNC\mslogon /v locdom3 /t REG_DWORD /d 0 /f >nul
echo %1: Creating WINVNC Service
sc %sc% create WinVNC start= auto binpath= "c:\program files\ultravnc\winvnc.exe -service" displayname= "VNC Service" type= own type= interact >nul
if not errorlevel 0 echo %1: Error creating service!
:done
echo %1: Firing Up The WINVNC Service
netsvc \\%1 winvnc /start >nul
goto :end

:present
if "%2"=="/u" goto :uninstall
if "%3"=="/u" goto :uninstall
if "%1"=="%computername%" goto :uninstall
echo %1: Querying service status
netsvc \\%1 winvnc /query >%temp%\tmpwinvnc.dat
for /f "tokens=3" %%s in (%temp%\tmpwinvnc.dat) do if "%%s"=="running" goto :queryuninstall
echo %1: Service was not started
:startit
echo %1: Starting WINVNC service
netsvc \\%1 winvnc /start >%temp%\tmpwinvnc.dat
for /f "tokens=3" %%s in (%temp%\tmpwinvnc.dat) do (
  if "%%s"=="running" set tempvnc=true
  if "%%s"=="1058" set tempvnc=disb
)
del %temp%\tmpwinvnc.dat
if "%tempvnc%"=="true" echo %1: WINVNC service running
if "%tempvnc%"=="true" choice /n /c:y,n /t:n,20 %1: Attempt connection? 
if "%tempvnc%"=="true" if errorlevel 2 goto :end
if "%tempvnc%"=="true" if errorlevel 1 goto connect
if "%tempvnc%"=="disb" goto :disabled
goto :end
:connect
vncviewer %1
if "%disabled%"=="true" choice /n /c:y,n /t:n,20 %1: Restored disabled service status? 
if "%disabled%"=="true" if errorlevel 2 goto :end
if "%disabled%"=="true" if errorlevel 1 sc \\%1 config winvnc start= disabled >nul
if "%disabled%"=="true" if errorlevel 1 echo %1: Service disabled. &goto :end
goto :end
:disabled
set disabled=true
echo %1: Service was disabled.  Enabling ...
sc \\%1 config winvnc start= auto >%temp%\tmpwinvnc.dat
for /f "tokens=3" %%s in (%temp%\tmpwinvnc.dat) do if "%%s"=="SUCCESS" set tempvnc=true
del %temp%\tmpwinvnc.dat
if "%tempvnc%"=="true" goto startit
echo %1: Service enable has failed.
goto :end
:queryuninstall
choice /n /c:y,n /t:n,20 %1: Uninstall VNC? 
if errorlevel 2 goto :runit
:uninstall
if not exist \\%1\c$\progra~1\ultravnc\winvnc.exe echo %1: UltraVNC is not present! &goto :end
echo %1: Stopping service
netsvc \\%1 "winvnc" /stop >nul
echo %1: Removing service
sc %sc% delete winvnc >nul
echo %1: Cleaning registry
if exist \\%1\c$\progra~1\realvnc\vnc4\winvnc4.exe reg delete \\%1\hklm\software\realvnc /f >nul
if exist \\%1\c$\progra~1\orl\vnc\winvnc.exe reg delete \\%1\hklm\software\orl /f >nul
if exist \\%1\c$\progra~1\ultravnc\winvnc.exe reg delete \\%1\hklm\software\orl /f >nul
if exist \\%1\c$\progra~1\ultravnc\winvnc.exe reg delete \\%1\hklm\software\ultravnc /f >nul
echo %1: Checking and removing process
taskkill /s %1 /im winvnc.exe /f >nul
echo %1: Cleaning filesystem
if exist \\%1\c$\progra~1\realvnc\vnc4\winvnc4.exe echo y|rd "\\%1\c$\program files\realvnc" /s >nul
if exist \\%1\c$\progra~1\orl\vnc\winvnc.exe echo y|rd "\\%1\c$\program files\orl" /s >nul
if exist \\%1\c$\progra~1\ultravnc\winvnc.exe echo y|rd "\\%1\c$\program files\ultravnc" /s >nul
goto :end
:runit
choice /n /c:y,n /t:n,20 %1: Connect? 
if errorlevel 2 goto :end
if errorlevel 1 vncviewer %1
:end
echo.
echo ------------------------------------------------------------------[ Complete! ]
goto :eof


:pwd
reg query \\%1\hklm\SOFTWARE\ORL\WinVNC3\Default /v Password >%temp%\tmppwd.dat
rem reg query \\%1\hklm\SOFTWARE\RealVNC\WinVNC4 /v Password >%temp%\tmppwd.dat
for /f "tokens=1,3" %%p in (%temp%\tmppwd.dat) do (
  if "%%p"=="Password" if "%%q"=="B7197FA86D3043E1" echo %1: Standard password
  if "%%p"=="Password" if not "%%q"=="B7197FA86D3043E1" (
    call :pwdparse %%q %1
  )
)
goto :end
:pwdparse
set pwd=%1
echo %pwd:~0,2% %pwd:~2,2% %pwd:~4,2% %pwd:~6,2% %pwd:~8,2% %pwd:~10,2% %pwd:~12,2% %pwd:~14,2% %pwd:~16,2% %pwd:~18,2% %pwd:~20,2% %pwd:~22,2% %pwd:~24,2% %pwd:~26,2% %pwd:~28,2% %pwd:~30,2% %pwd:~32,2% |x4 -W >%temp%\vncpwd.dat
for /f "tokens=1,3" %%v in (%temp%\vncpwd.dat) do if "%%v"=="VNC" echo %2: VNC Password %%w
del %temp%\vncpwd.dat
goto :eof


:chgpwd
echo %1: Stopping service ..
netsvc \\%1 winvnc /stop >nul
echo %1: Setting password ..
reg add \\%1\HKLM\SOFTWARE\ORL\WinVNC3\Default /v Password /t REG_BINARY /d B7197FA86D3043E1 /f >nul
echo %1: Starting service ..
netsvc \\%1 winvnc /start >nul
goto :end

:help
cls
echo Ken's VNC installer has been updated.  
echo You no longer need the INSTALL parameter.
echo.
echo Usage: VNC -computername-
echo.
echo It will determine if VNC is present, and if so ask if you want to uninstall or
echo connect.  If it is not present, it will install.
echo.
echo To decrypt the system's VNC password, pass the /p parameter.
goto :eof
echo.

:disable
echo %1: Disabling local inputs ..
reg add \\%1\hklm\software\orl\winvnc3\default /v LocalInputsDisabled /t REG_DWORD /d 1 /f >nul
netsvc \\%1 winvnc /stop >nul
netsvc \\%1 winvnc /start >nul
echo %1: Sleeping 5 seconds to allow service restart ..
choice /c:po /n /t:p,5 >nul
echo %1: Connecting ..
vncviewer %1
echo %1: Enabling local inputs ..
reg delete \\%1\hklm\software\orl\winvnc3\default /v LocalInputsDisabled /f >nul
netsvc \\%1 winvnc /stop >nul
netsvc \\%1 winvnc /start >nul
goto :end









