#!/usr/bin/env bash
# Session Management Controller
# Routes commands to appropriate handlers and provides core CRUD operations

set -euo pipefail

# Configuration
DATA_DIR=".claude/data/sessions"
SCHEMA="config/schemas/session.json"
HOOKS_DIR=".claude/hooks"

# Ensure required directories exist
ensure_dirs() {
  mkdir -p "$DATA_DIR"
  mkdir -p "$HOOKS_DIR"
}

# Load session JSON by ID
load_json() {
  local id="$1"
  if [ ! -f "$DATA_DIR/$id.json" ]; then
    echo "Error: Session not found: $id" >&2
    exit 1
  fi
  cat "$DATA_DIR/$id.json"
}

# Validate JSON against schema
validate_json() {
  local payload="$1"
  if ! echo "$payload" | npx --yes ajv-cli validate -s "$SCHEMA" 2>&1; then
    echo "Error: Schema validation failed" >&2
    return 1
  fi
}

# Generate UUID (cross-platform)
generate_uuid() {
  if command -v uuidgen >/dev/null; then
    uuidgen | tr '[:upper:]' '[:lower:]'
  else
    python3 -c "import uuid; print(uuid.uuid4())"
  fi
}

# Get current timestamp
get_timestamp() {
  date -u +%Y-%m-%dT%H:%M:%SZ
}

# Command: start
# Creates new session with metadata
command_start() {
  ensure_dirs
  
  local name="${1:-Unnamed Session}"
  local auto_post=false
  local channel="#council-ops"
  
  # Parse options
  shift || true
  while [ $# -gt 0 ]; do
    case "$1" in
      --auto-post)
        auto_post=true
        shift
        ;;
      --channel)
        channel="$2"
        shift 2
        ;;
      *)
        shift
        ;;
    esac
  done
  
  local id
  id=$(generate_uuid)
  local now
  now=$(get_timestamp)
  
  # Build session JSON
  local payload
  payload=$(jq -n \
    --arg id "$id" \
    --arg name "$name" \
    --arg now "$now" \
    --arg cwd "$PWD" \
    --argjson auto_post "$auto_post" \
    --arg channel "$channel" \
    '{
      session_id: $id,
      agent_name: $name,
      started_at: $now,
      ended_at: null,
      project: "slack-hq",
      working_directory: $cwd,
      status: "active",
      auto_post: $auto_post,
      slack_channel: $channel,
      slack_message_ts: null,
      slack_thread_ts: null,
      activities: [],
      prompts: [],
      tools_used: [],
      files_modified: [],
      tags: [],
      notes: "",
      handoff_status: {
        state: "none",
        assignee: null,
        notes: ""
      }
    }')
  
  # Validate and persist
  if ! validate_json "$payload"; then
    exit 1
  fi
  
  echo "$payload" > "$DATA_DIR/$id.json"
  
  # Trigger start hook if exists
  if [ -x "$HOOKS_DIR/session_start.sh" ]; then
    "$HOOKS_DIR/session_start.sh" "$id" &
  fi
  
  # Return summary
  jq '{session_id, started_at, working_directory}' <<< "$payload"
}

# Command: stop
# Completes session with optional notes
command_stop() {
  ensure_dirs
  
  local id="$1"
  shift || true
  
  local notes=""
  local do_post=false
  
  # Parse options
  while [ $# -gt 0 ]; do
    case "$1" in
      --notes)
        notes="$2"
        shift 2
        ;;
      --post)
        do_post=true
        shift
        ;;
      *)
        shift
        ;;
    esac
  done
  
  local path="$DATA_DIR/$id.json"
  
  # Update session
  jq --arg end "$(get_timestamp)" \
     --arg notes "$notes" \
     '.ended_at = $end | .status = "completed" | if $notes != "" then .notes = $notes else . end' \
     "$path" | sponge "$path"
  
  # Trigger stop hook
  if [ -x "$HOOKS_DIR/session_stop.sh" ]; then
    "$HOOKS_DIR/session_stop.sh" "$id" &
  fi
  
  # Post to Slack if requested
  if [ "$do_post" = true ]; then
    ./scripts/session.sh post --id "$id"
  fi
  
  jq '{session_id, ended_at, status, notes}' "$path"
}

# Command: current
# Returns ID of current active session
command_current() {
  ensure_dirs
  
  # Find most recent active session
  local current
  current=$(find "$DATA_DIR" -name "*.json" -type f -exec jq -r \
    'select(.status == "active") | .session_id' {} \; | head -n1)
  
  if [ -z "$current" ]; then
    echo "No active session" >&2
    exit 1
  fi
  
  echo "$current"
}

# Command: validate
# Validates session against schema
command_validate() {
  local id="$1"
  local payload
  payload=$(load_json "$id")
  
  if validate_json "$payload"; then
    echo "✅ Session valid"
  else
    echo "❌ Validation failed"
    exit 1
  fi
}

# Main router
case "${1:-help}" in
  start)
    shift
    command_start "$@"
    ;;
  stop)
    shift
    command_stop "$@"
    ;;
  status)
    shift
    exec ./scripts/session_status.ts "$@"
    ;;
  history)
    shift
    exec ./scripts/session_history.ts "$@"
    ;;
  show)
    shift
    exec ./scripts/session_show.ts "$@"
    ;;
  post)
    shift
    exec ./scripts/session_post.ts "$@"
    ;;
  current)
    shift
    command_current "$@"
    ;;
  validate)
    shift
    command_validate "$@"
    ;;
  help|--help|-h)
    cat << EOF
Session Management CLI

Usage: $0 <command> [options]

Commands:
  start [name] [--auto-post] [--channel <ch>]  Create new session
  stop <id> [--notes <text>] [--post]          Complete session
  status                                        Show current session
  history [--limit N] [--agent <name>]         List recent sessions
  show <id>                                     Display session details
  post [--id <id>] [--thread] [--dry-run]      Post to Slack
  current                                       Get active session ID
  validate <id>                                 Validate session JSON

Examples:
  $0 start "Implement feature"
  $0 stop abc123 --notes "Completed" --post
  $0 history --limit 5
  $0 post --id abc123 --thread
EOF
    ;;
  *)
    echo "Unknown command: $1" >&2
    echo "Run '$0 help' for usage" >&2
    exit 1
    ;;
esac
