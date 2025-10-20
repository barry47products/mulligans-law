# Security Policy

## Supported Versions

We release patches for security vulnerabilities. The following versions are currently being supported with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 0.x.x   | :white_check_mark: |

**Note:** As this project is in active development (pre-1.0 release), we currently only support the latest version. Once we reach v1.0.0, we will maintain security updates for the current major version.

## Reporting a Vulnerability

We take the security of Mulligans Law seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### How to Report a Security Vulnerability

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report them via one of the following methods:

1. **GitHub Security Advisories (Preferred)**
   - Navigate to the [Security tab](https://github.com/barry47products/mulligans-law/security/advisories)
   - Click "Report a vulnerability"
   - Provide a detailed description of the vulnerability

2. **Email**
   - Send an email to: <security@mulliganslaw.app> (or your preferred security contact email)
   - Use the subject line: `[SECURITY] Mulligans Law - Brief Description`
   - Include detailed information about the vulnerability

### What to Include in Your Report

Please include the following information in your vulnerability report:

- **Type of vulnerability** (e.g., SQL injection, XSS, authentication bypass, etc.)
- **Full paths of source file(s)** related to the vulnerability
- **Location of the affected source code** (tag/branch/commit or direct URL)
- **Step-by-step instructions to reproduce** the issue
- **Proof-of-concept or exploit code** (if possible)
- **Impact of the vulnerability** (what an attacker could achieve)
- **Suggested fix** (if you have one)

### What to Expect

- **Initial Response:** You can expect an initial response within **48 hours** acknowledging receipt of your report
- **Status Updates:** We will keep you informed of our progress every **5-7 business days**
- **Validation:** We will work to validate the vulnerability and determine its impact
- **Fix Development:** If confirmed, we will develop and test a fix
- **Disclosure:** Once a fix is ready, we will:
  1. Release the security patch
  2. Update this SECURITY.md file
  3. Publish a security advisory (crediting you if desired)
  4. Notify users through release notes

### Disclosure Policy

- **Coordinated Disclosure:** We follow a coordinated disclosure approach
- **Timeline:** We aim to patch confirmed vulnerabilities within **90 days**
- **Public Disclosure:** We will not publicly disclose the vulnerability until:
  - A fix has been released
  - Users have had reasonable time to update (typically 7-14 days)
  - You agree (if you reported it)

### Scope

#### In Scope

The following are in scope for security vulnerability reports:

- **Authentication & Authorization**
  - User authentication bypass
  - Privilege escalation
  - Session management issues
  - Token leakage or theft

- **Data Security**
  - Unauthorized access to user data
  - Data leakage through APIs
  - Insecure data storage
  - SQL injection or database vulnerabilities

- **API Security**
  - API authentication bypass
  - Rate limiting issues leading to DoS
  - Input validation vulnerabilities
  - Mass assignment vulnerabilities

- **Mobile App Security**
  - Local data storage vulnerabilities
  - Insecure communication channels
  - Certificate pinning bypass
  - Code injection vulnerabilities

- **Infrastructure**
  - Cloud misconfigurations
  - Exposed sensitive endpoints
  - Insecure direct object references (IDOR)

#### Out of Scope

The following are explicitly out of scope:

- **Denial of Service (DoS) attacks** requiring unrealistic resource consumption
- **Social engineering attacks**
- **Physical attacks** against the infrastructure
- **Spam** or abuse of contact forms
- **Reports about software versions** being out of date (without demonstrable vulnerability)
- **Clickjacking** on pages without sensitive actions
- **Missing best practices** without demonstrable security impact
- **Theoretical vulnerabilities** without proof of concept
- **Third-party vulnerabilities** (report these to the respective maintainers)
- **Issues in dependencies** already tracked in public vulnerability databases (we monitor these)

### Security Best Practices for Contributors

If you're contributing to Mulligans Law, please follow these security best practices:

#### Authentication & Authorization

- Never commit credentials, API keys, or secrets
- Use environment variables for sensitive configuration
- Implement proper role-based access control (RBAC)
- Always validate user permissions before sensitive operations

#### Data Handling

- Validate and sanitize all user inputs
- Use parameterized queries to prevent SQL injection
- Encrypt sensitive data at rest
- Use HTTPS/TLS for all data in transit
- Implement proper error handling (don't leak sensitive info in errors)

#### Dependencies

- Keep dependencies up to date
- Review security advisories for dependencies
- Use `flutter pub upgrade` regularly
- Run `flutter analyze` before committing

#### Code Review

- All code must be reviewed before merging
- Security-sensitive changes require extra scrutiny
- Use our CI/CD pipeline (all checks must pass)
- Follow the principle of least privilege

#### Mobile App Specific

- Store sensitive data in secure storage (iOS Keychain, Android Keystore)
- Implement certificate pinning for API calls
- Obfuscate sensitive code in production builds
- Never log sensitive information in production

### Security Features

Mulligans Law implements the following security measures:

- **Supabase Authentication:** Industry-standard OAuth 2.0 and JWT tokens
- **Row Level Security (RLS):** Database-level authorization on all tables
- **Encrypted Storage:** Sensitive local data encrypted on device
- **TLS/HTTPS:** All network communication encrypted in transit
- **Code Scanning:** Automated CodeQL security analysis on every commit
- **Dependency Scanning:** Automated vulnerability scanning of dependencies
- **Secure Defaults:** Security best practices enabled by default

### Security Updates

Security updates will be released as follows:

- **Critical vulnerabilities:** Immediate patch release (within 24-48 hours)
- **High severity:** Patch within 7 days
- **Medium severity:** Patch within 30 days
- **Low severity:** Included in next regular release

All security updates will be:

- Clearly marked in release notes with `[SECURITY]` prefix
- Published as GitHub Security Advisories
- Assigned CVE identifiers (if applicable)
- Communicated to users via app update notifications

### Past Security Advisories

No security advisories have been published yet.

Once published, they will be listed here with:

- CVE identifier
- Severity level
- Affected versions
- Fixed versions
- Description and impact

### Recognition

We believe in recognizing security researchers who help improve our security:

- **Public Acknowledgment:** With your permission, we will credit you in:
  - The security advisory
  - Release notes
  - This SECURITY.md file (Hall of Fame section below)
- **Hall of Fame:** (to be created once we receive our first valid report)

### Additional Resources

- [Supabase Security Best Practices](https://supabase.com/docs/guides/platform/security)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)
- [OWASP Mobile Security Project](https://owasp.org/www-project-mobile-security/)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)

### Questions?

If you have questions about this security policy, please:

- Open a public GitHub issue (for non-sensitive questions)
- Email <security@mulliganslaw.app> (for sensitive questions)

---

**Last Updated:** 2025-10-20

**Policy Version:** 1.0
