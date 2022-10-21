import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  late ConnectivityResult _crState;

  void startService() {
    Connectivity().onConnectivityChanged.listen((event) {
      if (_crState == event) return;

      _crState = event;
      String description = 'Network is connected.';
      if (event == ConnectivityResult.none) {
        description = 'Network was lost.';
      }

      //TODO: Replace by Overlay Support
      // GetService().topScaffold?.currentState?.showCSSnackBar(description);
    });
  }
}
