# Context Operating System

This is your AI employee's permanent memory. Every email, decision, spec sheet,
invoice, time entry, and voice note gets filed here. You don't need to touch
these files — your agent manages everything through Telegram. But if you ever
want to see the full history of a project, it's all here.

## How It Works

1. You talk to your agent through Telegram
2. The agent searches here, your email, and your Drive
3. It files new information automatically in real time
4. Every fact traces back to its source

## The Entity Hierarchy

Every piece of information follows this chain:

```
Owner (you)
└── Organization
    └── Company
        ├── Employees (team)
        ├── Entities (clients, subs, vendors)
        ├── Accounts (bank accounts, credit cards)
        ├── Rental Items (equipment)
        ├── PTO Policies
        └── Project
            ├── Schedule Lines (budget line items)
            ├── Transactions (expenses, receipts)
            ├── Time Entries (labor)
            ├── Invoices
            ├── Change Orders
            └── Documents (emails, photos, notes)
```

## Folder Map

```
organizations/{name}/       ← Your company lives here
├── company.md              ← Company info and structure
├── data-map.md             ← What data sources are connected (by tier)
├── employees.md            ← Your team directory
├── entities.md             ← Clients, subs, vendors, suppliers
├── accounts.md             ← Bank accounts, credit cards
├── rentals.md              ← Equipment inventory
├── pto-policies.md         ← Time-off policies
└── projects/{name}/        ← Each project gets a folder
    ├── context.md          ← Running narrative — what's happening right now
    ├── decisions.md        ← Key decisions with dates and sources
    ├── schedule-lines.md   ← Budget line items, milestones
    ├── transactions.md     ← Expenses, receipts, payments
    ├── time-entries.md     ← Employee labor by date/person/cost code
    ├── invoices.md         ← Sub invoices, vendor bills
    ├── change-orders.md    ← Scope and price changes
    ├── documents/          ← Filed emails, photos, voice notes
    └── specs/              ← Extracted product specifications

global/                     ← Cross-project files
├── flagged-emails.md       ← Dedup log for proactive email flags
└── system-notes.md         ← Agent operational notes
```

## Rules the Agent Follows

- Every fact must have a source (which email, which document, which date)
- Never hallucinate a spec, dollar amount, or product name
- Never take action without confirmation — notify and recommend only
- File everything by project — never dump information in the wrong folder
- File as-you-go, not in batches
- Keep context.md updated as a running story of each project

## You Never Touch These Files

Seriously. You talk to the agent through Telegram. It handles the filing. If you
manually edit these files, the agent might get confused. Let it do its job.
