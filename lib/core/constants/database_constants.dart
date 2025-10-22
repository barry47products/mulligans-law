/// Database table names for Supabase
class DatabaseTables {
  // Prevent instantiation
  const DatabaseTables._();

  static const String societies = 'societies';
  static const String members = 'members';
  static const String courses = 'courses';
  static const String rounds = 'rounds';
  static const String scores = 'scores';
  static const String tournaments = 'tournaments';
  static const String seasons = 'seasons';
  static const String messages = 'messages';
  static const String spotPrizes = 'spot_prizes';
  static const String knockoutMatches = 'knockout_matches';
}

/// Database column names
class DatabaseColumns {
  // Prevent instantiation
  const DatabaseColumns._();

  // Common columns
  static const String id = 'id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';

  // Society columns
  static const String name = 'name';
  static const String description = 'description';
  static const String logoUrl = 'logo_url';
  static const String isPublic = 'is_public';
  static const String handicapLimitEnabled = 'handicap_limit_enabled';
  static const String handicapMin = 'handicap_min';
  static const String handicapMax = 'handicap_max';
  static const String location = 'location';
  static const String rules = 'rules';
  static const String deletedAt = 'deleted_at';

  // Member columns
  static const String societyId = 'society_id';
  static const String userId = 'user_id';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String avatarUrl = 'avatar_url';
  static const String handicap = 'handicap';
  static const String role = 'role';
  static const String status = 'status';
  static const String joinedAt = 'joined_at';
  static const String lastPlayedAt = 'last_played_at';
  static const String expiresAt = 'expires_at';
  static const String rejectionMessage = 'rejection_message';
}

/// Member role values
class MemberRole {
  // Prevent instantiation
  const MemberRole._();

  static const String member = 'MEMBER';
  static const String captain = 'CAPTAIN';
  static const String owner = 'OWNER';
  static const String coOwner = 'CO_OWNER';
}

/// Member status values
class MemberStatus {
  // Prevent instantiation
  const MemberStatus._();

  static const String pending = 'PENDING';
  static const String active = 'ACTIVE';
  static const String resigned = 'RESIGNED';
}
