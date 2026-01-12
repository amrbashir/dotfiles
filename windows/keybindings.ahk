#SingleInstance force

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

#+r::Komorebic("retile")               ; Win + Shift + R
#+Enter::Komorebic("promote-swap")     ; Win + Shift + Enter
#t::Komorebic("toggle-float")          ; Win + T
#+f::Komorebic("toggle-monocle")       ; Win + Shift + F

#=::Komorebic("resize-axis horizontal increase")   ; Win + =
#-::Komorebic("resize-axis horizontal decrease")   ; Win + -
#+=::Komorebic("resize-axis vertical increase")    ; Win + Shift + =
#+-::Komorebic("resize-axis vertical decrease")    ; Win + Shift + -

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

#Enter:: ; Win + Enter
{
  Run "wt.exe"
  WinWait "ahk_exe WindowsTerminal.exe"
  WinActivate "ahk_exe WindowsTerminal.exe"
}

 
#q:: ; Win + Q
{
  try {
    WinClose "A"
  }
}

Pause::Media_Prev
PrintScreen::Media_Play_Pause
Home::Media_Next
