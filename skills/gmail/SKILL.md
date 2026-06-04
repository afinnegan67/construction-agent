---
name: gmail
description: Search, read, and cite Gmail messages and attachments using the Gmail API. Load when the user asks about email content, projects, or any question that might be answered in their inbox.
version: 1.0.0
---

# Gmail

This skill teaches Hermes how to search, read, and file emails from Gmail.

## Prerequisites

Before this skill works, you need:

1. **Google Cloud Project** with Gmail API enabled
2. **OAuth 2.0 credentials** (client ID + client secret)
3. **Refresh token** for the contractor's Gmail account
4. **Scopes:** `https://www.googleapis.com/auth/gmail.readonly`

The OAuth flow happens once. Hermes stores the refresh token and handles
re-authorization automatically.

## Setup Commands

```bash
pip install google-api-python-client google-auth-httplib2 google-auth-oauthlib

mkdir -p ~/.hermes/credentials/
```

## Skill File: SKILL.md

```markdown
---
name: gmail
description: Search and read Gmail emails. File relevant emails into project
  folders. Query by project, sender, date, or content.
version: 1.0.0
---

You have access to the contractor's Gmail inbox. You can search, read, and
extract information from emails and their attachments.

## How to Search

Use the Gmail API via the Python client. Always search with these filters to
keep results relevant:

```
q="Thompson" OR "Thompson Residence"

q="from:dan@precisioncabinetswa.com"

q="after:2026/05/01 before:2026/06/03"

q="(Thompson OR Henderson) from:subcontractor@example.com after:2026/05/01"
```

## When the Contractor Asks a Question

1. Parse the question. Identify: project name, person, trade, date range
2. Search Gmail with relevant queries
3. Read matching emails AND their attachments
4. If an attachment is a PDF, extract text from it
5. Find the most recent relevant information
6. Respond with: ANSWER, SOURCE (email subject + sender + date), and a link
   to the actual email thread

## Filing Emails

When you process new emails:

1. Determine which project they relate to (by subject, sender, content)
2. Save a summary to the project's `emails/` folder as a dated markdown file
3. Update `context.md` if the email contains a decision, change, or spec update

Format for filed emails:
```markdown
**From:** {sender}
**Date:** {date}
**Project:** {project name}

{body text}

**Attachments:** {list of attachment names}

**Action needed:** {yes/no — what}
```

## Reading PDF Attachments

When an email has a PDF attachment:

1. Download the attachment
2. If text-based: extract text with PyMuPDF (fitz)
3. If image-based (scanned): use vision tools to read it
4. Store the extracted text alongside the email summary

## What You CAN Do

- Search emails by any Gmail query
- Read email bodies and headers
- Download and parse PDF, Word, and Excel attachments
- Read images in emails (photos of job sites, spec labels)
- File email summaries into project folders

## What You CANNOT Do

- Send emails
- Delete emails
- Modify emails
- Access settings or filters
- Read emails from accounts you haven't been granted access to
```
