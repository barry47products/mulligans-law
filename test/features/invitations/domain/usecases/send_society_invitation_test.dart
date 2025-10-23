import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/features/invitations/domain/entities/society_invitation.dart';
import 'package:mulligans_law/features/invitations/domain/repositories/invitation_repository.dart';
import 'package:mulligans_law/features/invitations/domain/usecases/send_society_invitation.dart';

class MockInvitationRepository extends Mock implements InvitationRepository {}

void main() {
  late SendSocietyInvitation useCase;
  late MockInvitationRepository mockRepository;

  setUp(() {
    mockRepository = MockInvitationRepository();
    useCase = SendSocietyInvitation(mockRepository);
  });

  const testSocietyId = 'society-1';
  const testInvitedUserId = 'user-1';
  const testInvitedByUserId = 'captain-1';
  const testMessage = 'Join our golf society!';

  final testInvitation = SocietyInvitation(
    id: 'invitation-1',
    societyId: testSocietyId,
    societyName: 'Test Golf Society',
    invitedUserId: testInvitedUserId,
    invitedUserEmail: 'user@example.com',
    invitedUserName: 'John Doe',
    invitedByUserId: testInvitedByUserId,
    invitedByName: 'Captain Bob',
    message: testMessage,
    status: InvitationStatus.pending,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('SendSocietyInvitation', () {
    test('should send invitation successfully with message', () async {
      // Arrange
      when(
        () => mockRepository.sendInvitation(
          societyId: testSocietyId,
          invitedUserId: testInvitedUserId,
          invitedByUserId: testInvitedByUserId,
          message: testMessage,
        ),
      ).thenAnswer((_) async => testInvitation);

      // Act
      final result = await useCase(
        societyId: testSocietyId,
        invitedUserId: testInvitedUserId,
        invitedByUserId: testInvitedByUserId,
        message: testMessage,
      );

      // Assert
      expect(result, equals(testInvitation));
      verify(
        () => mockRepository.sendInvitation(
          societyId: testSocietyId,
          invitedUserId: testInvitedUserId,
          invitedByUserId: testInvitedByUserId,
          message: testMessage,
        ),
      ).called(1);
    });

    test('should send invitation successfully without message', () async {
      // Arrange
      final invitationWithoutMessage = SocietyInvitation(
        id: 'invitation-2',
        societyId: testSocietyId,
        societyName: 'Test Golf Society',
        invitedUserId: testInvitedUserId,
        invitedUserEmail: 'user@example.com',
        invitedUserName: 'John Doe',
        invitedByUserId: testInvitedByUserId,
        invitedByName: 'Captain Bob',
        message: null, // Explicitly null
        status: InvitationStatus.pending,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );
      when(
        () => mockRepository.sendInvitation(
          societyId: testSocietyId,
          invitedUserId: testInvitedUserId,
          invitedByUserId: testInvitedByUserId,
          message: null,
        ),
      ).thenAnswer((_) async => invitationWithoutMessage);

      // Act
      final result = await useCase(
        societyId: testSocietyId,
        invitedUserId: testInvitedUserId,
        invitedByUserId: testInvitedByUserId,
      );

      // Assert
      expect(result.message, isNull);
      verify(
        () => mockRepository.sendInvitation(
          societyId: testSocietyId,
          invitedUserId: testInvitedUserId,
          invitedByUserId: testInvitedByUserId,
          message: null,
        ),
      ).called(1);
    });

    test('should throw exception when user is already a member', () async {
      // Arrange
      when(
        () => mockRepository.sendInvitation(
          societyId: testSocietyId,
          invitedUserId: testInvitedUserId,
          invitedByUserId: testInvitedByUserId,
          message: any(named: 'message'),
        ),
      ).thenThrow(Exception('User already member'));

      // Act & Assert
      expect(
        () => useCase(
          societyId: testSocietyId,
          invitedUserId: testInvitedUserId,
          invitedByUserId: testInvitedByUserId,
        ),
        throwsException,
      );
    });

    test('should throw exception when pending invitation exists', () async {
      // Arrange
      when(
        () => mockRepository.sendInvitation(
          societyId: testSocietyId,
          invitedUserId: testInvitedUserId,
          invitedByUserId: testInvitedByUserId,
          message: any(named: 'message'),
        ),
      ).thenThrow(Exception('Pending invitation exists'));

      // Act & Assert
      expect(
        () => useCase(
          societyId: testSocietyId,
          invitedUserId: testInvitedUserId,
          invitedByUserId: testInvitedByUserId,
        ),
        throwsException,
      );
    });

    test('should throw exception when sender is unauthorized', () async {
      // Arrange
      when(
        () => mockRepository.sendInvitation(
          societyId: testSocietyId,
          invitedUserId: testInvitedUserId,
          invitedByUserId: testInvitedByUserId,
          message: any(named: 'message'),
        ),
      ).thenThrow(Exception('Unauthorized'));

      // Act & Assert
      expect(
        () => useCase(
          societyId: testSocietyId,
          invitedUserId: testInvitedUserId,
          invitedByUserId: testInvitedByUserId,
        ),
        throwsException,
      );
    });
  });
}
