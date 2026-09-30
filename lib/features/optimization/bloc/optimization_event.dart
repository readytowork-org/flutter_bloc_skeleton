import 'package:equatable/equatable.dart';
import '../../../core/network/connectivity_service.dart';

abstract class OptimizationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOptimizationSettings extends OptimizationEvent {}

class UpdateConnectivityStatus extends OptimizationEvent {
  final ConnectionStatus status;
  UpdateConnectivityStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class ToggleAutoDownloadOnWifi extends OptimizationEvent {
  final bool value;
  ToggleAutoDownloadOnWifi(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleDataSaverMode extends OptimizationEvent {
  final bool value;
  ToggleDataSaverMode(this.value);

  @override
  List<Object?> get props => [value];
}
