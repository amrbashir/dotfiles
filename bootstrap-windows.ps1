#Requires -RunAsAdministrator

if ($PSVersionTable.PSEdition -ne "Core") {
   Write-Host "❌ Install Powershell Core first using ``winget install --id Microsoft.Powershell`` then use it to run this script." -ForegroundColor Red
   exit
}

# Helper functions
function Refresh-PATH {
	$ENV:path = [System.ENVironment]::GetENVironmentVariable("Path", "Machine") + ";" + [System.ENVironment]::GetENVironmentVariable("Path", "User")
}
Function Add-PATHEntry {
    $oldpath = (Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -Name PATH).path
    $newpath = $oldpath + ";" + $args
    Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -Name PATH -Value $newPath
}
Function WingetSilentInstall {
    winget install --silent --accept-package-agreements --accept-source-agreements --source winget $args
}

# Remove execution restrictions
Set-ExecutionPolicy Bypass -Scope CurrentUser

# Install apps
iwr -useb get.scoop.sh | iex
WingetSilentInstall git
Add-PATHEntry "C:\Program Files\Git\bin"
Refresh-PATH
scoop install 7zip
Refresh-PATH
scoop bucket add nerd-fonts
scoop bucket add extras
scoop install zulip sudo uutils-coreutils starship bat ripgrep fd less qbittorrent python everything notepadplusplus pnpm neovim mailspring autohotkey trafficmonitor-lite instant-eyedropper fnm yarn inkscape
Refresh-PATH
mkdir "$HOME\bin"
iwr "https://github.com/eza-community/eza/releases/download/v0.11.0/x86_64-pc-windows-gnu-eza.exe" -o "$HOME\bin\eza.exe"
WingetSilentInstall Discord
WingetSilentInstall VSCode
WingetSilentInstall Steam
WingetSilentInstall "Windows Terminal"
WingetSilentInstall AltSnap
WingetSilentInstall StartAllBack
Refresh-PATH
fnm install --lts
fnm env --use-on-cd | Out-String | Invoke-Expression
fnm use lts-latest
Refresh-PATH

### Remaining apps:
# - ueli - I have a custom build
# - Visual Studio Build Tools
# - TranslucentTB
# - Rust

# Install Fonts
scoop install FiraCode FiraCode-NF
Refresh-PATH

# Install Powershell modules
Install-Module -Name PowerShellGet -Force
Install-Module PSReadLine -Force -SkipPublisherCheck -AllowPrerelease
Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force
Refresh-PATH

# Run post-install scripts
&"C:\ProgramData\scoop\apps\6zip\current\install-context.reg"
&"C:\ProgramData\scoop\apps\everything\current\install-context.reg"
&"C:\ProgramData\scoop\apps\python\current\install-pep-515.reg"
&"C:\ProgramData\scoop\apps\notepadplusplus\current\install-context.reg"

# Symlink or copy config files
@(
    [PSCustomObject]@{file = "$PWD/windows/powershell.ps1"; targetDir = "$HOME\Documents\PowerShell\"; targetFile = "Microsoft.PowerShell_profile.ps1"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/windows-terminal.json"; targetDir = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"; targetFile = "settings.json"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/alt-snap.ini"; targetDir = "$Env:APPDATA\AltSnap\"; targetFile = "AltSnap.ini"; symlink = $FALSE}
    [PSCustomObject]@{file = "$PWD/shared/starship.toml"; targetDir = "$HOME\.config\"; targetFile = "starship.toml"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/.gitconfig"; targetDir = "$HOME\"; targetFile = ".gitconfig"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/traffic-monitor.ini"; targetDir = "$Env:APPDATA\TrafficMonitor\"; targetFile = "config.ini"; symlink = $TRUE}
    [PSCustomObject]@{file = "$PWD/windows/keybindings.ahk"; targetDir = "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"; targetFile = "keybindings.ahk"; symlink = $TRUE}
) | ForEach-Object {
    New-Item -Path $_.targetDir -ItemType Directory -Force
    $target = $_.targetDir + $_.targetFile
    Remove-Item -Path $target  -Force
    if ($_.symlink -eq $TRUE) {
        New-Item -ItemType SymbolicLink -Target $_.file -Path $target
    } else {
        Copy-Item $_.file $target
    }
}
