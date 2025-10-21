import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_user.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_event.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_state.dart';
import 'package:mulligans_law/features/home/presentation/screens/dashboard_screen.dart';

import 'dashboard_screen_test.mocks.dart';

@GenerateMocks([AuthBloc])
void main() {
  group('DashboardScreen', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      when(mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    });

    Widget buildTestWidget() {
      return BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const MaterialApp(home: DashboardScreen()),
      );
    }

    group('AppBar', () {
      testWidgets('displays app bar with correct title', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.widgetWithText(AppBar, 'Mulligans Law'), findsOneWidget);
      });

      testWidgets('displays sign out button', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.byIcon(Icons.logout), findsOneWidget);
        expect(find.byTooltip('Sign Out'), findsOneWidget);
      });

      testWidgets('sign out button triggers AuthSignOutRequested event', (
        tester,
      ) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.byIcon(Icons.logout));
        await tester.pumpAndSettle();

        verify(mockAuthBloc.add(const AuthSignOutRequested())).called(1);
      });
    });

    group('Welcome Header', () {
      testWidgets('displays default name when user not authenticated', (
        tester,
      ) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.textContaining('Welcome back, Golfer!'), findsOneWidget);
      });

      testWidgets('displays user name when authenticated with name', (
        tester,
      ) async {
        final user = AuthUser(
          id: 'user-1',
          email: 'john@example.com',
          name: 'John Doe',
          createdAt: DateTime.now(),
        );
        when(mockAuthBloc.state).thenReturn(AuthAuthenticated(user));

        await tester.pumpWidget(buildTestWidget());

        expect(find.textContaining('Welcome back, John Doe!'), findsOneWidget);
      });

      testWidgets('displays email prefix when no name provided', (
        tester,
      ) async {
        final user = AuthUser(
          id: 'user-1',
          email: 'john@example.com',
          createdAt: DateTime.now(),
        );
        when(mockAuthBloc.state).thenReturn(AuthAuthenticated(user));

        await tester.pumpWidget(buildTestWidget());

        expect(find.textContaining('Welcome back, john!'), findsOneWidget);
      });

      testWidgets('displays user email when authenticated', (tester) async {
        final user = AuthUser(
          id: 'user-1',
          email: 'john@example.com',
          name: 'John Doe',
          createdAt: DateTime.now(),
        );
        when(mockAuthBloc.state).thenReturn(AuthAuthenticated(user));

        await tester.pumpWidget(buildTestWidget());

        expect(find.text('john@example.com'), findsOneWidget);
      });

      testWidgets('displays handicap placeholder', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.text('Handicap: Not set'), findsOneWidget);
      });

      testWidgets('displays user avatar with initials', (tester) async {
        final user = AuthUser(
          id: 'user-1',
          email: 'john@example.com',
          name: 'John Doe',
          createdAt: DateTime.now(),
        );
        when(mockAuthBloc.state).thenReturn(AuthAuthenticated(user));

        await tester.pumpWidget(buildTestWidget());

        expect(find.text('JD'), findsOneWidget);
      });

      testWidgets('displays single initial for single name', (tester) async {
        final user = AuthUser(
          id: 'user-1',
          email: 'john@example.com',
          name: 'John',
          createdAt: DateTime.now(),
        );
        when(mockAuthBloc.state).thenReturn(AuthAuthenticated(user));

        await tester.pumpWidget(buildTestWidget());

        expect(find.text('J'), findsOneWidget);
      });
    });

    group('Quick Stats', () {
      testWidgets('displays Quick Stats section title', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.text('Quick Stats'), findsOneWidget);
      });

      testWidgets('displays all four stat cards', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.text('Societies'), findsOneWidget);
        expect(find.text('Events'), findsOneWidget);
        expect(find.text('Rounds'), findsOneWidget);
        expect(find.text('Rank'), findsOneWidget);
      });

      testWidgets('displays placeholder values for stats', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        // Placeholder values
        expect(
          find.text('0'),
          findsNWidgets(3),
        ); // Societies, Events, and Rounds all 0
        expect(find.text('N/A'), findsOneWidget); // Rank
      });

      testWidgets('stats are displayed in 2x2 grid', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        final gridView = find.byType(GridView);
        expect(gridView, findsOneWidget);

        final grid = tester.widget<GridView>(gridView);
        expect(
          (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
              .crossAxisCount,
          2,
        );
      });
    });

    group('Recent Activity', () {
      testWidgets('displays Recent Activity section title', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.text('Recent Activity'), findsOneWidget);
      });

      testWidgets('displays empty state message', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.text('No recent activity'), findsOneWidget);
      });

      testWidgets('displays empty state icon', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      });
    });

    group('Quick Actions', () {
      testWidgets('displays Quick Actions section title', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.text('Quick Actions'), findsOneWidget);
      });

      testWidgets('displays My Societies button', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(
          find.widgetWithText(ElevatedButton, 'My Societies'),
          findsOneWidget,
        );
      });

      testWidgets('displays Start a Round button', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(
          find.widgetWithText(ElevatedButton, 'Start a Round'),
          findsOneWidget,
        );
      });
    });

    group('Layout', () {
      testWidgets('all sections are displayed in correct order', (
        tester,
      ) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        // Find all section titles
        expect(find.text('Quick Stats'), findsOneWidget);
        expect(find.text('Recent Activity'), findsOneWidget);
        expect(find.text('Quick Actions'), findsOneWidget);

        // Verify they appear in order (Quick Stats, Recent Activity, Quick Actions)
        final quickStats = tester.getTopLeft(find.text('Quick Stats'));
        final recentActivity = tester.getTopLeft(find.text('Recent Activity'));
        final quickActions = tester.getTopLeft(find.text('Quick Actions'));

        expect(quickStats.dy < recentActivity.dy, true);
        expect(recentActivity.dy < quickActions.dy, true);
      });

      testWidgets('screen is scrollable', (tester) async {
        when(mockAuthBloc.state).thenReturn(const AuthInitial());

        await tester.pumpWidget(buildTestWidget());

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });
  });
}
