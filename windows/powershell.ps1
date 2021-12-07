# start starship prompt
Invoke-Expression (&starship init powershell)

#region module imports
Import-Module posh-git
Import-Module "~\AppData\Local\vcpkg\scripts\posh-vcpkg"
#endregion

#region configure PSReadLine
$PSReadLineOptions = @{
    PredictionSource              = "History"
    HistoryNoDuplicates           = $true
    HistorySearchCursorMovesToEnd = $true
    Colors                        = @{
        Operator         = "Yellow"
        Command          = "Yellow"
        Parameter        = "Blue"
        Member           = "DarkYellow"
        Selection        = "$([char]0x1b)[36;7;238m"
        InlinePrediction = "#c9c9c7"
    }
}
Set-PSReadLineOption @PSReadLineOptions
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key F1 -Function WhatIsKey
Set-PSReadLineKeyHandler -Key Ctrl+Shift+LeftArrow -Function SelectBackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+Shift+RightArrow -Function SelectForwardWord
#endregion

#region functions and aliases
Function Refresh-PATH {
    $env:path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}
Function Add-PATHEntry {
    $oldpath = (Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -Name PATH).path
    $newpath = $oldpath + ";" + $args
    Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -Name PATH -Value $newPath
}
Function Add-EnvVar {
    [System.Environment]::SetEnvironmentVariable($args[0], $args[1], "User")
}

Function __rm {
    Param([Parameter(Position = 0)] [string[]] $path, [switch] $r, [switch] $f, [switch] $rf)
    Process {
        $rmArgs = @{
            Path    = $path
            Recurse = ($r -OR $rf)
            Force   = ($f -OR $rf)
        }
        Remove-Item @rmArgs
    }
}
Set-Alias rm __rm

Function __ls { exa --icons $args }
Function __lsa { exa -lah --icons --git --group-directories-first $args }
Set-Alias ls __ls -Option AllScope
Set-Alias lsa __lsa

Set-Alias vim nvim
Set-Alias touch New-Item
#endregion
