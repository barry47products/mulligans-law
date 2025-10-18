import 'package:equatable/equatable.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check if user is already signed in (on app start)
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event to sign in with email and password
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event to sign up with email, password, and optional name
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String? name;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

/// Event to sign out the current user
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Event triggered when auth state changes (from stream)
class AuthUserChanged extends AuthEvent {
  final String? userId;

  const AuthUserChanged(this.userId);

  @override
  List<Object?> get props => [userId];
}
