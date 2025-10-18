## [0.7.1](https://github.com/barry47products/mulligans-law/compare/v0.7.0...v0.7.1) (2025-10-18)


### Bug Fixes

* **ci:** configure CodeQL to analyze only JavaScript/TypeScript ([7e5f6af](https://github.com/barry47products/mulligans-law/commit/7e5f6af724ae37c33f60c999847c659f4c855927))


### Documentation

* add comprehensive authentication documentation ([133e8c9](https://github.com/barry47products/mulligans-law/commit/133e8c993c4e4c5a00e7199e2c78af2e639fd08a))

## [0.7.0](https://github.com/barry47products/mulligans-law/compare/v0.6.0...v0.7.0) (2025-10-18)


### Features

* **auth:** wire up authentication with Supabase and BLoC ([5ee092c](https://github.com/barry47products/mulligans-law/commit/5ee092cb5915b3710ee5befc79e9c7c7275a1944))

## [0.6.0](https://github.com/barry47products/mulligans-law/compare/v0.5.0...v0.6.0) (2025-10-18)


### Features

* **auth:** add authentication screens following Miro prototype ([c6bafda](https://github.com/barry47products/mulligans-law/commit/c6bafda1360239b246d093ff6666cca5aae32171))


### Documentation

* **test:** add test suite and comprehensive testing guide ([288aae7](https://github.com/barry47products/mulligans-law/commit/288aae7ddc05b313178226070980f56a2ab40ffe))

## [0.5.0](https://github.com/barry47products/mulligans-law/compare/v0.4.0...v0.5.0) (2025-10-18)


### Features

* **auth:** implement Auth BLoC for state management ([df23732](https://github.com/barry47products/mulligans-law/commit/df23732affd79abfa7ea246c3272c31fee900d1a))

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
