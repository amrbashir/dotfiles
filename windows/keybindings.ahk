#SingleInstance force

; Launch apps
; -----------

; Win + Enter
#Enter::	           	; Launch Terminal
  Run, wt.exe,,,
  WinWait, ahk_exe WindowsTerminal.exe,,
  WinActivate, ahk_exe WindowsTerminal.exe
Return


; Manage windows
; --------------

; Win + Q
#q::    	WinClose, A 			; Close active window


; Media keys
; ----------

NumpadAdd:: Volume_Up
NumpadSub:: Volume_Down
End:: Media_Prev
PgUp:: Media_Play_Pause
PgDn:: Media_Next