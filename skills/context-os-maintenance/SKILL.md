---
name: context-os-maintenance
description: Maintain the Context OS file structure. File every email, voice note, decision, invoice, transaction, time entry, schedule line, and spec into the correct location under the entity hierarchy. This is your memory system — nothing exists outside it.
version: 2.0.0
---

# Context OS Maintenance — How To File Everything

You maintain the Context OS at `~/workspace/context-os/`. This is your
permanent memory. Every fact you learn gets filed here immediately following
the rules in this document. You never hold information in conversation memory
and plan to file it later. File as-you-go. Always.

## THE HIERARCHY IS LAW

```
Owner → Organization → Company → Project → [Data Type]
```

Before filing ANYTHING:
1. **Which organization?** (default: the one at context-os/organizations/)
2. **Which company within that organization?**
3. **Which project within that company?** (if project-specific)
4. **What type of data?** (see list below)

If you cannot determine which project, ASK the contractor. Never guess and file
under the wrong project. Wrong-project data is worse than no data.

## FILING RULES BY DATA TYPE

### EMAIL

**When:** A new email arrives in Gmail, or the contractor describes an email.

**Where it goes:**
1. Create: `projects/{project}/documents/{date}-email-{sender-slug}-{subject-slug}.md`
2. Update: `projects/{project}/context.md` — add one line under today's date
3. If the email contains a decision → update `decisions.md`
4. If the email contains an invoice → update `invoices.md`
5. If the email references costs/payments → update `transactions.md`
6. If the email asks a question with no response → note for proactive flagging

**File format:**
```markdown
**From:** {sender name} ({sender email})
**Date:** {date}
**Project:** {project name}

{summary of body — key facts, not a word-for-word copy}

**Attachments:** {list of attachment filenames}
**Action needed:** {yes / no — what action and by when}
```

### VOICE NOTE

**When:** The contractor sends a voice message through Telegram.

**Where it goes:**
1. Create: `projects/{project}/documents/{date}-voice-note-{HHMM}.md`
2. Update: `projects/{project}/context.md` — add extracted facts under today's date
3. If facts reference costs → update `transactions.md`
4. If facts reference decisions → update `decisions.md`
5. If facts reference progress → update context.md "Current Phase" if needed

**File format:**
```markdown
**Date:** {date} {time}
**Project:** {project name}
**Delivered by:** contractor (voice note via Telegram)

## Full Transcript
{complete transcription}

## Extracted Facts
- {fact 1}
- {fact 2}
- {fact 3}

## Action Items
- [ ] {item} — flagged by contractor on {date}
```

### DECISION

**When:** A decision is made — from an email, voice note, or direct contractor
message.

**Where it goes:**
1. Add row to `projects/{project}/decisions.md`
2. Update `projects/{project}/context.md` under today's date
3. If the decision changes a previous decision → note the change in context.md
4. If the decision affects scope or price → also update `change-orders.md`

**Table format for decisions.md:**
```markdown
| Date | Decision | Made By | Source |
|------|----------|---------|--------|
| 2026-06-10 | Approved Bedrosians alternative tile for master bath | David Whitfield (client) | Email from Tony Vasquez (Coastal Tile), June 10 |
```

### INVOICE

**When:** You encounter an invoice — as an email attachment, a Drive file, or
described by the contractor.

**Where it goes:**
1. Add row to `projects/{project}/invoices.md`
2. Update `projects/{project}/transactions.md` if payment status is known
3. Update `projects/{project}/context.md` under today's date
4. If the original is an email attachment → also file in `documents/`

**Table format for invoices.md:**
```markdown
| Date | From/To | Invoice # | Description | Amount | Status | Due Date |
|------|---------|-----------|-------------|--------|--------|----------|
| 2026-05-29 | Snoqualmie Valley Concrete | 2026-05-002 | Cedar Bluff foundation progress | $55,125.18 | UNPAID | 2026-06-28 |
```

**Status values:** UNPAID, PAID, OVERDUE, DISPUTED, PARTIAL

### TRANSACTION

**When:** Money moves — a payment to a sub, a client draw, a credit card charge,
a reimbursement.

**Where it goes:**
1. Add row to `projects/{project}/transactions.md`
2. If it pays an invoice → update that invoice's status in `invoices.md`
3. Update `projects/{project}/context.md` under today's date (major transactions
   only — skip small receipts unless they're notable)

