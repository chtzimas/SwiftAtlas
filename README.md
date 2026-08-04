# SwiftAtlas
Understand your Swift architecture—without reading thousands of lines of code.

> Static architecture analysis and visualization for Swift projects.

## Overview

SwiftAtlas is a developer tool that analyzes Swift codebases and builds a high-level representation of their architecture — helping you understand large Swift projects without reading thousands of lines of code.

See [CONTEXT.md](CONTEXT.md) for the full project vision, design philosophy, and roadmap.

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
- [ ] Detect dependency cycles and fail CI on new ones
- [ ] Emit architecture diagrams as CI/PR artifacts
- [ ] Add further architecture rules
- [ ] Explore AI-assisted architecture analysis

## License

License will be added when the project becomes public.
