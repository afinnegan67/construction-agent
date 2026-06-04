# Construction AI Employee

An AI employee for residential contractors. Lives on a Railway cloud service,
talks to you through Telegram, reads your Gmail and Google Drive, and proactively
flags emails you haven't answered.

Built on [Hermes Agent](https://hermes-agent.nousresearch.com/), the open-source
agent framework from Nous Research.

---

## What it does

- **Cited answers.** Ask "what tile did the homeowner approve for the Thompson
  master bath?" — get the answer with the source email, the date, and who
  confirmed it.
- **Voice notes from the truck.** Hold the mic button in Telegram, talk for 45
  seconds, hang up. Transcribed, extracted, filed by project.
- **Proactive flags.** Every 15 minutes the agent scans your inbox for emails
  with unanswered questions, action requests, or deadlines. It pushes a flag
  to your Telegram chat without you asking.

---

## Setup — Railway, always-on

You don't install anything on your computer. The whole agent runs on a Railway
cloud service that stays awake 24/7. You talk to it through Telegram on your
phone.

### 1. Make a Telegram bot

On your phone, in Telegram:
1. Search for `@BotFather`
2. Send `/newbot`
3. Pick a name and username (username must end in `bot`)
4. Save the token BotFather gives you — looks like `7294xxxx:AAH...`

Then find your own Telegram user ID — open `@userinfobot`, send `/start`, copy
the number it shows. This is your `TELEGRAM_ALLOWED_USERS` value.

### 2. Get the two API keys

- **OpenRouter** ([openrouter.ai](https://openrouter.ai)) — pays for the language
  model. Sign up, add a credit, create an API key. Budget ~$15–$20/month.
- **Groq** ([console.groq.com](https://console.groq.com)) — transcribes your voice
  notes. Free tier is plenty for normal use.

### 3. Deploy on Railway

1. Go to [railway.app](https://railway.app), sign in with GitHub
2. Click **New** → **Deploy from GitHub repo**
3. Pick `afinnegan67/construction-agent`
4. Railway reads the `Dockerfile` and `railway.json` and starts building
5. While it builds, click **Variables** and add these five (paste your real values):

   | Variable | Value |
   |---|---|
   | `OPENROUTER_API_KEY` | `sk-or-v1-...` |
   | `GROQ_API_KEY` | `gsk_...` |
   | `TELEGRAM_BOT_TOKEN` | the BotFather token |
   | `TELEGRAM_ALLOWED_USERS` | your Telegram user ID |
   | `TELEGRAM_HOME_CHANNEL` | your Telegram user ID (same number) |

6. Click **Settings** → make sure **Sleep when idle** is **off**. The agent has
   to stay awake so the every-15-minute scanner can fire.
7. Watch the **Deploy Logs**. You're done when you see:
   ```
   [entrypoint] Starting Hermes gateway in polling mode...
   [telegram] Connected to Telegram (polling mode)
   ```

### 4. Say hi

On your phone, in Telegram, search your bot's username and send `/start`.
The agent replies. Congratulations — your AI employee is alive.

### 5. Turn on proactive flagging

In the Railway dashboard, click your service, click the **Shell** tab, and run:

```bash
hermes -p construction-agent cron create \
  "every 15m" \
  "Run the email-flagging skill. Scan Gmail for unresolved action items from the last 24 hours and flag them to Telegram." \
  --skill email-flagging \
  --name "inbox-flagging"
```

That's the only command you ever run by hand. From now on the agent watches your
inbox on its own.

---

## Connect your Gmail and Drive

Open Telegram and send your bot:

> I want to connect my business data

The agent walks you through a 10-minute conversation about your business and
outputs a data map. Then it walks you through the Google Cloud OAuth dance for
Gmail and Drive (one browser login, read-only access).

After that — ask it anything.

---

## What's actually in this repo

```
construction-agent/
├── distribution.yaml        ← Hermes profile manifest (env vars, version)
├── SOUL.md                  ← the agent's personality + construction domain knowledge
├── config.yaml              ← model (Sonnet via OpenRouter), STT (Groq), Telegram polling
├── skills/                  ← bundled Hermes skills
│   ├── context-os-maintenance/SKILL.md   ← how the agent files things
│   ├── data-mapping/SKILL.md              ← onboarding conversation
│   ├── gmail/SKILL.md                     ← Gmail search + read
│   ├── google-drive/SKILL.md              ← Drive search + read
│   └── email-flagging/SKILL.md            ← proactive inbox scan (the cron's brain)
├── cron/README.md           ← how to enable the every-15-min flag job
├── context-os-seed/         ← README files that get copied into ~/workspace/context-os/
├── Dockerfile               ← Python 3.12 + Hermes + ffmpeg, runs entrypoint
├── railway-entrypoint.sh    ← first-boot installs the profile, every-boot starts gateway
├── railway.json             ← always-on, restart-on-failure, no sleep
└── init-workspace.sh        ← rebuilds the Context OS folder tree if you ever need to
```

### Why polling mode (not webhook)

Hermes can talk to Telegram two ways: long polling (outbound) or webhook
(inbound). Webhook mode lets the container sleep between messages, which is
cheaper. But the proactive 15-minute scan needs the agent to wake itself up
when nothing has come in. Sleeping kills that. So this image runs polling and
the Railway service stays awake 24/7. Roughly $5–$10/month on Railway's hobby
plan.

### Updating the agent

When this repo ships a new version, you don't redeploy from scratch. From the
Railway Shell tab:

```bash
hermes profile update construction-agent
```

Your `.env`, your conversations, your data map, your Context OS — all preserved.

---

## Hand-rolled install (advanced)

If you want to run this on your own server instead of Railway:

```bash
# 1. Install Hermes
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# 2. Install this profile
hermes profile install github.com/afinnegan67/construction-agent --alias

# 3. Fill in your keys
nano ~/.hermes/profiles/construction-agent/.env

# 4. Scaffold the workspace
bash <(curl -fsSL https://raw.githubusercontent.com/afinnegan67/construction-agent/main/init-workspace.sh)

# 5. Start the gateway (use systemd or supervisord to keep it alive)
hermes -p construction-agent gateway
```

---

## Built by Opulence AI

We build AI employees for residential contractors. If you'd rather have us set
this up for your business — provisioning, OAuth, data mapping, the whole thing —
book a demo at [opulence.ai](https://opulence.ai).

You spend an hour with us. A week later you have your AI employee running
without ever touching a terminal.

---

## License

MIT.
