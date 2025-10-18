# Supabase Local Development Setup

This guide explains how to set up and use Supabase for local development.

## Prerequisites

- Docker Desktop installed and running
- Supabase CLI installed via Homebrew

## Installation

### Install Supabase CLI

```bash
brew install supabase/tap/supabase
```

Verify installation:

```bash
supabase --version
```

## Initialize Supabase

The project has already been initialized with Supabase. The configuration is stored in:

```bash
supabase/
├── config.toml          # Supabase configuration
├── migrations/          # Database migrations
├── .gitignore          # Git ignore for local files
├── .temp/              # Temporary files (not committed)
└── .branches/          # Branch-specific data (not committed)
```

## Starting Supabase

To start all Supabase services locally:

```bash
supabase start
```

This command will:

1. Pull required Docker images (first time only)
2. Start all Supabase services:

   - PostgreSQL database
   - PostgREST (REST API)
   - GoTrue (Authentication)
   - Realtime
   - Storage
   - Kong (API Gateway)
   - Studio (Admin UI)
   - Mailpit (Email testing)
   - Vector (Logs)
   - Analytics

3. Display service URLs and credentials

## Service URLs

After starting Supabase, you'll have access to:

| Service    | URL                                                     | Description                |
| ---------- | ------------------------------------------------------- | -------------------------- |
| API URL    | `http://127.0.0.1:54321`                               | Main API endpoint          |
| GraphQL    | `http://127.0.0.1:54321/graphql/v1`                    | GraphQL endpoint           |
| S3 Storage | `http://127.0.0.1:54321/storage/v1/s3`                 | S3-compatible storage      |
| Database   | `postgresql://postgres:postgres@127.0.0.1:54322/postgres`| Direct database connection |
| Studio     | `http://127.0.0.1:54323`                               | Admin dashboard            |
| Mailpit    | `http://127.0.0.1:54324`                               | Email inbox (for testing)  |

## Checking Status

To check the status of running services:

```bash
supabase status
```

This displays:

- All service URLs
- API keys (publishable and secret)
- S3 credentials
- Running/stopped services

## Stopping Supabase

To stop all services:

```bash
supabase stop
```

To stop and remove all data (reset to clean state):

```bash
supabase stop --no-backup
```

## Database Migrations

### Creating a Migration

```bash
supabase migration new <migration_name>
```

Example:

```bash
supabase migration new create_societies_table
```

This creates a new file in `supabase/migrations/` with a timestamp prefix.

### Applying Migrations

Migrations are automatically applied when you run `supabase start`.

To manually apply migrations:

```bash
supabase db reset
```

**Warning**: This will drop all data and re-run all migrations from scratch.

### Checking Migration Status

```bash
supabase migration list
```

## Accessing the Database

### Using Studio

The easiest way to interact with your database is through Supabase Studio:

1. Start Supabase: `supabase start`
2. Open Studio: `http://127.0.0.1:54323`
3. Navigate to the Table Editor, SQL Editor, or Authentication tabs

### Using psql

You can connect directly to the database using `psql`:

```bash
supabase db connect
```

Or using the connection string:

```bash
psql postgresql://postgres:postgres@127.0.0.1:54322/postgres
```

### Using SQL Files

To run a SQL file:

```bash
supabase db execute -f path/to/file.sql
```

## Environment Variables for Flutter App

When developing the Flutter app, you'll need these environment variables:

```dart
// For local development
const supabaseUrl = 'http://127.0.0.1:54321';
const supabaseAnonKey = 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH';
```

**Note**: These keys are for local development only and are safe to commit. Production keys should be stored securely and never committed.

## Seeding Data

To seed your database with initial data:

1. Create a file: `supabase/seed.sql`
2. Add your INSERT statements
3. Run: `supabase db reset`

The seed file is automatically run after migrations.

## Testing Email

Supabase includes Mailpit for testing emails locally:

1. Trigger an email in your app (e.g., password reset)
2. Open Mailpit: `http://127.0.0.1:54324`
3. View the email in the inbox

No real emails are sent in local development.

## Common Commands

| Command                         | Description                       |
| ------------------------------- | --------------------------------- |
| `supabase start`                | Start all services                |
| `supabase stop`                 | Stop all services                 |
| `supabase status`               | Show service status and URLs      |
| `supabase db reset`             | Reset database and run migrations |
| `supabase migration new <name>` | Create new migration              |
| `supabase migration list`       | List migrations                   |
| `supabase db connect`           | Connect to database with psql     |
| `supabase functions new <name>` | Create new Edge Function          |

## Troubleshooting

### Docker Not Running

**Error**: `Cannot connect to the Docker daemon`

**Solution**: Start Docker Desktop

### Port Already in Use

**Error**: `port 54321 already allocated`

**Solution**:

1. Stop Supabase: `supabase stop`
2. Kill the process using the port
3. Restart: `supabase start`

### Containers Won't Start

**Error**: Container health checks failing

**Solution**:

1. Stop all services: `supabase stop`
2. Remove volumes: `supabase stop --no-backup`
3. Restart: `supabase start`

### Database Reset Not Working

**Solution**:

1. Stop Supabase: `supabase stop`
2. Start fresh: `supabase db reset`

### Can't Connect from Flutter

**Solution**:

- iOS Simulator: Use `http://127.0.0.1:54321`
- Android Emulator: Use `http://10.0.2.2:54321`
- Physical Device: Use your computer's local IP (e.g., `http://192.168.1.100:54321`)

## Next Steps

1. Create your first migration (see [TASKS.md](../TASKS.md))
2. Set up Row Level Security (RLS) policies
3. Test authentication flow
4. Integrate with Flutter app

## Additional Resources

- [Supabase CLI Documentation](https://supabase.com/docs/guides/cli)
- [Local Development Guide](https://supabase.com/docs/guides/cli/local-development)
- [Database Migrations](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [Supabase Flutter SDK](https://supabase.com/docs/reference/dart/introduction)
