# SwiftAtlas
A static analysis CLI and GitHub Action that detects retain cycles in Swift projects.

[![CI](https://github.com/chtzimas/SwiftAtlas/actions/workflows/ci.yml/badge.svg)](https://github.com/chtzimas/SwiftAtlas/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/github/license/chtzimas/SwiftAtlas)](LICENSE)

## Overview

SwiftAtlas parses Swift source with [SwiftSyntax](https://github.com/swiftlang/swift-syntax), builds a project-wide dependency graph of strong-reference relationships between types, and detects retain cycles in that graph — classes holding strong references to each other, usually a missing `weak`/`unowned`, that silently leak memory. This covers both direct class-to-class references and the idiomatic protocol-typed delegate pattern (`weak var delegate: SomeDelegateProtocol?`).

It ships two ways to use that analysis:

- A CLI (`swiftatlas`) you can run against any Swift file, directory, or package.
- A reusable, zero-configuration [GitHub Action](action.yml) any Swift project can drop into its own CI with one step. It fails a pull request check only when the change introduces a *new* cycle, not on every pre-existing one.

## Project Status

Retain cycle detection is complete and validated end-to-end, both against this repository's own code and against a separate external consumer repository.

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
      - uses: chtzimas/SwiftAtlas@v1
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

## License

[MIT](LICENSE)
