# Source powershell utilities
. "$PSScriptRoot/windows/PowerShell/Utils.ps1"

Function WingetSilentInstall {
    winget install --silent --accept-package-agreements --accept-source-agreements --source winget $args
}

#################
#  Main Script  #
#################

# Install Git
WingetSilentInstall --id Git.Git
Add-ToPATH "$Env:SYSTEMDRIVE\Program Files\Git\bin"

Update-PATH

# Install Scoop
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

Update-PATH

# Add Scoop buckets
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add amrbashir https://github.com/amrbashir/scoop-bucket

# Symlink configs that are needed before installing from scoop
New-ConfigSymlink -File "$PWD\windows\AltSnap.ini" -ToDir "$HOME\scoop\persist\altsnap\" -ToFile "AltSnap.ini"
New-ConfigSymlink -File "$PWD\windows\trafficmonitor-lite\config.ini" -ToDir "$HOME\scoop\persist\trafficmonitor-lite\" -ToFile "config.ini"

# Install scoop apps
scoop install 7zip
scoop install uutils-coreutils starship bat ripgrep fd neovim eza zoxide fzf nircmd
scoop install python fnm gh cmake ninja deno nsis taplo
scoop install bitwarden-cli yubioath
scoop install g-helper qbittorrent everything everything-cli instant-eyedropper mailspring ds4windows inkscape
scoop install komorebi autohotkey trafficmonitor-lite altsnap windhawk translucenttb
scoop install FiraCode FiraCode-NF
scoop install kal komorebi-switcher
scoop install PSReadLine posh-git PSFzf
sudo scoop install windowsdesktop-runtime-lts

# Install winget apps 
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

Update-PATH

# Install WSL
wsl --update
wsl --install debian --no-launch

# Install Rust
Invoke-RestMethod -Uri https://win.rustup.rs/x86_64 -Out "$Env:TEMP/rustup-init.exe"
&"$Env:TEMP/rustup-init.exe"

Update-PATH

# Install Node.js
fnm install --lts
fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression
fnm use lts-latest

Update-PATH

# Add startup apps
Add-StartupApp keybindings "$HOME\scoop\apps\autohotkey\current\v2\AutoHotkey64.exe" "`"$PWD\windows\keybindings.ahk`""
Add-StartupApp Everything "$HOME\scoop\apps\everything\current\everything.exe" "-startup"
Add-StartupApp Mailspring "$HOME\scoop\apps\mailspring\current\mailspring.exe" "--background"
Add-StartupApp komorebi "$HOME\scoop\apps\nircmd\current\nircmd.exe" "elevate `"$HOME\scoop\apps\komorebi\current\komorebic-no-console.exe`" start --config `"$PWD\windows\komorebi.json`""
Add-StartupApp TrafficMonitor "$HOME\scoop\apps\trafficmonitor-lite\current\TrafficMonitor.exe"
Add-StartupApp AltSnap "$HOME\scoop\apps\altsnap\current\AltSnap.exe" "-elevate"
Add-StartupApp Windhawk "$HOME\scoop\apps\nircmd\current\nircmd.exe" "elevate `"$HOME\scoop\apps\windhawk\current\windhawk.exe`" -tray-only"
Add-StartupApp TranslucentTB "$HOME\scoop\apps\translucenttb\current\TranslucentTB.exe"
Add-StartupApp kal "$HOME\scoop\apps\kal\current\kal.exe"
Add-StartupApp komorebi-switcher "$HOME\scoop\apps\komorebi-switcher\current\komorebi-switcher.exe"
Add-StartupApp electron.app.Bitwarden "$Env:LOCALAPPDATA\Programs\Bitwarden\Bitwarden.exe"

# Symlink remaining config files
New-ConfigSymlink -Path "$PWD\windows\PowerShell\Microsoft.PowerShell_profile.ps1" -ToDir "$HOME\Documents\PowerShell" -ToFile "Microsoft.PowerShell_profile.ps1"
New-ConfigSymlink -Path "$PWD\windows\.gitconfig" -ToDir "$HOME" -ToFile ".gitconfig"
New-ConfigSymlink -Path "$PWD\shared\starship.toml" -ToDir "$HOME\.config" -ToFile "starship.toml"
New-ConfigSymlink -Path "$PWD\windows\kal.toml" -ToDir "$HOME\.config" -ToFile "kal.toml"
New-ConfigSymlink -Path "$PWD\windows\Windows Terminal\settings.json" -ToDir "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -ToFile "settings.json"

# Set environment variables
Add-EnvVar "CARGO_TARGET_DIR" "D:\.cargo-target"