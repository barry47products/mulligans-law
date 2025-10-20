import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/features/members/domain/usecases/get_member_count.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/presentation/screens/society_dashboard_screen.dart';

class MockGetMemberCount extends Mock implements GetMemberCount {}

void main() {
  late MockGetMemberCount mockGetMemberCount;

  setUp(() {
    mockGetMemberCount = MockGetMemberCount();
    // Default stub - returns 0 members
    when(() => mockGetMemberCount(any())).thenAnswer((_) async => 0);
  });

  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testSociety = Society(
    id: 'society-1',
    name: 'Mulligans Golf Society',
    description: 'A friendly golf society',
    logoUrl: null,
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  Widget createWidgetUnderTest({Society? society}) {
    return MaterialApp(
      home: SocietyDashboardScreen(
        society: society ?? testSociety,
        getMemberCount: mockGetMemberCount,
      ),
    );
  }

  group('SocietyDashboardScreen', () {
    group('Header', () {
      testWidgets('displays society name in app bar and header', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - name appears in both AppBar and header
        expect(find.text('Mulligans Golf Society'), findsNWidgets(2));
        expect(find.byType(AppBar), findsOneWidget);
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
          id: 'society-1',
          name: 'Test Society',
          description: null,
          logoUrl: null,
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(society: societyWithoutDescription),
        );

        // Assert - name appears in AppBar and header
        expect(find.text('Test Society'), findsNWidgets(2));
        // Description should not exist
        final descriptionFinder = find.text('A friendly golf society');
        expect(descriptionFinder, findsNothing);
      });

      testWidgets('displays logo placeholder when logoUrl is null', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byIcon(Icons.golf_course), findsOneWidget);
      });
    });

    group('Tab Navigation', () {
      testWidgets('displays tab bar with Overview and Members tabs', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.widgetWithText(Tab, 'Overview'), findsOneWidget);
        expect(find.widgetWithText(Tab, 'Members'), findsOneWidget);
        expect(find.byType(TabBar), findsOneWidget);
      });

      testWidgets('Overview tab is selected by default', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        final TabBar tabBar = tester.widget(find.byType(TabBar));
        expect(tabBar.controller?.index, 0);
      });

      testWidgets('can switch to Members tab', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest());

        // Act - tap on the Members tab (not the Members label in statistics)
        await tester.tap(find.widgetWithText(Tab, 'Members'));
        await tester.pumpAndSettle();

        // Assert
        final TabBar tabBar = tester.widget(find.byType(TabBar));
        expect(tabBar.controller?.index, 1);
      });

      testWidgets('displays Overview tab content', (tester) async {
        // Arrange
        when(() => mockGetMemberCount(any())).thenAnswer((_) async => 24);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert - should show statistics cards
        expect(find.text('Members'), findsWidgets);
        expect(find.text('24'), findsOneWidget);
      });

      testWidgets('displays Members tab content', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest());

        // Act - tap on the Members tab
        await tester.tap(find.widgetWithText(Tab, 'Members'));
        await tester.pumpAndSettle();

        // Assert - should show coming soon message
        expect(find.text('Coming soon'), findsOneWidget);
      });
    });

    group('Overview Tab - Statistics Cards', () {
      testWidgets('displays member count card', (tester) async {
        // Arrange
        when(() => mockGetMemberCount('society-1')).thenAnswer((_) async => 24);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Members'), findsWidgets);
        expect(find.text('24'), findsOneWidget);
        verify(() => mockGetMemberCount('society-1')).called(1);
      });

      testWidgets('displays events card with coming soon', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Events'), findsOneWidget);
        expect(find.text('0'), findsWidgets);
        expect(find.text('Coming soon'), findsWidgets);
      });

      testWidgets('member count loads asynchronously', (tester) async {
        // Arrange
        when(() => mockGetMemberCount('society-1')).thenAnswer((_) async => 24);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - initially shows 0
        expect(find.text('0'), findsWidgets);

        // Wait for async load
        await tester.pumpAndSettle();

        // Assert - now shows real count
        expect(find.text('24'), findsOneWidget);
      });

      testWidgets('handles member count error gracefully', (tester) async {
        // Arrange
        when(
          () => mockGetMemberCount(any()),
        ).thenThrow(Exception('Failed to load'));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert - should default to 0
        expect(find.text('0'), findsWidgets);
      });
    });

    group('Overview Tab - Quick Actions', () {
      testWidgets('displays View Members button', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Scroll to make buttons visible
        await tester.ensureVisible(find.text('View Members'));

        // Assert
        expect(find.text('View Members'), findsOneWidget);
      });

      testWidgets('displays Settings button', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Settings'), findsOneWidget);
      });

      testWidgets('View Members button navigates to members screen', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: SocietyDashboardScreen(
              society: testSociety,
              getMemberCount: mockGetMemberCount,
            ),
            routes: {
              '/societies/society-1/members': (context) =>
                  const Scaffold(body: Text('Members Screen')),
            },
          ),
        );
        await tester.pumpAndSettle();

        // Act - scroll to button and tap it
        await tester.ensureVisible(find.text('View Members'));
        await tester.tap(find.text('View Members'));
        await tester.pumpAndSettle();

        // Assert - should navigate to members screen
        expect(find.text('Members Screen'), findsOneWidget);
      });

      testWidgets('Settings button navigates to edit screen', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: SocietyDashboardScreen(
              society: testSociety,
              getMemberCount: mockGetMemberCount,
            ),
            routes: {
              '/societies/edit': (context) =>
                  const Scaffold(body: Text('Edit Screen')),
            },
          ),
        );
        await tester.pumpAndSettle();

        // Act - scroll to button and tap it
        await tester.ensureVisible(find.text('Settings'));
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Edit Screen'), findsOneWidget);
      });
    });
  });
}
