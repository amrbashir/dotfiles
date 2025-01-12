
# Symlink or copy config files
@(
    [PSCustomObject]@{file = "$PWD/windows/powershell.ps1"; targetDir = "$HOME\Documents\PowerShell\"; targetFile = "Microsoft.PowerShell_profile.ps1"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/windows-terminal.json"; targetDir = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"; targetFile = "settings.json"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/alt-snap.ini"; targetDir = "$Env:APPDATA\AltSnap\"; targetFile = "AltSnap.ini"; symlink = $FALSE}
    [PSCustomObject]@{file = "$PWD/shared/starship.toml"; targetDir = "$HOME\.config\"; targetFile = "starship.toml"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/MicaForEveryone.conf"; targetDir = "$Env:LOCALAPPDATA\Mica For Everyone\"; targetFile = "MicaForEveryone.conf"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/.gitconfig"; targetDir = "$HOME\"; targetFile = ".gitconfig"; symlink = $TRUE},
    [PSCustomObject]@{file = "$PWD/windows/traffic-monitor.ini"; targetDir = "$Env:APPDATA\TrafficMonitor\"; targetFile = "config.ini"; symlink = $TRUE}
    [PSCustomObject]@{file = "$PWD/windows/keybindings.ahk"; targetDir = "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"; targetFile = "keybindings.ahk"; symlink = $TRUE}
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
