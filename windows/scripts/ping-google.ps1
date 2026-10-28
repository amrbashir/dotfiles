# Required parameters:
# @vicinae.schemaVersion 1
# @vicinae.title Ping Google
# @vicinae.mode fullOutput

# Optional parameters:
# @vicinae.icon 🌐
# @vicinae.description Pings Google DNS server (8.8.8.8)

# Documentation:
# @vicinae.author Amr
# @vicinae.authorURL https://amrbashir.me

ping.exe 8.8.8.8
exit $LASTEXITCODE
