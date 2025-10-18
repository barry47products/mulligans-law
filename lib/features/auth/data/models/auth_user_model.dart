import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/auth_user.dart';

/// Extension to convert Supabase User to domain AuthUser
extension AuthUserMapper on supabase.User {
  /// Converts Supabase User to domain AuthUser entity
  AuthUser toDomain() {
    return AuthUser(
      id: id,
      email: email ?? '',
      name: userMetadata?['name'] as String?,
      avatarUrl: userMetadata?['avatar_url'] as String?,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
