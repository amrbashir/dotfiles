Import-Module posh-git
Import-Module "~\AppData\Local\vcpkg\scripts\posh-vcpkg"

# configure PSReadLine
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

# set environment variables
$env:CARGO_TARGET_DIR = "D:\.cargo-target"

# functions
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

# aliases
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

Function __git_checkout { git checkout $args }
Set-Alias gc __git_checkout
Function __git_status { git status $args }
Set-Alias gs __git_status
Function __git_diff { git diff $args }
Set-Alias gd __git_diff
Function __git_add { git add $args }
Set-Alias ga __git_add
Function __git_add { git add $args }
Set-Alias gaa __git_add
Function __git_commit { git commit $args }
Set-Alias gcm __git_commit
Function __git_commit { git commit $args }
Set-Alias gcmm __git_commit
Function __git_stash { git stash $args }
Set-Alias gst __git_stash
Function __git_pull { git pull $args }
Set-Alias gpull __git_pull
Function __git_push { git push $args }
Set-Alias gpush __git_push
Function __git_lg { git lg $args }
Set-Alias gl __git_lg
Function __git_branch { git branch $args }
Set-Alias gb __git_branch
Function __git_restore { git restore $args }
Set-Alias grestore __git_restore
Function __git_reset { git reset $args }
Set-Alias greset __git_reset
Function __git_remote { git remote $args }
Set-Alias gremote __git_remote
Function __git_rebase { git rebase $args }
Set-Alias grebase __git_rebase
#endregion

#region -------
Invoke-Expression (&starship init powershell)
fnm env --use-on-cd | Out-String | Invoke-Expression
#endregion
