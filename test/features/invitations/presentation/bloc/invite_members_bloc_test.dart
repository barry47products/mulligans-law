import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mulligans_law/core/errors/auth_exceptions.dart';
import 'package:mulligans_law/core/errors/invitation_exceptions.dart';
import 'package:mulligans_law/features/auth/domain/entities/user_profile.dart';
import 'package:mulligans_law/features/auth/domain/usecases/search_users.dart';
import 'package:mulligans_law/features/invitations/domain/entities/society_invitation.dart';
import 'package:mulligans_law/features/invitations/domain/usecases/send_society_invitation.dart';
import 'package:mulligans_law/features/invitations/presentation/bloc/invite_members_bloc.dart';
import 'package:mulligans_law/features/invitations/presentation/bloc/invite_members_event.dart';
import 'package:mulligans_law/features/invitations/presentation/bloc/invite_members_state.dart';

class MockSearchUsers extends Mock implements SearchUsers {}

class MockSendSocietyInvitation extends Mock implements SendSocietyInvitation {}

void main() {
  late InviteMembersBloc bloc;
  late MockSearchUsers mockSearchUsers;
  late MockSendSocietyInvitation mockSendInvitation;

  setUp(() {
    mockSearchUsers = MockSearchUsers();
    mockSendInvitation = MockSendSocietyInvitation();
    bloc = InviteMembersBloc(
      searchUsers: mockSearchUsers,
      sendInvitation: mockSendInvitation,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('InviteMembersBloc', () {
    const testQuery = 'John';
    const testUserId = 'user-1';
    const testSocietyId = 'society-1';
    const testInviterId = 'inviter-1';

    final testUsers = [
      const UserProfile(
        id: 'user-1',
        name: 'John Doe',
        email: 'john@example.com',
        handicap: 12,
        avatarUrl: null,
      ),
      const UserProfile(
        id: 'user-2',
        name: 'John Smith',
        email: 'jsmith@example.com',
        handicap: 18,
        avatarUrl: null,
      ),
    ];

    final testInvitation = SocietyInvitation(
      id: 'invitation-1',
      societyId: testSocietyId,
      societyName: 'Test Society',
      invitedUserId: testUserId,
      invitedUserEmail: 'john@example.com',
      invitedUserName: 'John Doe',
      invitedByUserId: testInviterId,
      invitedByName: 'Inviter Name',
      message: null,
      status: InvitationStatus.pending,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
      respondedAt: null,
    );

    test('initial state is InviteMembersInitial', () {
      expect(bloc.state, equals(const InviteMembersInitial()));
    });

    group('SearchUsersEvent', () {
      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SearchingUsers, UsersLoaded] when search succeeds',
        build: () {
          when(
            () => mockSearchUsers(
              query: testQuery,
              limit: any(named: 'limit'),
              excludeSocietyId: any(named: 'excludeSocietyId'),
            ),
          ).thenAnswer((_) async => testUsers);
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const SearchUsersEvent(testQuery, testSocietyId)),
        expect: () => [
          const SearchingUsers(),
          UsersLoaded(testUsers, testQuery),
        ],
        verify: (_) {
          verify(
            () => mockSearchUsers(
              query: testQuery,
              limit: 20,
              excludeSocietyId: testSocietyId,
            ),
          ).called(1);
        },
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SearchingUsers, UsersLoaded] with empty list when no users found',
        build: () {
          when(
            () => mockSearchUsers(
              query: testQuery,
              limit: any(named: 'limit'),
              excludeSocietyId: any(named: 'excludeSocietyId'),
            ),
          ).thenAnswer((_) async => []);
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const SearchUsersEvent(testQuery, testSocietyId)),
        expect: () => [
          const SearchingUsers(),
          const UsersLoaded([], testQuery),
        ],
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SearchingUsers, InviteMembersError] when search fails with NetworkException',
        build: () {
          when(
            () => mockSearchUsers(
              query: testQuery,
              limit: any(named: 'limit'),
              excludeSocietyId: any(named: 'excludeSocietyId'),
            ),
          ).thenThrow(const NetworkException('No internet connection'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const SearchUsersEvent(testQuery, testSocietyId)),
        expect: () => [
          const SearchingUsers(),
          const InviteMembersError('No internet connection'),
        ],
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SearchingUsers, InviteMembersError] when search fails with generic error',
        build: () {
          when(
            () => mockSearchUsers(
              query: testQuery,
              limit: any(named: 'limit'),
              excludeSocietyId: any(named: 'excludeSocietyId'),
            ),
          ).thenThrow(const AuthException('Search failed'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const SearchUsersEvent(testQuery, testSocietyId)),
        expect: () => [
          const SearchingUsers(),
          const InviteMembersError('Failed to search users: Search failed'),
        ],
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'does not search when query is empty',
        build: () => bloc,
        act: (bloc) => bloc.add(const SearchUsersEvent('', testSocietyId)),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockSearchUsers(
              query: any(named: 'query'),
              limit: any(named: 'limit'),
            ),
          );
        },
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'does not search when query is only whitespace',
        build: () => bloc,
        act: (bloc) => bloc.add(const SearchUsersEvent('   ', testSocietyId)),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockSearchUsers(
              query: any(named: 'query'),
              limit: any(named: 'limit'),
            ),
          );
        },
      );
    });

    group('SendInvitationEvent', () {
      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SendingInvitation, InvitationSent] when invitation succeeds',
        build: () {
          when(
            () => mockSendInvitation(
              societyId: testSocietyId,
              invitedUserId: testUserId,
              invitedByUserId: testInviterId,
              message: null,
            ),
          ).thenAnswer((_) async => testInvitation);
          return bloc;
        },
        seed: () => UsersLoaded(testUsers, testQuery),
        act: (bloc) => bloc.add(
          const SendInvitationEvent(
            societyId: testSocietyId,
            invitedUserId: testUserId,
            invitedByUserId: testInviterId,
          ),
        ),
        expect: () => [
          const SendingInvitation(testUserId),
          InvitationSent(
            testInvitation,
            [testUsers[1]], // First user removed from list
            testQuery,
          ),
        ],
        verify: (_) {
          verify(
            () => mockSendInvitation(
              societyId: testSocietyId,
              invitedUserId: testUserId,
              invitedByUserId: testInviterId,
              message: null,
            ),
          ).called(1);
        },
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SendingInvitation, InvitationSent] with custom message when provided',
        build: () {
          when(
            () => mockSendInvitation(
              societyId: testSocietyId,
              invitedUserId: testUserId,
              invitedByUserId: testInviterId,
              message: 'Join our golf society!',
            ),
          ).thenAnswer((_) async => testInvitation);
          return bloc;
        },
        seed: () => UsersLoaded(testUsers, testQuery),
        act: (bloc) => bloc.add(
          const SendInvitationEvent(
            societyId: testSocietyId,
            invitedUserId: testUserId,
            invitedByUserId: testInviterId,
            message: 'Join our golf society!',
          ),
        ),
        expect: () => [
          const SendingInvitation(testUserId),
          InvitationSent(testInvitation, [testUsers[1]], testQuery),
        ],
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SendingInvitation, InviteMembersError] when invitation fails with PendingInvitationExistsException',
        build: () {
          when(
            () => mockSendInvitation(
              societyId: testSocietyId,
              invitedUserId: testUserId,
              invitedByUserId: testInviterId,
              message: null,
            ),
          ).thenThrow(
            const PendingInvitationExistsException(
              'User already has a pending invitation to this society',
            ),
          );
          return bloc;
        },
        seed: () => UsersLoaded(testUsers, testQuery),
        act: (bloc) => bloc.add(
          const SendInvitationEvent(
            societyId: testSocietyId,
            invitedUserId: testUserId,
            invitedByUserId: testInviterId,
          ),
        ),
        expect: () => [
          const SendingInvitation(testUserId),
          InviteMembersError(
            'User already has a pending invitation to this society',
            users: testUsers,
            query: testQuery,
          ),
        ],
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SendingInvitation, InviteMembersError] when invitation fails with UserAlreadyMemberException',
        build: () {
          when(
            () => mockSendInvitation(
              societyId: testSocietyId,
              invitedUserId: testUserId,
              invitedByUserId: testInviterId,
              message: null,
            ),
          ).thenThrow(
            const UserAlreadyMemberException(
              'User is already a member of this society',
            ),
          );
          return bloc;
        },
        seed: () => UsersLoaded(testUsers, testQuery),
        act: (bloc) => bloc.add(
          const SendInvitationEvent(
            societyId: testSocietyId,
            invitedUserId: testUserId,
            invitedByUserId: testInviterId,
          ),
        ),
        expect: () => [
          const SendingInvitation(testUserId),
          InviteMembersError(
            'User is already a member of this society',
            users: testUsers,
            query: testQuery,
          ),
        ],
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SendingInvitation, InviteMembersError] when invitation fails with HandicapValidationException',
        build: () {
          when(
            () => mockSendInvitation(
              societyId: testSocietyId,
              invitedUserId: testUserId,
              invitedByUserId: testInviterId,
              message: null,
            ),
          ).thenThrow(
            const HandicapValidationException(
              'User handicap 28 is outside society limits (0 - 18)',
            ),
          );
          return bloc;
        },
        seed: () => UsersLoaded(testUsers, testQuery),
        act: (bloc) => bloc.add(
          const SendInvitationEvent(
            societyId: testSocietyId,
            invitedUserId: testUserId,
            invitedByUserId: testInviterId,
          ),
        ),
        expect: () => [
          const SendingInvitation(testUserId),
          InviteMembersError(
            'User handicap 28 is outside society limits (0 - 18)',
            users: testUsers,
            query: testQuery,
          ),
        ],
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SendingInvitation, InviteMembersError] when invitation fails with NetworkException',
        build: () {
          when(
            () => mockSendInvitation(
              societyId: testSocietyId,
              invitedUserId: testUserId,
              invitedByUserId: testInviterId,
              message: null,
            ),
          ).thenThrow(const NetworkException('No internet connection'));
          return bloc;
        },
        seed: () => UsersLoaded(testUsers, testQuery),
        act: (bloc) => bloc.add(
          const SendInvitationEvent(
            societyId: testSocietyId,
            invitedUserId: testUserId,
            invitedByUserId: testInviterId,
          ),
        ),
        expect: () => [
          const SendingInvitation(testUserId),
          InviteMembersError(
            'No internet connection',
            users: testUsers,
            query: testQuery,
          ),
        ],
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [SendingInvitation, InviteMembersError] when invitation fails with generic error',
        build: () {
          when(
            () => mockSendInvitation(
              societyId: testSocietyId,
              invitedUserId: testUserId,
              invitedByUserId: testInviterId,
              message: null,
            ),
          ).thenThrow(const DatabaseException('Database error'));
          return bloc;
        },
        seed: () => UsersLoaded(testUsers, testQuery),
        act: (bloc) => bloc.add(
          const SendInvitationEvent(
            societyId: testSocietyId,
            invitedUserId: testUserId,
            invitedByUserId: testInviterId,
          ),
        ),
        expect: () => [
          const SendingInvitation(testUserId),
          InviteMembersError(
            'Failed to send invitation: Database error',
            users: testUsers,
            query: testQuery,
          ),
        ],
      );
    });

    group('ClearSearchEvent', () {
      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [InviteMembersInitial] when clearing search from UsersLoaded state',
        build: () => bloc,
        seed: () => UsersLoaded(testUsers, testQuery),
        act: (bloc) => bloc.add(const ClearSearchEvent()),
        expect: () => [const InviteMembersInitial()],
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [InviteMembersInitial] when clearing search from InvitationSent state',
        build: () => bloc,
        seed: () => InvitationSent(testInvitation, [testUsers[1]], testQuery),
        act: (bloc) => bloc.add(const ClearSearchEvent()),
        expect: () => [const InviteMembersInitial()],
      );

      blocTest<InviteMembersBloc, InviteMembersState>(
        'emits [InviteMembersInitial] when clearing search from error state',
        build: () => bloc,
        seed: () => InviteMembersError(
          'Some error',
          users: testUsers,
          query: testQuery,
        ),
        act: (bloc) => bloc.add(const ClearSearchEvent()),
        expect: () => [const InviteMembersInitial()],
      );
    });
  });
}
