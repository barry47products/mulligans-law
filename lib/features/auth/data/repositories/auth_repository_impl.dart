import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/auth_exceptions.dart';
import '../models/auth_user_model.dart';
import '../models/auth_session_model.dart';
import '../models/user_profile_model.dart';

/// Implementation of [AuthRepository] using Supabase
class AuthRepositoryImpl implements AuthRepository {
  final supabase.SupabaseClient _supabase;

  /// Stream controller for auth state changes
  final _authStateController = StreamController<AuthUser?>.broadcast();

  AuthRepositoryImpl({required supabase.SupabaseClient supabase})
    : _supabase = supabase {
    // Listen to Supabase auth state changes and emit domain entities
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      _authStateController.add(user?.toDomain());
    });
  }

  @override
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw const UnauthorizedException('Sign in failed');
      }

      return response.session!.toDomain();
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains('invalid') || message.contains('credential')) {
        throw const InvalidCredentialsException();
      }
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<AuthSession> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );

      if (response.session == null) {
        throw const AuthException('Sign up failed - no session created');
      }

      return response.session!.toDomain();
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains('already registered') ||
          message.contains('already exists')) {
        throw const EmailAlreadyExistsException();
      }
      if (message.contains('password') &&
          (message.contains('weak') || message.contains('at least'))) {
        throw const WeakPasswordException();
      }
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      return user?.toDomain();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    try {
      final session = _supabase.auth.currentSession;
      return session?.toDomain();
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<AuthUser?> get authStateChanges => _authStateController.stream;

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains('not found') || message.contains('no user')) {
        throw const UserNotFoundException();
      }
      throw AuthException('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthUser> updateProfile({String? name, String? avatarUrl}) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;

      final response = await _supabase.auth.updateUser(
        supabase.UserAttributes(data: data),
      );

      if (response.user == null) {
        throw const UnauthorizedException('User not authenticated');
      }

      return response.user!.toDomain();
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains('not authenticated') ||
          message.contains('unauthorized')) {
        throw const UnauthorizedException();
      }
      throw AuthException('Profile update failed: ${e.toString()}');
    }
  }

  @override
  Future<List<UserProfile>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    try {
      // Search the user_profiles view we created in the migration
      final response = await _supabase
          .from('user_profiles')
          .select()
          .or('name.ilike.%$query%,email.ilike.%$query%')
          .limit(limit);

      final results = response as List;
      return results
          .map((json) => UserProfileModel.fromJson(json).toDomain())
          .toList();
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw AuthException('User search failed: ${e.toString()}');
    }
  }

  /// Dispose the stream controller
  void dispose() {
    _authStateController.close();
  }
}
