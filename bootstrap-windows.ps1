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
    Write-Output "Installing $appName..."
    irm "https://github.com/amrbashir/$appName/releases/latest/download/$appName-setup.exe" -OutFile "$Env:TEMP/$appName-setup.exe"
    &"$Env:TEMP/$appName-setup.exe" /S
}

Function AddAppToStartup {
    $name = $args[0]
    $path = $args[1]
    $args = $args[2]
    $args = if ($args -eq "") { "" } else { " $args" }
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $name -Value "`"$path`"$args"
}

function SymlinkConfig {
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

    # This requires Developer mode
    New-Item -ItemType SymbolicLink -Target $File -Path $to
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

# Symlink configs that needed before installing from scoop
SymlinkConfig -File "$PWD\windows\altsnap.ini" -ToDir "$HOME\scoop\persist\altsnap\" -ToFile "AltSnap.ini"
SymlinkConfig -File "$PWD\windows\trafficmonitor.ini" -ToDir "$HOME\scoop\persist\trafficmonitor-lite\" -ToFile "config.ini"

# Install scoop apps
scoop install 7zip winrar
scoop install uutils-coreutils starship bat ripgrep fd neovim eza zoxide fzf
scoop install python fnm gh cmake ninja deno nsis taplo
scoop install bitwarden-cli yubioath
scoop install g-helper qbittorrent everything everything-cli instant-eyedropper mailspring ds4windows inkscape
scoop install komorebi autohotkey trafficmonitor-lite altsnap windhawk translucenttb
scoop install FiraCode FiraCode-NF
sudo scoop install windowsdesktop-runtime-lts

InstallMyApp kal
InstallMyApp komorebi-switcher
 
WingetSilentInstall --id Bitwarden.Bitwarden
WingetSilentInstall --id Zen-Team.Zen-Browser
WingetSilentInstall --id Starpine.Screenbox
WingetSilentInstall --id Discord.Discord
WingetSilentInstall --id Microsoft.VisualStudioCode
WingetSilentInstall --id Valve.Steam
WingetSilentInstall --id Nefarius.HidHide
WingetSilentInstall --id Microsoft.PowerShell
WingetSilentInstall --id Google.AndroidStudio
WingetSilentInstall --id Docker.DockerDesktop

Refresh-PATH

# Install WSL
wsl --update
wsl --install debian --no-launch

# Install Rust
irm -Uri https://win.rustup.rs/x86_64 -Out "$Env:TEMP/rustup-init.exe"
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

# Add startup apps
AddAppToStartup keybindings "$HOME\scoop\apps\autohotkey\current\v2\AutoHotkey64.exe" "`"$PWD\windows\keybindings.ahk`""
AddAppToStartup Everything "$HOME\scoop\apps\everything\current\everything.exe" "-startup"
AddAppToStartup Mailspring "$HOME\scoop\apps\mailspring\current\mailspring.exe" "--background"
AddAppToStartup komorebi "$HOME\scoop\apps\komorebi\current\komorebic-no-console.exe" "start --config $PWD\windows\komorebi.json"
AddAppToStartup TrafficMonitor "$HOME\scoop\apps\trafficmonitor-lite\current\TrafficMonitor.exe"
AddAppToStartup AltSnap "$HOME\scoop\apps\altsnap\current\AltSnap.exe" "-elevate"
AddAppToStartup Windhawk "$HOME\scoop\apps\windhawk\current\windhawk.exe" "-tray-only"
AddAppToStartup TranslucentTB "$HOME\scoop\apps\translucenttb\current\TranslucentTB.exe"
AddAppToStartup kal "$Env:LOCALAPPDATA\kal\kal.exe"
AddAppToStartup komorebi-switcher "$Env:LOCALAPPDATA\komorebi-switcher\komorebi-switcher.exe"
AddAppToStartup electron.app.Bitwarden "$Env:LOCALAPPDATA\Programs\Bitwarden\Bitwarden.exe"

# Symlink remaining config files
SymlinkConfig -File "$PWD\windows\powershell.ps1" -ToDir "$HOME\Documents\PowerShell\" -ToFile "Microsoft.PowerShell_profile.ps1"
SymlinkConfig -File "$PWD\windows\.gitconfig" -ToDir "$HOME\" -ToFile ".gitconfig"
SymlinkConfig -File "$PWD\shared\starship.toml" -ToDir "$HOME\.config\" -ToFile "starship.toml"
SymlinkConfig -File "$PWD\windows\kal.toml" -ToDir "$HOME\.config\" -ToFile "kal.toml"
SymlinkConfig -File "$PWD\windows\windows-terminal.json" -ToDir "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\" -ToFile "settings.json"