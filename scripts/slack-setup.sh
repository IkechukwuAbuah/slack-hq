#!/usr/bin/env bash
set -Eeuo pipefail

WORKSPACE_NAME="The Council"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST_FILE="$ROOT_DIR/manifest.yml"

info() { echo "[INFO]  $*"; }
warn() { echo "[WARN]  $*" >&2; }
err()  { echo "[ERROR] $*" >&2; }
abort(){ err "$*"; exit 1; }

require_slack() {
  command -v slack >/dev/null 2>&1 || abort "Slack CLI not found. Install with: brew install --cask slack-cli"
  info "Slack CLI found: $(slack version || true)"
}

ensure_auth() {
  info "Checking Slack auths..."
  if ! slack auth list 2>/dev/null | grep -qi "$WORKSPACE_NAME"; then
    warn "No auth found for '$WORKSPACE_NAME'. Launching login..."
    slack login || abort "Login failed"
  fi
  info "Current auths:"
  slack auth list || true
  echo
  read -r -p "Ensure '$WORKSPACE_NAME' is selected in the list above (browser flow). Press Enter to continue..."
}

show_manifest() {
  [[ -f "$MANIFEST_FILE" ]] || abort "Manifest not found at $MANIFEST_FILE"

  info "Manifest file location: $MANIFEST_FILE"
  echo
  info "Council Bot manifest contents:"
  cat "$MANIFEST_FILE"
  echo
}

show_instructions() {
  cat <<'EOS'

📋 Manual Setup Required:

The Slack CLI in this setup uses a manifest-only approach. Follow these steps:

1. Go to https://api.slack.com/apps
2. Click "Create New App"
3. Choose "From an app manifest"
4. Select "The Council" workspace
5. Copy the contents of manifest.yml and paste it
6. Review the configuration and click "Create"
7. Click "Install to Workspace"
8. Authorize the permissions
9. Copy your tokens from the app settings:
   - Bot Token: OAuth & Permissions page
   - Signing Secret: Basic Information page
   - App Token: Basic Information > App-Level Tokens
   - Workspace ID: From your workspace URL

10. Save tokens to .env file:
    cp .env.example .env
    # Edit .env and add your tokens

EOS
}

next_steps() {
  cat <<'EOS'

Next steps:
1) If a browser OAuth link was shown, open it to install/update Council Bot in 'The Council'.
2) After installation, populate /Users/x/Downloads/slack-hq/.env with your values:
   - SLACK_BOT_TOKEN, SLACK_SIGNING_SECRET, SLACK_APP_TOKEN, SLACK_WORKSPACE_ID
3) Test the token:
   SLACK_BOT_TOKEN=your-token curl -s -X POST https://slack.com/api/auth.test -H "Authorization: Bearer $SLACK_BOT_TOKEN"
EOS
}

main() {
  require_slack
  ensure_auth
  show_manifest
  show_instructions
  next_steps
  info "Setup guide displayed. Follow the instructions above to create Council Bot."
}

main "$@"