**Table format for transactions.md:**
```markdown
| Date | Description | Amount | Category | Account | Related Invoice |
|------|-------------|--------|----------|---------|-----------------|
| 2026-06-10 | Snoqualmie Valley Concrete — Cedar Bluff draw #2 | $55,125.18 | Foundation | Chase checking *1234 | 2026-05-002 |
```

**Categories:** use the contractor's existing categories. If unknown, use
descriptive but consistent names: Foundation, Framing, MEP, Finishes, Site Work,
Permits, Professional Fees, Overhead.

### TIME ENTRY

**When:** An employee logs hours against a project — through a voice note,
email, timesheet description, or contractor message.

**Where it goes:**
1. Add row to `projects/{project}/time-entries.md`
2. Do NOT update context.md for routine time entries (only for notable labor
   events like "crew started framing" or "overtime this weekend")

**Table format for time-entries.md:**
```markdown
| Date | Employee | Hours | Rate | Cost Code | Notes |
|------|----------|-------|------|-----------|-------|
| 2026-06-10 | Mike Rivera | 8.0 | $45/hr | 05-100 Framing | Cedar Bluff — wall framing day 3 |
```

### SCHEDULE LINE

**When:** A budget line item is created, updated, or completed — from the
original budget, a change order, or contractor direction.

**Where it goes:**
1. Add or update row in `projects/{project}/schedule-lines.md`
2. If it's a new line from a change order → also update `change-orders.md`
3. Update `projects/{project}/context.md` if the change is significant

**Table format for schedule-lines.md:**
```markdown
| Line # | Description | Budget | Paid To Date | Remaining | Status |
|--------|-------------|--------|-------------|-----------|--------|
| 02-100 | Foundation — concrete, rebar, labor | $85,000 | $55,125.18 | $29,874.82 | In Progress |
```

**Status values:** Not Started, In Progress, Complete, On Hold

### CHANGE ORDER

**When:** A change order is created, approved, or rejected — from an email,
document, or contractor message.

**Where it goes:**
1. Add row to `projects/{project}/change-orders.md`
2. If the CO adds budget → add line(s) to `schedule-lines.md`
3. Update `projects/{project}/context.md` under today's date
4. Update `projects/{project}/decisions.md` if the CO was a client decision

**Table format for change-orders.md:**
```markdown
| Date | CO # | Description | Amount | Status | Approved By |
|------|------|-------------|--------|--------|-------------|
| 2026-06-10 | CO-004 | Cedar Bluff — finished basement add 400 sq ft | $32,500 | Pending | — |
```

**Status values:** Pending, Approved, Rejected, In Progress, Complete

### SPEC SHEET

**When:** You encounter a product specification — from a Drive PDF, email
attachment, or sub/vendor communication.

**Where it goes:**
1. Create: `projects/{project}/specs/{product-name-slug}.md`
2. Update `projects/{project}/context.md` under today's date if this is a new
   or changed selection

**File format:**
```markdown
# {Product Name}
**Model:** {model number}
**Supplier:** {supplier name}
**Source File:** {original filename on Drive}
**Last Updated:** {date}

## Specifications
- Type: {what it is}
- Dimensions: {size}
- Color/Finish: {if applicable}
- Material: {if applicable}
- Price: ${amount} {per unit / total}
- Lead Time: {if known}

## Selection History
- {Date}: {what happened} — source: {email/voice note/document}
```

### ENTITY (Client, Sub, Vendor, Supplier)

**When:** You learn about a new person or company — from an email, voice note,
or contractor message.

**Where it goes:**
1. Add row to `entities.md` at the company level (NOT per project)
2. Determine the type: Client, Sub, Vendor, Supplier, Architect, Engineer

**Table format for entities.md:**
```markdown
| ID | Type | Company Name | Contact Name | Phone | Email | Notes |
|----|------|-------------|-------------|-------|-------|-------|
| sub-001 | Sub | Snoqualmie Valley Concrete | Dave Renner | (555) 123-4567 | dave@svconcrete.com | Foundation and flatwork |
```

Use consistent IDs: `client-###`, `sub-###`, `vendor-###`, `supplier-###`.

### EMPLOYEE

**When:** You learn about a team member — during onboarding, from payroll data,
or contractor message.

**Where it goes:**
1. Add row to `employees.md` at the company level
2. Do NOT create employee entries per project — employees belong to the company

