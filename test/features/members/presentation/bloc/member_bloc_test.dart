import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/domain/usecases/get_society_members.dart';
import 'package:mulligans_law/features/members/domain/usecases/join_society.dart';
import 'package:mulligans_law/features/members/domain/usecases/leave_society.dart';
import 'package:mulligans_law/features/members/domain/usecases/update_member_role.dart';
import 'package:mulligans_law/features/members/presentation/bloc/member_bloc.dart';
import 'package:mulligans_law/features/members/presentation/bloc/member_event.dart';
import 'package:mulligans_law/features/members/presentation/bloc/member_state.dart';

import 'member_bloc_test.mocks.dart';

@GenerateMocks([GetSocietyMembers, JoinSociety, UpdateMemberRole, LeaveSociety])
void main() {
  late MemberBloc bloc;
  late MockGetSocietyMembers mockGetSocietyMembers;
  late MockJoinSociety mockJoinSociety;
  late MockUpdateMemberRole mockUpdateMemberRole;
  late MockLeaveSociety mockLeaveSociety;

  setUp(() {
    mockGetSocietyMembers = MockGetSocietyMembers();
    mockJoinSociety = MockJoinSociety();
    mockUpdateMemberRole = MockUpdateMemberRole();
    mockLeaveSociety = MockLeaveSociety();
    bloc = MemberBloc(
      getSocietyMembers: mockGetSocietyMembers,
      joinSociety: mockJoinSociety,
      updateMemberRole: mockUpdateMemberRole,
      leaveSociety: mockLeaveSociety,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const testSocietyId = 'society-123';
  const testUserId = 'user-456';
  const testMemberId = 'member-789';
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testMembers = [
    Member(
      id: 'member-1',
      userId: 'user-1',
      societyId: testSocietyId,
      name: 'Alice Smith',
      email: 'alice@example.com',
      handicap: 12.0,
      role: 'CAPTAIN',
      avatarUrl: null,
      joinedAt: testDateTime,
      lastPlayedAt: null,
    ),
    Member(
      id: 'member-2',
      userId: 'user-2',
      societyId: testSocietyId,
      name: 'Bob Jones',
      email: 'bob@example.com',
      handicap: 18.0,
      role: 'MEMBER',
      avatarUrl: null,
      joinedAt: testDateTime.add(const Duration(days: 1)),
      lastPlayedAt: null,
    ),
  ];

  final testNewMember = Member(
    id: testMemberId,
    userId: testUserId,
    societyId: testSocietyId,
    name: 'Charlie Brown',
    email: 'charlie@example.com',
    handicap: 24.0,
    role: 'MEMBER',
    avatarUrl: null,
    joinedAt: testDateTime.add(const Duration(days: 2)),
    lastPlayedAt: null,
  );

  group('MemberBloc', () {
    test('initial state is MemberInitial', () {
      expect(bloc.state, equals(const MemberInitial()));
    });

    group('MemberLoadRequested', () {
      blocTest<MemberBloc, MemberState>(
        'emits [MemberLoading, MemberLoaded] when load succeeds',
        build: () {
          when(
            mockGetSocietyMembers(testSocietyId),
          ).thenAnswer((_) async => testMembers);
          return bloc;
        },
        act: (bloc) => bloc.add(const MemberLoadRequested(testSocietyId)),
        expect: () => [
          const MemberLoading(),
          MemberLoaded(members: testMembers, societyId: testSocietyId),
        ],
        verify: (_) {
          verify(mockGetSocietyMembers(testSocietyId)).called(1);
        },
      );

      blocTest<MemberBloc, MemberState>(
        'emits [MemberLoading, MemberLoaded] with empty list when no members',
        build: () {
          when(
            mockGetSocietyMembers(testSocietyId),
          ).thenAnswer((_) async => []);
          return bloc;
        },
        act: (bloc) => bloc.add(const MemberLoadRequested(testSocietyId)),
        expect: () => [
          const MemberLoading(),
          const MemberLoaded(members: [], societyId: testSocietyId),
        ],
      );

      blocTest<MemberBloc, MemberState>(
        'emits [MemberLoading, MemberError] when load fails',
        build: () {
          when(
            mockGetSocietyMembers(testSocietyId),
          ).thenThrow(MemberDatabaseException('Database error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const MemberLoadRequested(testSocietyId)),
        expect: () => [
          const MemberLoading(),
          const MemberError(message: 'Failed to load members: Database error'),
        ],
      );
    });

    group('MemberAddRequested', () {
      blocTest<MemberBloc, MemberState>(
        'emits [MemberOperationInProgress, MemberOperationSuccess] when add succeeds',
        build: () {
          when(
            mockJoinSociety(userId: testUserId, societyId: testSocietyId),
          ).thenAnswer((_) async => testNewMember);
          when(
            mockGetSocietyMembers(testSocietyId),
          ).thenAnswer((_) async => [...testMembers, testNewMember]);
          return bloc;
        },
        act: (bloc) => bloc.add(
          const MemberAddRequested(
            userId: testUserId,
            societyId: testSocietyId,
          ),
        ),
        expect: () => [
          const MemberOperationInProgress('Adding member...'),
          MemberOperationSuccess(
            message: 'Member added successfully',
            members: [...testMembers, testNewMember],
            societyId: testSocietyId,
          ),
        ],
        verify: (_) {
          verify(
            mockJoinSociety(userId: testUserId, societyId: testSocietyId),
          ).called(1);
          verify(mockGetSocietyMembers(testSocietyId)).called(1);
        },
      );

      blocTest<MemberBloc, MemberState>(
        'emits [MemberOperationInProgress, MemberError] when add fails',
        build: () {
          when(
            mockJoinSociety(userId: testUserId, societyId: testSocietyId),
          ).thenThrow(MemberAlreadyExistsException('Member already exists'));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const MemberAddRequested(
            userId: testUserId,
            societyId: testSocietyId,
          ),
        ),
        expect: () => [
          const MemberOperationInProgress('Adding member...'),
          const MemberError(
            message: 'Failed to add member: Member already exists',
          ),
        ],
      );
    });

    group('MemberUpdateRoleRequested', () {
      final updatedMember = testMembers[1].copyWith(role: 'CAPTAIN');

      blocTest<MemberBloc, MemberState>(
        'emits [MemberOperationInProgress, MemberOperationSuccess] when update succeeds',
        build: () {
          when(
            mockUpdateMemberRole(memberId: testMemberId, role: 'CAPTAIN'),
          ).thenAnswer((_) async => updatedMember);
          when(
            mockGetSocietyMembers(testSocietyId),
          ).thenAnswer((_) async => [testMembers[0], updatedMember]);
          return bloc;
        },
        seed: () =>
            MemberLoaded(members: testMembers, societyId: testSocietyId),
        act: (bloc) => bloc.add(
          const MemberUpdateRoleRequested(
            memberId: testMemberId,
            role: 'CAPTAIN',
          ),
        ),
        expect: () => [
          const MemberOperationInProgress('Updating member role...'),
          MemberOperationSuccess(
            message: 'Member role updated successfully',
            members: [testMembers[0], updatedMember],
            societyId: testSocietyId,
          ),
        ],
        verify: (_) {
          verify(
            mockUpdateMemberRole(memberId: testMemberId, role: 'CAPTAIN'),
          ).called(1);
          verify(mockGetSocietyMembers(testSocietyId)).called(1);
        },
      );

      blocTest<MemberBloc, MemberState>(
        'emits [MemberOperationInProgress, MemberError] when update fails',
        build: () {
          when(
            mockUpdateMemberRole(memberId: testMemberId, role: 'CAPTAIN'),
          ).thenThrow(
            InvalidMemberOperationException('Only captains can update roles'),
          );
          return bloc;
        },
        seed: () =>
            MemberLoaded(members: testMembers, societyId: testSocietyId),
        act: (bloc) => bloc.add(
          const MemberUpdateRoleRequested(
            memberId: testMemberId,
            role: 'CAPTAIN',
          ),
        ),
        expect: () => [
          const MemberOperationInProgress('Updating member role...'),
          MemberError(
            message:
                'Failed to update member role: Only captains can update roles',
            members: testMembers,
            societyId: testSocietyId,
          ),
        ],
      );
    });

    group('MemberRemoveRequested', () {
      blocTest<MemberBloc, MemberState>(
        'emits [MemberOperationInProgress, MemberOperationSuccess] when remove succeeds',
        build: () {
          when(mockLeaveSociety(testMemberId)).thenAnswer((_) async {});
          when(
            mockGetSocietyMembers(testSocietyId),
          ).thenAnswer((_) async => [testMembers[0]]);
          return bloc;
        },
        seed: () =>
            MemberLoaded(members: testMembers, societyId: testSocietyId),
        act: (bloc) => bloc.add(const MemberRemoveRequested(testMemberId)),
        expect: () => [
          const MemberOperationInProgress('Removing member...'),
          MemberOperationSuccess(
            message: 'Member removed successfully',
            members: [testMembers[0]],
            societyId: testSocietyId,
          ),
        ],
        verify: (_) {
          verify(mockLeaveSociety(testMemberId)).called(1);
          verify(mockGetSocietyMembers(testSocietyId)).called(1);
        },
      );

      blocTest<MemberBloc, MemberState>(
        'emits [MemberOperationInProgress, MemberError] when remove fails',
        build: () {
          when(mockLeaveSociety(testMemberId)).thenThrow(
            InvalidMemberOperationException(
              'Captain cannot leave while other members exist',
            ),
          );
          return bloc;
        },
        seed: () =>
            MemberLoaded(members: testMembers, societyId: testSocietyId),
        act: (bloc) => bloc.add(const MemberRemoveRequested(testMemberId)),
        expect: () => [
          const MemberOperationInProgress('Removing member...'),
          MemberError(
            message:
                'Failed to remove member: Captain cannot leave while other members exist',
            members: testMembers,
            societyId: testSocietyId,
          ),
        ],
      );
    });
  });
}
