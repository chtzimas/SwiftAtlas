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

SwiftAtlas is currently in early development (`v0.1`).

The current focus is establishing the foundation for source analysis.

---

## SwiftSyntax Integration

Implemented:

- SwiftSyntax dependency integration
- Source file parsing
- Syntax tree traversal

The initial approach uses visitors to extract information from Swift source files.

---

## Class Analysis

Implemented:

### ClassVisitor

Responsible for traversing SwiftSyntax nodes and detecting class declarations.

Responsibilities:

- Locate class declarations
- Extract class-related information
- Convert syntax information into domain representations

The visitor layer should remain focused on extraction only.

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

In progress.

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

---

## Future Vision

Potential future capabilities:

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
