import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/members/domain/usecases/update_member_role.dart';

import 'update_member_role_test.mocks.dart';

@GenerateMocks([MemberRepository])
void main() {
  late UpdateMemberRole useCase;
  late MockMemberRepository mockRepository;

  setUp(() {
    mockRepository = MockMemberRepository();
    useCase = UpdateMemberRole(mockRepository);
  });

  const testMemberId = 'member-123';
  const testNewRole = 'CAPTAIN';
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testUpdatedMember = Member(
    id: testMemberId,
    userId: 'user-123',
    societyId: 'society-456',
    name: 'John Doe',
    email: 'john@example.com',
    handicap: 18.0,
    role: testNewRole,
    avatarUrl: null,
    joinedAt: testDateTime,
    lastPlayedAt: null,
  );

  group('UpdateMemberRole', () {
    test('should update member role', () async {
      // Arrange
      when(
        mockRepository.updateMemberRole(
          memberId: testMemberId,
          role: testNewRole,
        ),
      ).thenAnswer((_) async => testUpdatedMember);

      // Act
      final result = await useCase(memberId: testMemberId, role: testNewRole);

      // Assert
      expect(result.role, testNewRole);
      expect(result.id, testMemberId);
      verify(
        mockRepository.updateMemberRole(
          memberId: testMemberId,
          role: testNewRole,
        ),
      ).called(1);
    });

    test(
      'should throw MemberNotFoundException when member not found',
      () async {
        // Arrange
        when(
          mockRepository.updateMemberRole(
            memberId: testMemberId,
            role: testNewRole,
          ),
        ).thenThrow(MemberNotFoundException('Member not found'));

        // Act & Assert
        expect(
          () => useCase(memberId: testMemberId, role: testNewRole),
          throwsA(isA<MemberNotFoundException>()),
        );
      },
    );

    test(
      'should throw InvalidMemberOperationException for invalid operation',
      () async {
        // Arrange
        when(
          mockRepository.updateMemberRole(
            memberId: testMemberId,
            role: testNewRole,
          ),
        ).thenThrow(
          InvalidMemberOperationException('Only captains can update roles'),
        );

        // Act & Assert
        expect(
          () => useCase(memberId: testMemberId, role: testNewRole),
          throwsA(isA<InvalidMemberOperationException>()),
        );
      },
    );
  });
}