**Table format for employees.md:**
```markdown
| ID | Name | Role | Phone | Email | Rate | Start Date |
|----|------|------|-------|-------|------|------------|
| emp-001 | Mike Rivera | Site Superintendent | (555) 234-5678 | mike@apexconstruction.com | $45/hr | 2023-03-15 |
```

### ACCOUNT

**When:** The contractor tells you about a bank account, credit card, or payment
method.

**Where it goes:**
1. Add row to `accounts.md` at the company level

**Table format for accounts.md:**
```markdown
| Account Name | Bank/Institution | Type | Last 4 | Purpose |
|-------------|-----------------|------|--------|---------|
| Operations Checking | Chase | Checking | 1234 | Sub payments, general operating |
| Business Visa | Chase | Credit Card | 5678 | Materials, supplies, fuel |
```

### CONTEXT.MD — THE RUNNING NARRATIVE

Every project's `context.md` is the single source of truth for "what's happening
right now." Update it when ANY of the above data types changes. The format is
cumulative — new entries go at the top under today's date.

**File structure:**
```markdown
# {Project Name} — Running Context

**Client:** {name} | **Address:** {address}
**Type:** {custom home | remodel | spec | ADU | commercial}
**Contract Value:** ${amount} | **Start:** {date} | **Target Complete:** {date}

## Current Phase
{framing, with subs for mechanical rough-in and roofing}

## Active Subs On Site
| Trade | Company | Contact | Phone | Scope |

## Recent Activity
### {Date — most recent first}
- {What happened} — Source: {email from Name on Date / voice note / contractor}
- {What happened} — Source: ...
### {Previous Date}
- ...

## Open Items
- [ ] {Item} — flagged {date}, waiting on {person/event}
- [ ] {Item} — ...
```

**Update rules:**
- Add a `### {Date}` heading for today if it doesn't exist yet
- One line per event. Not paragraphs.
- Update "Current Phase" when the project moves forward
- Update "Active Subs On Site" as subs start and finish
- Open items: add when flagged, remove when resolved
- Keep the most recent 14 days of activity in detail. Older activity stays but
  new entries push down.

## VALIDATION RULES

Before you file anything, verify:

1. **Project match.** Does this information belong to this project? If a sub
   works across multiple projects, split the information per project.

2. **No duplicates.** Does this exact fact already exist? Check the relevant
   file before adding. If it's already there with the same source and date,
   don't add it again.

3. **Source traceability.** Can you point to where this fact came from? If not,
   do not file it. "The contractor told me" is acceptable if it was a direct
   Telegram message — cite the date and message.

4. **Format consistency.** Use the exact formats above. Consistent tables make
   searching and reading fast.

5. **No PII in filenames.** Use first-name-last-initial for people (e.g.,
   `dave-r` not `dave-renner`). Use company slugs for companies.

## WHEN TO CREATE A NEW PROJECT

Create a new project folder when the contractor mentions a project you haven't
seen before. Use the `templates/project-template/` folder as the starting point:

```
projects/{project-name-slug}/
├── context.md         ← copy template and fill in what you know
├── decisions.md       ← copy template (empty table)
├── schedule-lines.md  ← copy template (empty table)
├── transactions.md    ← copy template (empty table)
├── time-entries.md    ← copy template (empty table)
├── invoices.md        ← copy template (empty table)
├── change-orders.md   ← copy template (empty table)
├── documents/         ← empty directory
└── specs/             ← empty directory
```

If you don't know the contract value, start date, or target date, leave those
fields blank in context.md and fill them in later when you learn them.

## NEVER DO THIS

- **Never file under the wrong project.** If uncertain, ask.
- **Never skip the hierarchy.** Every fact traces Owner → Org → Company → Project.
- **Never create duplicate entries.** Check before you file.
- **Never overwrite contractor-edited content.** The contractor shouldn't be
  editing files directly, but if they do, don't undo their changes.
- **Never file without a source.** Every fact must trace to an email, voice note,
  document, or direct message.
- **Never batch-file.** File information as you learn it. Not at the end of the
  day. Not when you "have time." Immediately.
- **Never use vague descriptions.** "Stuff happened at the site" is useless.
  "Honeycomb void in northeast garage footing, ~8 inches, Dave Renner needs to
  patch before backfill" is useful.
- **Never mix projects in one file.** Each file belongs to exactly one project.
- **Never create files outside the Context OS.** No `/tmp/` notes, no in-memory
  scratchpads, no "I'll remember this one." Everything goes in Context OS.
