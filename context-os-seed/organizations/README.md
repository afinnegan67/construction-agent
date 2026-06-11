# Organizations

Each organization is a top-level business grouping. If you operate under one
company name, you'll have one organization folder here. If you have multiple
entities (a GC company + a rental company + a development LLC), each gets its
own organization.

## Inside Each Organization

```
{org-name}/
├── company.md              ← Mission, structure, company info
├── data-map.md             ← Connected data sources organized by tier
├── agents.md               ← Deployed AI employees and their configs
├── employees.md            ← Team directory: names, roles, contact, rates
├── entities.md             ← Clients, subs, vendors, suppliers
├── accounts.md             ← Bank accounts, credit cards, payment methods
├── rentals.md              ← Equipment inventory and rental tracking
├── pto-policies.md         ← Time-off policies per employee
└── projects/               ← Active and completed projects
    └── {project-name}/     ← Each project is a folder (see project template)
```

## Company-Level vs Project-Level

Some data belongs to the company, not a specific project:

| Company Level | Project Level |
|--------------|---------------|
| Employee directory | Time entries (hours logged per project) |
| Entity list (all subs/clients) | Which subs are on this project |
| Bank accounts | Transactions (money in/out per project) |
| Equipment inventory | Equipment used on this project |
| PTO policies | — |

The agent files company data at the company level and project data at the
project level. Cross-referencing happens automatically when you ask a question.

## The Agent Maintains This

Your AI employee creates and updates these files. `data-map.md` is generated
during onboarding. Everything else gets populated as the agent processes
emails, voice notes, and documents through Telegram.
