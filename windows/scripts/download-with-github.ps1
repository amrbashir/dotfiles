# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Download with GitHub
# @raycast.description Download a file using GitHub Actions as a proxy.
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.argument1 { "type": "text", "placeholder": "URL", "optional": false }

# Documentation:
# @raycast.author Amr
# @raycast.authorURL https://amrbashir.me

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Url
)

$ErrorActionPreference = 'Stop'
$Repo = 'amrbashir/github-actions-downloader'

Write-Host "Triggering workflow..."
gh workflow run download.yml -R $Repo -f url="$Url"

Write-Host "Waiting for run to start..."
Start-Sleep -Seconds 2

$RunId = gh run list -R $Repo -w download.yml -L 1 --json databaseId -q '.[0].databaseId'

if (-not $RunId) {
    Write-Error "Could not find run ID"
    exit 1
}

Write-Host "Watching run $RunId..."
gh run watch $RunId -R $Repo --exit-status
if ($LASTEXITCODE -ne 0) { exit 1 }

$ArtifactUrl = gh api "repos/$Repo/actions/runs/$RunId/artifacts" --jq '.artifacts[0].archive_download_url'

if (-not $ArtifactUrl) {
    Write-Error "No artifact found"
    exit 1
}

Write-Host "curl -LO $ArtifactUrl"
curl -LO $ArtifactUrl
