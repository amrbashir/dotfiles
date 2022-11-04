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

Pause:: Media_Prev
PrintScreen:: Media_Play_Pause
Home:: Media_Next