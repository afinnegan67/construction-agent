# Construction AI Employee — Railway image
#
# This image:
#   1. Installs the Hermes Agent framework
#   2. On first boot, installs THIS profile via `hermes profile install`
#   3. Loads the contractor's secrets from Railway env vars into the profile's .env
#   4. Runs the Hermes gateway in polling mode (PID 1)
#
# Always-on Railway service — polling mode requires the container to stay
# awake so the every-15-minute cron can fire even when no message has
# arrived. Configure the Railway service with no sleep/idle.

FROM python:3.12-slim

# System deps Hermes needs: git (for `profile install`), curl, ffmpeg
# (Telegram voice notes are ogg/opus, ffmpeg handles them), build tools for
# any pip packages that compile (PyMuPDF, etc.).
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates ffmpeg build-essential sudo \
    && rm -rf /var/lib/apt/lists/*

# Install code-server — VS Code in the browser. This is how the contractor
# sees the agent's filesystem live (Context OS folders, profile, skills)
# from any device. Optional: only starts if CODE_SERVER_PASSWORD is set.
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install Hermes via pip — explicit, no install-script side effects.
# We pin a floor that supports profile distributions (>=0.13.0).
RUN pip install --no-cache-dir "hermes-agent>=0.13.0" \
    && pip install --no-cache-dir \
        google-api-python-client \
        google-auth-httplib2 \
        google-auth-oauthlib \
        PyMuPDF

# Hermes stores everything under ~/.hermes. Railway containers run as root
# by default, so that's /root/.hermes.
ENV HERMES_HOME=/root/.hermes
ENV PROFILE_NAME=construction-agent
ENV DISTRIBUTION_REPO=https://github.com/afinnegan67/construction-agent.git

WORKDIR /root

# Entrypoint: installs the profile on first boot, syncs env vars, runs gateway.
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh

# Railway routes its public HTTPS to whatever PORT we set. code-server binds
# there if CODE_SERVER_PASSWORD is set. Telegram polling is outbound only,
# so the gateway itself doesn't need a port — code-server is the ONLY thing
# that listens. No port = code-server disabled, gateway still runs fine.
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
