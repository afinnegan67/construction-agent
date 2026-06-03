#!/bin/bash
# ============================================================
# Opulence AI — Construction Agent Setup
# One command to install everything.
# Run this on a fresh Ubuntu 24.04 server (Hetzner CX22).
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/opulence-ai/construction-agent/main/setup.sh | bash
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

REPO="https://raw.githubusercontent.com/afinnegan67/construction-agent/main"
HERMES_HOME="$HOME/.hermes"
PROFILE_DIR="$HERMES_HOME/profiles/construction"
SKILLS_DIR="$PROFILE_DIR/skills"
CONTEXT_OS="$HOME/workspace/context-os"

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  Opulence AI — Construction Agent Setup${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo "This will install everything your AI employee needs."
echo "It takes about 3-5 minutes."
echo ""

# --- Step 1: System updates ---
echo -e "${YELLOW}[1/6] Updating system packages...${NC}"
sudo apt update -qq && sudo apt upgrade -y -qq
sudo apt install -y -qq python3 python3-pip python3-venv git curl tmux jq
echo -e "${GREEN}  Done.${NC}"

# --- Step 2: Install Hermes ---
echo -e "${YELLOW}[2/6] Installing Hermes (the AI agent framework)...${NC}"
if command -v hermes &> /dev/null; then
    echo "  Hermes already installed. Skipping."
else
    curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
    echo -e "${GREEN}  Hermes installed.${NC}"
fi

# --- Step 3: Set up the construction profile ---
echo -e "${YELLOW}[3/6] Setting up construction profile...${NC}"

# Create profile if it doesn't exist
hermes profile create construction 2>/dev/null || true

# Create directories
mkdir -p "$PROFILE_DIR"
mkdir -p "$SKILLS_DIR"
mkdir -p "$HERMES_HOME/credentials"

# Download construction profile
curl -fsSL "$REPO/construction-profile.md" -o "$PROFILE_DIR/SKILL.md"

# Download skills
echo "  Downloading skills..."
curl -fsSL "$REPO/skills/context-os-maintenance.md" -o "$SKILLS_DIR/context-os-maintenance/SKILL.md" --create-dirs
curl -fsSL "$REPO/skills/data-mapping.md" -o "$SKILLS_DIR/data-mapping/SKILL.md" --create-dirs
curl -fsSL "$REPO/skills/gmail.md" -o "$SKILLS_DIR/gmail/SKILL.md" --create-dirs
curl -fsSL "$REPO/skills/google-drive.md" -o "$SKILLS_DIR/google-drive/SKILL.md" --create-dirs
curl -fsSL "$REPO/skills/email-flagging.md" -o "$SKILLS_DIR/email-flagging/SKILL.md" --create-dirs

# Configure profile
hermes config set model.default "anthropic/claude-sonnet-4" --profile construction
hermes config set model.provider "openrouter" --profile construction
hermes config set terminal.cwd "$HOME/workspace/context-os/" --profile construction

echo -e "${GREEN}  Profile configured.${NC}"

# --- Step 4: Scaffold Context OS ---
echo -e "${YELLOW}[4/6] Building Context OS folder structure...${NC}"

# Download the folder template
curl -fsSL "$REPO/context-os-template.tar.gz" -o /tmp/context-os-template.tar.gz

# Only extract if we got the file
if [ -f /tmp/context-os-template.tar.gz ] && [ -s /tmp/context-os-template.tar.gz ]; then
    mkdir -p "$CONTEXT_OS"
    tar -xzf /tmp/context-os-template.tar.gz -C "$CONTEXT_OS" --strip-components=1 2>/dev/null || true
    rm /tmp/context-os-template.tar.gz
else
    # Fallback: scaffold manually from raw GitHub files
    echo "  Scaffolding from raw files..."
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/thompson-residence/documents"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/thompson-residence/specs"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/henderson-residence/documents"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/henderson-residence/specs"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/mcgraw-remodel/documents"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/mcgraw-remodel/specs"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/parker-custom/documents"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/parker-custom/specs"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/davis-addition/documents"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/davis-addition/specs"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/reynolds-spec/documents"
    mkdir -p "$CONTEXT_OS/organizations/opulence-custom-homes/projects/reynolds-spec/specs"
    mkdir -p "$CONTEXT_OS/templates/project-template/documents"
    mkdir -p "$CONTEXT_OS/templates/project-template/specs"
    mkdir -p "$CONTEXT_OS/global"
fi

# Download README files
echo "  Downloading README files..."
curl -fsSL "$REPO/context-os/README.md" -o "$CONTEXT_OS/README.md" --create-dirs
curl -fsSL "$REPO/context-os/organizations/README.md" -o "$CONTEXT_OS/organizations/README.md" --create-dirs
curl -fsSL "$REPO/context-os/global/README.md" -o "$CONTEXT_OS/global/README.md" --create-dirs

echo -e "${GREEN}  Context OS ready at ~/workspace/context-os/${NC}"

# --- Step 5: Install Python tools ---
echo -e "${YELLOW}[5/5] Installing Python tools (for Gmail, Drive, PDF reading)...${NC}"
pip install --quiet google-api-python-client google-auth-httplib2 google-auth-oauthlib PyMuPDF
echo -e "${GREEN}  Python tools installed.${NC}"

# --- Done ---
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Setup complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "Your AI employee is installed but needs a few more things"
echo "before it can work. Follow these steps:"
echo ""
echo -e "${CYAN}Step 1:${NC} Create a Telegram bot"
echo "  Open Telegram on your phone"
echo "  Search for @BotFather"
echo "  Send: /newbot"
echo "  Give it a name and username"
echo "  Copy the token it gives you"
echo ""
echo -e "${CYAN}Step 2:${NC} Wire the bot to Hermes"
echo "  hermes gateway setup --profile construction"
echo "  Select: Telegram"
echo "  Paste the token from BotFather"
echo ""
echo -e "${CYAN}Step 3:${NC} Start the gateway"
echo "  hermes gateway start --profile construction"
echo ""
echo -e "${CYAN}Step 4:${NC} Test it"
echo "  Open Telegram on your phone"
echo "  Search for your bot's username"
echo "  Send: /start"
echo "  The agent should respond!"
echo ""
echo -e "${YELLOW}Next:${NC} Type 'I want to connect my business data'"
echo "  and the agent will walk you through the data mapping"
echo "  conversation to discover all your data sources."
echo ""
