#SingleInstance force

RunWait "komorebic.exe start --await-configuration", , "Hide"

#Include "komorebi.generated.ahk"

RunWait "komorebic.exe focus-follows-mouse disable", , "Hide"
RunWait "komorebic.exe ensure-workspaces 0 5", , "Hide"
RunWait "komorebic.exe active-window-border enable", , "Hide"
RunWait "komorebic.exe container-padding 0 0 5", , "Hide"
RunWait "komorebic.exe workspace-padding 0 0 5", , "Hide"
RunWait "komorebic.exe container-padding 1 1 5", , "Hide"
RunWait "komorebic.exe workspace-padding 1 1 5", , "Hide"
RunWait "komorebic.exe container-padding 2 2 5", , "Hide"
RunWait "komorebic.exe workspace-padding 2 2 5", , "Hide"
RunWait "komorebic.exe container-padding 3 3 5", , "Hide"
RunWait "komorebic.exe workspace-padding 3 3 5", , "Hide"
RunWait "komorebic.exe container-padding 4 4 5", , "Hide"
RunWait "komorebic.exe workspace-padding 4 4 5", , "Hide"

RunWait "komorebic.exe complete-configuration", , "Hide"

; Focus windows
!h::
{
    Run "komorebic.exe focus left", , "Hide"
}
!j::
{
    Run "komorebic.exe focus down", , "Hide"
}
!k::
{
    Run "komorebic.exe focus up", , "Hide"
}
!l::
{
    Run "komorebic.exe focus right", , "Hide"
}
!+VK0xDB::
{
    Run "komorebic.exe cycle-focus previous"
    }
!+VK0xDD::
{
    Run "komorebic.exe cycle-focus next", , "Hide"
}

; move windows
!+h::
{
    Run "komorebic.exe move left", , "Hide"
}
!+j::
{
    Run "komorebic.exe move down", , "Hide"
}
!+k::
{
    Run "komorebic.exe move up", , "Hide"
}
!+l::
{
    Run "komorebic.exe move right", , "Hide"
}
!+Enter::
{
    Run "komorebic.exe promote", , "Hide"
}

; resize
!^l::
{
    Run "komorebic.exe resize-axis horizontal increase", , "Hide"
}
!^h::
{
    Run "komorebic.exe resize-axis horizontal decrease", , "Hide"
}
!^k::
{
    Run "komorebic.exe resize-axis vertical increase", , "Hide"
}
!^j::
{
    Run "komorebic.exe resize-axis vertical decrease", , "Hide"
}

; workspaces
!1::
{
    Run "komorebic.exe focus-workspace 0", , "Hide"
}
!2::
{
    Run "komorebic.exe focus-workspace 1", , "Hide"
}
!3::
{
    Run "komorebic.exe focus-workspace 2", , "Hide"
}
!4::
{
    Run "komorebic.exe focus-workspace 3", , "Hide"
}
!5::
{
    Run "komorebic.exe focus-workspace 4", , "Hide"
}

; move windows across workspaces
!+1::
{
    Run "komorebic.exe move-to-workspace 0", , "Hide"
}
!+2::
{
    Run "komorebic.exe move-to-workspace 1", , "Hide"
}
!+3::
{
    Run "komorebic.exe move-to-workspace 2", , "Hide"
}
!+4::
{
    Run "komorebic.exe move-to-workspace 3", , "Hide"
}
!+5::
{
    Run "komorebic.exe move-to-workspace 4", , "Hide"
}

; manipulate windows
!t::
{
    Run "komorebic.exe toggle-float", , "Hide"
}
!+f::
{
    Run "komorebic.exe toggle-monocle", , "Hide"
}

; window manager options
!+r::
{
    Run "komorebic.exe retile", , "Hide"
}