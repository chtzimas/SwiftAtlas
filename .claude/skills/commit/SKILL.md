---
name: commit
description: Stage and commit the current changes on a branch, following SwiftAtlas's commit style (imperative mood, concise, one logical change, backticks around code terms, no Co-Authored-By trailer). Always runs the test suite first and updates, adds, or removes tests as needed so the commit's tests match its code. Does not push. Trigger when the user says "commit this", "commit these changes", or as the final step of the new-feature skill.
---

# Commit Workflow

Use this skill to turn the current working-tree changes into a single local commit. It does not create branches and does not push — see `new-feature` for branch setup and `open-pr` for pushing/opening a PR.

## 1. Review the change

- Run `git status` and `git diff` to see everything that would be committed.
- Confirm the change set represents one logical change; if it doesn't, flag the unrelated parts to the user rather than bundling them into one commit.

## 2. Verify and reconcile tests

- Run `swift test` against the current changes.
- If tests fail because of the change: either fix the implementation, or — if the change intentionally alters behavior — update the affected tests to match the new expected behavior.
- If the change introduces a new capability without coverage, add unit tests for it (golden path plus relevant edge cases).
- If the change removes a capability or makes existing tests obsolete, remove those tests rather than leaving dead or skipped tests behind.
- Do not proceed to staging until `swift test` passes cleanly.

## 3. Stage

- Stage only the files relevant to this change — no unrelated files, no stray build artifacts.

## 4. Write the commit message

- Imperative mood, concise, one logical change per commit.
- Describe the capability or fix introduced, not implementation mechanics.
- Wrap file, type, and function names in backticks (e.g. `` `ClassNode` ``, `` `CycleDetector` ``).
- No `Co-Authored-By` trailer.

## 5. Stop

Do not push. Hand off to `open-pr` when the user is ready to open a PR.
