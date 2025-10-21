import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/features/members/domain/usecases/get_member_count.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_bloc.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_event.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_state.dart';
import 'package:mulligans_law/features/societies/presentation/screens/society_list_screen.dart';

class MockSocietyBloc extends Mock implements SocietyBloc {}

class MockGetMemberCount extends Mock implements GetMemberCount {}

void main() {
  late MockSocietyBloc mockBloc;
  late MockGetMemberCount mockGetMemberCount;

  setUpAll(() {
    registerFallbackValue(const SocietyLoadRequested());
    registerFallbackValue(const SocietySelected(''));
  });

  setUp(() {
    mockBloc = MockSocietyBloc();
    mockGetMemberCount = MockGetMemberCount();
    when(() => mockBloc.close()).thenAnswer((_) async {});
    // Default stub for member count - returns 0 for any society
    when(() => mockGetMemberCount(any())).thenAnswer((_) async => 0);
  });

  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testSocieties = [
    Society(
      id: 'society-1',
      name: 'Mulligans Golf Society',
      description: 'A friendly golf society',
      logoUrl: 'https://example.com/logo1.png',
      createdAt: testDateTime,
      updatedAt: testDateTime,
    ),
    Society(
      id: 'society-2',
      name: 'Another Golf Club',
      createdAt: testDateTime,
      updatedAt: testDateTime,
    ),
  ];

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<GetMemberCount>.value(value: mockGetMemberCount),
        ],
        child: BlocProvider<SocietyBloc>(
          create: (_) => mockBloc,
          child: const SocietyListScreen(),
        ),
      ),
    );
  }

  group('SocietyListScreen', () {
    testWidgets('displays app bar with title', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('My Societies'), findsOneWidget);
    });

    testWidgets('displays loading indicator when state is SocietyLoading', (
      tester,
    ) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyLoading());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays list of societies when state is SocietyLoaded', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockBloc.state,
      ).thenReturn(SocietyLoaded(societies: testSocieties));
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Mulligans Golf Society'), findsOneWidget);
      expect(find.text('Another Golf Club'), findsOneWidget);
      expect(find.text('A friendly golf society'), findsOneWidget);
    });

    testWidgets('displays empty state message when no societies', (
      tester,
    ) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyLoaded(societies: []));
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(
        find.text("You're not a member of any societies yet"),
        findsOneWidget,
      );
      expect(
        find.text('Create your first society to get started'),
        findsOneWidget,
      );
    });

    testWidgets('displays error message when state is SocietyError', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockBloc.state,
      ).thenReturn(const SocietyError(message: 'Failed to load societies'));
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Failed to load societies'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('displays floating action button to create society', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockBloc.state,
      ).thenReturn(SocietyLoaded(societies: testSocieties));
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('triggers load event on init', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockBloc.add(any())).thenReturn(null);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      verify(() => mockBloc.add(const SocietyLoadRequested())).called(1);
    });

    // Navigation test skipped - requires form screen to be implemented first

    testWidgets('tapping society card selects that society and navigates', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockBloc.state,
      ).thenReturn(SocietyLoaded(societies: testSocieties));
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockBloc.add(any())).thenReturn(null);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<GetMemberCount>.value(
                value: mockGetMemberCount,
              ),
            ],
            child: BlocProvider<SocietyBloc>(
              create: (_) => mockBloc,
              child: const SocietyListScreen(),
            ),
          ),
          routes: {
            '/society-1/dashboard': (context) =>
                const Scaffold(body: Text('Dashboard Screen')),
          },
        ),
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'View').first);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockBloc.add(const SocietySelected('society-1'))).called(1);
    });

    testWidgets('retry button triggers load event', (tester) async {
      // Arrange
      when(
        () => mockBloc.state,
      ).thenReturn(const SocietyError(message: 'Error'));
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockBloc.add(any())).thenReturn(null);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Try Again'));

      // Assert
      verify(
        () => mockBloc.add(const SocietyLoadRequested()),
      ).called(greaterThan(1));
    });

    group('Search functionality', () {
      testWidgets('displays search bar at top of society list', (tester) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('search bar has proper hint text', (tester) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Search societies...'), findsOneWidget);
      });

      testWidgets('filters societies by name (case-insensitive)', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(find.byType(TextField), 'mulligans');
        await tester.pump();

        // Assert
        expect(find.text('Mulligans Golf Society'), findsOneWidget);
        expect(find.text('Another Golf Club'), findsNothing);
      });

      testWidgets('search is case-insensitive', (tester) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(find.byType(TextField), 'GOLF');
        await tester.pump();

        // Assert
        expect(find.text('Mulligans Golf Society'), findsOneWidget);
        expect(find.text('Another Golf Club'), findsOneWidget);
      });

      testWidgets('empty search shows all societies', (tester) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(find.byType(TextField), '');
        await tester.pump();

        // Assert
        expect(find.text('Mulligans Golf Society'), findsOneWidget);
        expect(find.text('Another Golf Club'), findsOneWidget);
      });

      testWidgets('search with no results shows "No societies found" message', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(find.byType(TextField), 'NonExistentSociety');
        await tester.pump();

        // Assert
        expect(find.text('No societies found'), findsOneWidget);
        expect(find.text('Mulligans Golf Society'), findsNothing);
        expect(find.text('Another Golf Club'), findsNothing);
      });

      testWidgets('clearing search restores full list', (tester) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        // First filter
        await tester.enterText(find.byType(TextField), 'Mulligans');
        await tester.pump();
        expect(find.text('Another Golf Club'), findsNothing);

        // Then clear
        await tester.enterText(find.byType(TextField), '');
        await tester.pump();

        // Assert - both should be visible again
        expect(find.text('Mulligans Golf Society'), findsOneWidget);
        expect(find.text('Another Golf Club'), findsOneWidget);
      });

      testWidgets('search bar has clear button when text is entered', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        // Assert
        expect(find.byIcon(Icons.clear), findsOneWidget);
      });
    });

    group('Member count integration', () {
      testWidgets('displays member count from GetMemberCount use case', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockGetMemberCount('society-1')).thenAnswer((_) async => 24);
        when(() => mockGetMemberCount('society-2')).thenAnswer((_) async => 15);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        // Wait for async member count loading
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('24 members'), findsOneWidget);
        expect(find.text('15 members'), findsOneWidget);
        verify(() => mockGetMemberCount('society-1')).called(1);
        verify(() => mockGetMemberCount('society-2')).called(1);
      });

      testWidgets('displays 0 members when member count fails to load', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
        when(
          () => mockGetMemberCount(any()),
        ).thenThrow(Exception('Failed to load'));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        // Wait for async member count loading
        await tester.pumpAndSettle();

        // Assert - should default to 0 members
        expect(find.text('0 members'), findsWidgets);
        // Verify it attempted to fetch member counts
        verify(() => mockGetMemberCount(any())).called(greaterThan(0));
      });

      testWidgets('displays singular "member" for count of 1', (tester) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: [testSocieties.first]));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockGetMemberCount('society-1')).thenAnswer((_) async => 1);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        // Wait for async member count loading
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('1 member'), findsOneWidget);
        expect(find.text('1 members'), findsNothing);
      });

      testWidgets('member count loads asynchronously without blocking UI', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockGetMemberCount('society-1')).thenAnswer((_) async => 10);
        when(() => mockGetMemberCount('society-2')).thenAnswer((_) async => 10);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - UI should render immediately with 0 members
        expect(find.text('0 members'), findsWidgets);

        // Pump once to trigger the async load
        await tester.pump();

        // Wait for member counts to load
        await tester.pumpAndSettle();

        // Assert - member counts should update
        expect(find.text('10 members'), findsWidgets);
      });

      testWidgets('member counts persist when filtering with search', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(SocietyLoaded(societies: testSocieties));
        when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockGetMemberCount('society-1')).thenAnswer((_) async => 24);
        when(() => mockGetMemberCount('society-2')).thenAnswer((_) async => 15);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert initial state
        expect(find.text('24 members'), findsOneWidget);
        expect(find.text('15 members'), findsOneWidget);

        // Filter to show only first society
        await tester.enterText(find.byType(TextField), 'Mulligans');
        await tester.pump();

        // Assert - member count should still be visible
        expect(find.text('24 members'), findsOneWidget);
        expect(find.text('15 members'), findsNothing);

        // Clear filter
        await tester.enterText(find.byType(TextField), '');
        await tester.pump();

        // Assert - both member counts should be visible again
        expect(find.text('24 members'), findsOneWidget);
        expect(find.text('15 members'), findsOneWidget);
      });
    });
  });
}
