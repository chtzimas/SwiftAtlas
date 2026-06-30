# SwiftAtlas
Understand your Swift architecture—without reading thousands of lines of code.

> Static architecture analysis and visualization for Swift projects.

## Overview

SwiftAtlas is a developer tool that analyzes Swift codebases and builds a high-level representation of their architecture.

The long-term vision is to help developers understand large Swift projects by providing:

- Architecture visualization
- Dependency graphs
- Module relationships
- Architecture diffing
- CI integration
- AI-assisted architecture insights

## Why?

Understanding an unfamiliar codebase is one of the hardest parts of software development.

SwiftAtlas aims to reduce that friction by transforming Swift source code into an architectural model that can be explored, analyzed, and eventually enforced.

## Design Principles

SwiftAtlas follows a deterministic analysis model.

Architecture information is extracted from Swift source code using static analysis.

AI is intended to augment the experience by explaining and interpreting the architecture—not by generating or guessing it.

## Project Status

🚧 SwiftAtlas is currently in early development (v0.1).

The current milestone focuses on:

- Parsing Swift source files
- Extracting basic type declarations
- Building the first architecture graph

## Roadmap

- [ ] Parse a single Swift file
- [ ] Extract classes, structs and protocols
- [ ] Detect inheritance and protocol conformance
- [ ] Build an internal graph model
- [ ] Create CLI (`swiftatlas analyze`)
- [ ] Visualize the graph in a macOS application
- [ ] Add architecture rules and CI integration
- [ ] Explore AI-assisted architecture analysis

## License

License will be added when the project becomes public.
