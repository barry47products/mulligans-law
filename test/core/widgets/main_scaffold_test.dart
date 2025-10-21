import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/core/widgets/main_scaffold.dart';

void main() {
  group('MainScaffold', () {
    testWidgets('renders with bottom navigation bar', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

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
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

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
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

      // Home tab should be displayed
      expect(find.text('Home Tab'), findsOneWidget);
      expect(find.text('Coming soon'), findsOneWidget);

      // Other tabs should not be visible
      expect(find.text('Societies Tab'), findsNothing);
      expect(find.text('Events Tab'), findsNothing);
      expect(find.text('Leaderboard Tab'), findsNothing);
      expect(find.text('Profile Tab'), findsNothing);
    });

    testWidgets('switches to Societies tab when tapped', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

      // Tap Societies tab
      await tester.tap(find.text('Societies'));
      await tester.pumpAndSettle();

      // Societies tab should be displayed
      expect(find.text('Societies Tab'), findsOneWidget);

      // Home tab should not be visible
      expect(find.text('Home Tab'), findsNothing);
    });

    testWidgets('switches to Events tab when tapped', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

      // Tap Events tab
      await tester.tap(find.text('Events'));
      await tester.pumpAndSettle();

      // Events tab should be displayed
      expect(find.text('Events Tab'), findsOneWidget);
    });

    testWidgets('switches to Leaderboard tab when tapped', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

      // Tap Leaderboard tab
      await tester.tap(find.text('Leaderboard'));
      await tester.pumpAndSettle();

      // Leaderboard tab should be displayed
      expect(find.text('Leaderboard Tab'), findsOneWidget);
    });

    testWidgets('switches to Profile tab when tapped', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

      // Tap Profile tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Profile tab should be displayed
      expect(find.text('Profile Tab'), findsOneWidget);
    });

    testWidgets('preserves state when switching tabs', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

      // Start on Home tab
      expect(find.text('Home Tab'), findsOneWidget);

      // Switch to Societies
      await tester.tap(find.text('Societies'));
      await tester.pumpAndSettle();
      expect(find.text('Societies Tab'), findsOneWidget);

      // Switch to Events
      await tester.tap(find.text('Events'));
      await tester.pumpAndSettle();
      expect(find.text('Events Tab'), findsOneWidget);

      // Switch back to Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      // Home tab should still be there (state preserved)
      expect(find.text('Home Tab'), findsOneWidget);

      // Switch back to Societies
      await tester.tap(find.text('Societies'));
      await tester.pumpAndSettle();

      // Societies tab should still be there (state preserved)
      expect(find.text('Societies Tab'), findsOneWidget);
    });

    testWidgets('each tab has its own scaffold and app bar', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

      // Home tab has its own app bar
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

      // Switch to Societies
      await tester.tap(find.text('Societies'));
      await tester.pumpAndSettle();

      // Societies tab has its own app bar
      expect(find.widgetWithText(AppBar, 'Societies'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Home'), findsNothing);
    });

    testWidgets('IndexedStack is used to preserve all tabs in memory', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

      // Verify IndexedStack is present
      expect(find.byType(IndexedStack), findsOneWidget);

      // IndexedStack should have 5 children (one for each tab)
      final indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.children.length, 5);
    });

    testWidgets('bottom navigation highlights correct tab', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScaffold()));

      // Get BottomNavigationBar
      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Initially, Home (index 0) should be selected
      expect(bottomNav.currentIndex, 0);

      // Tap Societies
      await tester.tap(find.text('Societies'));
      await tester.pumpAndSettle();

      // Now Societies (index 1) should be selected
      final updatedBottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(updatedBottomNav.currentIndex, 1);

      // Tap Profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Now Profile (index 4) should be selected
      final profileBottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(profileBottomNav.currentIndex, 4);
    });
  });
}
