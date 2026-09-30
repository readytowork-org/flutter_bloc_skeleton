import 'package:equatable/equatable.dart';
import '../../../core/network/connectivity_service.dart';

class OptimizationState extends Equatable {
  final bool autoDownloadOnWifi;
  final bool dataSaverMode;
  final ConnectionStatus connectivityStatus;
  final bool isSyncing;

  const OptimizationState({
    this.autoDownloadOnWifi = true,
    this.dataSaverMode = false,
    this.connectivityStatus = ConnectionStatus.none,
    this.isSyncing = false,
  });

  OptimizationState copyWith({
    bool? autoDownloadOnWifi,
    bool? dataSaverMode,
    ConnectionStatus? connectivityStatus,
    bool? isSyncing,
  }) {
    return OptimizationState(
      autoDownloadOnWifi: autoDownloadOnWifi ?? this.autoDownloadOnWifi,
      dataSaverMode: dataSaverMode ?? this.dataSaverMode,
      connectivityStatus: connectivityStatus ?? this.connectivityStatus,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }

  @override
  List<Object?> get props => [
    autoDownloadOnWifi,
    dataSaverMode,
    connectivityStatus,
    isSyncing,
  ];
}
