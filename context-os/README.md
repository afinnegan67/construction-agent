# Context Operating System

This is your AI employee's permanent memory. Every email, decision, spec sheet,
and voice note gets filed here. You don't need to touch these files — your agent
manages everything through Telegram. But if you ever want to see the full
history of a decision, it's all here.

## How It Works

1. You talk to your agent through Telegram
2. The agent searches here, your email, and your Drive
3. It files new information automatically
4. Every fact traces back to its source

## The Entity Hierarchy

Every piece of information follows this chain:

```
Owner (you)
└── Organization
    └── Company
        └── Project
```

When the agent files something, it always traces back through this chain.
This means a decision about the Thompson Residence tile is always filed under:
`organizations/{org}/projects/thompson-residence/`

## Folder Map

```
organizations/{name}/      ← Your company lives here
  company.md               ← Company info
  data-map.md              ← What data sources are connected
  projects/{name}/          ← Each project gets a folder
    context.md             ← Running narrative — what's happening
    decisions.md           ← Key decisions with dates and sources
    documents/             ← Filed emails, photos, voice notes
    specs/                 ← Extracted spec sheets
  employees.md             ← Your team
  entities.md              ← Clients, subs, vendors

global/                    ← Cross-project files
  flagged-emails.md        ← Things the agent is watching
```

## Rules the Agent Follows

- Every fact must have a source (which email, which document, which date)
- Never hallucinate a spec or product name
- Never take action without confirmation
- File everything by project — never dump information in the wrong folder
- Keep context.md updated as a running story of each project

## You Never Touch These Files

Seriously. You talk to the agent through Telegram. It handles the filing. If you
manually edit these files, the agent might get confused. Let it do its job.
