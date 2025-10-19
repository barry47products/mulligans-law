import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/errors/society_exceptions.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/domain/usecases/create_society.dart';
import 'package:mulligans_law/features/societies/domain/usecases/get_user_societies.dart';
import 'package:mulligans_law/features/societies/domain/usecases/update_society.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_bloc.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_event.dart';
import 'package:mulligans_law/features/societies/presentation/bloc/society_state.dart';

import 'society_bloc_test.mocks.dart';

@GenerateMocks([CreateSociety, GetUserSocieties, UpdateSociety])
void main() {
  late SocietyBloc bloc;
  late MockCreateSociety mockCreateSociety;
  late MockGetUserSocieties mockGetUserSocieties;
  late MockUpdateSociety mockUpdateSociety;

  setUp(() {
    mockCreateSociety = MockCreateSociety();
    mockGetUserSocieties = MockGetUserSocieties();
    mockUpdateSociety = MockUpdateSociety();
    bloc = SocietyBloc(
      createSociety: mockCreateSociety,
      getUserSocieties: mockGetUserSocieties,
      updateSociety: mockUpdateSociety,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testSocieties = [
    Society(
      id: 'society-1',
      name: 'Mulligans Golf Society',
      description: 'A friendly golf society',
      logoUrl: 'https://example.com/logo1.png',
      createdAt: testDateTime,
      updatedAt: testDateTime,
    ),
    Society(
      id: 'society-2',
      name: 'Another Golf Club',
      createdAt: testDateTime,
      updatedAt: testDateTime,
    ),
  ];

  final testSociety = testSocieties[0];

  group('SocietyBloc', () {
    test('initial state is SocietyInitial', () {
      expect(bloc.state, equals(const SocietyInitial()));
    });

    group('SocietyLoadRequested', () {
      blocTest<SocietyBloc, SocietyState>(
        'emits [SocietyLoading, SocietyLoaded] when load succeeds',
        build: () {
          when(mockGetUserSocieties()).thenAnswer((_) async => testSocieties);
          return bloc;
        },
        act: (bloc) => bloc.add(const SocietyLoadRequested()),
        expect: () => [
          const SocietyLoading(),
          SocietyLoaded(societies: testSocieties),
        ],
        verify: (_) {
          verify(mockGetUserSocieties()).called(1);
        },
      );

      blocTest<SocietyBloc, SocietyState>(
        'emits [SocietyLoading, SocietyLoaded] with empty list when no societies',
        build: () {
          when(mockGetUserSocieties()).thenAnswer((_) async => []);
          return bloc;
        },
        act: (bloc) => bloc.add(const SocietyLoadRequested()),
        expect: () => [
          const SocietyLoading(),
          const SocietyLoaded(societies: []),
        ],
      );

      blocTest<SocietyBloc, SocietyState>(
        'emits [SocietyLoading, SocietyError] when load fails',
        build: () {
          when(mockGetUserSocieties()).thenThrow(
            const SocietyDatabaseException('Failed to load societies'),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const SocietyLoadRequested()),
        expect: () => [
          const SocietyLoading(),
          const SocietyError(message: 'Failed to load societies'),
        ],
      );
    });

    group('SocietyCreateRequested', () {
      blocTest<SocietyBloc, SocietyState>(
        'emits [SocietyOperationInProgress, SocietyOperationSuccess] when create succeeds',
        build: () {
          when(
            mockCreateSociety(
              name: anyNamed('name'),
              description: anyNamed('description'),
              logoUrl: anyNamed('logoUrl'),
            ),
          ).thenAnswer((_) async => testSociety);
          when(mockGetUserSocieties()).thenAnswer((_) async => testSocieties);
          return bloc;
        },
        act: (bloc) => bloc.add(
          const SocietyCreateRequested(
            name: 'Mulligans Golf Society',
            description: 'A friendly golf society',
          ),
        ),
        expect: () => [
          const SocietyOperationInProgress('Creating society...'),
          SocietyOperationSuccess(
            message: 'Society created successfully',
            societies: testSocieties,
          ),
        ],
        verify: (_) {
          verify(
            mockCreateSociety(
              name: 'Mulligans Golf Society',
              description: 'A friendly golf society',
              logoUrl: null,
            ),
          ).called(1);
          verify(mockGetUserSocieties()).called(1);
        },
      );

      blocTest<SocietyBloc, SocietyState>(
        'emits [SocietyOperationInProgress, SocietyError] when create fails due to validation',
        build: () {
          when(
            mockCreateSociety(
              name: anyNamed('name'),
              description: anyNamed('description'),
              logoUrl: anyNamed('logoUrl'),
            ),
          ).thenThrow(
            const InvalidSocietyDataException('Society name cannot be empty'),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const SocietyCreateRequested(name: '')),
        expect: () => [
          const SocietyOperationInProgress('Creating society...'),
          const SocietyError(message: 'Society name cannot be empty'),
        ],
      );

      blocTest<SocietyBloc, SocietyState>(
        'emits [SocietyOperationInProgress, SocietyError] when create fails',
        build: () {
          when(
            mockCreateSociety(
              name: anyNamed('name'),
              description: anyNamed('description'),
              logoUrl: anyNamed('logoUrl'),
            ),
          ).thenThrow(const SocietyDatabaseException('Database error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const SocietyCreateRequested(name: 'Test')),
        expect: () => [
          const SocietyOperationInProgress('Creating society...'),
          const SocietyError(message: 'Database error'),
        ],
      );
    });

    group('SocietyUpdateRequested', () {
      blocTest<SocietyBloc, SocietyState>(
        'emits [SocietyOperationInProgress, SocietyOperationSuccess] when update succeeds',
        build: () {
          when(
            mockUpdateSociety(
              id: anyNamed('id'),
              name: anyNamed('name'),
              description: anyNamed('description'),
              logoUrl: anyNamed('logoUrl'),
            ),
          ).thenAnswer((_) async => testSociety);
          when(mockGetUserSocieties()).thenAnswer((_) async => testSocieties);
          return bloc;
        },
        act: (bloc) => bloc.add(
          const SocietyUpdateRequested(id: 'society-1', name: 'Updated Name'),
        ),
        expect: () => [
          const SocietyOperationInProgress('Updating society...'),
          SocietyOperationSuccess(
            message: 'Society updated successfully',
            societies: testSocieties,
          ),
        ],
        verify: (_) {
          verify(
            mockUpdateSociety(
              id: 'society-1',
              name: 'Updated Name',
              description: null,
              logoUrl: null,
            ),
          ).called(1);
          verify(mockGetUserSocieties()).called(1);
        },
      );

      blocTest<SocietyBloc, SocietyState>(
        'emits [SocietyOperationInProgress, SocietyError] when update fails',
        build: () {
          when(
            mockUpdateSociety(
              id: anyNamed('id'),
              name: anyNamed('name'),
              description: anyNamed('description'),
              logoUrl: anyNamed('logoUrl'),
            ),
          ).thenThrow(const SocietyNotFoundException('Society not found'));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const SocietyUpdateRequested(id: 'society-1', name: 'Updated Name'),
        ),
        expect: () => [
          const SocietyOperationInProgress('Updating society...'),
          const SocietyError(message: 'Society not found'),
        ],
      );
    });

    group('SocietySelected', () {
      blocTest<SocietyBloc, SocietyState>(
        'updates selected society when in SocietyLoaded state',
        build: () => bloc,
        seed: () => SocietyLoaded(societies: testSocieties),
        act: (bloc) => bloc.add(const SocietySelected('society-1')),
        expect: () => [
          SocietyLoaded(
            societies: testSocieties,
            selectedSociety: testSocieties[0],
          ),
        ],
      );

      blocTest<SocietyBloc, SocietyState>(
        'does nothing when society not found',
        build: () => bloc,
        seed: () => SocietyLoaded(societies: testSocieties),
        act: (bloc) => bloc.add(const SocietySelected('non-existent')),
        expect: () => [],
      );

      blocTest<SocietyBloc, SocietyState>(
        'does nothing when not in SocietyLoaded state',
        build: () => bloc,
        act: (bloc) => bloc.add(const SocietySelected('society-1')),
        expect: () => [],
      );
    });

    group('SocietyClearSelection', () {
      blocTest<SocietyBloc, SocietyState>(
        'clears selected society when in SocietyLoaded state',
        build: () => bloc,
        seed: () => SocietyLoaded(
          societies: testSocieties,
          selectedSociety: testSocieties[0],
        ),
        act: (bloc) => bloc.add(const SocietyClearSelection()),
        expect: () => [
          SocietyLoaded(societies: testSocieties, selectedSociety: null),
        ],
      );

      blocTest<SocietyBloc, SocietyState>(
        'does nothing when not in SocietyLoaded state',
        build: () => bloc,
        act: (bloc) => bloc.add(const SocietyClearSelection()),
        expect: () => [],
      );
    });
  });
}
