# Build Your AI Employee — Complete Resource Guide

*Everything from the video, in one place. Bookmark this.*

---

## What You're Building

An AI employee that:
- Answers questions with cited sources (which email, which date, who confirmed)
- Processes voice notes (talk while driving, it files everything)
- Proactively flags emails that need a response
- Reads your Gmail, Google Drive, and PDF attachments

All through Telegram on your phone.

---

## Step 1: Get a Server ($4.51/month)

1. Go to [hetzner.com/cloud](https://hetzner.com/cloud)
2. Create an account (email + credit card)
3. Click **"Create Server"**
4. Location: Pick the one closest to you
5. Image: **Ubuntu 24.04**
6. Type: **CX22** (2 vCPU, 4GB RAM, 20GB SSD — $4.51/month)
7. Name: Anything you want
8. Click **"Create & Buy Now"**

Once the server says "Running," click the little **monitor icon** (Console).
This opens a terminal in your browser. Nothing to install on your computer.

---

## Step 2: Install Everything

Copy and paste this command into the browser terminal. Press Enter.

```bash
curl -fsSL https://raw.githubusercontent.com/afinnegan67/construction-agent/main/setup.sh | bash
```

This installs Hermes (the AI agent), the construction profile, the Context OS
folder structure, all the skills, and required tools. Takes 3-5 minutes.

When it finishes, it prints the next steps. Read them.

---

## Step 3: Create a Telegram Bot

**On your phone, in Telegram:**
1. Search for **@BotFather** (the official bot creator)
2. Send: `/newbot`
3. Name: Whatever you want (like "My Construction Agent")
4. Username: Must end in "bot" (like `MyConstructionBot`)
5. BotFather gives you a **token** — it looks like `7294xxxx:AAH...`
6. **Copy this token.**

---

## Step 4: Wire the Bot to Your Agent

**Back in the browser terminal:**

```bash
hermes gateway setup --profile construction
```
- Select: **Telegram**
- Paste the token from BotFather

```bash
hermes gateway start --profile construction
```

Your server has a public IP — Telegram reaches it automatically. No extra setup.

---

## Step 5: Test It

**On your phone, in Telegram:**
1. Search for your bot's username
2. Send: `/start`
3. The agent should respond

---

## Step 6: Onboard Your Agent

Send this message to your agent in Telegram:

> I want to connect my business data

The agent asks you a series of questions about your business — what email you
use, where you store files, what PM software, what CRM, what accounting. It's
discovering where all your data lives.

At the end, it creates a **data map** — a document showing exactly what data
you have, how easy each source is to connect, and what data is currently
being lost (texts, verbal decisions, paper files).

---

## Step 7: Connect Gmail and Google Drive

The agent walks you through this after the data mapping. You'll need:

1. A Google account (the one you use for business)
2. OAuth setup (the agent guides you — it's a one-time browser login)

Once connected, the agent can search your email and Drive. Try asking:

> What's the latest on the Thompson Residence?

---

## Step 8: Set Up Proactive Flagging

The agent scans your inbox every 15 minutes for emails that need a response.

In the browser terminal:
```bash
hermes cron create "0 */15 * * * *" \
  --profile construction \
  --prompt "Scan inbox for unresolved action items and flag them." \
  --name "email-flagging"
```

---

## Costs

| Item | Monthly Cost |
|------|-------------|
| Hetzner CX22 server | $4.51 |
| OpenRouter (Claude Sonnet 4) | ~$15-20 (depends on usage) |
| **Total** | **~$20-25/month** |

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Bot doesn't respond | In terminal: `hermes gateway restart` |
| "Command not found: hermes" | Re-run the setup script |
| "Invalid token" | Bot token is wrong — create a new bot with BotFather |
| Agent gives wrong answers | It can only search data you've connected. Connect Gmail + Drive first |

---

## Links

- **GitHub repo (all code):** [github.com/afinnegan67/construction-agent](https://github.com/afinnegan67/construction-agent)
- **Construction profile:** [github.com/afinnegan67/construction-agent/blob/main/construction-profile.md](https://github.com/afinnegan67/construction-agent/blob/main/construction-profile.md)
- **Hermes Agent:** [github.com/NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
- **Hetzner Cloud:** [hetzner.com/cloud](https://hetzner.com/cloud)
- **Opulence AI (we'll set this up for you):** [opulence.ai](https://opulence.ai)
- **YouTube tutorial:** [Watch the full walkthrough](https://youtube.com/@Aidan-Finnegan)

---

## Questions?

Leave a comment on the YouTube video or open an issue on the GitHub repo.
If you want Opulence AI to handle the entire setup for your business, book
a demo at [opulence.ai](https://opulence.ai).
