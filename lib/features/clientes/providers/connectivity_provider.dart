import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_app/core/connectivity/connectivity_service.dart';

final connectivityProvider =
    Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});