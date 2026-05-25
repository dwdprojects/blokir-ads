import 'package:equatable/equatable.dart';
import '../../domain/entities/blocker_status_entity.dart';

abstract class AdBlockerState extends Equatable {
  const AdBlockerState();

  @override
  List<Object?> get props => [];
}

class AdBlockerInitial extends AdBlockerState {
  const AdBlockerInitial();
}

class AdBlockerLoading extends AdBlockerState {
  const AdBlockerLoading();
}

class AdBlockerActive extends AdBlockerState {
  const AdBlockerActive({required this.status});

  final BlockerStatusEntity status;

  @override
  List<Object?> get props => [status];
}

class AdBlockerInactive extends AdBlockerState {
  const AdBlockerInactive({required this.status});

  final BlockerStatusEntity status;

  @override
  List<Object?> get props => [status];
}

class AdBlockerError extends AdBlockerState {
  const AdBlockerError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class AdBlockerPermissionRequired extends AdBlockerState {
  const AdBlockerPermissionRequired();
}
