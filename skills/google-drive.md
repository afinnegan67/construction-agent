# Google Drive Skill for Hermes

This skill teaches Hermes how to search, read, and reference files from Google
Drive.

## Prerequisites

Same Google Cloud Project as Gmail. Add the Drive scope:

```
https://www.googleapis.com/auth/drive.readonly
```

## Setup

```bash
# Same credentials JSON used for Gmail
# Place at ~/.hermes/credentials/drive-oauth.json
# Or reuse the same OAuth client with both scopes
```

## Skill File: SKILL.md

```markdown
---
name: google-drive
description: Search and read files from Google Drive. Find spec sheets,
  contracts, plans, and other project documents.
version: 1.0.0
---

# Google Drive

You have access to the contractor's Google Drive. You can search, read, and
extract information from stored files.

## How to Search

Use the Drive API. Search by filename, folder, or content type:

```
# Search by filename
q="name contains 'Thompson'"

# Search by file type
q="mimeType='application/pdf'"

# Search by folder
q="'folder-id-here' in parents"

# Combined search
q="name contains 'spec' and mimeType='application/pdf' and 'project-folder-id' in parents"
```

## When the Contractor Asks About a Document

1. Parse the question. What kind of document? Which project?
2. Search Drive for matching files
3. Download and read the most recent version
4. If it's a PDF, extract text; if a spreadsheet, parse it; if a doc, read it
5. Respond with: ANSWER, SOURCE (filename + last modified date), and content

## Spec Sheet Handling

Spec sheets are the most frequently queried documents. When you find one:

1. Download it
2. Extract: product name, model number, dimensions, color/finish, supplier
3. File extracted specs into project's `specs/` folder as markdown
4. Update `context.md` if this is a change from a previous spec

Format for filed specs:
```markdown
# {Product Name}
**Model:** {model number}
**Supplier:** {supplier name}
**File:** {original filename}
**Last updated:** {Drive modified date}

## Specifications
- Dimensions: ...
- Color/Finish: ...
- Material: ...
- Price: ...
- Lead time: ...

## Notes
{Any relevant notes from emails about this spec}
```

## Organizing

If the contractor's Drive is messy (most are):

1. Note this in data-map.md
2. Suggest a folder structure: `/{Project Name}/` with subfolders for Plans,
   Specs, Contracts, Photos, Invoices
3. Offer to help reorganize (but don't move files without permission)

## What You CAN Do

- Search files by name, type, folder
- Download and read any file type
- Extract text from PDFs, docs, spreadsheets
- Read images stored on Drive

## What You CANNOT Do

- Upload files
- Delete files
- Move or rename files (without explicit permission)
- Share files or change permissions
- Access files outside the contractor's Drive
```
