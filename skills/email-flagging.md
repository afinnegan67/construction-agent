# Proactive Email Flagging — Cron Setup

This documents the cron job and skill that makes the agent proactively check
for unresolved emails and flag them to the contractor through Telegram.

## How It Works

Every 15 minutes, Hermes wakes up, scans the inbox, and looks for emails that:
1. Ask a question or request an action
2. Have no response from the contractor in the thread
3. Were received more than 2 hours ago

If it finds any, it sends a lightweight notification through Telegram. Not a
task list — just a nudge. "Hey, this might need attention."

The contractor can reply "dismiss," "handled," or "remind me tomorrow" and the
agent respects it.

## Cron Job Setup

```bash
hermes cron create "0 */15 * * * *" \
  --profile construction \
  --prompt "Load the email-flagging skill. Scan the Gmail inbox for the last
4 hours. Find emails that: (1) ask a question or request an action, (2) have
no response from the contractor in the thread, (3) were received more than 2
hours ago. For each one found, send a brief flag to the contractor through
Telegram with: the sender name, project, subject, date received, and a
one-line summary of what's needed. Do NOT flag emails that were already
flagged in a previous check. Keep it to 3 flags max per check. Format each
flag as: 'Flag: [Name] from [Company] emailed about [topic] on [date].
[One-line action needed].'" \
  --name "email-flagging" \
  --deliver origin
```

## Flag Format

The agent sends flags that look like this:

```
Flag: Tony Vasquez from Coastal Tile emailed about the Thompson master bath
floor tile on June 1. The Ann Sacks tile is backordered 3-4 weeks — Tony
needs a decision on the Bedrosians alternative by Thursday.

Reply "handled" if you've taken care of this, "dismiss" if it doesn't need
attention, or "remind me tomorrow" to see this again.
```

## What Gets Flagged (Detection Rules)

The agent looks for these signals in unresponded emails:

| Signal | Example |
|--------|---------|
| Direct question | "Can you confirm...?" "Which do you want...?" "What's the plan for...?" |
| Deadline mentioned | "Need to know by Thursday" "Schedule is going to slip" "Before the inspection" |
| Problem reported | "Bad news" "Issue" "Problem" "Not on the drawings" "Backordered" |
| Action requested | "Please send" "Can you coordinate" "Let me know" "Call me" |
| Thread stalled | Last message was from someone else, no contractor reply, >2 hours old |

## What Does NOT Get Flagged

- Newsletters, marketing, spam
- Confirmation emails ("got it," "thanks," "sounds good")
- Threads where the contractor was the last to respond
- Emails flagged in a previous check (deduplication)
- Emails older than 7 days (assume they've been handled or died)

## Deduplication

The agent maintains a file at `~/workspace/construction/global/flagged-emails.md`
that tracks every email it has flagged:

```markdown
# Flagged Emails Log

| ID | Date Flagged | Sender | Subject | Status |
|----|-------------|--------|---------|--------|
| msg_001 | 2026-06-03 | Tony Vasquez | Thompson master bath tile | flagged |
| msg_002 | 2026-06-03 | Mike Chen | Thompson paint sheen | handled |
```

Before flagging, the agent checks this log. If the email ID already exists and
status is not "dismissed," it skips it.

## Skill File: SKILL.md

```markdown
---
name: email-flagging
description: Scan Gmail inbox for unresolved action items and flag them to the
  contractor through Telegram
version: 1.0.0
---

# Email Flagging

Periodic scan of the inbox for emails that need attention. Designed to be run
as a cron job every 15 minutes.

## Process

1. Search Gmail for emails from the last 4 hours
2. For each email thread:
   a. Check if the last message is from the contractor — skip if yes
   b. Check if it contains a question, request, deadline, or problem
   c. Check the flagged-emails.md log — skip if already flagged
3. For qualifying emails (max 3 per check):
   a. Send a flag notification through Telegram
   b. Add to flagged-emails.md with status "flagged"
4. If no qualifying emails, do nothing (silent — don't message the contractor)

## Response Handling

When the contractor replies to a flag:
- "handled" or "done" → update flagged-emails.md status to "handled"
- "dismiss" or "ignore" → update status to "dismissed"
- "remind me tomorrow" → update status, add a "remind_after" date

## Important Rules

- MAX 3 FLAGS PER CHECK. Do not overwhelm the contractor.
- If you already flagged something and haven't gotten a response, do NOT
  re-flag it. Check the log.
- If the same thread gets a new email from the other person (they're
  following up), it counts as a NEW flag — the situation changed.
- Be brief. One line per flag, not a paragraph.
- No flags after 9 PM or before 7 AM local time. Hold them for the next
  check.
```
