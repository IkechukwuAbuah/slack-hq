#!/bin/bash
# Slack API Helper - Direct API calls bypassing buggy MCP
# Usage: ./slack-api-helper.sh <command> [args]

set -euo pipefail

# Load environment
if [ -f "$(dirname "$0")/../.env" ]; then
    source "$(dirname "$0")/../.env"
elif [ -f ".env" ]; then
    source .env
else
    echo "Error: .env file not found"
    exit 1
fi

# Verify token is set
if [ -z "${SLACK_BOT_TOKEN:-}" ]; then
    echo "Error: SLACK_BOT_TOKEN not set"
    exit 1
fi

BASE_URL="https://slack.com/api"

# Helper function for API calls
slack_api_call() {
    local endpoint="$1"
    shift
    curl -s "${BASE_URL}/${endpoint}" \
        -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
        -H "Content-Type: application/json" \
        "$@"
}

case "${1:-help}" in
    list-channels)
        # List all public channels (bypasses MCP bug)
        response=$(slack_api_call "conversations.list?types=public_channel&limit=200&exclude_archived=true")
        if ! echo "$response" | jq -e '.ok' > /dev/null; then
            echo "$response"
            exit 1
        fi
        echo "$response" | jq '{
            ok: .ok,
            count: (.channels | length),
            channels: [.channels[] | {
                id,
                name,
                is_member,
                num_members,
                topic: .topic.value,
                purpose: .purpose.value
            }]
        }'
        ;;

    get-channel)
        # Get channel by name or ID
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 get-channel <name-or-id>"
            exit 1
        fi

        # Try as ID first
        result=$(slack_api_call "conversations.info?channel=$2")
        if echo "$result" | jq -e '.ok' > /dev/null; then
            echo "$result" | jq '.channel'
        else
            # Search by name
            response=$(slack_api_call "conversations.list?types=public_channel&limit=200")
            if ! echo "$response" | jq -e '.ok' > /dev/null; then
                echo "$response"
                exit 1
            fi
            echo "$response" | jq --arg name "$2" '.channels[] | select(.name == $name)'
        fi
        ;;

    post-message)
        # Post message to channel
        if [ -z "${2:-}" ] || [ -z "${3:-}" ]; then
            echo "Usage: $0 post-message <channel-id> <message>"
            exit 1
        fi

        slack_api_call "chat.postMessage" \
            -d "{\"channel\":\"$2\",\"text\":\"$3\"}"
        ;;

    channel-history)
        # Get channel history
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 channel-history <channel-id> [limit]"
            exit 1
        fi

        limit="${3:-10}"
        response=$(slack_api_call "conversations.history?channel=$2&limit=$limit")
        if ! echo "$response" | jq -e '.ok' > /dev/null; then
            echo "$response"
            exit 1
        fi
        echo "$response" | jq '.messages'
        ;;

    find-channel)
        # Find channel by partial name match
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 find-channel <search-term>"
            exit 1
        fi

        response=$(slack_api_call "conversations.list?types=public_channel&limit=200")
        if ! echo "$response" | jq -e '.ok' > /dev/null; then
            echo "$response"
            exit 1
        fi
        echo "$response" | jq --arg search "$2" '.channels[] | select(.name | contains($search)) | {id, name, purpose: .purpose.value}'
        ;;

    list-users)
        # List workspace users
        response=$(slack_api_call "users.list?limit=200")
        if ! echo "$response" | jq -e '.ok' > /dev/null; then
            echo "$response"
            exit 1
        fi
        echo "$response" | jq '{
            ok: .ok,
            count: (.members | length),
            members: [.members[] | {
                id,
                name: .name,
                real_name: .profile.real_name_normalized,
                display_name: .profile.display_name_normalized,
                is_bot,
                is_owner,
                is_admin,
                is_app_user
            }]
        }'
        ;;

    get-user)
        # Get user by ID or email
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 get-user <id|--email address>"
            exit 1
        fi

        if [ "$2" = "--email" ]; then
            if [ -z "${3:-}" ]; then
                echo "Usage: $0 get-user --email user@example.com"
                exit 1
            fi
            response=$(slack_api_call "users.lookupByEmail?email=${3}")
            if ! echo "$response" | jq -e '.ok' > /dev/null; then
                echo "$response"
                exit 1
            fi
            echo "$response" | jq '.user'
        else
            response=$(slack_api_call "users.info?user=${2}")
            if ! echo "$response" | jq -e '.ok' > /dev/null; then
                echo "$response"
                exit 1
            fi
            echo "$response" | jq '.user'
        fi
        ;;

    create-channel)
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 create-channel <name> [--private] [--topic \"text\"] [--purpose \"text\"]"
            exit 1
        fi

        name="$2"
        is_private="false"
        topic=""
        purpose=""
        shift 2

        while [ $# -gt 0 ]; do
            case "$1" in
                --private)
                    is_private="true"
                    shift
                    ;;
                --topic)
                    topic="${2:-}"
                    shift 2
                    ;;
                --purpose)
                    purpose="${2:-}"
                    shift 2
                    ;;
                *)
                    echo "Unknown option: $1"
                    exit 1
                    ;;
            esac
        done

        if [ "$is_private" = "true" ]; then
            private_json=true
        else
            private_json=false
        fi

        create_payload=$(jq -n --arg name "$name" --argjson private "$private_json" '{name: $name, is_private: $private}')
        response=$(slack_api_call "conversations.create" -X POST -d "$create_payload")

        if ! echo "$response" | jq -e '.ok' > /dev/null; then
            echo "$response"
            exit 1
        fi

        channel_id=$(echo "$response" | jq -r '.channel.id')

        if [ -n "$topic" ]; then
            slack_api_call "conversations.setTopic" -X POST -d "$(jq -n --arg channel "$channel_id" --arg topic "$topic" '{channel: $channel, topic: $topic}')"
        fi

        if [ -n "$purpose" ]; then
            slack_api_call "conversations.setPurpose" -X POST -d "$(jq -n --arg channel "$channel_id" --arg purpose "$purpose" '{channel: $channel, purpose: $purpose}')"
        fi

        echo "$response" | jq '.channel'
        ;;

    invite-to-channel)
        if [ $# -lt 3 ]; then
            echo "Usage: $0 invite-to-channel <channel-id> <user-id-1> [user-id-2 ...]"
            exit 1
        fi

        channel_id="$2"
        shift 2
        users=$(IFS=,; echo "$*")
        payload=$(jq -n --arg channel "$channel_id" --arg users "$users" '{channel: $channel, users: $users}')
        response=$(slack_api_call "conversations.invite" -X POST -d "$payload")
        echo "$response"
        ;;

    archive-channel)
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 archive-channel <channel-id>"
            exit 1
        fi

        payload=$(jq -n --arg channel "$2" '{channel: $channel}')
        response=$(slack_api_call "conversations.archive" -X POST -d "$payload")
        echo "$response"
        ;;

    post-thread)
        if [ $# -lt 4 ]; then
            echo "Usage: $0 post-thread <channel-id> <thread-ts> <message>"
            exit 1
        fi

        channel_id="$2"
        thread_ts="$3"
        shift 3
        text="$*"

        payload=$(jq -n --arg channel "$channel_id" --arg text "$text" --arg thread_ts "$thread_ts" '{channel: $channel, text: $text, thread_ts: $thread_ts}')
        response=$(slack_api_call "chat.postMessage" -X POST -d "$payload")
        echo "$response"
        ;;

    open-dm)
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 open-dm <user-id> [message]"
            exit 1
        fi

        user_id="$2"
        message="${3:-}"
        open_payload=$(jq -n --arg users "$user_id" '{users: [$users]}')
        open_response=$(slack_api_call "conversations.open" -X POST -d "$open_payload")

        if ! echo "$open_response" | jq -e '.ok' > /dev/null; then
            echo "$open_response"
            exit 1
        fi

        channel_id=$(echo "$open_response" | jq -r '.channel.id')

        if [ -n "$message" ]; then
            message_payload=$(jq -n --arg channel "$channel_id" --arg text "$message" '{channel: $channel, text: $text}')
            response=$(slack_api_call "chat.postMessage" -X POST -d "$message_payload")
            echo "$response"
        else
            echo "$open_response" | jq '.channel'
        fi
        ;;

    help|*)
        cat << 'EOF'
Slack API Helper - Direct API Access (bypasses MCP bug)

Commands:
  list-channels              List all public channels (unfiltered)
  get-channel <name-or-id>   Get channel details by name or ID
  post-message <id> <text>   Post message to channel
  channel-history <id> [n]   Get last n messages (default 10)
  find-channel <search>      Find channels by partial name match
  list-users                 List workspace members (basic fields)
  get-user <id|--email>      Fetch user information
  create-channel <name> [options]    Create public/private channels
  invite-to-channel <id> <user...>   Invite one or more users
  archive-channel <id>       Archive a channel
  post-thread <id> <ts> <text>       Reply in a thread
  open-dm <user-id> [text]   Start DM (and optionally send a message)
  help                       Show this help message

Examples:
  ./slack-api-helper.sh list-channels
  ./slack-api-helper.sh find-channel announcements
  ./slack-api-helper.sh get-channel C09Q8KCGM9C
  ./slack-api-helper.sh post-message C09Q8KCGM9C "Test message"
  ./slack-api-helper.sh channel-history C09Q8KCGM9C 20

Environment:
  Requires SLACK_BOT_TOKEN in .env file
EOF
        ;;
esac
