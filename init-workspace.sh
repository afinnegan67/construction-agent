#!/usr/bin/env bash
# Manual workspace scaffolder. The Railway entrypoint runs this automatically
# on first boot, but you can re-run it any time to repair the Context OS tree.
#
# Usage (from the Railway service Shell tab):
#   bash <(curl -fsSL https://raw.githubusercontent.com/afinnegan67/construction-agent/main/init-workspace.sh)
#
# Or, if the profile is already installed locally:
#   bash ~/.hermes/profiles/construction-agent/init-workspace.sh

set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-/root/workspace}"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
PROFILE_DIR="${HERMES_HOME}/profiles/construction-agent"

mkdir -p "${WORKSPACE_DIR}/context-os/organizations"
mkdir -p "${WORKSPACE_DIR}/context-os/global"
mkdir -p "${WORKSPACE_DIR}/context-os/templates/project-template/documents"
mkdir -p "${WORKSPACE_DIR}/context-os/templates/project-template/specs"

# If the profile is installed, copy the seed README files (they explain what
# each folder is for so the contractor isn't lost in VS Code).
if [ -d "${PROFILE_DIR}/context-os-seed" ]; then
    cp -rn "${PROFILE_DIR}/context-os-seed/." "${WORKSPACE_DIR}/context-os/"
    echo "Seeded Context OS from ${PROFILE_DIR}/context-os-seed"
else
    echo "Profile not installed locally — skeleton folders created, no README seeds."
fi

echo "Workspace ready at ${WORKSPACE_DIR}/context-os/"
