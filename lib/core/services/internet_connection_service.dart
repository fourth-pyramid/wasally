import '../imports/imports.dart';

class InternetConnectionService {
  InternetConnectionService();

  final InternetConnection internetConnection = InternetConnection();

  // Stream that emits whenever internet connectivity is restored
  final StreamController<void> _connectivityRestoredController =
      StreamController<void>.broadcast();

  Stream<void> get connectivityRestoredStream =>
      _connectivityRestoredController.stream;

  bool _lastStatus = true;

  void notifyRestored() {
    _connectivityRestoredController.add(null);
  }

  void updateStatus(bool isConnected) {
    if (!_lastStatus && isConnected) {
      notifyRestored();
    }
    _lastStatus = isConnected;
  }

  Future<bool> hasConnection() async =>
      await internetConnection.hasInternetAccess;

  void dispose() {
    _connectivityRestoredController.close();
  }
}
