import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_user.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_state.dart'
    as auth;
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_bloc.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_event.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_state.dart';
import 'package:mulligans_law/features/societies/presentation/screens/society_form_screen.dart';

class MockSocietyBloc extends Mock implements SocietyBloc {}

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockSocietyBloc mockBloc;
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(
      const SocietyCreateRequested(userId: 'test-user', name: ''),
    );
    registerFallbackValue(const SocietyUpdateRequested(id: '', name: ''));
  });

  setUp(() {
    mockBloc = MockSocietyBloc();
    mockAuthBloc = MockAuthBloc();
    when(() => mockBloc.close()).thenAnswer((_) async {});
    when(() => mockAuthBloc.close()).thenAnswer((_) async {});
  });

  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testSociety = Society(
    id: 'society-1',
    name: 'Mulligans Golf Society',
    description: 'A friendly golf society',
    logoUrl: 'https://example.com/logo.png',
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  const testUserId = 'test-user-id';
  final testAuthUser = AuthUser(
    id: testUserId,
    email: 'test@example.com',
    createdAt: testDateTime,
  );

  Widget createWidgetUnderTest({Society? society}) {
    // Setup auth state with authenticated user
    when(
      () => mockAuthBloc.state,
    ).thenReturn(auth.AuthAuthenticated(testAuthUser));
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SocietyBloc>(create: (_) => mockBloc),
          BlocProvider<AuthBloc>(create: (_) => mockAuthBloc),
        ],
        child: SocietyFormScreen(society: society),
      ),
    );
  }

  group('SocietyFormScreen - Create Mode', () {
    testWidgets('displays app bar with "Create Society" title', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.widgetWithText(AppBar, 'Create Society'), findsOneWidget);
    });

    testWidgets('displays name and description input fields', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      // Now has 4 TextFormFields: name, description, location (disabled), rules
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.text('Society Name *'), findsOneWidget);
      expect(find.text('Description (Optional)'), findsOneWidget);
    });

    testWidgets('displays save button', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(
        find.widgetWithText(ElevatedButton, 'Save Society'),
        findsOneWidget,
      );
    });

    testWidgets('shows validation error when name is empty', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Society'));
      await tester.pump();

      // Assert
      expect(find.text('Society name is required'), findsOneWidget);
    });

    testWidgets('shows validation error when name exceeds max length', (
      tester,
    ) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(
        find.byType(TextFormField).first,
        'A' * 101, // Exceeds 100 character limit
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Society'));
      await tester.pump();

      // Assert
      expect(
        find.text('Society name must be 100 characters or less'),
        findsOneWidget,
      );
    });

    testWidgets('shows validation error when description exceeds max length', (
      tester,
    ) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextFormField).first, 'Valid Name');
      await tester.enterText(
        find.byType(TextFormField).at(1), // Description field (second field)
        'A' * 501, // Exceeds 500 character limit
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Society'));
      await tester.pump();

      // Assert
      expect(
        find.text('Description must be 500 characters or less'),
        findsOneWidget,
      );
    });

    testWidgets('triggers create event when form is valid', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockBloc.add(any())).thenReturn(null);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextFormField).first, 'Test Society');
      await tester.enterText(
        find.byType(TextFormField).at(1), // Description field
        'Test Description',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Society'));
      await tester.pump();

      // Assert
      verify(
        () => mockBloc.add(
          const SocietyCreateRequested(
            userId: testUserId,
            name: 'Test Society',
            description: 'Test Description',
          ),
        ),
      ).called(1);
    });

    testWidgets('triggers create event without description when not provided', (
      tester,
    ) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockBloc.add(any())).thenReturn(null);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextFormField).first, 'Test Society');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Society'));
      await tester.pump();

      // Assert
      verify(
        () => mockBloc.add(
          const SocietyCreateRequested(
            userId: testUserId,
            name: 'Test Society',
            description: null,
          ),
        ),
      ).called(1);
    });

    testWidgets('disables save button when operation in progress', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockBloc.state,
      ).thenReturn(const SocietyOperationInProgress('Creating society...'));
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows progress indicator when operation in progress', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockBloc.state,
      ).thenReturn(const SocietyOperationInProgress('Creating society...'));
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('pops navigation on success', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const SocietyOperationSuccess(
            message: 'Society created successfully',
            societies: [],
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert - screen should have popped
      expect(find.byType(SocietyFormScreen), findsNothing);
    });
  });

  group('SocietyFormScreen - Edit Mode', () {
    testWidgets('displays app bar with "Edit Society" title', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest(society: testSociety));

      // Assert
      expect(find.text('Edit Society'), findsOneWidget);
    });

    testWidgets('pre-fills form with existing society data', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest(society: testSociety));

      // Assert
      expect(find.text('Mulligans Golf Society'), findsOneWidget);
      expect(find.text('A friendly golf society'), findsOneWidget);
    });

    testWidgets('displays "Save Changes" button in edit mode', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest(society: testSociety));

      // Assert
      expect(
        find.widgetWithText(ElevatedButton, 'Save Changes'),
        findsOneWidget,
      );
    });

    testWidgets('triggers update event when form is valid', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockBloc.add(any())).thenReturn(null);

      // Act
      await tester.pumpWidget(createWidgetUnderTest(society: testSociety));
      await tester.enterText(find.byType(TextFormField).first, 'Updated Name');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Changes'));
      await tester.pump();

      // Assert
      verify(
        () => mockBloc.add(
          const SocietyUpdateRequested(
            id: 'society-1',
            name: 'Updated Name',
            description: 'A friendly golf society',
            isPublic: false,
            handicapLimitEnabled: false,
            handicapMin: null,
            handicapMax: null,
            location: null,
            rules: null,
          ),
        ),
      ).called(1);
    });

    testWidgets('validates name in edit mode', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const SocietyInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest(society: testSociety));
      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Changes'));
      await tester.pump();

      // Assert
      expect(find.text('Society name is required'), findsOneWidget);
    });
  });
}
