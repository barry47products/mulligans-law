import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/society_exceptions.dart';
import '../../domain/usecases/create_society.dart';
import '../../domain/usecases/get_user_societies.dart';
import '../../domain/usecases/update_society.dart';
import 'society_event.dart';
import 'society_state.dart';

/// BLoC for managing society state and operations
class SocietyBloc extends Bloc<SocietyEvent, SocietyState> {
  final CreateSociety _createSociety;
  final GetUserSocieties _getUserSocieties;
  final UpdateSociety _updateSociety;

  SocietyBloc({
    required CreateSociety createSociety,
    required GetUserSocieties getUserSocieties,
    required UpdateSociety updateSociety,
  }) : _createSociety = createSociety,
       _getUserSocieties = getUserSocieties,
       _updateSociety = updateSociety,
       super(const SocietyInitial()) {
    on<SocietyLoadRequested>(_onLoadRequested);
    on<SocietyCreateRequested>(_onCreateRequested);
    on<SocietyUpdateRequested>(_onUpdateRequested);
    on<SocietySelected>(_onSocietySelected);
    on<SocietyClearSelection>(_onClearSelection);
  }

  /// Handles loading user societies
  Future<void> _onLoadRequested(
    SocietyLoadRequested event,
    Emitter<SocietyState> emit,
  ) async {
    emit(const SocietyLoading());
    try {
      final societies = await _getUserSocieties();
      emit(SocietyLoaded(societies: societies));
    } on SocietyException catch (e) {
      emit(SocietyError(message: e.message));
    } catch (e) {
      emit(SocietyError(message: e.toString()));
    }
  }

  /// Handles creating a new society
  Future<void> _onCreateRequested(
    SocietyCreateRequested event,
    Emitter<SocietyState> emit,
  ) async {
    emit(const SocietyOperationInProgress('Creating society...'));
    try {
      await _createSociety(
        userId: event.userId,
        name: event.name,
        description: event.description,
        logoUrl: event.logoUrl,
        isPublic: event.isPublic,
        handicapLimitEnabled: event.handicapLimitEnabled,
        handicapMin: event.handicapMin,
        handicapMax: event.handicapMax,
        location: event.location,
        rules: event.rules,
      );

      // Reload societies after creation
      final societies = await _getUserSocieties();
      emit(
        SocietyOperationSuccess(
          message: 'Society created successfully',
          societies: societies,
        ),
      );
    } on SocietyException catch (e) {
      emit(SocietyError(message: e.message));
    } catch (e) {
      emit(SocietyError(message: e.toString()));
    }
  }

  /// Handles updating an existing society
  Future<void> _onUpdateRequested(
    SocietyUpdateRequested event,
    Emitter<SocietyState> emit,
  ) async {
    emit(const SocietyOperationInProgress('Updating society...'));
    try {
      await _updateSociety(
        id: event.id,
        name: event.name,
        description: event.description,
        logoUrl: event.logoUrl,
        isPublic: event.isPublic,
        handicapLimitEnabled: event.handicapLimitEnabled,
        handicapMin: event.handicapMin,
        handicapMax: event.handicapMax,
        location: event.location,
        rules: event.rules,
      );

      // Reload societies after update
      final societies = await _getUserSocieties();
      emit(
        SocietyOperationSuccess(
          message: 'Society updated successfully',
          societies: societies,
        ),
      );
    } on SocietyException catch (e) {
      emit(SocietyError(message: e.message));
    } catch (e) {
      emit(SocietyError(message: e.toString()));
    }
  }

  /// Handles selecting a society
  void _onSocietySelected(SocietySelected event, Emitter<SocietyState> emit) {
    if (state is SocietyLoaded) {
      final currentState = state as SocietyLoaded;
      final selectedSociety = currentState.societies.firstWhere(
        (society) => society.id == event.societyId,
        orElse: () => currentState.societies.first,
      );

      // Only emit if a matching society was found
      if (currentState.societies.any((s) => s.id == event.societyId)) {
        emit(currentState.copyWith(selectedSociety: selectedSociety));
      }
    }
  }

  /// Handles clearing society selection
  void _onClearSelection(
    SocietyClearSelection event,
    Emitter<SocietyState> emit,
  ) {
    if (state is SocietyLoaded) {
      final currentState = state as SocietyLoaded;
      emit(currentState.copyWith(clearSelection: true));
    }
  }
}
