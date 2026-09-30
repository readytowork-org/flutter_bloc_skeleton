import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectionStatus { wifi, cellular, none }

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _statusController = StreamController<ConnectionStatus>.broadcast();

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_emitStatus);
    // Initial check
    checkConnectivity();
  }

  Stream<ConnectionStatus> get statusStream => _statusController.stream;

  Future<ConnectionStatus> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    final status = _mapResultToStatus(result);
    _statusController.add(status);
    return status;
  }

  void _emitStatus(List<ConnectivityResult> results) {
    // connectivity_plus 6.0+ returns a list. We prioritize wifi > cellular > none.
    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      _statusController.add(ConnectionStatus.wifi);
    } else if (results.contains(ConnectivityResult.mobile)) {
      _statusController.add(ConnectionStatus.cellular);
    } else {
      _statusController.add(ConnectionStatus.none);
    }
  }

  ConnectionStatus _mapResultToStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      return ConnectionStatus.wifi;
    } else if (results.contains(ConnectivityResult.mobile)) {
      return ConnectionStatus.cellular;
    } else {
      return ConnectionStatus.none;
    }
  }

  void dispose() {
    _statusController.close();
  }
}
