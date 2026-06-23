import 'dart:developer';

import 'package:offline_first_app/features/clientes/data/models/cliente.dart';
import 'package:offline_first_app/features/clientes/data/repositories/cliente_repository.dart';

class SyncService {
  final ClienteRepository repository;

  bool _isSyncing = false;

  SyncService(this.repository);

  bool get isSyncing => _isSyncing;

  Future<void> sync() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      await repository.syncPending();

      log('Sincronização concluída');
    } catch (e) {
      log('Erro de sincronização: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
