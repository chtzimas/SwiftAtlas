# SwiftAtlas Project Context

## Project Overview

SwiftAtlas is a static architecture analysis and visualization tool for Swift projects.

Its goal is to help developers understand complex Swift codebases by transforming source code into a meaningful architectural representation.

Instead of navigating thousands of lines of code to understand relationships between components, developers should be able to inspect a high-level model of their system:

- Types and their relationships
- Inheritance hierarchies
- Protocol conformances
- Module boundaries
- Dependencies
- Architecture evolution over time

SwiftAtlas aims to become an architecture intelligence layer for Swift projects.

---

# Vision

Understanding an unfamiliar codebase is one of the hardest parts of software development.

Modern applications often contain hundreds or thousands of files, making architecture knowledge difficult to acquire and maintain.

SwiftAtlas exists to reduce this friction by automatically extracting architectural information from Swift source code and presenting it in a form that developers can understand.

The long-term vision is a tool that can answer questions such as:

- How is this application structured?
- What are the main architectural components?
- How are modules connected?
- Which components depend on each other?
- How has the architecture changed between versions?

---

# Core Philosophy

## Deterministic Analysis First

SwiftAtlas follows a deterministic static analysis approach.

Architecture information must originate from the source code itself.

The analysis pipeline should:

- Parse Swift source code
- Extract verified information
- Build domain representations
- Generate architectural models

AI should not be responsible for discovering or guessing architecture.

AI may be used in the future to:

- Explain architectural decisions
- Summarize relationships
- Answer questions about the generated model

However, the underlying analysis must remain deterministic and reproducible.

---

# Non-Goals

SwiftAtlas is not intended to become:

- An IDE replacement
- A code editor
- A code formatter
- A linter
- A generic AI code assistant

The focus is architecture understanding and visualization.

---

# Architectural Principles

## Domain Ownership

SwiftSyntax is an implementation detail.

SwiftAtlas should not expose SwiftSyntax types throughout the application.

The parsing layer extracts information from SwiftSyntax and transforms it into SwiftAtlas-owned domain models.

The project should evolve around meaningful concepts rather than raw syntax trees.

Example:

Instead of passing:

```
ClassDeclSyntax
```

through the system, SwiftAtlas should create:

```
ClassNode
```

which represents the concept of a Swift class inside the architecture model.

---

## Separation of Responsibilities

The architecture should follow clear boundaries:

```
Swift Source Code
        |
        v
SwiftSyntax Parsing Layer
        |
        v
SwiftAtlas Domain Layer
        |
        v
Analysis / Graph Layer
        |
        v
Output Layer
        |
        +--> CLI
        +--> Visualization
        +--> CI Reports
```

Each layer should have a clear responsibility.

---

# Current Technical Direction

## Technology Stack

Current technologies:

- Swift
- Swift Package Manager
- SwiftSyntax
- Swift CLI tools

Future possibilities:

- CI integrations
- Architecture visualization as CLI-emitted artifacts (e.g. diagrams posted to a pull request)
- AI-assisted explanations

A standalone macOS application for visualization is not part of the roadmap.
The CLI, combined with CI-emitted artifacts, covers the visualization need
without introducing a separate application to maintain.

---

# Current Implementation Status

SwiftAtlas has shipped a complete pipeline from source parsing through retain-cycle
detection enforced in CI, distributed as a reusable, zero-configuration GitHub Action.

---

## SwiftSyntax Integration

Implemented:

- SwiftSyntax dependency integration
- Source file parsing — a single file, a plain directory, or a full Swift package
  (via `swift package dump-package`, analyzing every target)
- Syntax tree traversal via dedicated visitors (`ClassVisitor`, `StructVisitor`,
  `EnumVisitor`, `ProtocolVisitor`), each responsible only for extraction

---

## Declaration & Property Analysis

Implemented:

Visitors extract class, struct, enum, and protocol declarations, converting SwiftSyntax
nodes into SwiftAtlas-owned domain models (`ClassNode`, `StructNode`, `EnumNode`,
`ProtocolNode`) without leaking SwiftSyntax types past the parsing layer.

For classes, stored instance properties are also extracted (`PropertyNode`),
distinguishing genuinely stored properties — including ones with `willSet`/`didSet`
observers — from computed ones, and capturing ownership (`weak` / `unowned` / strong).

---

## Project-Wide Type Resolution

Implemented:

`TypeResolver` resolves every inherited-type and property-type reference against a
project-wide index of declared types, turning an `.unresolved(name)` reference into
`.resolved(TypeIdentity)`, `.external(name)` (a name not declared anywhere in the
project, e.g. `AnyObject` or `Codable`), or `.ambiguous(name)` (more than one match).

---

## Dependency Graph & Retain Cycle Detection

Implemented:

`DependencyGraph` builds a strong-reference graph from a resolved project: a node is a
class, or a protocol conformed to by at least one analyzed class; an edge represents a
non-`weak`/`unowned` stored property, or a conformance from a protocol to the class that
implements it. This captures both direct class-to-class references and the idiomatic
delegate pattern (`weak var delegate: SomeDelegateProtocol?`) — correctness comes from
only ever drawing a conformance edge to a class actually parsed from the project, so a
protocol with no observed conformer is a harmless dead end rather than a false positive.

`CycleDetector` finds cycles in that graph with a depth-first search: each node is
tracked as unvisited, in-progress (on the current DFS path), or fully visited, and a
cycle is recorded whenever an edge leads to a node still in progress. Every cycle is
normalized to a canonical rotation — starting at its lexicographically smallest node —
so the same cycle is reported once regardless of where the traversal happened to enter
it.

