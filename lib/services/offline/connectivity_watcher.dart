import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// EAT-141 — thin wrapper over `connectivity_plus` that emits only the
/// offline→online edge. Used to trigger queue replay on reconnect.
class ConnectivityWatcher {
  ConnectivityWatcher._();
  static final ConnectivityWatcher instance = ConnectivityWatcher._();

  final Connectivity _connectivity = Connectivity();
  final StreamController<void> _restoredController =
      StreamController<void>.broadcast();

  bool _online = true;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  Stream<void> get onRestored => _restoredController.stream;
  bool get isOnline => _online;

  Future<void> start() async {
    if (_sub != null) return;
    final initial = await _connectivity.checkConnectivity();
    _online = _hasNetwork(initial);
    _sub = _connectivity.onConnectivityChanged.listen((results) {
      final now = _hasNetwork(results);
      if (!_online && now) {
        _restoredController.add(null);
      }
      _online = now;
    });
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    if (!_restoredController.isClosed) {
      await _restoredController.close();
    }
  }

  bool _hasNetwork(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);
  }
}
