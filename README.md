# Construction AI Employee

An AI employee for residential contractors. Connects to your Gmail and Google
Drive, answers questions with cited sources, files everything by project, and
proactively flags things that need attention — all through Telegram.

Built on [Hermes](https://github.com/NousResearch/hermes-agent), the open-source
AI agent framework from Nous Research.

## What It Does

- **Ask questions, get cited answers.** "What tile did we spec on the Thompson
  master bath?" → answer with source email, date, and who confirmed it
- **Voice dump from the car.** Talk to it hands-free while driving. It
  transcribes, extracts facts, and files everything by project
- **Proactive flagging.** Scans your inbox every 15 minutes for emails that
  need a response and nudges you through Telegram
- **Reads attachments.** PDFs, spec sheets, contracts — it extracts the data
  so you don't have to open every file

All through Telegram. No new app. No dashboard. Just talk to it.

## Quick Start

### What You Need

- About 30 minutes
- A phone with Telegram installed
- A Gmail account and Google Drive
- $4.51/month for the server
- OpenRouter account with API credits (~$15-20/month)

### Step 1: Get a Server

1. Go to [Hetzner Cloud](https://hetzner.com/cloud) and create an account
2. Click "Create Server"
3. Pick: **Ubuntu 24.04**, **CX22** (2 vCPU, 4GB RAM, 20GB SSD)
4. Click "Create & Buy Now" ($4.51/month)
5. Once it's running, click the **"Console"** button (the little monitor icon)
   — this opens a terminal in your browser. Nothing to install on your computer.

### Step 2: Install Everything

In the browser terminal, paste this one command:

```bash
curl -fsSL https://raw.githubusercontent.com/opulence-ai/construction-agent/main/setup.sh | bash
```

This installs Hermes, the construction profile, the Context OS folder
structure, all skills, and required tools. Takes about 3-5 minutes.

When it finishes, it prints the next steps.

### Step 3: Create Your Telegram Bot

1. Open Telegram on your phone
2. Search for **@BotFather**
3. Send: `/newbot`
4. Give it a name (like "My Construction Agent")
5. Give it a username (must end in "bot", like `MyConstructionBot`)
6. Copy the token BotFather gives you

### Step 4: Wire Everything Together

Back in the browser terminal:

```bash
hermes gateway setup --profile construction
# Select: Telegram
# Paste the bot token

hermes gateway start --profile construction
```

### Step 5: Test It

1. Open Telegram on your phone
2. Search for your bot's username
3. Send: `/start`
4. The agent should respond!

### Step 6: Onboard Your Agent

Send your agent this message on Telegram:

> I want to connect my business data

The agent walks you through a conversation to discover where all your
business data lives — email, files, CRM, project management, everything. It
builds a data map and tells you what to connect first.

## What's in This Repo

```
construction-agent/
├── setup.sh                      ← One-command installer
├── construction-profile.md        ← Hermes profile (the agent's "brain")
├── context-os/                    ← Folder structure the agent maintains
│   ├── README.md
│   ├── organizations/
│   │   └── README.md
│   └── global/
│       └── README.md
└── skills/                        ← Agent skills
    ├── context-os-maintenance.md   ← How to file things correctly
    ├── data-mapping.md             ← Onboarding conversation
    ├── gmail.md                    ← Gmail search and reading
    ├── google-drive.md             ← Google Drive search and reading
    └── email-flagging.md           ← Proactive inbox monitoring
```

## After Setup

Once your agent is running, here's what to do first:

1. **Data mapping** — send "I want to connect my business data"
2. **Connect Gmail** — the agent walks you through OAuth
3. **Connect Google Drive** — same OAuth flow
4. **Set up proactive flagging** — cron job scans inbox every 15 minutes
5. **Start asking questions** — "What's the latest on the Thompson Residence?"

## Requirements

- **Server:** Hetzner CX22 ($4.51/month) or any Ubuntu 24.04 server with 4GB+ RAM
- **AI Provider:** OpenRouter account with API credits (Claude Sonnet 4
  recommended, ~$15-20/month for typical use)
- **Gmail + Google Drive:** A Google account with OAuth access
- **Phone:** Telegram app

## Costs

| Item | Monthly Cost |
|------|-------------|
| Hetzner CX22 server | $4.51 |
| OpenRouter (Claude Sonnet 4) | ~$15-20 |
| Telegram | Free |
| **Total** | **~$20-25/month** |

## Built by Opulence AI

We build AI employees for residential contractors. If you'd rather have us
set this up for you — provisioning, OAuth, data mapping, the whole thing —
book a demo at [opulence.ai](https://opulence.ai).

You talk to us for an hour about your business. A week later your AI
employee is running.

## Open Source

Everything in this repo is open source. Hermes is open source. The
construction profile, skills, and Context OS structure — free to use,
modify, and share.

## Support

- **GitHub Issues:** Bug reports and feature requests
- **YouTube:** [@Aidan-Finnegan](https://youtube.com/@Aidan-Finnegan) —
  full video walkthrough of this setup
- **opulence.ai:** Book a demo if you want us to handle the setup
