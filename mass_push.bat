@echo off
for /L %%b in (%1,1,%2) do for /L %%s in (1,1,254) do call cscript.exe /nologo "Time Zone Update Check.vbs" 169.156.%%b.%%s >> dst\%%bsubnet.txt
