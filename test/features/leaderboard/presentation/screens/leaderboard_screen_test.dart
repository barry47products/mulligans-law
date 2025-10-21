import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/features/leaderboard/presentation/screens/leaderboard_screen.dart';

void main() {
  group('LeaderboardScreen', () {
    testWidgets('displays app bar with correct title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LeaderboardScreen()));

      expect(find.widgetWithText(AppBar, 'Leaderboard'), findsOneWidget);
    });

    testWidgets('displays leaderboard icon', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LeaderboardScreen()));

      expect(find.byIcon(Icons.leaderboard), findsOneWidget);
    });

    testWidgets('displays coming soon title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LeaderboardScreen()));

      expect(find.text('Leaderboards coming soon'), findsOneWidget);
    });

    testWidgets('displays descriptive text', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LeaderboardScreen()));

      expect(
        find.text(
          'View rankings, statistics, and compete with society members',
        ),
        findsOneWidget,
      );
    });

    testWidgets('content is centered', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LeaderboardScreen()));

      // Verify Column with center alignment exists
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('displays all elements in correct order', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LeaderboardScreen()));

      // Find positions of elements
      final iconPosition = tester.getTopLeft(find.byIcon(Icons.leaderboard));
      final titlePosition = tester.getTopLeft(
        find.text('Leaderboards coming soon'),
      );
      final descPosition = tester.getTopLeft(
        find.text(
          'View rankings, statistics, and compete with society members',
        ),
      );

      // Verify order from top to bottom
      expect(iconPosition.dy < titlePosition.dy, true);
      expect(titlePosition.dy < descPosition.dy, true);
    });
  });
}
