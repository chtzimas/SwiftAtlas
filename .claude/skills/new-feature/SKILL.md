---
name: new-feature
description: Scaffold a new SwiftAtlas feature or bugfix from a roadmap milestone in CONTEXT.md - creates a branch following the v<version>/feature|bugfix/<name> convention and guides implementation per the domain-ownership and separation-of-responsibilities principles. Hands off to the commit skill for testing and committing. Does not push or open a PR (use create-pr for that). Trigger when the user wants to start a new feature/bugfix, says things like "let's implement X", "start the next milestone", or names a roadmap item from CONTEXT.md.
---

# New Feature / Bugfix Workflow

Use this skill to take a capability from `CONTEXT.md`'s roadmap (or a bug report) from branch creation through implementation, following SwiftAtlas's incremental development approach.

## 1. Confirm scope and branch

- Determine the capability or bugfix name and the current version (ask the user if not already known — do not guess).
- Confirm the branch name with the user: `<version>/feature/<kebab-case-name>` or `<version>/bugfix/<kebab-case-name>`.
- Check `git status`. If the working tree is not clean, stop and ask the user how to proceed rather than discarding anything.
- Update local `main` before branching: `git fetch origin main` then `git checkout main && git pull origin main` (or `git merge --ff-only origin/main` if already on `main`).
- If not already on the correct branch, create it from the freshly updated `main`: `git checkout -b <version>/feature|bugfix/<name>`.

## 2. Implement incrementally

Follow `CONTEXT.md`'s Core Philosophy and Architectural Principles while implementing:

- **Deterministic analysis only.** Architecture information must come from parsing source, never guessed or inferred by AI.
- **Domain ownership.** SwiftSyntax is an implementation detail. Extract information into SwiftAtlas-owned domain models (e.g. `ClassNode`, `SourceFileNode`) at the parsing layer boundary — never let SwiftSyntax types (e.g. `ClassDeclSyntax`) leak into the domain, analysis, or output layers.
- **Respect layer boundaries**: `SwiftSyntax parsing -> SwiftAtlas domain -> Analysis/Graph -> Output (CLI / visualization / CI reports)`.
- **Avoid premature abstraction.** Implement the simplest correct version of the capability; introduce new domain models only when the capability actually needs them.

## 3. Hand off to commit

Once the capability is implemented, invoke the `commit` skill to run the test suite, reconcile test coverage (add/update/remove as needed), stage, and commit — it owns the test-verification and commit-message rules. This skill does not push or open a PR; once committed, hand off to `create-pr` when the user is ready.
