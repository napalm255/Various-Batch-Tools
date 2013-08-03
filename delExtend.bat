@echo off
setlocal
if "%1"=="" set pc=%computername%
if not "%1"=="" set pc=%1
if exist %pc% for /f %%s in (%pc%) do call :process %%s
if not exist %pc% call :process %pc%
goto :eof

:process
ping -n 1 %1 >%temp%\tmpping.dat
for /f "tokens=1" %%p in (%temp%\tmpping.dat) do if "%%p" == "Reply" set online=true
del %temp%\tmpping.dat
if not "%online%" == "true" echo [%1]: Error: System is not online! &goto :eof
echo [%1]: System Online
for /f %%s in ('dir "\\%1\c$\documents and settings" /ad/b') do if exist "\\%1\c$\documents and settings\%%s\local settings\application data\microsoft\outlook\extend.dat" echo [%1]: Cleaning %%s &del "\\%1\c$\documents and settings\%%s\local settings\application data\microsoft\outlook\extend.dat"
:: shutdown \\%1 /t:300 /c /r 

endlocal