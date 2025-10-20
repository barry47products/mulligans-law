import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/members/domain/usecases/update_primary_member.dart';

import 'update_primary_member_test.mocks.dart';

@GenerateMocks([MemberRepository])
void main() {
  late UpdatePrimaryMember useCase;
  late MockMemberRepository mockRepository;

  setUp(() {
    mockRepository = MockMemberRepository();
    useCase = UpdatePrimaryMember(mockRepository);
  });

  const testUserId = 'user-123';
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testMember = Member(
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

  group('UpdatePrimaryMember', () {
    test('should update primary member with all fields', () async {
      // Arrange
      final updatedMember = testMember.copyWith(
        name: 'John Updated',
        email: 'updated@example.com',
        handicap: 12.0,
        avatarUrl: 'https://example.com/avatar.png',
      );
      when(
        mockRepository.updatePrimaryMember(
          userId: testUserId,
          name: 'John Updated',
          email: 'updated@example.com',
          handicap: 12.0,
          avatarUrl: 'https://example.com/avatar.png',
        ),
      ).thenAnswer((_) async => updatedMember);

      // Act
      final result = await useCase(
        userId: testUserId,
        name: 'John Updated',
        email: 'updated@example.com',
        handicap: 12.0,
        avatarUrl: 'https://example.com/avatar.png',
      );

      // Assert
      expect(result.name, 'John Updated');
      expect(result.email, 'updated@example.com');
      expect(result.handicap, 12.0);
      expect(result.avatarUrl, 'https://example.com/avatar.png');
      verify(
        mockRepository.updatePrimaryMember(
          userId: testUserId,
          name: 'John Updated',
          email: 'updated@example.com',
          handicap: 12.0,
          avatarUrl: 'https://example.com/avatar.png',
        ),
      ).called(1);
    });

    test('should update only name', () async {
      // Arrange
      final updatedMember = testMember.copyWith(name: 'New Name');
      when(
        mockRepository.updatePrimaryMember(
          userId: testUserId,
          name: 'New Name',
        ),
      ).thenAnswer((_) async => updatedMember);

      // Act
      final result = await useCase(userId: testUserId, name: 'New Name');

      // Assert
      expect(result.name, 'New Name');
    });

    test('should update only handicap', () async {
      // Arrange
      final updatedMember = testMember.copyWith(handicap: 24.0);
      when(
        mockRepository.updatePrimaryMember(userId: testUserId, handicap: 24.0),
      ).thenAnswer((_) async => updatedMember);

      // Act
      final result = await useCase(userId: testUserId, handicap: 24.0);

      // Assert
      expect(result.handicap, 24.0);
    });

    test(
      'should throw MemberNotFoundException when member not found',
      () async {
        // Arrange
        when(
          mockRepository.updatePrimaryMember(
            userId: testUserId,
            name: 'New Name',
          ),
        ).thenThrow(MemberNotFoundException('Primary member not found'));

        // Act & Assert
        expect(
          () => useCase(userId: testUserId, name: 'New Name'),
          throwsA(isA<MemberNotFoundException>()),
        );
      },
    );

    test('should propagate repository exceptions', () async {
      // Arrange
      when(
        mockRepository.updatePrimaryMember(
          userId: testUserId,
          name: 'New Name',
        ),
      ).thenThrow(MemberDatabaseException('Database error'));

      // Act & Assert
      expect(
        () => useCase(userId: testUserId, name: 'New Name'),
        throwsA(isA<MemberDatabaseException>()),
      );
    });
  });
}
