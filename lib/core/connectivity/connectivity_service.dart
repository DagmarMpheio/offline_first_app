import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Serviço para monitorar a conectividade da rede
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Stream que emite um valor booleano indicando se a conexão foi restaurada
  Stream<bool> get onConnectionRestored {
    return _connectivity.onConnectivityChanged.map(
      (results) => results.isNotEmpty &&
          !results.contains(ConnectivityResult.none),
    );
  }

  /// Verifica se o dispositivo está conectado à internet
  Future<bool> isConnected() async {
    final results =
        await _connectivity.checkConnectivity();

    return results.isNotEmpty &&
        !results.contains(ConnectivityResult.none);
  }
}