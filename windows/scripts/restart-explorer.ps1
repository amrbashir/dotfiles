# Required parameters:
# @vicinae.schemaVersion 1
# @vicinae.title Restart Explorer
# @vicinae.mode silent

# Optional parameters:
# @vicinae.icon 🔄️
# @vicinae.description Restarts Windows Explorer

# Documentation:
# @vicinae.author Amr
# @vicinae.authorURL https://amrbashir.me

Stop-Process -Name explorer -Force
Start-Process explorer.exe
