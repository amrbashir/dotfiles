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

#################
#  Main Script  #
#################

# Install Git
WingetSilentInstall --id Git.Git
Add-PATHEntry "$Env:SYSTEMDRIVE\Program Files\Git\bin"
Refresh-PATH

# Install Scoop
iwr -useb get.scoop.sh | iex
Refresh-PATH
scoop bucket add nerd-fonts
scoop bucket add extras
scoop bucket add versions

# Install apps
scoop install 7zip uutils-coreutils starship bat ripgrep fd neovim eza 
scoop install python fnm
sudo scoop install windowsdesktop-runtime-lts
scoop install qbittorrent everything everything-cli instant-eyedropper mailspring ds4windows
scoop install komorebi autohotkey trafficmonitor-lite altsnap micaforeveryone windhawk
scoop install FiraCode FiraCode-NF
WingetSilentInstall Discord
WingetSilentInstall VSCode
WingetSilentInstall Steam
WingetSilentInstall 1password
WingetSilentInstall TranslucentTB
WingetSilentInstall Powershell
Refresh-PATH

# Run post-install scripts
&"$HOME\scoop\apps\7zip\current\install-context.reg"
&"$HOME\scoop\apps\python\current\install-pep-514.reg"

# Install Rust
irm -Uri https://win.rustup.rs/x86_64 -Out $Env:TEMP/rustup-init.exe
&"$Env:TEMP/rustup-init.exe"
Refresh-PATH

# Install Node.js
fnm install --lts
fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression
fnm use lts-latest
Refresh-PATH

# Install PowerShell modules
pwsh -Command "Install-Module -Name PowerShellGet -Force"
pwsh -Command "Install-Module PSReadLine -Force -SkipPublisherCheck -AllowPrerelease"
pwsh -Command "Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force"

# Symlink or copy config files
@(
    @{file = "$PWD/windows/kal.toml"; targetDir = "$HOME\.config\"; targetFile = "kal.toml"; symlink = $TRUE},
    @{file = "$PWD/windows/powershell.ps1"; targetDir = "$HOME\Documents\PowerShell\"; targetFile = "Microsoft.PowerShell_profile.ps1"; symlink = $TRUE},
    @{file = "$PWD/windows/windows-terminal.json"; targetDir = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"; targetFile = "settings.json"; symlink = $TRUE},
    @{file = "$PWD/windows/alt-snap.ini"; targetDir = "$Env:APPDATA\AltSnap\"; targetFile = "AltSnap.ini"; symlink = $FALSE}
    @{file = "$PWD/shared/starship.toml"; targetDir = "$HOME\.config\"; targetFile = "starship.toml"; symlink = $TRUE},
    @{file = "$PWD/windows/MicaForEveryone.conf"; targetDir = "$Env:LOCALAPPDATA\Mica For Everyone\"; targetFile = "MicaForEveryone.conf"; symlink = $TRUE},
    @{file = "$PWD/windows/.gitconfig"; targetDir = "$HOME\"; targetFile = ".gitconfig"; symlink = $TRUE},
    @{file = "$PWD/windows/traffic-monitor.ini"; targetDir = "$Env:APPDATA\TrafficMonitor\"; targetFile = "config.ini"; symlink = $TRUE}
    @{file = "$PWD/windows/keybindings.ahk"; targetDir = "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"; targetFile = "keybindings.ahk"; symlink = $TRUE}
) | ForEach-Object {
    New-Item -Path $_.targetDir -ItemType Directory -Force
    $target = $_.targetDir + $_.targetFile

    if (Test-Path -Path $target) {
      Remove-Item -Path $target  -Force
    } 

    if ($_.symlink -eq $TRUE) {
        New-Item -ItemType SymbolicLink -Target $_.file -Path $target
    } else {
        Copy-Item $_.file $target
    }
}
