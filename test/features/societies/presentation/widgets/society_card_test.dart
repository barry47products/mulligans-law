import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/presentation/widgets/society_card.dart';

void main() {
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testSociety = Society(
    id: 'society-1',
    name: 'Mulligans Golf Society',
    description: 'A friendly golf society',
    logoUrl: null,
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  Widget createWidgetUnderTest({
    Society? society,
    int memberCount = 0,
    VoidCallback? onViewPressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SocietyCard(
          society: society ?? testSociety,
          memberCount: memberCount,
          onViewPressed: onViewPressed ?? () {},
        ),
      ),
    );
  }

  group('SocietyCard', () {
    testWidgets('displays society name', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Mulligans Golf Society'), findsOneWidget);
    });

    testWidgets('displays society description when provided', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('A friendly golf society'), findsOneWidget);
    });

    testWidgets('does not display description when null', (tester) async {
      // Arrange
      final societyWithoutDescription = Society(
        id: 'society-2',
        name: 'Test Society',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(society: societyWithoutDescription),
      );

      // Assert
      expect(find.text('Test Society'), findsOneWidget);
      // Description should not be present
      expect(
        find.byType(Text),
        findsNWidgets(3),
      ); // name + member count + button
    });

    testWidgets('displays member count badge with 0 members', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(memberCount: 0));

      // Assert
      expect(find.text('0 members'), findsOneWidget);
    });

    testWidgets('displays member count badge with 1 member (singular)', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(memberCount: 1));

      // Assert
      expect(find.text('1 member'), findsOneWidget);
    });

    testWidgets('displays member count badge with multiple members (plural)', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(memberCount: 20));

      // Assert
      expect(find.text('20 members'), findsOneWidget);
    });

    testWidgets('displays View button', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.widgetWithText(ElevatedButton, 'View'), findsOneWidget);
    });

    testWidgets('calls onViewPressed when View button is tapped', (
      tester,
    ) async {
      // Arrange
      var wasPressed = false;
      await tester.pumpWidget(
        createWidgetUnderTest(onViewPressed: () => wasPressed = true),
      );

      // Act
      await tester.tap(find.widgetWithText(ElevatedButton, 'View'));
      await tester.pump();

      // Assert
      expect(wasPressed, isTrue);
    });

    testWidgets('displays logo placeholder when logoUrl is null', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byIcon(Icons.golf_course), findsOneWidget);
    });

    testWidgets('displays logo image when logoUrl is provided', (tester) async {
      // Arrange
      final societyWithLogo = Society(
        id: 'society-3',
        name: 'Logo Society',
        logoUrl: 'https://example.com/logo.png',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(society: societyWithLogo));

      // Assert
      // NetworkImage widget should be present (even if it fails to load in test)
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('card has proper Material styling', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(Card), findsOneWidget);
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
    });

    testWidgets('displays all elements in correct layout order', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(memberCount: 15));

      // Assert
      expect(find.text('Mulligans Golf Society'), findsOneWidget);
      expect(find.text('A friendly golf society'), findsOneWidget);
      expect(find.text('15 members'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'View'), findsOneWidget);
    });
  });
}
