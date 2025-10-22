## [0.28.0](https://github.com/barry47products/mulligans-law/compare/v0.27.1...v0.28.0) (2025-10-22)

### Features

* **societies:** enhance society form screen with advanced fields ([459adbe](https://github.com/barry47products/mulligans-law/commit/459adbe9c357db4c3954307dc50e3da785810411))

## [0.27.1](https://github.com/barry47products/mulligans-law/compare/v0.27.0...v0.27.1) (2025-10-21)

### Bug Fixes

* **database:** resolve RLS infinite recursion and implement atomic society creation ([3b912c4](https://github.com/barry47products/mulligans-law/commit/3b912c4b9f575af72d8940e5fa150c8f027e2c28))

## [0.27.0](https://github.com/barry47products/mulligans-law/compare/v0.26.0...v0.27.0) (2025-10-21)

### Features

* **navigation:** move societies navigation to nested Societies tab Navigator ([96f3c5a](https://github.com/barry47products/mulligans-law/commit/96f3c5a68ee3f815b33addf1df1659822f43ac92))

## [0.26.0](https://github.com/barry47products/mulligans-law/compare/v0.25.0...v0.26.0) (2025-10-21)

### Features

* **profile:** implement profile landing screen with user info and sign out ([fbe6708](https://github.com/barry47products/mulligans-law/commit/fbe67086bb05a5798921e31b2f71e17fbac4963b))

## [0.25.0](https://github.com/barry47products/mulligans-law/compare/v0.24.0...v0.25.0) (2025-10-21)

### Features

* **leaderboard:** implement leaderboard landing screen with placeholder content ([b507ae6](https://github.com/barry47products/mulligans-law/commit/b507ae6c4c39c63ef1a2ee5ce4b99e70090ed603))

## [0.24.0](https://github.com/barry47products/mulligans-law/compare/v0.23.0...v0.24.0) (2025-10-21)

### Features

* **events:** implement events landing screen with placeholder content ([e90e67c](https://github.com/barry47products/mulligans-law/commit/e90e67cb4947e207246b796b48805365eeaddb81))

## [0.23.0](https://github.com/barry47products/mulligans-law/compare/v0.22.0...v0.23.0) (2025-10-21)

### Features

* **home:** implement dashboard home screen with statistics and quick actions ([350cf9a](https://github.com/barry47products/mulligans-law/commit/350cf9af2703a298d1ddf8f2aecfae509fc81ce4))

## [0.22.0](https://github.com/barry47products/mulligans-law/compare/v0.21.0...v0.22.0) (2025-10-21)

### Features

* **navigation:** implement main bottom navigation with 5 tabs ([e7c1c67](https://github.com/barry47products/mulligans-law/commit/e7c1c67225b05790a55422d2efd2cba58092d46f))

## [0.21.0](https://github.com/barry47products/mulligans-law/compare/v0.20.0...v0.21.0) (2025-10-20)

### Features

* **societies:** implement Society Members Screen and MemberCard widget ([82d1ec9](https://github.com/barry47products/mulligans-law/commit/82d1ec9eff79c114c014523f1e1384520df20521))

## [0.20.0](https://github.com/barry47products/mulligans-law/compare/v0.19.0...v0.20.0) (2025-10-20)

### Features

* **societies:** implement Society Dashboard Screen with tabs and stats ([34aba79](https://github.com/barry47products/mulligans-law/commit/34aba79ddb61d58f0a34dcb7ecfac051b8666529))

## [0.19.0](https://github.com/barry47products/mulligans-law/compare/v0.18.0...v0.19.0) (2025-10-20)

### Features

* **societies:** enhance Society List Screen with search and member count ([b9c96ee](https://github.com/barry47products/mulligans-law/commit/b9c96ee212ee4b5778d6579166f1e84edb138ab0))

## [0.18.0](https://github.com/barry47products/mulligans-law/compare/v0.17.0...v0.18.0) (2025-10-20)

### Features

* **members:** implement 7 member use cases with 28 tests ([076a9db](https://github.com/barry47products/mulligans-law/commit/076a9db5d9da3735611bf9b66e7d6be53742be95))
* **members:** implement MemberBloc with 10 comprehensive tests ([d89a155](https://github.com/barry47products/mulligans-law/commit/d89a155f7b7206700aa6272e3def533260c6abab))

## [0.17.0](https://github.com/barry47products/mulligans-law/compare/v0.16.0...v0.17.0) (2025-10-20)

### Features

* **societies:** add creator as captain member on society creation ([2a13cdc](https://github.com/barry47products/mulligans-law/commit/2a13cdc10e95fab6db3d48e846801b395887c469))

### Bug Fixes

* **ci:** remove docker dependabot config for supabase ([47740c1](https://github.com/barry47products/mulligans-law/commit/47740c16091dacc8b62672cfd74f2d72aafbadcb))

### Documentation

* **tasks:** mark repository integration tests as complete ([a6bef56](https://github.com/barry47products/mulligans-law/commit/a6bef56708afe3ba58e5b8479559d1e3a7fbcf5b))

## [0.16.0](https://github.com/barry47products/mulligans-law/compare/v0.15.0...v0.16.0) (2025-10-20)

### Features

* **auth:** automatically create primary member on sign up ([9951a3f](https://github.com/barry47products/mulligans-law/commit/9951a3fe27c744294b3971d788bd5e04cb6aa043))

## [0.15.0](https://github.com/barry47products/mulligans-law/compare/v0.14.7...v0.15.0) (2025-10-20)

### ⚠ BREAKING CHANGES

* **members:** Member.societyId and Member.role are now nullable (String?)

Changes:
- Update Member entity: societyId and role now nullable to support primary profiles
- Update MemberModel: handle null society_id and role in JSON serialization
- Add MemberRepository.getPrimaryMember(userId) - fetch primary member profile
- Add MemberRepository.createPrimaryMember() - create profile with null societyId/role
- Add comprehensive entity behavior tests (copyWith, equality, edge cases)
- Add primary member profile tests for model and repository

Tests:
- 44 tests passing (up from 25)
- Coverage: Member Entity 100% (up from 4%), Overall 94.9% (up from 64.6%)
- Added 19 entity behavior tests (copyWith, equality, edge cases)
- Added 3 primary member profile tests

Also fixes:
- Android Gradle configuration for Flutter plugin compatibility
- Added SDK version defaults to prevent plugin build errors

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>

### Features

* **members:** add nullable society support for primary member profiles ([74ade79](https://github.com/barry47products/mulligans-law/commit/74ade79719c0dd7e76573b5fe6eb9bc2d47ab6ef))

### Documentation

* **security:** add comprehensive security policy ([aba188a](https://github.com/barry47products/mulligans-law/commit/aba188ac1576521302b51b5398217c1b4b712c5c))

## [0.14.7](https://github.com/barry47products/mulligans-law/compare/v0.14.6...v0.14.7) (2025-10-20)

### Bug Fixes

* **security:** add explicit permissions to all CD jobs ([deffb34](https://github.com/barry47products/mulligans-law/commit/deffb34c8948028f6b8c87dd605b964a56562645))

## [0.14.6](https://github.com/barry47products/mulligans-law/compare/v0.14.5...v0.14.6) (2025-10-20)

### Bug Fixes

* **security:** add explicit permissions to all CI jobs ([ff98500](https://github.com/barry47products/mulligans-law/commit/ff9850093eafd2b4bd87fd5a69a452e74b00a3c1)), closes [#1](https://github.com/barry47products/mulligans-law/issues/1) [#2](https://github.com/barry47products/mulligans-law/issues/2) [#3](https://github.com/barry47products/mulligans-law/issues/3)

## [0.14.5](https://github.com/barry47products/mulligans-law/compare/v0.14.4...v0.14.5) (2025-10-20)

### Bug Fixes

* **security:** update CodeQL workflow to Advanced format for JS/TS only ([f371e17](https://github.com/barry47products/mulligans-law/commit/f371e175d01722c7c817d4a1c0631ab21c3ad975))

## [0.14.4](https://github.com/barry47products/mulligans-law/compare/v0.14.3...v0.14.4) (2025-10-20)

### Bug Fixes

* **security:** add custom CodeQL workflow for JavaScript/TypeScript only ([c56f2bc](https://github.com/barry47products/mulligans-law/commit/c56f2bccf6a1f2ba458f250eb4c3fb81d10e9fba))

## [0.14.3](https://github.com/barry47products/mulligans-law/compare/v0.14.2...v0.14.3) (2025-10-20)

### Bug Fixes

* **ci:** add explicit workflow permissions for security ([c4cc5d8](https://github.com/barry47products/mulligans-law/commit/c4cc5d80b06dc87c1c2efb9869b467eeef321738))

## [0.14.2](https://github.com/barry47products/mulligans-law/compare/v0.14.1...v0.14.2) (2025-10-20)


### Bug Fixes

* **cd:** update CD workflow to use Java 21 ([c6ee7ae](https://github.com/barry47products/mulligans-law/commit/c6ee7aeff105695d01de4277a1082300b07bce73))

## [0.14.1](https://github.com/barry47products/mulligans-law/compare/v0.14.0...v0.14.1) (2025-10-20)


### Bug Fixes

* **ci:** update GitHub Actions to use Java 21 and fix gradle configuration ([c6b1cf5](https://github.com/barry47products/mulligans-law/commit/c6b1cf51bafe892f8de19605ef2a18dee5de28e4))

## [0.14.0](https://github.com/barry47products/mulligans-law/compare/v0.13.0...v0.14.0) (2025-10-20)


### Features

* **database:** update members table for primary member profiles ([2f0543f](https://github.com/barry47products/mulligans-law/commit/2f0543f0e0f964c4479f38e1de7fdbefe01a8073))

## [0.13.0](https://github.com/barry47products/mulligans-law/compare/v0.12.0...v0.13.0) (2025-10-19)


### Features

* **members:** implement member data layer with TDD ([e4a8b71](https://github.com/barry47products/mulligans-law/commit/e4a8b718c1dbbdc7bc593590b540089ca45d15d2))


### Documentation

* **tasks:** replace dummy data approach with minimal real implementation ([f7d1090](https://github.com/barry47products/mulligans-law/commit/f7d10901e2ca063d690b1771d7ea1899b4a2877e))

## [0.12.0](https://github.com/barry47products/mulligans-law/compare/v0.11.0...v0.12.0) (2025-10-19)


### Features

* **societies:** implement society form screen with create/edit modes ([6a5e834](https://github.com/barry47products/mulligans-law/commit/6a5e834d75d6dee3e08beae3a5cb56b8a3f8b335))
* **societies:** implement society list screen with widget tests ([fefbfb4](https://github.com/barry47products/mulligans-law/commit/fefbfb423d89b82f49396ba75e71aa425016bfad))
* **societies:** wire up navigation and add comprehensive tasks ([095c088](https://github.com/barry47products/mulligans-law/commit/095c0881a87d5f36a232128be38af6f2afaf019f))

## [0.11.0](https://github.com/barry47products/mulligans-law/compare/v0.10.0...v0.11.0) (2025-10-19)


### Features

* **societies:** implement SocietyBloc with TDD ([4f8d7b7](https://github.com/barry47products/mulligans-law/commit/4f8d7b714031f14059a2a6ba3bbd486da1e40bca))

## [0.10.0](https://github.com/barry47products/mulligans-law/compare/v0.9.0...v0.10.0) (2025-10-19)


### Features

* **societies:** implement society repository with TDD ([9dd4061](https://github.com/barry47products/mulligans-law/commit/9dd406145fa88f35182a2fcab6d02f06b4b19bfb))
* **societies:** implement society use cases with TDD ([cd694ca](https://github.com/barry47products/mulligans-law/commit/cd694ca3205b49c1027678b96acebfcb33996676))

## [0.9.0](https://github.com/barry47products/mulligans-law/compare/v0.8.0...v0.9.0) (2025-10-19)


### Features

* **societies:** add society domain layer with TDD ([afc55f9](https://github.com/barry47products/mulligans-law/commit/afc55f9450fb39b2340c8329742278cbcca397fa))

## [0.8.0](https://github.com/barry47products/mulligans-law/compare/v0.7.2...v0.8.0) (2025-10-18)


### Features

* **branding:** integrate Mulligans Law logo throughout app ([1f5b98b](https://github.com/barry47products/mulligans-law/commit/1f5b98bdd2bf28c3f50f7885bc1252de636a3867))

## [0.7.2](https://github.com/barry47products/mulligans-law/compare/v0.7.1...v0.7.2) (2025-10-18)


### Bug Fixes

* **ci:** remove custom CodeQL workflow to use default setup ([d4b6fa8](https://github.com/barry47products/mulligans-law/commit/d4b6fa8ca93fdd6db4c786a7bdf53bc5b38b3da7))

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
