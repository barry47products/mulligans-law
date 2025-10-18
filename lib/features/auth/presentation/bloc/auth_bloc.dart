import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../../../core/errors/auth_exceptions.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for managing authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final AuthRepository _authRepository;

  StreamSubscription<dynamic>? _authStateSubscription;

  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
    required AuthRepository authRepository,
  }) : _signIn = signIn,
       _signUp = signUp,
       _signOut = signOut,
       _getCurrentUser = getCurrentUser,
       _authRepository = authRepository,
       super(const AuthInitial()) {
    // Register event handlers
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthUserChanged>(_onAuthUserChanged);

    // Listen to auth state changes
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthUserChanged(user?.id));
    });
  }

  /// Handle auth check on app start
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _getCurrentUser();

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Handle sign in request
  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final session = await _signIn(
        email: event.email,
        password: event.password,
      );

      emit(AuthAuthenticated(session.user));
    } on InvalidCredentialsException catch (e) {
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Handle sign up request
  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final session = await _signUp(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      emit(AuthAuthenticated(session.user));
    } on EmailAlreadyExistsException catch (e) {
      emit(AuthError(e.message));
    } on WeakPasswordException catch (e) {
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Handle sign out request
  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _signOut();
      emit(const AuthUnauthenticated());
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Handle auth state change from stream
  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.userId == null) {
      emit(const AuthUnauthenticated());
    } else {
      emit(const AuthLoading());
      try {
        final user = await _getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthUnauthenticated());
        }
      } catch (e) {
        emit(const AuthUnauthenticated());
      }
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
