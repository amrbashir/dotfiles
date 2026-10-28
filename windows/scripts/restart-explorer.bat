@echo off

REM Required parameters:
REM @vicinae.schemaVersion 1
REM @vicinae.title Restart Explorer
REM @vicinae.mode silent

REM Optional parameters:
REM @vicinae.icon 🔄️
REM @vicinae.description Restarts Windows Explorer

REM Documentation:
REM @vicinae.author Amr
REM @vicinae.authorURL https://amrbashir.me

taskkill /f /im explorer.exe
start explorer.exe
