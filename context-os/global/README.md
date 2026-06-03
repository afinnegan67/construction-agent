# Global Files

These files span across all projects and organizations.

## flagged-emails.md

The agent's deduplication log. When the agent proactively flags an email that
needs attention, it records the flag here. This prevents the same email from
being flagged twice. The contractor can reply "handled," "dismiss," or "remind
me tomorrow" and the agent updates the status.

## system-notes.md

The agent's scratchpad. Operational notes, configuration details, and
cross-project observations. You probably never need to read this.
