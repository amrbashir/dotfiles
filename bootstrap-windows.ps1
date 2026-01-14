# Source powershell profile (as it have useful functions and aliases)
. "$PWD\windows\powershell.ps1" -ErrorAction SilentlyContinue

Function WingetSilentInstall {
    winget install --silent --accept-package-agreements --accept-source-agreements --source winget $args
}

#################
#  Main Script  #
#################

# Install Git
WingetSilentInstall --id Git.Git
AddTo-PATH "$Env:SYSTEMDRIVE\Program Files\Git\bin"

Refresh-PATH

# Install Scoop
iwr -useb get.scoop.sh | iex

Refresh-PATH

# Add Scoop buckets
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add amrbashir https://github.com/amrbashir/scoop-bucket

# Symlink configs that are needed before installing from scoop
Symlink-Config -File "$PWD\windows\altsnap.ini" -ToDir "$HOME\scoop\persist\altsnap\" -ToFile "AltSnap.ini"
Symlink-Config -File "$PWD\windows\trafficmonitor.ini" -ToDir "$HOME\scoop\persist\trafficmonitor-lite\" -ToFile "config.ini"

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

# Add startup apps
AddTo-Startup keybindings "$HOME\scoop\apps\autohotkey\current\v2\AutoHotkey64.exe" "`"$PWD\windows\keybindings.ahk`""
AddTo-Startup Everything "$HOME\scoop\apps\everything\current\everything.exe" "-startup"
AddTo-Startup Mailspring "$HOME\scoop\apps\mailspring\current\mailspring.exe" "--background"
AddTo-Startup komorebi "$HOME\scoop\apps\nircmd\current\nircmd.exe" "elevate `"$HOME\scoop\apps\komorebi\current\komorebic-no-console.exe`" start --config `"$PWD\windows\komorebi.json`""
AddTo-Startup TrafficMonitor "$HOME\scoop\apps\trafficmonitor-lite\current\TrafficMonitor.exe"
AddTo-Startup AltSnap "$HOME\scoop\apps\altsnap\current\AltSnap.exe" "-elevate"
AddTo-Startup Windhawk "$HOME\scoop\apps\nircmd\current\nircmd.exe" "elevate `"$HOME\scoop\apps\windhawk\current\windhawk.exe`" -tray-only"
AddTo-Startup TranslucentTB "$HOME\scoop\apps\translucenttb\current\TranslucentTB.exe"
AddTo-Startup kal "$HOME\scoop\apps\kal\current\kal.exe"
AddTo-Startup komorebi-switcher "$HOME\scoop\apps\komorebi-switcher\current\komorebi-switcher.exe"
AddTo-Startup electron.app.Bitwarden "$Env:LOCALAPPDATA\Programs\Bitwarden\Bitwarden.exe"

# Symlink remaining config files
Symlink-Config -File "$PWD\windows\powershell.ps1" -ToDir "$HOME\Documents\PowerShell\" -ToFile "Microsoft.PowerShell_profile.ps1"
Symlink-Config -File "$PWD\windows\.gitconfig" -ToDir "$HOME\" -ToFile ".gitconfig"
Symlink-Config -File "$PWD\shared\starship.toml" -ToDir "$HOME\.config\" -ToFile "starship.toml"
Symlink-Config -File "$PWD\windows\kal.toml" -ToDir "$HOME\.config\" -ToFile "kal.toml"
Symlink-Config -File "$PWD\windows\windows-terminal.json" -ToDir "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\" -ToFile "settings.json"

# Set environment variables
Add-EnvVar "CARGO_TARGET_DIR" "D:\.cargo-target"