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

#region set environment variables
$env:CARGO_TARGET_DIR = "D:\.cargo-target"
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

Set-Alias vim nvim

Function __ls { exa --icons $args }
Set-Alias ls __ls -Option AllScope

Function __ll { exa -lah --icons --git --group-directories-first $args }
Set-Alias ll __ll

Function __coreutils_cp { coreutils cp $args }
Set-Alias cp __coreutils_cp -Option AllScope

Function __coreutils_mv { coreutils mv $args }
Set-Alias mv __coreutils_mv

Function __coreutils_rm { coreutils rm $args }
Set-Alias rm __coreutils_rm

Function __coreutils_rmdir { coreutils rmdir $args }
Set-Alias rmdir __coreutils_rmdir

Function __coreutils_touch { coreutils touch $args }
Set-Alias touch __coreutils_touch

Function __coreutils_mkdir { coreutils mkdir $args }
Set-Alias mkdir __coreutils_mkdir

Function __coreutils_dirname { coreutils dirname $args }
Set-Alias dirname __coreutils_dirname

Function __coreutils_pwd { coreutils pwd $args }
Set-Alias pwd __coreutils_pwd

Function __coreutils_wc { coreutils wc $args }
Set-Alias wc __coreutils_wc
#endregion

#region -------
Invoke-Expression (&starship init powershell)
fnm env --use-on-cd | Out-String | Invoke-Expression
#endregion
