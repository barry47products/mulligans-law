import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/members/domain/usecases/get_primary_member.dart';

import 'get_primary_member_test.mocks.dart';

@GenerateMocks([MemberRepository])
void main() {
  late GetPrimaryMember useCase;
  late MockMemberRepository mockRepository;

  setUp(() {
    mockRepository = MockMemberRepository();
    useCase = GetPrimaryMember(mockRepository);
  });

  const testUserId = 'user-123';
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testPrimaryMember = Member(
    id: 'member-1',
    userId: testUserId,
    societyId: null,
    name: 'John Doe',
    email: 'john@example.com',
    handicap: 18.0,
    role: null,
    avatarUrl: null,
    joinedAt: testDateTime,
    lastPlayedAt: null,
  );

  group('GetPrimaryMember', () {
    test('should get primary member from repository', () async {
      // Arrange
      when(
        mockRepository.getPrimaryMember(testUserId),
      ).thenAnswer((_) async => testPrimaryMember);

      // Act
      final result = await useCase(testUserId);

      // Assert
      expect(result, testPrimaryMember);
      verify(mockRepository.getPrimaryMember(testUserId)).called(1);
    });

    test('should return member with null societyId and role', () async {
      // Arrange
      when(
        mockRepository.getPrimaryMember(testUserId),
      ).thenAnswer((_) async => testPrimaryMember);

      // Act
      final result = await useCase(testUserId);

      // Assert
      expect(result.societyId, isNull);
      expect(result.role, isNull);
      expect(result.userId, testUserId);
    });

    test(
      'should throw MemberNotFoundException when member not found',
      () async {
        // Arrange
        when(
          mockRepository.getPrimaryMember(testUserId),
        ).thenThrow(MemberNotFoundException('Primary member not found'));

        // Act & Assert
        expect(
          () => useCase(testUserId),
          throwsA(isA<MemberNotFoundException>()),
        );
        verify(mockRepository.getPrimaryMember(testUserId)).called(1);
      },
    );

    test('should propagate repository exceptions', () async {
      // Arrange
      when(
        mockRepository.getPrimaryMember(testUserId),
      ).thenThrow(MemberDatabaseException('Database error'));

      // Act & Assert
      expect(
        () => useCase(testUserId),
        throwsA(isA<MemberDatabaseException>()),
      );
    });
  });
}
