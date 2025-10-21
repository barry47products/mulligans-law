import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/widgets/main_scaffold.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_state.dart';

import 'main_scaffold_test.mocks.dart';

@GenerateMocks([AuthBloc])
void main() {
  group('MainScaffold', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      when(mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
      when(mockAuthBloc.state).thenReturn(const AuthInitial());
    });

    Widget buildTestWidget() {
      return BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const MaterialApp(home: MainScaffold()),
      );
    }

    testWidgets('renders with bottom navigation bar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify bottom navigation bar exists
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Get the bottom navigation bar
      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Verify all 5 nav items are present
      expect(bottomNav.items.length, 5);
      expect(bottomNav.items[0].label, 'Home');
      expect(bottomNav.items[1].label, 'Societies');
      expect(bottomNav.items[2].label, 'Events');
      expect(bottomNav.items[3].label, 'Leaderboard');
      expect(bottomNav.items[4].label, 'Profile');
    });

    testWidgets('displays correct icons for each tab', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Get the bottom navigation bar
      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Verify icons are correct
      expect((bottomNav.items[0].icon as Icon).icon, Icons.home);
      expect((bottomNav.items[1].icon as Icon).icon, Icons.groups);
      expect((bottomNav.items[2].icon as Icon).icon, Icons.event);
      expect((bottomNav.items[3].icon as Icon).icon, Icons.leaderboard);
      expect((bottomNav.items[4].icon as Icon).icon, Icons.person);
    });

    testWidgets('starts with Home tab selected', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Home tab (DashboardScreen) should be displayed
      expect(find.text('Quick Stats'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);

      // Other tabs should not be visible
      expect(find.text('Societies Tab'), findsNothing);
      expect(find.text('Events coming soon'), findsNothing);
      expect(find.text('Leaderboards coming soon'), findsNothing);
      expect(find.text('Profile Tab'), findsNothing);
    });

    testWidgets('switches to Societies tab when tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap Societies tab in bottom nav
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Societies'),
        ),
      );
      await tester.pumpAndSettle();

      // Societies tab should be displayed
      expect(find.text('Societies Tab'), findsOneWidget);

      // Home tab should not be visible
      expect(find.text('Quick Stats'), findsNothing);
    });

    testWidgets('switches to Events tab when tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap Events tab in bottom nav
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Events'),
        ),
      );
      await tester.pumpAndSettle();

      // Events tab (EventsScreen) should be displayed
      expect(find.text('Events coming soon'), findsOneWidget);
    });

    testWidgets('switches to Leaderboard tab when tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap Leaderboard tab
      await tester.tap(find.text('Leaderboard'));
      await tester.pumpAndSettle();

      // Leaderboard tab (LeaderboardScreen) should be displayed
      expect(find.text('Leaderboards coming soon'), findsOneWidget);
    });

    testWidgets('switches to Profile tab when tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap Profile tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Profile tab (ProfileScreen) should be displayed
      // Since ProfileScreen requires AuthBloc and will show "Not authenticated"
      // when there's no authenticated user in the test
      expect(find.text('Not authenticated'), findsOneWidget);
    });

    testWidgets('preserves state when switching tabs', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Start on Home tab (DashboardScreen)
      expect(find.text('Quick Stats'), findsOneWidget);

      // Switch to Societies
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Societies'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Societies Tab'), findsOneWidget);

      // Switch to Events
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Events'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Events coming soon'), findsOneWidget);

      // Switch back to Home
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Home'),
        ),
      );
      await tester.pumpAndSettle();

      // Home tab (DashboardScreen) should still be there (state preserved)
      expect(find.text('Quick Stats'), findsOneWidget);

      // Switch back to Societies
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Societies'),
        ),
      );
      await tester.pumpAndSettle();

      // Societies tab should still be there (state preserved)
      expect(find.text('Societies Tab'), findsOneWidget);
    });

    testWidgets('each tab has its own scaffold and app bar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Home tab (DashboardScreen) has its own app bar
      expect(find.widgetWithText(AppBar, 'Mulligans Law'), findsOneWidget);

      // Switch to Societies
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Societies'),
        ),
      );
      await tester.pumpAndSettle();

      // Societies tab has its own app bar
      expect(find.widgetWithText(AppBar, 'Societies'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Mulligans Law'), findsNothing);
    });

    testWidgets('IndexedStack is used to preserve all tabs in memory', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify IndexedStack is present
      expect(find.byType(IndexedStack), findsOneWidget);

      // IndexedStack should have 5 children (one for each tab)
      final indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.children.length, 5);
    });

    testWidgets('bottom navigation highlights correct tab', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Get BottomNavigationBar
      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Initially, Home (index 0) should be selected
      expect(bottomNav.currentIndex, 0);

      // Tap Societies in bottom nav
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Societies'),
        ),
      );
      await tester.pumpAndSettle();

      // Now Societies (index 1) should be selected
      final updatedBottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(updatedBottomNav.currentIndex, 1);

      // Tap Profile in bottom nav
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Profile'),
        ),
      );
      await tester.pumpAndSettle();

      // Now Profile (index 4) should be selected
      final profileBottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(profileBottomNav.currentIndex, 4);
    });
  });
}
