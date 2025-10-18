/// Supabase configuration for the application.
///
/// Uses environment variables with sensible defaults for local development.
class SupabaseConfig {
  // Private constructor to prevent instantiation
  SupabaseConfig._();

  /// Supabase project URL
  ///
  /// Default: Local Supabase instance (http://localhost:54321)
  /// Production: Set via --dart-define SUPABASE_URL=your-project-url
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'http://localhost:54321',
  );

  /// Supabase anonymous key
  ///
  /// Default: Standard local development anon key
  /// Production: Set via --dart-define SUPABASE_ANON_KEY=your-anon-key
  ///
  /// SECURITY NOTE: This is the public anon key, safe to include in client code.
  /// The anon key is used for Row Level Security policies.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0',
  );

  /// Whether to enable debug logging for Supabase
  ///
  /// Default: true for local development
  /// Production: Set via --dart-define SUPABASE_DEBUG=false
  static const bool enableDebugLogging = bool.fromEnvironment(
    'SUPABASE_DEBUG',
    defaultValue: true,
  );
}