`CycleDetector.detectNewCycles` diffs two graphs (a pull request's base and head),
reporting only cycles absent from the base. A cycle already present before the change
isn't something the change introduced, and isn't flagged — the detail that makes the
check adoptable on a real, pre-existing codebase rather than only a clean one.

---

## CLI

Implemented:

The `swiftatlas` executable analyzes a single file, a directory, or a full Swift
package, printing a retain-cycle report for packages. An optional `--base <path>`
argument compares against another checkout and reports only newly introduced cycles.
The CLI exits non-zero whenever a cycle (or newly introduced cycle) is found, so it can
drive a CI failure.

---

## CI Integration

Implemented:

SwiftAtlas ships `action.yml`, a composite GitHub Action any Swift project can adopt
with a single `uses: chtzimas/SwiftAtlas@main` step in its own workflow — no
configuration required. On a pull request it builds and runs `swiftatlas` against the
consuming repository, automatically checks out the PR's base commit to diff against,
fails the check if a newly introduced retain cycle is found, and posts one PR comment
that updates in place on every subsequent push instead of accumulating duplicates.

This repository dogfoods the same Action on itself (`.github/workflows/ci.yml`).

---

# Domain Model

The domain layer represents Swift concepts using SwiftAtlas-owned models.

## ClassNode

`ClassNode` represents a Swift class inside the architecture model.

Responsibilities:

- Represent class identity
- Store extracted metadata
- Encapsulate relationships

Current capabilities:

- Class name representation
- Inheritance information

Example:

Swift source:

```swift
class UserViewModel: BaseViewModel
```

becomes:

```
ClassNode(
    name: "UserViewModel",
    inheritedTypes: ["BaseViewModel"]
)
```

---

## SourceFileNode

`SourceFileNode` represents an analyzed Swift source file.

Responsibilities:

- Aggregate extracted domain objects from a source file
- Provide a higher-level representation of file analysis results

Current structure:

```
SourceFileNode
    |
    +-- ClassNode
    +-- ClassNode
    +-- ...
```

---

# Development Approach

SwiftAtlas is intentionally developed incrementally.

The goal is not to build the complete vision immediately.

Each milestone should introduce one meaningful capability while preserving architectural clarity.

The preferred workflow:

1. Define a small capability
2. Implement the simplest correct version
3. Introduce appropriate domain models
4. Add tests
5. Review architectural impact
6. Move to the next milestone

Avoid premature abstractions.

---

# Version Roadmap

## v0.1 - Source Analysis Foundation

Goal:

Create the foundation for analyzing Swift source files.

Capabilities:

- Parse Swift files
- Detect type declarations
- Extract class information
- Extract inheritance relationships
- Produce domain models

Current status:

Complete.

---

## v0.2 - Project Analysis

Goal:

Move from individual files to complete Swift projects.

Potential capabilities:

- Analyze multiple files
- Understand project structure
- Introduce project-level models

Potential models:

- ProjectNode
- ModuleNode
- DependencyNode

Current status:

Complete. `ProjectNode`/`ModuleNode` analyze a full Swift package across every target,
and cross-module type references are resolved project-wide. A standalone `DependencyNode`
model was never introduced — dependency relationships are instead represented directly
by `DependencyGraph` (see v0.3), which made a separate node type unnecessary.

---

## v0.3 - Architecture Graph

Goal:

Build a graph representation of a Swift application architecture.

Potential capabilities:

- Relationship graphs
- Dependency visualization
- Inheritance graphs
- Architecture exploration
- Dependency cycle detection

First CI goal:

Detect newly introduced dependency cycles and fail a pull request check when
one appears. This is the first capability targeted for CI enforcement, and it
requires no configuration or rule authoring from the consuming project.

Current status:

The first CI goal is complete: `DependencyGraph` and `CycleDetector` detect retain
cycles — direct class-to-class strong references and the protocol-typed delegate
pattern — diff newly introduced cycles against a PR's base branch, and are enforced via
a zero-configuration, reusable GitHub Action (see "CI Integration" above). This is what
the dependency-cycle-detection slice of this milestone turned out to mean in practice:
inheritance-cycle detection was considered and deliberately dropped, since the Swift
compiler already forbids any inheritance or protocol-inheritance cycle from compiling,
so a dedicated check for it could never fire on real code. The broader, more
exploratory capabilities on this list — general relationship/dependency/inheritance
graph visualization and open-ended "architecture exploration" — are not currently being
pursued; development has paused at this milestone as a deliberately complete,
self-contained capability rather than continuing toward those.

---

## Future Vision

Potential future capabilities, not currently planned or in progress:

- Architecture diagrams as CI/PR artifacts
- CI architecture reports
- Architecture rules
- Pull request architecture diffing
- AI-assisted architecture explanations

---

# Development Workflow

SwiftAtlas follows a professional incremental development workflow.

## Commits

Commits should:

- Represent one logical change
- Use imperative mood
- Be concise
- Explain the capability introduced

Examples:

```
Add ClassNode domain model

Introduce SourceFileNode as source file domain model

Extract inheritance information from class declarations
```

---

## Pull Requests

Pull requests should explain:

- Why the change exists
- What capability it introduces
- How it contributes to the larger vision

PRs should focus on architectural progress rather than only implementation details.

---

# Guidance for AI Contributors

AI assistants working on SwiftAtlas should:

- Understand the project vision before suggesting changes
- Preserve architectural boundaries
- Prefer incremental improvements
- Avoid unnecessary complexity
- Respect existing domain models
- Ask before introducing major architectural changes

The objective is not only to make SwiftAtlas functional.

The objective is to build a maintainable, professional architecture analysis platform for Swift projects.
