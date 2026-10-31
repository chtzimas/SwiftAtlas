# SwiftAtlas
Understand your Swift architecture—without reading thousands of lines of code.

> Static architecture analysis for Swift projects, starting with retain cycle detection enforced in CI.

## Overview

SwiftAtlas is a deterministic static analysis tool for Swift codebases. It parses Swift source with [SwiftSyntax](https://github.com/swiftlang/swift-syntax), builds a project-wide domain model, and today uses that model to find a specific, high-value architectural problem: **retain cycles** — classes holding strong references to each other, usually a missing `weak`/`unowned`, that silently leak memory.

It ships two ways to use that analysis:

- A CLI (`swiftatlas`) you can run against any Swift file, directory, or package.
- A reusable, zero-configuration [GitHub Action](action.yml) any Swift project can drop into its own CI with one step.

See [CONTEXT.md](CONTEXT.md) for the full project vision, design philosophy, and roadmap.

## Project Status

SwiftAtlas is at **v0.3 (Architecture Graph)**. Retain cycle detection — the milestone's first CI goal — is complete and validated end-to-end, both against this repository's own code and against a separate external consumer repository.

## What's implemented

- **Parsing** — single files, plain directories, or a full Swift package (every target, via `swift package dump-package`), extracting classes, structs, enums, and protocols without leaking SwiftSyntax types past the parsing layer.
- **Property analysis** — stored instance properties on classes, distinguishing them from computed properties (including ones with `willSet`/`didSet`), and capturing `weak`/`unowned`/strong ownership.
- **Project-wide type resolution** — every inherited-type and property-type reference is resolved against all declarations in the project, including across module boundaries.
- **Dependency graph construction** — a graph of strong-reference relationships: a node is a class or a protocol conformed to by at least one analyzed class; an edge is a strong stored property, or a conformance from a protocol to the class implementing it. This covers both direct class-to-class references and the idiomatic delegate pattern (`weak var delegate: SomeDelegateProtocol?`).
- **Retain cycle detection via depth-first search** — each node is tracked as unvisited, in-progress (on the current DFS path), or visited; a cycle is recorded whenever an edge leads back to an in-progress node. Each cycle is normalized to a canonical rotation (starting at its lexicographically smallest node) so it's reported exactly once, regardless of where the traversal entered it.
- **Newly-introduced-only diffing** — cycle sets from a PR's base and head are diffed, so only cycles the change actually introduces are flagged. A pre-existing cycle elsewhere in a large codebase doesn't fail every future PR.
- **A CLI** — `swiftatlas <path>` for a one-off report, `swiftatlas <path> --base <basePath>` to compare against another checkout, exiting non-zero whenever a (newly introduced) cycle is found.
- **A reusable GitHub Action** — builds and runs `swiftatlas` against the consuming repository, automatically diffs against the PR's base commit, fails the check on a newly introduced cycle, and posts a single PR comment that updates in place rather than piling up duplicates.

## Usage

### CLI

From the `SwiftAtlas/` package directory:

```bash
swift run swiftatlas path/to/MyFile.swift
swift run swiftatlas path/to/MyPackage
swift run swiftatlas path/to/MyPackage --base path/to/main-checkout
```

### CI

Add this to a workflow in any Swift project — no configuration required:

```yaml
on:
  pull_request:
    branches: [main]

jobs:
  retain-cycle-check:
    runs-on: macos-15
    permissions:
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
      - uses: chtzimas/SwiftAtlas@main
        with:
          path: '.'
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

## Roadmap

- [x] Parse a single Swift file, a directory, and a full Swift package
- [x] Extract classes, structs, enums, and protocols
- [x] Detect inheritance and protocol conformance
- [x] Resolve types across module boundaries
- [x] Build an internal dependency graph model
- [x] Create a CLI (`swiftatlas`)
- [x] Detect retain cycles and fail CI only on newly introduced ones
- [x] Ship as a reusable, zero-configuration GitHub Action
- [ ] Emit architecture diagrams as CI/PR artifacts
- [ ] Add further architecture rules
- [ ] Explore AI-assisted architecture analysis

The last three are documented in [CONTEXT.md](CONTEXT.md) as possible future directions; they are not currently in progress. Development has paused at this milestone as a deliberately complete, self-contained capability — see `CONTEXT.md`'s "Current Implementation Status" for the full reasoning.

## License

SwiftAtlas is public; a license has not yet been chosen.
