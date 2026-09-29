---
name: sync
description: Reconcile AGENTS.md, MEMORY.md, and existing documentation with verified code, branch, and commit changes in this repository.
---

# Skill Playbook: /sync

Use this playbook to keep project context accurate after substantive changes. Do not substitute documentation updates for requested code work.

## 1. Inspect the delta

Read `git status`, the current branch, relevant diffs/commits, and affected `lib/`, tests, generator files, or `docs/knowledge/` content when present. Compare claims against source and executable configuration. Do not treat an empty or draft document as evidence, or infer PR milestones from uncommitted work.

## 2. Update `MEMORY.md`

Keep this uppercase file canonical. Refresh **Memory** and **Next steps / Open items** when the current state changes. Append to **Decisions made** only for a verified decision, and to **Progress log** only for an actual commit, PR, or clearly labeled working-tree milestone. Preserve chronological order; distinguish committed history from pending work.

## 3. Sync guidance and verify

Update `AGENTS.md` only for durable changes to architecture, commands, paths, or workflows. Update other documentation only when it exists and is affected. Preserve the required sections, check links and Markdown, and report unresolved uncertainty. Never copy secrets or private configuration into memory, and never claim tests passed without running them.
