tell application "System Events"
    repeat with appName in {"Vicinae", "Stats", "Swift Shift", "AltTab", "komorebi-switcher"}
        set appPath to "/Applications/" & appName & ".app"
        if not (exists login item appName) then
            make new login item at end with properties {path:appPath, hidden:false}
        end if
    end repeat
end tell
