import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_bloc.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_event.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_state.dart';
import 'package:mulligans_law/features/societies/presentation/screens/society_list_screen.dart';

class MockSocietyBloc extends Mock implements SocietyBloc {}

void main() {
  late MockSocietyBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(const SocietyLoadRequested());
    registerFallbackValue(const SocietySelected(''));
  });

  setUp(() {
    mockBloc = MockSocietyBloc();
    when(() => mockBloc.close()).thenAnswer((_) async {});
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
      home: BlocProvider<SocietyBloc>(
        create: (_) => mockBloc,
        child: const SocietyListScreen(),
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
          home: BlocProvider<SocietyBloc>(
            create: (_) => mockBloc,
            child: const SocietyListScreen(),
          ),
          routes: {
            '/societies/edit': (context) =>
                const Scaffold(body: Text('Edit Screen')),
          },
        ),
      );
      await tester.tap(find.text('Mulligans Golf Society'));
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
  });
}
