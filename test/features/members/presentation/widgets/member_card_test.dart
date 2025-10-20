import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/presentation/widgets/member_card.dart';

void main() {
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testMemberCaptain = Member(
    id: 'member-1',
    societyId: 'society-1',
    userId: 'user-1',
    name: 'John Doe',
    email: 'john@example.com',
    handicap: 12.5,
    role: 'CAPTAIN',
    joinedAt: testDateTime,
  );

  final testMemberRegular = Member(
    id: 'member-2',
    societyId: 'society-1',
    userId: 'user-2',
    name: 'Jane Smith',
    email: 'jane@example.com',
    handicap: 18.0,
    role: 'MEMBER',
    joinedAt: testDateTime,
  );

  Widget createWidgetUnderTest(Member member) {
    return MaterialApp(
      home: Scaffold(body: MemberCard(member: member)),
    );
  }

  group('MemberCard', () {
    group('Display', () {
      testWidgets('displays member name', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest(testMemberRegular));

        // Assert
        expect(find.text('Jane Smith'), findsOneWidget);
      });

      testWidgets('displays member handicap with one decimal place', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest(testMemberCaptain));

        // Assert
        expect(find.text('HCP: 12.5'), findsOneWidget);
      });

      testWidgets('displays handicap as integer when whole number', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest(testMemberRegular));

        // Assert
        expect(find.text('HCP: 18'), findsOneWidget);
      });

      testWidgets('displays CAPTAIN role badge', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest(testMemberCaptain));

        // Assert
        expect(find.text('CAPTAIN'), findsOneWidget);
      });

      testWidgets('does not display badge for regular MEMBER', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest(testMemberRegular));

        // Assert
        expect(find.text('CAPTAIN'), findsNothing);
        expect(find.text('MEMBER'), findsNothing);
      });

      testWidgets(
        'displays avatar placeholder with initials when no avatarUrl',
        (tester) async {
          // Arrange & Act
          await tester.pumpWidget(createWidgetUnderTest(testMemberRegular));

          // Assert - should show initials "JS" for Jane Smith
          expect(find.text('JS'), findsOneWidget);
          expect(find.byType(CircleAvatar), findsOneWidget);
        },
      );

      testWidgets('displays initials correctly for single name', (
        tester,
      ) async {
        // Arrange
        final singleNameMember = Member(
          id: 'member-x',
          societyId: 'society-1',
          userId: 'user-x',
          name: 'Madonna',
          email: 'madonna@example.com',
          handicap: 10.0,
          role: 'MEMBER',
          joinedAt: testDateTime,
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest(singleNameMember));

        // Assert - should show first letter "M"
        expect(find.text('M'), findsOneWidget);
      });

      testWidgets('displays chevron icon for navigation', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest(testMemberRegular));

        // Assert
        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('is wrapped in a Card widget', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest(testMemberRegular));

        // Assert
        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('has proper ListTile structure', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createWidgetUnderTest(testMemberRegular));

        // Assert
        expect(find.byType(ListTile), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('calls onTap when card is tapped', (tester) async {
        // Arrange
        bool wasTapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MemberCard(
                member: testMemberRegular,
                onTap: () => wasTapped = true,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(MemberCard));
        await tester.pump();

        // Assert
        expect(wasTapped, isTrue);
      });

      testWidgets('does not crash when onTap is not provided', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(testMemberRegular));

        // Act & Assert - should not throw
        await tester.tap(find.byType(MemberCard));
        await tester.pump();
      });
    });
  });
}
