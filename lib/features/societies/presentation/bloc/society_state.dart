import 'package:equatable/equatable.dart';
import '../../domain/entities/society.dart';

/// Base class for all society states
abstract class SocietyState extends Equatable {
  const SocietyState();

  @override
  List<Object?> get props => [];
}

/// Initial state when BLoC is created
class SocietyInitial extends SocietyState {
  const SocietyInitial();
}

/// State when loading societies
class SocietyLoading extends SocietyState {
  const SocietyLoading();
}

/// State when societies are loaded successfully
class SocietyLoaded extends SocietyState {
  final List<Society> societies;
  final Society? selectedSociety;

  const SocietyLoaded({required this.societies, this.selectedSociety});

  @override
  List<Object?> get props => [societies, selectedSociety];

  /// Creates a copy with optional field overrides
  SocietyLoaded copyWith({
    List<Society>? societies,
    Society? selectedSociety,
    bool clearSelection = false,
  }) {
    return SocietyLoaded(
      societies: societies ?? this.societies,
      selectedSociety: clearSelection
          ? null
          : (selectedSociety ?? this.selectedSociety),
    );
  }
}

/// State when a society operation is in progress
class SocietyOperationInProgress extends SocietyState {
  final String message;

  const SocietyOperationInProgress(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a society operation succeeds
class SocietyOperationSuccess extends SocietyState {
  final String message;
  final List<Society> societies;

  const SocietyOperationSuccess({
    required this.message,
    required this.societies,
  });

  @override
  List<Object?> get props => [message, societies];
}

/// State when an error occurs
class SocietyError extends SocietyState {
  final String message;
  final List<Society>? societies;

  const SocietyError({required this.message, this.societies});

  @override
  List<Object?> get props => [message, societies];
}
