import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/members/domain/usecases/request_to_join_society.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/domain/repositories/society_repository.dart';

class MockMemberRepository extends Mock implements MemberRepository {}

class MockSocietyRepository extends Mock implements SocietyRepository {}

void main() {
  late RequestToJoinSociety useCase;
  late MockMemberRepository mockMemberRepository;
  late MockSocietyRepository mockSocietyRepository;

  const userId = 'user-1';
  const societyId = 'society-1';

  final testPrimaryMember = Member(
    id: 'member-1',
    societyId: null,
    userId: userId,
    name: 'John Doe',
    email: 'john@example.com',
    handicap: 12.0,
    role: null,
    status: null,
    joinedAt: DateTime(2024, 1, 1),
  );

  final testSociety = Society(
    id: societyId,
    name: 'Test Society',
    description: 'A test society',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
    isPublic: true,
    handicapLimitEnabled: false,
  );

  setUp(() {
    mockMemberRepository = MockMemberRepository();
    mockSocietyRepository = MockSocietyRepository();
    useCase = RequestToJoinSociety(
      memberRepository: mockMemberRepository,
      societyRepository: mockSocietyRepository,
    );
  });

  group('RequestToJoinSociety', () {
    test(
      'should create pending member record when user requests to join public society',
      () async {
        // Arrange
        when(
          () => mockMemberRepository.getPrimaryMember(userId),
        ).thenAnswer((_) async => testPrimaryMember);
        when(
          () => mockSocietyRepository.getSocietyById(societyId),
        ).thenAnswer((_) async => testSociety);
        when(
          () => mockMemberRepository.addMember(
            societyId: any(named: 'societyId'),
            userId: any(named: 'userId'),
            name: any(named: 'name'),
            email: any(named: 'email'),
            avatarUrl: any(named: 'avatarUrl'),
            handicap: any(named: 'handicap'),
            role: any(named: 'role'),
            status: any(named: 'status'),
            expiresAt: any(named: 'expiresAt'),
          ),
        ).thenAnswer((_) async => testPrimaryMember);

        // Act
        await useCase(userId: userId, societyId: societyId);

        // Assert
        verify(() => mockMemberRepository.getPrimaryMember(userId)).called(1);
        verify(() => mockSocietyRepository.getSocietyById(societyId)).called(1);
        verify(
          () => mockMemberRepository.addMember(
            societyId: societyId,
            userId: userId,
            name: testPrimaryMember.name,
            email: testPrimaryMember.email,
            avatarUrl: testPrimaryMember.avatarUrl,
            handicap: testPrimaryMember.handicap,
            role: 'MEMBER',
            status: 'PENDING',
            expiresAt: any(named: 'expiresAt'),
          ),
        ).called(1);
      },
    );

    test(
      'should throw MemberNotFoundException when primary member not found',
      () async {
        // Arrange
        when(
          () => mockMemberRepository.getPrimaryMember(userId),
        ).thenThrow(MemberNotFoundException('Primary member not found'));

        // Act & Assert
        expect(
          () => useCase(userId: userId, societyId: societyId),
          throwsA(isA<MemberNotFoundException>()),
        );
      },
    );

    test(
      'should throw InvalidMemberOperationException when society is not public',
      () async {
        // Arrange
        final privateSociety = testSociety.copyWith(isPublic: false);
        when(
          () => mockMemberRepository.getPrimaryMember(userId),
        ).thenAnswer((_) async => testPrimaryMember);
        when(
          () => mockSocietyRepository.getSocietyById(societyId),
        ).thenAnswer((_) async => privateSociety);

        // Act & Assert
        expect(
          () => useCase(userId: userId, societyId: societyId),
          throwsA(isA<InvalidMemberOperationException>()),
        );
      },
    );

    test(
      'should throw InvalidMemberOperationException when society is deleted',
      () async {
        // Arrange
        final deletedSociety = testSociety.copyWith(
          deletedAt: DateTime(2024, 6, 1),
        );
        when(
          () => mockMemberRepository.getPrimaryMember(userId),
        ).thenAnswer((_) async => testPrimaryMember);
        when(
          () => mockSocietyRepository.getSocietyById(societyId),
        ).thenAnswer((_) async => deletedSociety);

        // Act & Assert
        expect(
          () => useCase(userId: userId, societyId: societyId),
          throwsA(isA<InvalidMemberOperationException>()),
        );
      },
    );

    test(
      'should throw InvalidMemberOperationException when user handicap is outside society limits',
      () async {
        // Arrange
        final societyWithLimits = testSociety.copyWith(
          handicapLimitEnabled: true,
          handicapMin: 0,
          handicapMax: 10,
        );
        when(
          () => mockMemberRepository.getPrimaryMember(userId),
        ).thenAnswer((_) async => testPrimaryMember); // handicap 12.0
        when(
          () => mockSocietyRepository.getSocietyById(societyId),
        ).thenAnswer((_) async => societyWithLimits);

        // Act & Assert
        expect(
          () => useCase(userId: userId, societyId: societyId),
          throwsA(isA<InvalidMemberOperationException>()),
        );
      },
    );

    test(
      'should succeed when user handicap is within society limits',
      () async {
        // Arrange
        final societyWithLimits = testSociety.copyWith(
          handicapLimitEnabled: true,
          handicapMin: 0,
          handicapMax: 24,
        );
        when(
          () => mockMemberRepository.getPrimaryMember(userId),
        ).thenAnswer((_) async => testPrimaryMember); // handicap 12.0
        when(
          () => mockSocietyRepository.getSocietyById(societyId),
        ).thenAnswer((_) async => societyWithLimits);
        when(
          () => mockMemberRepository.addMember(
            societyId: any(named: 'societyId'),
            userId: any(named: 'userId'),
            name: any(named: 'name'),
            email: any(named: 'email'),
            avatarUrl: any(named: 'avatarUrl'),
            handicap: any(named: 'handicap'),
            role: any(named: 'role'),
            status: any(named: 'status'),
            expiresAt: any(named: 'expiresAt'),
          ),
        ).thenAnswer((_) async => testPrimaryMember);

        // Act
        await useCase(userId: userId, societyId: societyId);

        // Assert - should not throw
        verify(
          () => mockMemberRepository.addMember(
            societyId: any(named: 'societyId'),
            userId: any(named: 'userId'),
            name: any(named: 'name'),
            email: any(named: 'email'),
            avatarUrl: any(named: 'avatarUrl'),
            handicap: any(named: 'handicap'),
            role: any(named: 'role'),
            status: any(named: 'status'),
            expiresAt: any(named: 'expiresAt'),
          ),
        ).called(1);
      },
    );
  });
}
