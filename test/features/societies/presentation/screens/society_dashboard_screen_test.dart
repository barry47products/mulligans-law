import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/domain/entities/society_stats.dart';
import 'package:mulligans_law/features/societies/domain/usecases/get_society_stats.dart';
import 'package:mulligans_law/features/societies/presentation/screens/society_dashboard_screen.dart';

class MockGetSocietyStats extends Mock implements GetSocietyStats {}

void main() {
  late MockGetSocietyStats mockGetSocietyStats;

  setUp(() {
    mockGetSocietyStats = MockGetSocietyStats();
    // Default stub - returns empty stats
    when(() => mockGetSocietyStats(any())).thenAnswer(
      (_) async => const SocietyStats(
        memberCount: 0,
        ownerNames: [],
        captainNames: [],
        averageHandicap: 0.0,
      ),
    );
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

  const testStats = SocietyStats(
    memberCount: 24,
    ownerNames: ['John Doe', 'Jane Smith'],
    captainNames: ['Bob Johnson'],
    averageHandicap: 18.5,
  );

  Widget createWidgetUnderTest({Society? society}) {
    return MaterialApp(
      home: SocietyDashboardScreen(
        society: society ?? testSociety,
        getSocietyStats: mockGetSocietyStats,
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
        when(
          () => mockGetSocietyStats(any()),
        ).thenAnswer((_) async => testStats);

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
      testWidgets('displays all stats cards', (tester) async {
        // Arrange
        when(
          () => mockGetSocietyStats('society-1'),
        ).thenAnswer((_) async => testStats);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Members'), findsWidgets);
        expect(find.text('24'), findsOneWidget);
        expect(find.text('Avg Handicap'), findsOneWidget);
        expect(find.text('18.5'), findsOneWidget);
        expect(find.text('Owners'), findsOneWidget);
        expect(find.text('John Doe, Jane Smith'), findsOneWidget);
        expect(find.text('Captains'), findsOneWidget);
        expect(find.text('Bob Johnson'), findsOneWidget);
        verify(() => mockGetSocietyStats('society-1')).called(1);
      });

      testWidgets('displays activity feed scaffolding', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Recent Activity'), findsOneWidget);
        expect(
          find.text('Activity feed will show recent events when implemented'),
          findsOneWidget,
        );
      });

      testWidgets('stats load asynchronously with loading indicator', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockGetSocietyStats('society-1'),
        ).thenAnswer((_) async => testStats);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - initially shows loading
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for async load
        await tester.pumpAndSettle();

        // Assert - now shows real stats
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('24'), findsOneWidget);
      });

      testWidgets('handles stats error gracefully', (tester) async {
        // Arrange
        when(
          () => mockGetSocietyStats(any()),
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
        await tester.pumpAndSettle();

        // Scroll to make settings button visible
        await tester.ensureVisible(find.text('Settings'));

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
              getSocietyStats: mockGetSocietyStats,
            ),
            routes: {
              '/society-1/members': (context) =>
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
              getSocietyStats: mockGetSocietyStats,
            ),
            routes: {
              '/edit': (context) => const Scaffold(body: Text('Edit Screen')),
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

    group('Soft Delete Banner', () {
      testWidgets('displays banner when society is deleted', (tester) async {
        // Arrange
        final deletedSociety = Society(
          id: 'society-1',
          name: 'Deleted Society',
          description: 'This was deleted',
          logoUrl: null,
          deletedAt: DateTime.now(),
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: SocietyDashboardScreen(
              society: deletedSociety,
              getSocietyStats: mockGetSocietyStats,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('This society has been deleted and is read-only'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
      });

      testWidgets('does not display banner when society is active', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('This society has been deleted and is read-only'),
          findsNothing,
        );
      });

      testWidgets('disables action buttons when society is deleted', (
        tester,
      ) async {
        // Arrange
        final deletedSociety = Society(
          id: 'society-1',
          name: 'Deleted Society',
          description: 'This was deleted',
          logoUrl: null,
          deletedAt: DateTime.now(),
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: SocietyDashboardScreen(
              society: deletedSociety,
              getSocietyStats: mockGetSocietyStats,
            ),
            routes: {
              '/society-1/members': (context) =>
                  const Scaffold(body: Text('Members Screen')),
              '/edit': (context) => const Scaffold(body: Text('Edit Screen')),
            },
          ),
        );
        await tester.pumpAndSettle();

        // Try to tap buttons - they should be disabled so taps won't work
        await tester.ensureVisible(find.text('View Members'));
        await tester.tap(find.text('View Members'));
        await tester.pumpAndSettle();

        // Assert - should NOT navigate (still on dashboard)
        expect(find.text('Members Screen'), findsNothing);
        expect(find.text('Deleted Society'), findsWidgets);

        await tester.ensureVisible(find.text('Settings'));
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        // Assert - should NOT navigate (still on dashboard)
        expect(find.text('Edit Screen'), findsNothing);
        expect(find.text('Deleted Society'), findsWidgets);
      });
    });
  });
}
