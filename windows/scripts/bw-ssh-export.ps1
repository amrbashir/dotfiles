# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Export SSH Keys from Bitwarden
# @raycast.description Export all SSH keys from Bitwarden vault to ~/.ssh
# @raycast.mode compact

# Documentation:
# @raycast.author Amr
# @raycast.authorURL https://amrbashir.me

$ErrorActionPreference = "Stop"

# Login if not logged in
if (-not (bw login --check 2>$null)) {
    Write-Host "Not logged in. Logging in..."
    $env:BW_SESSION = bw login --raw
}

# Unlock if locked
if (-not (bw unlock --check 2>$null)) {
    Write-Host "Vault is locked. Unlocking..."
    $env:BW_SESSION = bw unlock --raw
}

# Ensure ~/.ssh exists
$sshDir = "$env:USERPROFILE\.ssh"
if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir | Out-Null
}

# Export SSH keys
$items = bw list items | ConvertFrom-Json
$items | Where-Object { $_.type -eq 5 } | ForEach-Object {
    $name = $_.name
    $item = bw get item $_.id | ConvertFrom-Json

    Write-Host "Exporting: $name"

    $privatePath = Join-Path $sshDir $name
    $publicPath = Join-Path $sshDir "$name.pub"

    Set-Content -Path $privatePath -Value $item.sshKey.privateKey -NoNewline
    Set-Content -Path $publicPath -Value $item.sshKey.publicKey -NoNewline

    # Set ACL on private key: remove inheritance, restrict to current user only
    $acl = New-Object System.Security.AccessControl.FileSecurity
    $acl.SetAccessRuleProtection($true, $false)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        [System.Security.Principal.WindowsIdentity]::GetCurrent().Name,
        "FullControl",
        "Allow"
    )
    $acl.AddAccessRule($rule)
    Set-Acl -Path $privatePath -AclObject $acl
}

Write-Host "Done."
