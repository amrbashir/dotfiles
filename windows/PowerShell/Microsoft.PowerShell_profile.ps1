# ----------------------------------
# Source utilities
# ----------------------------------
# Because current file is symlinked, resolve the actual script root
$ScriptTarget = (Get-Item $PSCommandPath | Select-Object -ExpandProperty Target)
$ScriptRoot = Split-Path -Path $ScriptTarget -Parent

. "$ScriptRoot/Utils.ps1"

# ----------------------------------
# Configure PSReadLine
# ----------------------------------
$PSReadLineOptions = @{
    PredictionSource              = "History"
    HistorySearchCursorMovesToEnd = $true
    Colors                        = @{
        Operator  = "Yellow"
        Parameter = "Blue"
        Member    = "DarkYellow"
    }
}
Set-PSReadLineOption @PSReadLineOptions
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Escape -ScriptBlock { # Add sudo on double ESC tap
    $script:escTapCount++
    if ($script:escTapCount % 2 -eq 0) {
        $script:escTapCount = 0
        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        if ($line -like "sudo *") {
            [Microsoft.PowerShell.PSConsoleReadLine]::Delete(0, 5)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 5)
        }
        else {
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition(0)
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("sudo ")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 5)
        }
    }
}

# ----------------------------------
# Aliases
# ----------------------------------
# For each util in `coreutils --list` provided by uutils-coreutils,
# remove any existing alias to avoid conflicts
foreach ($util in (coreutils --list)) {
    # Skip the `[` utility as it conflicts with PowerShell syntax
    if ($util -eq "[") { continue } 

    if (Get-Alias $util -ErrorAction SilentlyContinue) {
        Remove-Alias $util -Force
    }
}

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

# ----------------------------------
# Poweshell Modules
# ----------------------------------
Import-Module posh-git -arg 0, 0, 1 # for git tab completion

# ----------------------------------
# Shell integrations
# ----------------------------------
Invoke-Expression (&starship init powershell)
fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

Use-CDIntegrations @("__zoxide_z", "Set-FnmOnLoad")