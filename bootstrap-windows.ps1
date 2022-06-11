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
scoop install -g 7zip
Refresh-PATH
scoop bucket add spotify "https://github.com/TheRandomLabs/Scoop-Spotify.git"
scoop bucket add nerd-fonts
scoop bucket add extras
scoop install -g uutils-coreutils starship bat ripgrep fd less qbittorrent python everything notepadplusplus
scoop install komorebi pnpm neovim mailspring spicetify-cli autohotkey trafficmonitor instant-eyedropper cmake fnm yarn rustup
Refresh-PATH
iwr "https://github.com/ogham/exa/files/8483243/exa.zip" -o "$HOME/downloads/exa.zip"; 7z e .\exa.zip -o"$HOME\scoop\persist\rustup\.cargo\bin"; Remove-Item "$HOME\downloads\exa.zip" -Force
git clone "https://github.com/AstroNvim/AstroNvim" "$Env:LOCALAPPDATA/nvim"
WingetSilentInstall ModernFlyouts
WingetSilentInstall Vivaldi
WingetSilentInstall VLC
WingetSilentInstall VSCode
WingetSilentInstall Steam
WingetSilentInstall "Windows Terminal"
WingetSilentInstall AltSnap
WingetSilentInstall Discord
WingetSilentInstall Spotify
git clone "https://github.com/microsoft/vcpkg" "$Env:LOCALAPPDATA/vcpkg"
&"$ENV:LOCALAPPDATA/vcpkg/bootstrap-vcpkg.bat" -disableMetrics
Refresh-PATH
fnm install --lts
fnm use lts-latest
Refresh-PATH

### Remaining apps:
# - ueli - I have a custom build
# - Visual Studio Build Tools
# - TranslucentTB

# Install Fonts
scoop install -g FiraCode FiraCode-NF
Refresh-PATH

# Install Powershell modules
Install-Module -Name PowerShellGet -Force
Install-Module PSReadLine -Force -SkipPublisherCheck -AllowPrerelease
Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force
Refresh-PATH

# Symlink config files
@(
    [PSCustomObject]@{file = "$PWD/windows/powershell.ps1"; targetDir = "$HOME\Documents\PowerShell\"; targetFile = "Microsoft.PowerShell_profile.ps1"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/windows-terminal.json"; targetDir = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"; targetFile = "settings.json"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/spicetify.ini"; targetDir = "$HOME\.spicetify\"; targetFile = "config-xpui.ini"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/alt-snap.ini"; targetDir = "$Env:APPDATA\AltSnap\"; targetFile = "AltSnap.ini"; symlink = $FALSE}
    [PSCustomObject]@{file = "$PWD/shared/starship.toml"; targetDir = "$HOME\.config\"; targetFile = "starship.toml"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/.gitconfig"; targetDir = "$HOME\"; targetFile = ".gitconfig"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/shared/neovim.lua"; targetDir = "$Env:LOCALAPPDATA\nvim\lua\user\"; targetFile = "init.lua"; symlink = $TRUE},
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

# Run post-install scripts
&"C:\ProgramData\scoop\apps\7zip\current\install-context.reg"
&"C:\ProgramData\scoop\apps\everything\current\install-context.reg"
&"C:\ProgramData\scoop\apps\python\current\install-pep-514.reg"
&"C:\ProgramData\scoop\apps\notepadplusplus\current\install-context.reg"
Add-PATHEntry "$HOME\scoop\persist\rustup\.cargo\bin"
Add-PATHEntry "$ENV:LOCALAPPDATA/vcpkg"
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/JulienMaille/dribbblish-dynamic-theme/master/install.ps1" | Invoke-Expression
