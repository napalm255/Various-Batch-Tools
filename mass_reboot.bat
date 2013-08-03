@echo off
for /f %%f in (.\reboot.txt) do shutdown -f -r -m %%f -t 01