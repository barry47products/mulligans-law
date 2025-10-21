import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/features/events/presentation/screens/events_screen.dart';

void main() {
  group('EventsScreen', () {
    testWidgets('displays app bar with correct title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EventsScreen()));

      expect(find.widgetWithText(AppBar, 'Events'), findsOneWidget);
    });

    testWidgets('displays event icon', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EventsScreen()));

      expect(find.byIcon(Icons.event), findsOneWidget);
    });

    testWidgets('displays coming soon title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EventsScreen()));

      expect(find.text('Events coming soon'), findsOneWidget);
    });

    testWidgets('displays descriptive text', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EventsScreen()));

      expect(
        find.text(
          'Track society events, book tee times, and manage tournaments',
        ),
        findsOneWidget,
      );
    });

    testWidgets('content is centered', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EventsScreen()));

      // Verify Column with center alignment exists
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('displays all elements in correct order', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EventsScreen()));

      // Find positions of elements
      final iconPosition = tester.getTopLeft(find.byIcon(Icons.event));
      final titlePosition = tester.getTopLeft(find.text('Events coming soon'));
      final descPosition = tester.getTopLeft(
        find.text(
          'Track society events, book tee times, and manage tournaments',
        ),
      );

      // Verify order from top to bottom
      expect(iconPosition.dy < titlePosition.dy, true);
      expect(titlePosition.dy < descPosition.dy, true);
    });
  });
}
