import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/auth_session.dart';
import 'auth_user_model.dart';

/// Extension to convert Supabase Session to domain AuthSession
extension AuthSessionMapper on supabase.Session {
  /// Converts Supabase Session to domain AuthSession entity
  AuthSession toDomain() {
    return AuthSession(
      user: user.toDomain(),
      accessToken: accessToken,
      refreshToken: refreshToken ?? '',
      expiresAt: DateTime.fromMillisecondsSinceEpoch(expiresAt! * 1000),
    );
  }
}
