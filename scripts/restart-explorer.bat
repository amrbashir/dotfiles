@echo off

REM Required parameters:
REM @raycast.schemaVersion 1
REM @raycast.title Restart Explorer
REM @raycast.mode silent

REM Optional parameters:
REM @raycast.icon 🤖
REM @raycast.description Restarts Windows Explorer

REM Documentation:
REM @raycast.author Amr
REM @raycast.authorURL https://amrbashir.me

taskkill /f /im explorer.exe
start explorer.exe
