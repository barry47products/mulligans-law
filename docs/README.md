# Documentation Structure

This directory contains project-level documentation. The technical documentation website (Docusaurus) is located in a separate directory.

## Directory Organization

### `/docs/` (this directory)
Project documentation and specifications:
- `functional-spec.md` - Feature requirements and user stories
- `technical-spec.md` - Architecture and implementation details
- `GITHUB_SETUP.md` - GitHub configuration guide
- `DOCASAURUS_SETUP.md` - Instructions for setting up the technical docs site

### `/docs-technical/` (separate directory)
Docusaurus-based technical documentation website:
- Living documentation for developers
- API reference
- Feature guides
- Architecture documentation
- Getting started tutorials

## Why This Structure?

**Project Documentation (`/docs/`):**
- Core specifications that define the project
- Referenced directly in root-level files (README.md, WORKFLOW.md, CLAUDE.md)
- Markdown files meant to be read directly in the repository
- Versioned with the codebase

**Technical Documentation (`/docs-technical/`):**
- Interactive documentation site built with Docusaurus
- Published to GitHub Pages
- Feature-specific implementation guides
- API reference with code examples
- Searchable and versioned
- Treated as a feature implementation

## When to Update Each

### Update `/docs/` when:
- Project requirements change
- Architecture decisions are made
- Development workflow changes
- GitHub setup changes

### Update `/docs-technical/` when:
- New features are implemented
- APIs change
- Adding code examples
- Creating user guides
- Architecture implementation details change

## Quick Links

- [Functional Specification](functional-spec.md)
- [Technical Specification](technical-spec.md)
- [Docusaurus Setup Guide](DOCASAURUS_SETUP.md)
- [GitHub Setup Guide](GITHUB_SETUP.md)
