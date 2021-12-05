#Requires -RunAsAdministrator

if ($PSVersionTable.PSEdition -ne "Core") {
    Write-Host "❌ Install Powershell Core first then use it to run the script." -ForegroundColor Red
    exit
}

Set-ExecutionPolicy Bypass -Scope CurrentUser

function RefreshPATH { $ENV:path = [System.ENVironment]::GetENVironmentVariable("Path", "Machine") + ";" + [System.ENVironment]::GetENVironmentVariable("Path", "User") }

if (-Not (Get-Command scoop)) {
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString("https://get.scoop.sh")
    RefreshPATH
}

scoop install git --global
RefreshPATH

scoop bucket add spotify "https://github.com/TheRandomLabs/Scoop-Spotify.git"
scoop bucket add nerd-fonts
scoop bucket add extras

scoop install sudo --global
scoop install vcredist --global

scoop install spotify-latest
scoop install blockthespot
scoop install spicetify-cli

scoop install autohotkey
scoop install rainmeter
scoop install taskbarx
scoop install trafficmonitor

scoop install windows-terminal --global
scoop install starship
scoop install neovim
scoop install bat
scoop install ripgrep

scoop install mailspring
scoop install 7zip --global
scoop install qbittorrent --global
scoop install everything --global
scoop install instant-eyedropper

git clone "https://github.com/microsoft/vcpkg" "$ENV:LOCALAPPDATA/vcpkg"
&"$ENV:LOCALAPPDATA/vcpkg/bootstrap-vcpkg.bat" -disableMetrics
scoop install yarn
RefreshPATH
yarn add --global pnpm
pnpm env use --global latest

#######
# 1. rustup - try scoop again
# 2. vscode - try scoop again and disable auto updater in vscode
# 3. steam - try
# 4. ueli - we have a custom build
# 5. modern flyouts - only from store
# 6. vivaldi - try scoop again
# 7. cmake - try scoop again
# 8. vlc - try scoop again
# 9. exa - instal from exa frok using cargo --git

scoop install FiraCode --global
scoop install FiraCode-NF --global

Install-Module -Name PowerShellGet -Force
Install-Module PSReadLine -Force -SkipPublisherCheck -AllowPrerelease
Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force

@(
    [PSCustomObject]@{file = "$PWD/windows/powershell.ps1"; targetFolder = "$HOME\Documents\PowerShell"; targetFile = "Microsoft.PowerShell_profile.ps1"},
    [PSCustomObject]@{file = "$PWD/windows/windows-terminal.json"; targetFolder = "$Env:LOCALAPPDATA\Microsoft\Windows Terminal"; targetFile = "settings.json"},
    [PSCustomObject]@{file = "$PWD/windows/spicetify.ini"; targetFolder = "$HOME\.spicetify"; targetFile = "config-xpui.ini"},
    [PSCustomObject]@{file = "$PWD/windows/alt-drag.ini"; targetFolder = "$HOME\scoop\apps\altdrag\current"; targetFile = "AltDrag.ini"}
    [PSCustomObject]@{file = "$PWD/shared/starship.toml"; targetFolder = "$HOME\.config"; targetFile = "starship.toml"},
    [PSCustomObject]@{file = "$PWD/shared/.gitconfig"; targetFolder = "$HOME"; targetFile = ".gitconfig"},
    [PSCustomObject]@{file = "$PWD/shared/neovim.vim"; targetFolder = "$Env:LOCALAPPDATA\nvim"; targetFile = "init.vim"}
) | ForEach-Object {
    if ($_.targetFolder -ne $HOME) {
        New-Item -Path $_.targetFolder -ItemType Directory -Force
    }

    $target = $_.targetFolder + $_.targetFile
    Remove-Item -Path $target  -Force
    New-Item -ItemType SymbolicLink -Target $_.file -Path $target
}
