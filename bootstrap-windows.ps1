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

Function InstallMyApp {
    $appName = $args[0]
    irm "https://github.com/amrbashir/$appName/releases/latest/download/$appName-setup.exe" -OutFile "$appName-setup.exe"
    & "./$appName-setup.exe"
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

# Add Scoop buckets
scoop bucket add extras
scoop bucket add nerd-fonts

# Install apps
scoop install 7zip winrar
scoop install uutils-coreutils starship bat ripgrep fd neovim eza zoxide fzf
scoop install python fnm gh cmake ninja deno nsis taplo
scoop install bitwarden bitwarden-cli yubioath
scoop install g-helper qbittorrent everything everything-cli instant-eyedropper mailspring ds4windows inkscape
scoop install komorebi autohotkey trafficmonitor-lite altsnap windhawk translucenttb
scoop install FiraCode FiraCode-NF
sudo scoop install windowsdesktop-runtime-lts
InstallMyApp kal
InstallMyApp komorebi-switcher
WingetSilentInstall "Zen Browser"
WingetSilentInstall Screenbox
WingetSilentInstall Discord
WingetSilentInstall VSCode
WingetSilentInstall Steam
WingetSilentInstall Powershell
WingetSilentInstall Docker

Refresh-PATH

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

# Symlink config files
@(
    @{file = "$PWD/windows/kal.toml"; targetDir = "$HOME\.config\"; targetFile = "kal.toml"},
    @{file = "$PWD/windows/powershell.ps1"; targetDir = "$HOME\Documents\PowerShell\"; targetFile = "Microsoft.PowerShell_profile.ps1"},
    @{file = "$PWD/windows/windows-terminal.json"; targetDir = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"; targetFile = "settings.json"},
    @{file = "$PWD/windows/alt-snap.ini"; targetDir = "$HOME\scoop\apps\AltSnap\current"; targetFile = "AltSnap.ini"}
    @{file = "$PWD/shared/starship.toml"; targetDir = "$HOME\.config\"; targetFile = "starship.toml"},
    @{file = "$PWD/windows/.gitconfig"; targetDir = "$HOME\"; targetFile = ".gitconfig"},
    @{file = "$PWD/windows/traffic-monitor.ini"; targetDir = "$Env:APPDATA\TrafficMonitor\"; targetFile = "config.ini"}
    @{file = "$PWD/windows/keybindings.ahk"; targetDir = "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"; targetFile = "keybindings.ahk"}
) | ForEach-Object {
    New-Item -Path $_.targetDir -ItemType Directory -Force
    $target = $_.targetDir + $_.targetFile

    if (Test-Path -Path $target) {
      Remove-Item -Path $target  -Force
    } 

    New-Item -ItemType SymbolicLink -Target $_.file -Path $target
}
