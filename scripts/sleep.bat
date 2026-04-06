@echo off

REM Required parameters:
REM @raycast.schemaVersion 1
REM @raycast.title Sleep
REM @raycast.mode silent

REM Optional parameters:
REM @raycast.icon 💤
REM @raycast.description Actually sleep, no standby bullshit
REM @raycast.needsConfirmation true

REM Documentation:
REM @raycast.author Amr
REM @raycast.authorURL https://amrbashir.me

rundll32.exe powrprof.dll,SetSuspendState 0,1,1
