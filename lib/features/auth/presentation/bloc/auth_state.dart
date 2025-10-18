import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when BLoC is created
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when checking authentication status
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is authenticated
class AuthAuthenticated extends AuthState {
  final AuthUser user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when an authentication error occurs
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
