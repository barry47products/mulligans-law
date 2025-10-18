## [0.4.0](https://github.com/barry47products/mulligans-law/compare/v0.3.0...v0.4.0) (2025-10-18)


### Features

* **auth:** implement auth use cases with TDD ([86f9b6e](https://github.com/barry47products/mulligans-law/commit/86f9b6e5ad8485ac24845cc41a7018762d9f5399))

## [0.3.0](https://github.com/barry47products/mulligans-law/compare/v0.2.0...v0.3.0) (2025-10-18)


### Features

* **auth:** implement authentication data layer with TDD ([da37f75](https://github.com/barry47products/mulligans-law/commit/da37f7530f091e426307cd576ef545db13d5e318))

## [0.2.0](https://github.com/barry47products/mulligans-law/compare/v0.1.0...v0.2.0) (2025-10-18)


### Features

* **ui:** implement Mulligans Law design system ([932d7cb](https://github.com/barry47products/mulligans-law/commit/932d7cb4702b704e3935959b84e9c51349399557)), closes [#4CD4B0](https://github.com/barry47products/mulligans-law/issues/4CD4B0)


### Documentation

* **changelog:** add initial changelog for v0.1.0 ([e7ff024](https://github.com/barry47products/mulligans-law/commit/e7ff024bda9cead2de3a07c5db765760d878a4da))

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-10-18

### Added

- Flutter project initialized with Clean Architecture structure
- Database schema with societies and members tables
- Row Level Security (RLS) policies for data protection
- CI/CD pipelines with GitHub Actions
- Semantic versioning with semantic-release
- Codecov integration for test coverage tracking
- Git hooks with Lefthook for code quality enforcement
- Comprehensive technical documentation (Docusaurus)
  - Architecture overview
  - Development workflow guide
  - Testing strategy guide
- Testing infrastructure with helpers and mock factories
- Supabase local development environment
- GitHub issue and PR templates

### Infrastructure

- **CI Pipeline**: Automated testing, linting, and builds for iOS and Android
- **CD Pipeline**: Semantic versioning and automated releases
- **Documentation Site**: Docusaurus deployed to GitHub Pages
- **Local Development**: Supabase CLI for local database development

### Technical Details

- Flutter 3.35.6 with Dart 3.9.2
- Supabase for backend (PostgreSQL, Auth)
- Drift 2.22.0 for offline-first local storage
- BLoC pattern for state management
- TDD approach with 70% coverage target

---

_This is a pre-1.0 development release. The application is not yet production-ready._
