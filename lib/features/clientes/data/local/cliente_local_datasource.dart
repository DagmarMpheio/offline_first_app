import 'package:hive_ce/hive.dart';
import 'package:offline_first_app/core/database/hive_service.dart';
import 'package:offline_first_app/features/clientes/data/models/cliente.dart';

class ClienteLocalDataSource {
  final Box<Cliente> _box = HiveService.clientesBox;

  /// CREATE
  Future<void> addCliente(Cliente cliente) async {
    await _box.put(cliente.id, cliente);
  }

  /// READ
  Future<List<Cliente>> getClientes() async {
    return _box.values.where((cliente) => !cliente.isDeleted).toList();
  }

  /// READ - Escuta alterações em tempo real
  Stream<List<Cliente>> watchClientes() async* {
    // 1. Emite estado inicial
    yield _box.values.where((cliente) => !cliente.isDeleted).toList();

    // 2. Depois escuta mudanças
    yield* _box.watch().map((event) {
      return _box.values.where((cliente) => !cliente.isDeleted).toList();
    });
  }

  /// UPDATE
  Future<void> updateCliente(Cliente cliente) async {
    cliente.updatedAt = DateTime.now();
    cliente.isSynced = false;

    await cliente.save();
  }

  /// DELETE (Soft Delete)
  Future<void> deleteCliente(Cliente cliente) async {
    cliente.isDeleted = true;
    cliente.updatedAt = DateTime.now();
    cliente.isSynced = false;

    await cliente.save();
  }

  /// Busca registros pendentes de sincronização
  Future<List<Cliente>> getPendingSync() async {
    return _box.values.where((cliente) => !cliente.isSynced).toList();
  }
}
