#SingleInstance force

; Launch apps
; -----------

; Win + Enter
#Enter::	 	; Launch Terminal
{
  Run "wt.exe"
  WinWait "ahk_exe WindowsTerminal.exe"
  WinActivate "ahk_exe WindowsTerminal.exe"
}

; Manage windows
; --------------

; Win + Q
#q::      ; Close active window
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
