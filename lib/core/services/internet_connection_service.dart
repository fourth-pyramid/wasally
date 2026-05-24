import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

enum NetworkState { connected, unstable, disconnected }

class NetworkConfig {
  static const int pingIntervalSeconds = 5;
  static const int slowPingThresholdMs = 450;      // Socket ping
  static const int slowDioThresholdMs = 2800;      // HTTP requests
  static const int maxSlowHits = 3;
}

class InternetConnectionService {
  InternetConnectionService();

  final InternetConnection internetConnection = InternetConnection();

  final StreamController<NetworkState> _stateController =
  StreamController<NetworkState>.broadcast();

  final StreamController<void> _connectivityRestoredController =
  StreamController<void>.broadcast();

  Stream<NetworkState> get stateStream => _stateController.stream;
  Stream<void> get connectivityRestoredStream => _connectivityRestoredController.stream;

  NetworkState _currentState = NetworkState.connected;
  bool _isConnected = true;
  Timer? _pingTimer;

  int _slowHits = 0;

  // Public API
  Future<bool> hasConnection() => internetConnection.hasInternetAccess;

  bool get isStable => _currentState == NetworkState.connected;
  NetworkState get currentState => _currentState;

  void updateStatus(bool isConnected) {
    if (_isConnected == isConnected) return;

    _isConnected = isConnected;
    _slowHits = 0;

    if (!isConnected) {
      stopPingCheck();
      _emit(NetworkState.disconnected);
    } else {
      _connectivityRestoredController.add(null);
      _emit(NetworkState.connected);
      startPingCheck();
    }
  }

  void reportLatency(int ms) {
    if (!_isConnected) return;
    _handleLatencyResult(ms >= NetworkConfig.slowDioThresholdMs);
  }

  void startPingCheck() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(
      const Duration(seconds: NetworkConfig.pingIntervalSeconds),
          (_) => _ping(),
    );
    _ping(); // Immediate check
  }

  void stopPingCheck() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  Future<void> checkNow() => _ping();

  void dispose() {
    _stateController.close();
    _connectivityRestoredController.close();
    stopPingCheck();
  }

  // Internals
  void _handleLatencyResult(bool isSlow) {
    if (!_isConnected) return;

    if (isSlow) {
      _slowHits++;
      if (_slowHits >= NetworkConfig.maxSlowHits) {
        _emit(NetworkState.unstable);
      }
    } else {
      _slowHits = 0;
      if (_currentState != NetworkState.connected) {
        _emit(NetworkState.connected);
      }
    }
  }

  void _emit(NetworkState state) {
    if (_currentState == state) return;
    _currentState = state;
    debugPrint('[Network] State → $state');
    _stateController.add(state);
  }

  Future<void> _ping() async {
    if (!_isConnected) return;

    try {
      final sw = Stopwatch()..start();

      final socket = await Socket.connect(
        '1.1.1.1',
        53,
        timeout: const Duration(seconds: 2),
      );

      sw.stop();
      socket.destroy();

      if (!_isConnected) return;

      debugPrint('[Network] Ping ${sw.elapsedMilliseconds}ms');
      _handleLatencyResult(sw.elapsedMilliseconds >= NetworkConfig.slowPingThresholdMs);
    } catch (_) {
      if (!_isConnected) return;
      debugPrint('[Network] Ping failed');
      _handleLatencyResult(true);
    }
  }
}