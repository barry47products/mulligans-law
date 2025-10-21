import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_user.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_event.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_state.dart';
import 'package:mulligans_law/features/profile/presentation/screens/profile_screen.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late DateTime testDate;

  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    testDate = DateTime(2024, 1, 1);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen', () {
    testWidgets('displays AppBar with Profile title', (tester) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets(
      'displays not authenticated when state is not AuthAuthenticated',
      (tester) async {
        // Arrange
        const state = AuthUnauthenticated();
        whenListen(mockAuthBloc, Stream.value(state), initialState: state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Not authenticated'), findsOneWidget);
      },
    );

    testWidgets('displays user avatar with initials', (tester) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'john.doe@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('JO'), findsOneWidget); // First two letters of "john"
    });

    testWidgets('displays user email as name', (tester) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('test@example.com'), findsNWidgets(2)); // Name + email
    });

    testWidgets('displays handicap placeholder', (tester) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Handicap: Not set'), findsOneWidget);
    });

    testWidgets('displays Edit Profile menu item', (tester) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.widgetWithIcon(ListTile, Icons.edit), findsOneWidget);
    });

    testWidgets('displays Settings menu item', (tester) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Settings'), findsOneWidget);
      expect(find.widgetWithIcon(ListTile, Icons.settings), findsOneWidget);
    });

    testWidgets('displays Sign Out button', (tester) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Sign Out'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('tapping Edit Profile shows coming soon snackbar', (
      tester,
    ) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Edit Profile'));
      await tester.pump();

      // Assert
      expect(find.text('Coming soon'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('tapping Settings shows coming soon snackbar', (tester) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Settings'));
      await tester.pump();

      // Assert
      expect(find.text('Coming soon'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('tapping Sign Out triggers AuthSignOutRequested event', (
      tester,
    ) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Sign Out'));
      await tester.pump();

      // Assert
      verify(() => mockAuthBloc.add(any())).called(1);
    });

    group('initials generation', () {
      testWidgets('generates two-letter initials from email', (tester) async {
        // Arrange
        final testUser = AuthUser(
          id: 'user1',
          email: 'alice@example.com',
          createdAt: testDate,
        );
        final state = AuthAuthenticated(testUser);
        whenListen(mockAuthBloc, Stream.value(state), initialState: state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('AL'), findsOneWidget);
      });

      testWidgets('generates single-letter initial for short username', (
        tester,
      ) async {
        // Arrange
        final testUser = AuthUser(
          id: 'user1',
          email: 'a@example.com',
          createdAt: testDate,
        );
        final state = AuthAuthenticated(testUser);
        whenListen(mockAuthBloc, Stream.value(state), initialState: state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('A'), findsOneWidget);
      });

      testWidgets('generates question mark for empty email', (tester) async {
        // Arrange
        final testUser = AuthUser(id: 'user1', email: '', createdAt: testDate);
        final state = AuthAuthenticated(testUser);
        whenListen(mockAuthBloc, Stream.value(state), initialState: state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('?'), findsOneWidget);
      });
    });

    testWidgets('screen is scrollable', (tester) async {
      // Arrange
      final testUser = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        createdAt: testDate,
      );
      final state = AuthAuthenticated(testUser);
      whenListen(mockAuthBloc, Stream.value(state), initialState: state);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
