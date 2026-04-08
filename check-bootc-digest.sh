#!/bin/bash
set -euo pipefail

STATE_DIR="/etc/bottomtext/bootc-digest"
STATE_FILE="$STATE_DIR/last-digest"

mkdir -p "$STATE_DIR"


CURRENT_DIGEST=$(bootc status | grep -m1 'Digest:' | awk '{print $2}')


if [[ -z "${CURRENT_DIGEST:-}" ]]; then
    echo "No bootc digest found"
    echo "unknown" > "$STATE_FILE"
    exit 0
fi

# Init
if [[ ! -f "$STATE_FILE" ]]; then
    echo "Initializing bootc digest state: $CURRENT_DIGEST"
    echo "$CURRENT_DIGEST" > "$STATE_FILE"
    exit 0
fi

PREVIOUS_DIGEST=$(cat "$STATE_FILE")

# Compare
if [[ "$CURRENT_DIGEST" != "$PREVIOUS_DIGEST" ]]; then
    echo "bootc digest changed:"
    echo "  old: $PREVIOUS_DIGEST"
    echo "  new: $CURRENT_DIGEST"

    # Only run if digest changed (new image)
    /etc/bottomtext/bin/bottomtext

    # Update
    echo "$CURRENT_DIGEST" > "$STATE_FILE"
else
    echo "bootc digest unchanged, not running"
fi
