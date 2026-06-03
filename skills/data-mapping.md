# Data Mapping

Use this skill when the contractor says "I want to connect my business data"
or "map my systems" or anything indicating they're ready to set up their AI
employee with their actual data sources.

## Purpose

Walk the contractor through a structured conversation to discover every
data source in their business. Output a `data-map.md` file organized by
connection difficulty. Surface what's currently being lost.

## Conversation Flow

Ask these questions in order. Wait for each answer. Don't rush.

### Phase 1 — Business Profile

1. "What type of construction do you do? Custom homes, remodels, commercial,
   spec homes, ADUs — or a mix?"
2. "How many projects are active right now?"
3. "How big is your team? Anyone helping with project management, admin, or
   are you doing everything yourself?"
4. "Do you work under one company name or multiple entities?"

### Phase 2 — Communication Tools

5. "Where does client communication happen? Email, text, phone calls — all
   three?"
6. "What email do you use? Gmail, Outlook, iCloud, company domain?"
7. "Where do texts with clients and subs live? iMessage, WhatsApp, regular
   texts, GoHighLevel, something else?"
8. "Do you use a CRM? GoHighLevel, HubSpot, JobNimbus, BuilderTrend, nothing?"

### Phase 3 — Project Management

9. "What do you use to manage projects? BuilderTrend, Procore, spreadsheets,
   a whiteboard, your head?"
10. "How do you track selections? Tile, flooring, fixtures, paint — where
    does that live?"
11. "How do you manage your schedule? Who updates it?"
12. "How do you track change orders?"

### Phase 4 — Field Data

13. "When you visit a job site, what happens to photos and notes?"
14. "How do subs report progress to you?"
15. "How do you track punch list items and issues that need fixing?"

### Phase 5 — Files and Documents

16. "Where do you store project documents? Google Drive, OneDrive, Dropbox,
    a server, paper files?"
17. "How are they organized — by project, by trade, or...?"
18. "Where are your contracts, plans, and permits?"

### Phase 6 — Financial

19. "What do you use for accounting? QuickBooks, Xero, a bookkeeper, Excel?"
20. "How do you process subcontractor invoices?"
21. "How do you track job costs against budget?"

### Phase 7 — The Gaps

22. "What information do you regularly lose track of?"
23. "What decisions get made verbally that never get written down anywhere?"
24. "What's the one thing you wish you could just ask and get an instant
    answer about?"

## Output: data-map.md

After the conversation, create `organizations/{org-name}/data-map.md`:

```markdown
# Data Map for {Organization Name}
Generated: {date}

## Tier 1 — Easy to Connect (Open APIs Exist)

| Source | What's In It | Connection Method | Priority |
|--------|-------------|-------------------|----------|
| {source} | {what data lives there} | {OAuth / API key / etc.} | HIGH/MEDIUM/LOW |

## Tier 2 — Moderate (Has API, Needs Setup)

| Source | What's In It | Connection Method | Priority |
|--------|-------------|-------------------|----------|
| {source} | {what data lives there} | {API key / dev work needed} | HIGH/MEDIUM/LOW |

## Tier 3 — Hard or No Access (Manual Workarounds)

| Source | What's In It | Why It's Hard | Workaround |
|--------|-------------|---------------|------------|
| iMessage texts | Sub and client texts | No API access from Apple | Use GoHighLevel CRM (hosted number → API-accessible texts) |
| Verbal site decisions | Conversations on site | Never captured | Voice note to agent after each site visit |
| Paper files | Contracts, permits | Physical documents | Take photo → send to agent → agent files to Google Drive |
| Phone calls | Supplier/vendor discussions | Not recorded | Voice note to agent after call |

## Quick Wins — Data Currently Being LOST

These are the highest-value fixes:
1. {gap} — {workaround}
2. {gap} — {workaround}
3. {gap} — {workaround}

## Next Steps
1. Connect Tier 1 sources immediately
2. Set up workarounds for Quick Wins
3. Plan Tier 2 integrations
```

## Rules

- Never guess what tools the contractor uses. Ask and wait.
- If they mention a tool you don't recognize: "What does that do for you?"
  Then classify it yourself.
- The Quick Wins section is the most valuable output. These are data sources
  currently evaporating. Highlight them.
- After output: "Here's your data map, organized by what's easy, what needs
  work, and what's currently being lost. Want to start connecting Tier 1?"
