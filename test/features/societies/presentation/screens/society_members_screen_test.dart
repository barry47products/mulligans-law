import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/presentation/bloc/member_bloc.dart';
import 'package:mulligans_law/features/members/presentation/bloc/member_event.dart';
import 'package:mulligans_law/features/members/presentation/bloc/member_state.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/presentation/screens/society_members_screen.dart';

class MockMemberBloc extends Mock implements MemberBloc {}

void main() {
  late MockMemberBloc mockBloc;

  setUp(() {
    mockBloc = MockMemberBloc();
    when(() => mockBloc.state).thenReturn(const MemberInitial());
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
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

  final testMembers = [
    Member(
      id: 'member-1',
      societyId: 'society-1',
      userId: 'user-1',
      name: 'John Doe',
      email: 'john@example.com',
      handicap: 12.5,
      role: 'CAPTAIN',
      joinedAt: testDateTime,
    ),
    Member(
      id: 'member-2',
      societyId: 'society-1',
      userId: 'user-2',
      name: 'Jane Smith',
      email: 'jane@example.com',
      handicap: 18.0,
      role: 'MEMBER',
      joinedAt: testDateTime,
    ),
    Member(
      id: 'member-3',
      societyId: 'society-1',
      userId: 'user-3',
      name: 'Alice Johnson',
      email: 'alice@example.com',
      handicap: 5.2,
      role: 'MEMBER',
      joinedAt: testDateTime,
    ),
  ];

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<MemberBloc>.value(
        value: mockBloc,
        child: SocietyMembersScreen(society: testSociety),
      ),
    );
  }

  group('SocietyMembersScreen', () {
    group('AppBar', () {
      testWidgets('displays society name with member count in title', (
        tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          MemberLoaded(members: testMembers, societyId: 'society-1'),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Members (3)'), findsOneWidget);
      });

      testWidgets('displays "Members (0)" when no members', (tester) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(const MemberLoaded(members: [], societyId: 'society-1'));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Members (0)'), findsOneWidget);
      });

      testWidgets('displays Add Member button in app bar', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byIcon(Icons.person_add), findsOneWidget);
      });
    });

    group('Loading and Error States', () {
      testWidgets('triggers MemberLoadRequested on init', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        verify(
          () => mockBloc.add(const MemberLoadRequested('society-1')),
        ).called(1);
      });

      testWidgets('displays loading indicator when state is MemberLoading', (
        tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(const MemberLoading());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('displays error message when state is MemberError', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(const MemberError(message: 'Failed to load members'));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Failed to load members'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('triggers reload when retry button is tapped', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(const MemberError(message: 'Failed to load members'));

        await tester.pumpWidget(createWidgetUnderTest());

        // Act
        await tester.tap(find.text('Retry'));
        await tester.pump();

        // Assert - should have called add twice (once on init, once on retry)
        verify(
          () => mockBloc.add(const MemberLoadRequested('society-1')),
        ).called(2);
      });
    });

    group('Empty State', () {
      testWidgets('displays empty state when no members', (tester) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(const MemberLoaded(members: [], societyId: 'society-1'));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('No members yet'), findsOneWidget);
        expect(
          find.text('Add your first member to get started!'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.people_outline), findsOneWidget);
      });
    });

    group('Member List Display', () {
      testWidgets('displays list of members when loaded', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          MemberLoaded(members: testMembers, societyId: 'society-1'),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Jane Smith'), findsOneWidget);
        expect(find.text('Alice Johnson'), findsOneWidget);
      });

      testWidgets('displays member cards for each member', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          MemberLoaded(members: testMembers, societyId: 'society-1'),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(Card), findsNWidgets(3));
      });
    });

    group('Sorting', () {
      testWidgets('displays sort dropdown', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          MemberLoaded(members: testMembers, societyId: 'society-1'),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(DropdownButton<String>), findsOneWidget);
        expect(find.text('Sort by'), findsOneWidget);
      });

      testWidgets('sorts by name ascending', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          MemberLoaded(members: testMembers, societyId: 'society-1'),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        // Act
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Name (A-Z)').last);
        await tester.pumpAndSettle();

        // Assert - Alice should be first
        final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
        final firstTile = listTiles.first;
        final titleWidget = firstTile.title as Row;
        final textWidget =
            (titleWidget.children.first as Expanded).child as Text;
        expect(textWidget.data, 'Alice Johnson');
      });

      testWidgets('sorts by name descending', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          MemberLoaded(members: testMembers, societyId: 'society-1'),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        // Act
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Name (Z-A)').last);
        await tester.pumpAndSettle();

        // Assert - John should be first
        final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
        final firstTile = listTiles.first;
        final titleWidget = firstTile.title as Row;
        final textWidget =
            (titleWidget.children.first as Expanded).child as Text;
        expect(textWidget.data, 'John Doe');
      });

      testWidgets('sorts by handicap low to high', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          MemberLoaded(members: testMembers, societyId: 'society-1'),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        // Act
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Handicap (Low-High)').last);
        await tester.pumpAndSettle();

        // Assert - Alice (5.2) should be first
        final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
        final firstTile = listTiles.first;
        final titleWidget = firstTile.title as Row;
        final textWidget =
            (titleWidget.children.first as Expanded).child as Text;
        expect(textWidget.data, 'Alice Johnson');
      });

      testWidgets('sorts by handicap high to low', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          MemberLoaded(members: testMembers, societyId: 'society-1'),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        // Act
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Handicap (High-Low)').last);
        await tester.pumpAndSettle();

        // Assert - Jane (18.0) should be first
        final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
        final firstTile = listTiles.first;
        final titleWidget = firstTile.title as Row;
        final textWidget =
            (titleWidget.children.first as Expanded).child as Text;
        expect(textWidget.data, 'Jane Smith');
      });
    });
  });
}
