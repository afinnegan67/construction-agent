# Cron Jobs for the Construction AI Employee

Hermes profile distributions ship cron templates but **do not auto-schedule them**.
That's a safety guard so installing a stranger's profile can't silently start
running tasks on your machine. You enable cron jobs explicitly after install.

## The proactive email-flagging job

This is the one cron job this profile needs. It scans your inbox every 15 minutes
for emails with unanswered questions, action requests, or deadlines, and posts a
flag to your Telegram home channel.

After your Railway service is running and you've sent `/start` to your bot, open
the Railway service Shell tab and run:

```bash
hermes -p construction-agent cron create \
  "every 15m" \
  "Run the email-flagging skill. Scan Gmail for unresolved action items from the last 24 hours and flag them to Telegram." \
  --skill email-flagging \
  --name "inbox-flagging"
```

That's it. The job lives in `~/.hermes/cron/jobs.json` from then on. The gateway
(which is the same process serving Telegram) ticks the scheduler on every cron
window. Results are delivered to the chat ID in `TELEGRAM_HOME_CHANNEL`.

## Verify it's scheduled

```bash
hermes -p construction-agent cron list
```

You should see one job called `inbox-flagging` with a `next_run_at` timestamp.

## Trigger it manually (useful for filming)

```bash
hermes -p construction-agent cron run inbox-flagging
```

This fires the job immediately without waiting for the next 15-minute window.
Handy when you want to demo the proactive flag on camera without waiting.

## Pause / resume

```bash
hermes -p construction-agent cron pause inbox-flagging
hermes -p construction-agent cron resume inbox-flagging
```

## See past runs

Every run writes its output to `~/.hermes/cron/output/{job_id}/{timestamp}.md`.
The agent's response is also delivered to Telegram automatically — you don't need
to read these files unless you're debugging.
