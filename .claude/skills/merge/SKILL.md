---
name: merge
description: Squash-merge the current branch's PR into main with a well-written extended commit message (why, what, how it advances the roadmap), then delete the local and remote branch. Invoking this skill is itself the user's authorization to merge immediately - no additional confirmation step. Trigger when the user says "merge this", "merge the PR", "merge it in".
---

# Merge Workflow

Use once a PR is open and ready to land on `main`.

## 1. Verify the PR is mergeable

- Find the PR for the current branch and check its state: `gh pr view --json number,mergeable,mergeStateStatus,statusCheckRollup`.
- If required checks (`Unit Tests`) are still pending or failing, or the branch is behind `main`, stop and tell the user what's blocking rather than attempting the merge.

## 2. Draft the squash commit message

- Title: short, imperative — same convention as commit and PR titles. Append the PR number in parentheses, e.g. `Add directory analysis (#8)`, matching GitHub's default squash-title convention (this is required because supplying `--subject` below overrides GitHub's automatic `(#N)` suffix).
- Extended description: reuse the "why / what / how it advances the vision" structure used for PR bodies (see `open-pr`). Nice and descriptive but not too extensive — big picture and reasoning behind decisions, not an implementation walkthrough.
- Wrap file, type, and function names in backticks. No `Co-Authored-By` trailer.

## 3. Merge

No confirmation step — invoking this skill is the user's authorization to proceed immediately:

- `gh pr merge <number> --squash --delete-branch --subject "<title> (#<number>)" --body "<extended description>"`

## 4. Clean up locally

- Switch back to `main`: `git checkout main`.
- Pull the merged commit: `git pull origin main`.
- Delete the local feature branch if it still exists (the remote copy is already removed by `--delete-branch`): `git branch -d <branch>`.

## 5. Report back

Confirm the merge commit and that the branch was deleted, both locally and on the remote.
