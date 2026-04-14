#!/usr/bin/env bash

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

set -euo pipefail

URL="$1"
REPO="amrbashir/github-actions-downloader"

echo "Triggering workflow..."
gh workflow run download.yml -R "$REPO" -f url="$URL"

echo "Waiting for run to start..."
sleep 2

RUN_ID=$(gh run list -R "$REPO" -w download.yml -L 1 --json databaseId -q '.[0].databaseId')

if [ -z "$RUN_ID" ]; then
  echo "Error: could not find run ID" >&2
  exit 1
fi

echo "Watching run $RUN_ID..."
gh run watch "$RUN_ID" -R "$REPO" --exit-status

ARTIFACT_URL=$(gh api "repos/$REPO/actions/runs/$RUN_ID/artifacts" --jq '.artifacts[0].archive_download_url')

if [ -z "$ARTIFACT_URL" ]; then
  echo "Error: no artifact found" >&2
  exit 1
fi

echo "curl -LO $ARTIFACT_URL"
curl -LO "$ARTIFACT_URL"
