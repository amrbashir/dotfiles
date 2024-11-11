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
; Win + Q     
#q::
{
  try {
    WinClose "A"
  }
}

; Media keys
; ----------

Pause::Media_Next
Scrolllock::Media_Play_Pause
PrintScreen::Media_Prev

; Komorebi
; --------------

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

; Win + Shift + R
#+r::Komorebic("retile")

; Win + Shift + Enter
#+Enter::Komorebic("promote")

; Win + T
#t::Komorebic("toggle-float")

; Win + Shift + F
#+f::Komorebic("toggle-monocle")

; Win + [0..9]
#1::Komorebic("focus-workspace 0")
#2::Komorebic("focus-workspace 1")
#3::Komorebic("focus-workspace 2")
#4::Komorebic("focus-workspace 3")
#5::Komorebic("focus-workspace 4")
#6::Komorebic("focus-workspace 5")
#7::Komorebic("focus-workspace 6")
#8::Komorebic("focus-workspace 7")
#9::Komorebic("focus-workspace 8")
#0::Komorebic("focus-workspace 9")

; Win + Shift + [0..9]
#+1::Komorebic("send-to-workspace 0")
#+2::Komorebic("send-to-workspace 1")
#+3::Komorebic("send-to-workspace 2")
#+4::Komorebic("send-to-workspace 3")
#+5::Komorebic("send-to-workspace 4")
#+6::Komorebic("send-to-workspace 5")
#+7::Komorebic("send-to-workspace 6")
#+8::Komorebic("send-to-workspace 7")
#+9::Komorebic("send-to-workspace 8")
#+0::Komorebic("send-to-workspace 9")
