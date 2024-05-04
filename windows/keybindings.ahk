#SingleInstance force

; Launch apps
; -----------

; Launch Terminal
#Enter:: ; Win + Enter
{
  Run "wt.exe"
  WinWait "ahk_exe WindowsTerminal.exe"
  WinActivate "ahk_exe WindowsTerminal.exe"
}

; Manage windows
; --------------

; Close active window
#q:: ; Win + Q     
{
  try {
    WinClose "A"
  }
}

; Media keys
; ----------

Pause::Media_Prev
PrintScreen::Media_Play_Pause
Home::Media_Next

; Komorebi
; --------------

; Alt + Shift + R
!+r::Run "komorebic.exe retile",,"Hide"

; Alt + Shift + Enter
!+Enter::Run "komorebic.exe promote",,"Hide"

; Alt + T
!t::Run "komorebic.exe toggle-float",,"Hide"

; Alt + Shift + F
!+f::Run "komorebic.exe toggle-monocle",,"Hide"

; Alt + [1..9]
!1::Run "komorebic.exe focus-workspace 0",,"Hide"
!2::Run "komorebic.exe focus-workspace 1",,"Hide"
!3::Run "komorebic.exe focus-workspace 2",,"Hide"
!4::Run "komorebic.exe focus-workspace 3",,"Hide"
!5::Run "komorebic.exe focus-workspace 4",,"Hide"
!6::Run "komorebic.exe focus-workspace 5",,"Hide"
!7::Run "komorebic.exe focus-workspace 6",,"Hide"
!8::Run "komorebic.exe focus-workspace 7",,"Hide"
!9::Run "komorebic.exe focus-workspace 8",,"Hide"

; Alt + Shift + [1..9]
!+1::Run "komorebic.exe send-to-workspace 0",,"Hide"
!+2::Run "komorebic.exe send-to-workspace 1",,"Hide"
!+3::Run "komorebic.exe send-to-workspace 2",,"Hide"
!+4::Run "komorebic.exe send-to-workspace 3",,"Hide"
!+5::Run "komorebic.exe send-to-workspace 4",,"Hide"
!+6::Run "komorebic.exe send-to-workspace 5",,"Hide"
!+7::Run "komorebic.exe send-to-workspace 6",,"Hide"
!+8::Run "komorebic.exe send-to-workspace 7",,"Hide"
!+9::Run "komorebic.exe send-to-workspace 8",,"Hide"
