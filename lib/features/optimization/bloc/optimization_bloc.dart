import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/storage/optimization_service.dart';
import 'optimization_event.dart';
import 'optimization_state.dart';

class OptimizationBloc extends Bloc<OptimizationEvent, OptimizationState> {
  final OptimizationService _optimizationService;
  final ConnectivityService _connectivityService;
  StreamSubscription? _connectivitySubscription;

  OptimizationBloc({
    required OptimizationService optimizationService,
    required ConnectivityService connectivityService,
  }) : _optimizationService = optimizationService,
       _connectivityService = connectivityService,
       super(const OptimizationState()) {
    on<LoadOptimizationSettings>(_onLoadSettings);
    on<UpdateConnectivityStatus>(_onUpdateConnectivity);
    on<ToggleAutoDownloadOnWifi>(_onToggleAutoDownload);
    on<ToggleDataSaverMode>(_onToggleDataSaver);

    _connectivitySubscription = _connectivityService.statusStream.listen((
      status,
    ) {
      add(UpdateConnectivityStatus(status));
    });

    add(LoadOptimizationSettings());
  }

  Future<void> _onLoadSettings(
    LoadOptimizationSettings event,
    Emitter<OptimizationState> emit,
  ) async {
    final status = await _connectivityService.checkConnectivity();
    emit(
      state.copyWith(
        autoDownloadOnWifi: _optimizationService.autoDownloadOnWifi,
        dataSaverMode: _optimizationService.dataSaverMode,
        connectivityStatus: status,
      ),
    );
  }

  void _onUpdateConnectivity(
    UpdateConnectivityStatus event,
    Emitter<OptimizationState> emit,
  ) {
    emit(state.copyWith(connectivityStatus: event.status));
  }

  Future<void> _onToggleAutoDownload(
    ToggleAutoDownloadOnWifi event,
    Emitter<OptimizationState> emit,
  ) async {
    await _optimizationService.setAutoDownloadOnWifi(event.value);
    emit(state.copyWith(autoDownloadOnWifi: event.value));
  }

  Future<void> _onToggleDataSaver(
    ToggleDataSaverMode event,
    Emitter<OptimizationState> emit,
  ) async {
    await _optimizationService.setDataSaverMode(event.value);
    emit(state.copyWith(dataSaverMode: event.value));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
