import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/members/domain/usecases/get_member_count.dart';

import 'get_member_count_test.mocks.dart';

@GenerateMocks([MemberRepository])
void main() {
  late GetMemberCount useCase;
  late MockMemberRepository mockRepository;

  setUp(() {
    mockRepository = MockMemberRepository();
    useCase = GetMemberCount(mockRepository);
  });

  const testSocietyId = 'society-123';

  group('GetMemberCount', () {
    test('should get member count from repository', () async {
      // Arrange
      when(
        mockRepository.getMemberCount(testSocietyId),
      ).thenAnswer((_) async => 5);

      // Act
      final result = await useCase(testSocietyId);

      // Assert
      expect(result, 5);
      verify(mockRepository.getMemberCount(testSocietyId)).called(1);
    });

    test('should return zero when no members exist', () async {
      // Arrange
      when(
        mockRepository.getMemberCount(testSocietyId),
      ).thenAnswer((_) async => 0);

      // Act
      final result = await useCase(testSocietyId);

      // Assert
      expect(result, 0);
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      when(
        mockRepository.getMemberCount(testSocietyId),
      ).thenThrow(MemberDatabaseException('Database error'));

      // Act & Assert
      expect(
        () => useCase(testSocietyId),
        throwsA(isA<MemberDatabaseException>()),
      );
    });
  });
}
