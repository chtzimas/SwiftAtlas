---
name: open-pr
description: Push the current feature/bugfix branch and open a GitHub PR for it, following SwiftAtlas's PR philosophy from CONTEXT.md (why the change exists, what capability it introduces, how it contributes to the roadmap). Invoking this skill is itself the user's authorization to push and open the PR immediately, with no additional confirmation step. Trigger when the user says "open a PR", "create the PR", "push this branch", or after finishing work started with new-feature.
---

# Create Pull Request Workflow

Use this skill once a feature or bugfix branch has one or more local commits ready to go upstream.

## 1. Verify readiness

- Confirm the branch has commits ahead of `main`: `git log main..HEAD`.
- Confirm the working tree is clean (`git status`) — if not, stop and ask how to proceed.
- Check whether the branch already tracks a remote and whether it's up to date.

## 2. Review the full change set

- Look at **all** commits going into the PR, not just the latest: `git log main..HEAD` and `git diff main...HEAD`.
- Make sure the summary below reflects everything in the branch, not just the most recent commit.

## 3. Draft the PR

Per `CONTEXT.md`'s "Pull Requests" section, the description should explain:

- **Why** the change exists.
- **What** capability it introduces.
- **How** it contributes to the larger vision — tie it back to the relevant roadmap milestone in `CONTEXT.md` (e.g. v0.3 Architecture Graph).

Keep the body nice and descriptive but not too extensive. Write for the big picture and the reasoning behind decisions and the goal achieved — not a walkthrough of implementation details (no line-by-line "changed X function to do Y", no file-by-file diff narration). A reader should come away understanding *why this change exists and what it accomplishes*, not *how the code works internally*.

Formatting:

- Title: short (under ~70 chars), imperative mood.
- Wrap file, type, and function names in backticks (e.g. `` `CycleDetector` ``).
- No `Co-Authored-By` trailer.
- No "Test plan" checklist section.

## 4. Push and create the PR

No confirmation step — invoking this skill is the user's authorization to proceed immediately:

- `git push -u origin <branch>`.
- Create the PR with `gh pr create --title "..." --body "..."`, using a heredoc for the body to preserve formatting.

## 5. Report back

Return the PR URL to the user.
