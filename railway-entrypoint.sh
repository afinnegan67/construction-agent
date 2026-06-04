#!/usr/bin/env bash
# Construction AI Employee — Railway entrypoint
#
# Runs as PID 1 in the container. Idempotent: safe to restart any time.
#
# On first boot:
#   - Installs the construction-agent profile from this repo
#   - Scaffolds the Context OS workspace
# On every boot:
#   - Syncs Railway env vars into the profile's .env
#   - Starts the Hermes gateway in polling mode (blocks forever)

set -euo pipefail

PROFILE_DIR="${HERMES_HOME}/profiles/${PROFILE_NAME}"
WORKSPACE_DIR="/root/workspace"

# ---------- 1. Install the profile (first boot only) ----------
if [ ! -f "${PROFILE_DIR}/distribution.yaml" ]; then
    echo "[entrypoint] First boot: installing profile from ${DISTRIBUTION_REPO}"
    hermes profile install "${DISTRIBUTION_REPO}" --yes
else
    echo "[entrypoint] Profile already installed at ${PROFILE_DIR}"
fi

# ---------- 2. Scaffold the Context OS workspace (first boot only) ----------
if [ ! -d "${WORKSPACE_DIR}/context-os/organizations" ]; then
    echo "[entrypoint] First boot: scaffolding Context OS workspace"
    mkdir -p "${WORKSPACE_DIR}/context-os/organizations"
    mkdir -p "${WORKSPACE_DIR}/context-os/global"
    mkdir -p "${WORKSPACE_DIR}/context-os/templates/project-template/documents"
    mkdir -p "${WORKSPACE_DIR}/context-os/templates/project-template/specs"

    # Copy README seed files from the installed profile so the directory
    # explains itself when the contractor opens it in VS Code.
    if [ -d "${PROFILE_DIR}/context-os-seed" ]; then
        cp -rn "${PROFILE_DIR}/context-os-seed/." "${WORKSPACE_DIR}/context-os/"
    fi
else
    echo "[entrypoint] Workspace already exists at ${WORKSPACE_DIR}/context-os"
fi

# ---------- 3. Sync Railway env vars into the profile's .env ----------
# Hermes reads ~/.hermes/profiles/<name>/.env at gateway start. Railway gives
# us env vars in the container environment, so we write them through.
ENV_FILE="${PROFILE_DIR}/.env"
{
    echo "# Auto-generated from Railway env vars by railway-entrypoint.sh"
    echo "# Edits will be overwritten on restart. Set values in Railway's"
    echo "# Variables tab instead."
    for var in OPENROUTER_API_KEY TELEGRAM_BOT_TOKEN TELEGRAM_ALLOWED_USERS \
               TELEGRAM_HOME_CHANNEL TELEGRAM_HOME_CHANNEL_NAME \
               TELEGRAM_CRON_THREAD_ID GROQ_API_KEY CODE_SERVER_PASSWORD; do
        val="${!var:-}"
        if [ -n "$val" ]; then
            echo "${var}=${val}"
        fi
    done
} > "${ENV_FILE}"
echo "[entrypoint] Wrote env vars to ${ENV_FILE}"

# ---------- 4. Sanity-check required vars before booting the gateway ----------
missing=()
for var in OPENROUTER_API_KEY TELEGRAM_BOT_TOKEN TELEGRAM_ALLOWED_USERS \
           TELEGRAM_HOME_CHANNEL GROQ_API_KEY; do
    if [ -z "${!var:-}" ]; then
        missing+=("$var")
    fi
done
if [ ${#missing[@]} -ne 0 ]; then
    echo "[entrypoint] ERROR: required Railway variables are not set:"
    for v in "${missing[@]}"; do echo "  - $v"; done
    echo "[entrypoint] Add them in Railway → Variables, then redeploy."
    exit 1
fi

# ---------- 5. Start code-server in background (if password is set) ----------
# code-server gives the contractor real VS Code in the browser, looking at
# the live filesystem: the Hermes profile, the Context OS workspace, and
# the running gateway logs. They get a full terminal panel too.
#
# Skipped if CODE_SERVER_PASSWORD is unset, so the agent works without it.
if [ -n "${CODE_SERVER_PASSWORD:-}" ]; then
    CODE_PORT="${PORT:-8080}"
    # Open VS Code on the workspace root so the contractor lands inside
    # ~/workspace with Context OS visible in the sidebar by default.
    mkdir -p "${WORKSPACE_DIR}"
    echo "[entrypoint] Starting code-server on 0.0.0.0:${CODE_PORT}"
    PASSWORD="${CODE_SERVER_PASSWORD}" \
        code-server \
            --bind-addr "0.0.0.0:${CODE_PORT}" \
            --auth password \
            --disable-telemetry \
            --disable-update-check \
            "${WORKSPACE_DIR}" \
        > /var/log/code-server.log 2>&1 &
    echo "[entrypoint] code-server PID $! — visit your Railway public URL"
else
    echo "[entrypoint] CODE_SERVER_PASSWORD not set — skipping VS Code"
fi

# ---------- 6. Run the gateway (PID 1, blocks forever) ----------
echo "[entrypoint] Starting Hermes gateway in polling mode for profile ${PROFILE_NAME}"
exec hermes -p "${PROFILE_NAME}" gateway
