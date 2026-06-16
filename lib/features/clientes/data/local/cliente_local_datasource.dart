import 'package:isar/isar.dart';
import 'package:offline_first_app/core/database/isar_service.dart';
import 'package:offline_first_app/features/clientes/data/models/cliente.dart';

// Classe responsável por gerenciar o acesso local aos dados de clientes usando o Isar como base de dados local.
class ClienteLocalDataSource {
  // Instância do IsarService para interagir com a base de dados local.
  final Isar _isar = IsarService.instance;

  /// CREATE
  Future<void> addCliente(Cliente cliente) async {
    await _isar.writeTxn(() async {
      await _isar.clientes.put(cliente);
    });
  }

  /// READ - Lista todos os clientes activos
  Future<List<Cliente>> getClientes() async {
    return await _isar.clientes.filter().isDeletedEqualTo(false).findAll();
  }

  /// READ - Escuta alterações em tempo real
  Stream<List<Cliente>> watchClientes() {
    return _isar.clientes.where().watch(fireImmediately: true);
  }

  /// UPDATE
  Future<void> updateCliente(Cliente cliente) async {
    cliente.updatedAt = DateTime.now();
    cliente.isSynced = false;

    await _isar.writeTxn(() async {
      await _isar.clientes.put(cliente);
    });
  }

  /// DELETE (Soft Delete)
  Future<void> deleteCliente(Cliente cliente) async {
    cliente.isDeleted = true;
    cliente.updatedAt = DateTime.now();
    cliente.isSynced = false;

    await _isar.writeTxn(() async {
      await _isar.clientes.put(cliente);
    });
  }

  /// Buscar clientes pendentes de sincronização
  Future<List<Cliente>> getPendingSync() async {
    return await _isar.clientes.filter().isSyncedEqualTo(false).findAll();
  }
}
