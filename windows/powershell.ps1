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
$___escTapCount=0
Set-PSReadLineKeyHandler -Key Escape -ScriptBlock {
    ([ref]$___escTapCount).Value++
    if ($___escTapCount % 2 -eq 0) {
        ([ref]$___escTapCount).Value=0

        $currentString=$null
        $currentCPos=$null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref] $currentString, [ref] $currentCPos)
        if ($currentString -like "sudo *") {
            [Microsoft.PowerShell.PSConsoleReadLine]::Delete(0, 5)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($currentCPos - 5)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition(0)
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("sudo ")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($currentCPos + 5)
        }
    }
}




# set environment variables (don't forget to also add them in Widnows settings for GUI apps)
$env:CARGO_TARGET_DIR = "D:\.cargo-target"
$env:KOMOREBI_CONFIG_HOME = "$HOME\dotfiles\windows"

# functions
Function Refresh-PATH {
    $env:path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}
Function Add-PATHEntry {
    $newpath = [System.Environment]::GetEnvironmentVariable("Path") + ";" + $args[0]
    [System.Environment]::SetEnvironmentVariable("Path", $newpath, "User")
}
Function Add-EnvVar {
    [System.Environment]::SetEnvironmentVariable($args[0], $args[1], "User")
}
Function Load-DotEnv {
    Get-Content .env | ForEach {
        $nameValue, $comment = $_.split('#')
        if (![string]::IsNullOrWhiteSpace($nameValue)) {
            $name, $value = $nameValue.split('=')
            if (![string]::IsNullOrWhiteSpace($name)) {
                Set-Item -Path Env:\$($name) -Value $value
            }
        }
    }
}

# aliases
Set-Alias vim nvim

Function __ls { eza --icons $args }
Remove-Alias ls
Set-Alias ls __ls
Function __ll { eza -lah --icons --git --group-directories-first $args }
Set-Alias ll __ll

Function __coreutils_cp { coreutils cp $args }
Remove-Alias cp
Set-Alias cp __coreutils_cp
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

Function Git-checkout { git checkout $args }
Remove-Alias gc -Force
Set-Alias gc Git-checkout
Function Git-status { git st $args }
Set-Alias gs Git-status
Function Git-diff { git diff $args }
Set-Alias gd Git-diff
Function Git-add { git add $args }
Set-Alias ga Git-add
Function Git-add-all { git add . $args }
Set-Alias gaa Git-add-all
Function Git-commit { git commit $args }
Remove-Alias gcm -Force
Set-Alias gcm Git-commit
Function Git-commit-m { git commit -m $args }
Set-Alias gcmm Git-commit-m
Function Git-stash { git stash $args }
Set-Alias gst Git-stash
Function Git-pull { git pull $args }
Set-Alias gpl Git-pull
Function Git-push { git push $args }
Set-Alias gp Git-push -Force
Function Git-lg { git lg $args }
Remove-Alias gl -Force
Set-Alias gl Git-lg
Function Git-branch { git branch $args }
Set-Alias gb Git-branch
Function Git-restore { git restore $args }
Set-Alias grestore Git-restore
Function Git-reset { git reset $args }
Set-Alias greset Git-reset
Function Git-remote { git remote $args }
Set-Alias gremote Git-remote
Function Git-rebase { git rebase $args }
Set-Alias grebase Git-rebase

# imports
Import-Module posh-git -arg 0,0,1

# ------------------
Invoke-Expression (&starship init powershell)
fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
