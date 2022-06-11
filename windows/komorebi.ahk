#SingleInstance Force

; Run komorebi
Run, komorebic.exe start, , Hide

; Enable hot reloading of changes to this file
Run, komorebic.exe watch-configuration enable, , Hide

; Enable focus follows mouse
Run, komorebic.exe focus-follows-mouse disable, , Hide

; Ensure there are 9 workspaces created on monitor 0
Run, komorebic.exe ensure-workspaces 0 9, , Hide

; Always float Task Manager, matching on class
Run, komorebic.exe float-rule class TaskManagerWindow, , Hide

; Identify applications that close to the tray
Run, komorebic.exe identify-tray-application exe Discord.exe, , Hide
Run, komorebic.exe identify-tray-application exe Spotify.exe, , Hide
Run, komorebic.exe identify-tray-application exe mailspring.exe, , Hide


; Change the focused window, Alt + Vim direction keys
!h::
Run, komorebic.exe focus left, , Hide
return

!j::
Run, komorebic.exe focus down, , Hide
return

!k::
Run, komorebic.exe focus up, , Hide
return

!l::
Run, komorebic.exe focus right, , Hide
return

; Move the focused window in a given direction, Alt + Shift + Vim direction keys
!+h::
Run, komorebic.exe move left, , Hide
return

!+j::
Run, komorebic.exe move down, , Hide
return

!+k::
Run, komorebic.exe move up, , Hide
return

!+l::
Run, komorebic.exe move right, , Hide
return

; Promote the focused window to the top of the tree, Alt + Shift + Enter
!+Enter::
Run, komorebic.exe promote, , Hide
return

; Toggle the Monocle layout for the focused window, Alt + Shift + F
!+f::
Run, komorebic.exe toggle-monocle, , Hide
return

; Float the focused window, Alt + Ctrl + Space
!^Space::
Run, komorebic.exe toggle-float, , Hide
return

; Force a retile if things get janky, Alt + Shift + R
!+r::
Run, komorebic.exe retile, , Hide
return


; Switch to workspace
!1::
Send !
Run, komorebic.exe focus-workspace 0, , Hide
return

!2::
Send !
Run, komorebic.exe focus-workspace 1, , Hide
return

!3::
Send !
Run, komorebic.exe focus-workspace 2, , Hide
return

!4::
Send !
Run, komorebic.exe focus-workspace 3, , Hide
return

!5::
Send !
Run, komorebic.exe focus-workspace 4, , Hide
return

!6::
Send !
Run, komorebic.exe focus-workspace 5, , Hide
return

!7::
Send !
Run, komorebic.exe focus-workspace 6, , Hide
return

!8::
Send !
Run, komorebic.exe focus-workspace 7, , Hide
return

!9::
Send !
Run, komorebic.exe focus-workspace 8, , Hide
return

; Move window to workspace
!+1::
Run, komorebic.exe move-to-workspace 0, , Hide
return

!+2::
Run, komorebic.exe move-to-workspace 1, , Hide
return

!+3::
Run, komorebic.exe move-to-workspace 2, , Hide
return

!+4::
Run, komorebic.exe move-to-workspace 3, , Hide
return

!+5::
Run, komorebic.exe move-to-workspace 4, , Hide
return

!+6::
Run, komorebic.exe move-to-workspace 5, , Hide
return

!+7::
Run, komorebic.exe move-to-workspace 6, , Hide
return

!+8::
Run, komorebic.exe move-to-workspace 7, , Hide
return

!+9::
Run, komorebic.exe move-to-workspace 8, , Hide
return