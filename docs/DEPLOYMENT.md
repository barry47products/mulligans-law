# Deployment Guide

This guide explains how the CD (Continuous Deployment) pipeline works and how to configure it for production deployments.

## Overview

The CD pipeline automatically:

1. **Analyzes commits** using Conventional Commits to determine version bumps
2. **Generates version numbers** using semantic versioning (semver)
3. **Creates releases** on GitHub with auto-generated changelogs
4. **Builds and deploys** iOS and Android apps (when configured)

## How It Works

### Semantic Versioning

The project uses [semantic-release](https://github.com/semantic-release/semantic-release) to automatically determine version numbers based on commit messages:

| Commit Type                       | Version Bump  | Example                                                    |
| --------------------------------- | ------------- | ---------------------------------------------------------- |
| `feat:`                           | Minor (0.X.0) | `feat(scores): add stableford calculation` → 0.1.0 → 0.2.0 |
| `fix:`                            | Patch (0.0.X) | `fix(sync): handle offline queue` → 0.1.0 → 0.1.1          |
| `perf:`                           | Patch (0.0.X) | `perf(db): optimize leaderboard query` → 0.1.0 → 0.1.1     |
| `refactor:`                       | Patch (0.0.X) | `refactor(auth): simplify login flow` → 0.1.0 → 0.1.1      |
| `docs:`, `test:`, `ci:`, `chore:` | No release    | No version bump                                            |

**Breaking changes** (major version bump):

```bash
feat(api)!: redesign authentication flow

BREAKING CHANGE: Authentication now requires OAuth tokens instead of API keys
```

This would bump 0.1.0 → 1.0.0

### Release Process

1. **Developer** merges PR to `main` with conventional commit messages
2. **CI pipeline** runs tests and builds
3. **CD pipeline** triggers on successful CI:
   - Analyzes commits since last release
   - Determines version bump
   - Updates `CHANGELOG.md`
   - Creates GitHub release
   - Builds iOS and Android apps
   - Deploys to TestFlight/Play Store (when configured)

## Current Status

✅ **Configured:**

- Semantic release versioning
- Automatic changelog generation
- GitHub release creation
- iOS and Android builds

🚧 **Not Yet Configured:**

- TestFlight uploads (requires Apple Developer account)
- Play Store uploads (requires Google Play Console account)

## Configuring iOS Deployment (TestFlight)

### iOS Prerequisites

1. **Apple Developer Account** ($99/year)
2. **App Store Connect** account
3. **Xcode** installed locally

### iOS Setup Steps

#### 1. Create App in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **My Apps** → **+** → **New App**
3. Fill in app details:
   - Platform: iOS
   - Name: Mulligans Law
   - Primary Language: English
   - Bundle ID: com.mulliganslaw.mulliganslaw
   - SKU: mulliganslaw

#### 2. Generate App Store Connect API Key

1. Go to **Users and Access** → **Keys** → **App Store Connect API**
2. Click **+** to create new key
3. Name: "GitHub Actions CD"
4. Access: **App Manager**
5. Download the `.p8` file (keep it safe!)
6. Note the **Key ID** and **Issuer ID**

#### 3. Create Certificates and Provisioning Profiles

Using Fastlane Match (recommended):

```bash
# Install Fastlane
gem install fastlane

# Initialize Fastlane in ios/ directory
cd ios
fastlane init

# Set up Match for code signing
fastlane match init

# Generate certificates
fastlane match appstore
```

#### 4. Configure iOS GitHub Secrets

Add these secrets to your GitHub repository:

```bash
# Settings → Secrets and variables → Actions → New repository secret

APP_STORE_CONNECT_KEY_ID=ABC123XYZ
APP_STORE_CONNECT_ISSUER_ID=12345678-1234-1234-1234-123456789012
APP_STORE_CONNECT_API_KEY=<base64 encoded .p8 file content>
MATCH_PASSWORD=<your match password>
MATCH_GIT_URL=<your match certificates repo>
```

To encode the API key:

```bash
base64 -i AuthKey_ABC123XYZ.p8 | pbcopy
```

#### 5. Update CD Workflow for iOS

Uncomment and configure the TestFlight upload step in `.github/workflows/cd.yml`:

```yaml
- name: Upload to TestFlight
  uses: apple-actions/upload-testflight-build@v1
  with:
    app-path: build/ios/iphoneos/Runner.app
    issuer-id: ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}
    api-key-id: ${{ secrets.APP_STORE_CONNECT_KEY_ID }}
    api-private-key: ${{ secrets.APP_STORE_CONNECT_API_KEY }}
```

## Configuring Android Deployment (Play Store)

### Android Prerequisites

1. **Google Play Console** account ($25 one-time fee)
2. **Service account** with Play Store access

### Android Setup Steps

#### 1. Create App in Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Click **Create app**
3. Fill in app details:
   - App name: Mulligans Law
   - Default language: English
   - App or game: App
   - Free or paid: Free
4. Complete the app setup checklist

#### 2. Create Service Account

1. Go to **Setup** → **API access**
2. Click **Create new service account**
3. Follow link to Google Cloud Console
4. Create service account: "github-actions-cd"
5. Grant permissions: **Service Account User**
6. Create and download JSON key
7. Back in Play Console, grant access to the service account

#### 3. Generate Signing Keystore

```bash
# Generate keystore
keytool -genkey -v -keystore mulligans-law-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias mulliganslaw

# Convert to base64 for GitHub secret
base64 -i mulligans-law-release.jks | pbcopy
```

Create `android/key.properties`:

```properties
storePassword=<your store password>
keyPassword=<your key password>
keyAlias=mulliganslaw
storeFile=mulligans-law-release.jks
```

#### 4. Configure Android GitHub Secrets

Add these secrets:

```bash
PLAY_STORE_SERVICE_ACCOUNT_JSON=<contents of service account JSON>
ANDROID_KEYSTORE=<base64 encoded keystore>
KEYSTORE_PASSWORD=<your keystore password>
KEY_ALIAS=mulliganslaw
KEY_PASSWORD=<your key password>
```

#### 5. Update CD Workflow for Android

Uncomment and configure the Play Store upload step in `.github/workflows/cd.yml`:

```yaml
- name: Upload to Play Store
  uses: r0adkll/upload-google-play@v1
  with:
    serviceAccountJson: ${{ secrets.PLAY_STORE_SERVICE_ACCOUNT_JSON }}
    packageName: com.mulliganslaw.mulliganslaw
    releaseFiles: build/app/outputs/bundle/release/app-release.aab
    track: internal
    status: completed
```

## Testing the CD Pipeline

### 1. Test Semantic Release Locally

```bash
# Install semantic-release CLI
npm install -g semantic-release-cli

# Dry run (doesn't publish)
npx semantic-release --dry-run
```

### 2. Trigger a Release

Create a commit with a conventional commit message:

```bash
git checkout -b feat/test-release
# Make some changes
git add .
git commit -m "feat(app): add initial release version"
git push origin feat/test-release

# Create PR and merge to main
```

When merged to main, the CD pipeline will:

1. Analyze the `feat:` commit
2. Bump version from 1.0.0 → 1.1.0
3. Generate changelog
4. Create GitHub release
5. Build and deploy apps

### 3. Monitor the Deployment

```bash
# Check GitHub Actions
gh run list --workflow=cd.yml

# View specific run
gh run view <run-id>

# Check releases
gh release list
```

## Version Management

### Manual Version Override

If you need to set a specific version:

```bash
# Edit pubspec.yaml
version: 1.2.3+456

# Commit with [skip ci] to prevent CD from running
git commit -m "chore: set version to 1.2.3 [skip ci]"
```

### Build Numbers

Build numbers are automatically incremented using GitHub run number:

- Version: `1.2.3` (from semantic-release)
- Build number: `+456` (from GitHub Actions run number)
- Full version: `1.2.3+456`

## Rollback Process

If a release has issues:

### Option 1: Fix Forward (Recommended)

```bash
# Create hotfix
git checkout -b fix/critical-bug
# Fix the issue
git commit -m "fix(critical): resolve authentication crash"
git push

# Merge to main → triggers new patch release
```

### Option 2: Revert Release

```bash
# Revert the problematic commit
git revert <commit-sha>
git commit -m "revert: rollback broken authentication"

# This triggers a new patch release with the revert
```

## Changelog

The `CHANGELOG.md` file is automatically generated and includes:

- All features, fixes, and breaking changes
- Links to commits and PRs
- Grouped by release version

Example:

```markdown
## [1.2.0](https://github.com/user/repo/compare/v1.1.0...v1.2.0) (2025-10-18)

### Features

- **scores:** add stableford calculation ([abc123](https://github.com/user/repo/commit/abc123))
- **sync:** implement offline queue ([def456](https://github.com/user/repo/commit/def456))

### Bug Fixes

- **auth:** handle session timeout gracefully ([ghi789](https://github.com/user/repo/commit/ghi789))
```

## Best Practices

### Commit Messages

✅ **Good:**

```bash
feat(scores): add net score calculation
fix(sync): prevent duplicate uploads
perf(db): optimize leaderboard query
docs(api): update repository documentation
```

❌ **Bad:**

```bash
Update code
Fix bug
WIP
changes
```

### Release Timing

- **Merge to main** only when code is production-ready
- **Use feature branches** for work in progress
- **Test thoroughly** before merging
- **Review PRs** carefully - merges trigger deployments!

### Emergency Hotfixes

For critical production issues:

```bash
git checkout -b fix/critical-crash
# Fix the issue with minimal changes
git commit -m "fix(critical): resolve app crash on startup"
# Create PR with "urgent" label
# Get quick review and merge
# CD automatically deploys the patch
```

## Troubleshooting

### Release Not Created

**Problem:** CD pipeline runs but no release is created

**Solution:** Check commit messages use conventional commits format

```bash
# View recent commits
git log --oneline -10

# Ensure at least one feat/fix/perf commit since last release
```

### Build Fails on iOS

**Problem:** iOS build fails with code signing errors

**Solution:**

1. Check certificates are valid in App Store Connect
2. Regenerate provisioning profiles: `fastlane match appstore --force`
3. Verify secrets are correctly configured in GitHub

### Build Fails on Android

**Problem:** Android build fails with keystore errors

**Solution:**

1. Verify keystore secret is base64 encoded correctly
2. Check `key.properties` configuration
3. Ensure passwords match the keystore

## Resources

- [Semantic Release Documentation](https://semantic-release.gitbook.io/)
- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Fastlane Documentation](https://docs.fastlane.tools/)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [Google Play Console](https://developer.android.com/distribute/console)

## Next Steps

1. ✅ CD pipeline is configured and ready
2. ⏭️ Set up Apple Developer account when ready to deploy to TestFlight
3. ⏭️ Set up Google Play Console when ready to deploy to Play Store
4. ⏭️ Configure app signing for both platforms
5. ⏭️ Test the full deployment pipeline end-to-end
