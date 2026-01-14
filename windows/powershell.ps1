# Configure PSReadLine
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
Set-PSReadLineKeyHandler -Key Escape -ScriptBlock { # Add sudo on double ESC tap
    $script:escTapCount++
    if ($script:escTapCount % 2 -eq 0) {
        $script:escTapCount = 0
        $line=$null
        $cursor=$null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        if ($line -like "sudo *") {
            [Microsoft.PowerShell.PSConsoleReadLine]::Delete(0, 5)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 5)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition(0)
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("sudo ")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 5)
        }
    }
}

# Utilities
Function Refresh-PATH {
    $env:path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

Function AddTo-PATH {
    param(
        [string]$Path
    )
    $newpath = [System.Environment]::GetEnvironmentVariable("Path") + ";" + $Path
    [System.Environment]::SetEnvironmentVariable("Path", $newpath, "User")
}

Function Add-EnvVar {
    param(
        [string]$Name,
        [string]$Value,
        [string]$Scope = "User"
    )
    [System.Environment]::SetEnvironmentVariable($Name, $Value, $Scope)
}

Function AddTo-Startup {
    param(
        [string]$Name,
        [string]$Path,
        [string]$Args = ""
    )
    $Args = if ($Args -eq "") { "" } else { " $Args" }
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $Name -Value "`"$Path`"$Args"
}

function Symlink-Config {
    param(
        [string]$File,
        [string]$ToDir,
        [string]$ToFile
    )
    New-Item -Path $ToDir -ItemType Directory -Force
    $to = $ToDir + $ToFile

    if (Test-Path -Path $to) {
        Remove-Item -Path $to -Force
    }

    # This requires Developer mode to be enabled
    New-Item -ItemType SymbolicLink -Target $File -Path $to
}

Function Set-AliasEx {
    param (
        [string]$AliasName,
        [string]$Command,
        [string]$WrapperFn = ""
    )

    $WrapperFn = if ($WrapperFn -eq "") { "__$AliasName" } else { "$WrapperFn" }

    # Remove existing alias if it exists
    Remove-Alias $AliasName -Force -ErrorAction SilentlyContinue

    # Create an intermediate function to allow aliases that has fixed arguments
    $functionScript = "Function global:$WrapperFn {$Command `$args }"
    Invoke-Expression $functionScript

    # Set Alias to the intermediate function
    Set-Alias $AliasName "$WrapperFn" -Scope Global -Force
}

Function Set-GitAlias {
    param (
        [string]$AliasName,
        [string]$GitCommand
    )

    $gitVerb = $GitCommand.Split(' ')[1]
    Set-AliasEx $AliasName $GitCommand -WrapperFn "Git-$gitVerb"
}

# Aliases
Set-AliasEx vim nvim
Set-AliasEx ls "eza --icons"
Set-AliasEx ll "eza -lah --icons --git --group-directories-first"

Set-GitAlias gc        "git checkout"
Set-GitAlias gs        "git status"
Set-GitAlias gd        "git diff"
Set-GitAlias ga        "git add"
Set-GitAlias gaa       "git add ."
Set-GitAlias gcm       "git commit"
Set-GitAlias gcmm      "git commit -m"
Set-GitAlias gst       "git stash"
Set-GitAlias gpl       "git pull"
Set-GitAlias gp        "git push"
Set-GitAlias gl        "git lg"
Set-GitAlias gb        "git branch"
Set-GitAlias grestore  "git restore"
Set-GitAlias greset    "git reset"
Set-GitAlias gremote   "git remote"
Set-GitAlias grebase   "git rebase"

# Imports
Import-Module posh-git -arg 0,0,1

# Shell integrations
Invoke-Expression (&starship init powershell)
fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
