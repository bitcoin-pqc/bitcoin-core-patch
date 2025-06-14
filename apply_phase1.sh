#!/bin/bash
set -e

# Usage: ./apply_phase1.sh <repo-url> [<branch>]
# Example: ./apply_phase1.sh https://github.com/bitcoin-pqc/bitcoin-core-patch main
#
# This script applies Phase 1 changes to the bitcoin-core-patch repository.
# Phase 1 includes:
# - Initial repository setup
# - OP_CHECKPQCVERIFY opcode stub
# - Basic documentation and CI setup

if [ $# -lt 1 ]; then
    echo "Usage: $0 <repo-url> [<branch>]"
    echo "Example: $0 https://github.com/bitcoin-pqc/bitcoin-core-patch main"
    exit 1
fi

REPO_URL="$1"
BRANCH="${2:-main}"
TEMP_DIR=$(mktemp -d)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cleanup() {
    echo "Cleaning up temporary directory..."
    rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

echo "Cloning repository..."
git clone "$REPO_URL" "$TEMP_DIR"
cd "$TEMP_DIR"

echo "Checking out branch: $BRANCH"
git checkout "$BRANCH" || git checkout -b "$BRANCH"

echo "Applying Phase 1 patch..."
if ! git apply --3way "$SCRIPT_DIR/phase1.patch"; then
    echo "Error: Failed to apply patch"
    exit 1
fi

echo "Committing changes..."
git add .
git commit -m "Apply Phase 1 updates"

echo "Pushing changes..."
if ! git push origin "$BRANCH"; then
    echo "Error: Failed to push changes"
    exit 1
fi

echo "Successfully applied Phase 1 changes to $REPO_URL (branch: $BRANCH)"
