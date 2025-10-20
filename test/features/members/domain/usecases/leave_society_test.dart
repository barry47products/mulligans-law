import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/members/domain/usecases/leave_society.dart';

import 'leave_society_test.mocks.dart';

@GenerateMocks([MemberRepository])
void main() {
  late LeaveSociety useCase;
  late MockMemberRepository mockRepository;

  setUp(() {
    mockRepository = MockMemberRepository();
    useCase = LeaveSociety(mockRepository);
  });

  const testMemberId = 'member-123';

  group('LeaveSociety', () {
    test('should remove member from society', () async {
      // Arrange
      when(
        mockRepository.removeSocietyMember(testMemberId),
      ).thenAnswer((_) async {});

      // Act
      await useCase(testMemberId);

      // Assert
      verify(mockRepository.removeSocietyMember(testMemberId)).called(1);
    });

    test(
      'should throw MemberNotFoundException when member not found',
      () async {
        // Arrange
        when(
          mockRepository.removeSocietyMember(testMemberId),
        ).thenThrow(MemberNotFoundException('Member not found'));

        // Act & Assert
        expect(
          () => useCase(testMemberId),
          throwsA(isA<MemberNotFoundException>()),
        );
      },
    );

    test(
      'should throw InvalidMemberOperationException when captain tries to leave with other members',
      () async {
        // Arrange
        when(mockRepository.removeSocietyMember(testMemberId)).thenThrow(
          InvalidMemberOperationException(
            'Captain cannot leave while other members exist',
          ),
        );

        // Act & Assert
        expect(
          () => useCase(testMemberId),
          throwsA(isA<InvalidMemberOperationException>()),
        );
      },
    );

    test('should propagate repository exceptions', () async {
      // Arrange
      when(
        mockRepository.removeSocietyMember(testMemberId),
      ).thenThrow(MemberDatabaseException('Database error'));

      // Act & Assert
      expect(
        () => useCase(testMemberId),
        throwsA(isA<MemberDatabaseException>()),
      );
    });
  });
}
