import 'package:offline_first_app/features/clientes/data/local/cliente_local_datasource.dart';
import 'package:offline_first_app/features/clientes/data/models/cliente.dart';
import 'package:offline_first_app/features/clientes/data/remote/cliente_remote_datasource.dart';

class ClienteRepository {
  final ClienteLocalDataSource local;
  final ClienteRemoteDataSource remote;

  ClienteRepository({required this.local, required this.remote});

  /// CREATE
  Future<void> addCliente(Cliente cliente) async {
    await local.addCliente(cliente);
  }

  /// READ
  Future<List<Cliente>> getClientes() async {
    return local.getClientes();
  }

  /// STREAM
  Stream<List<Cliente>> watchClientes() {
    return local.watchClientes();
  }

  /// UPDATE
  Future<void> updateCliente(Cliente cliente) async {
    await local.updateCliente(cliente);
  }

  /// DELETE
  Future<void> deleteCliente(Cliente cliente) async {
    await local.deleteCliente(cliente);
  }

  /// Pendentes de sincronização
  Future<List<Cliente>> getPendingSync() {
    return local.getPendingSync();
  }

  /// Sincronização de um cliente específico
  Future<void> syncCliente(Cliente cliente) async {
    // Se o cliente estiver marcado como excluído, removemos do remoto e do local
    if (cliente.isDeleted) {
      // Remover o cliente do remoto
      await remote.deleteCliente(cliente.id);

      // Remover o cliente do local
      await cliente.delete();

      return;
    }
    
    // Se o cliente não estiver marcado como excluído, salvamos no remoto e actualizamos o status de sincronização
    await remote.saveCliente(cliente);

    // Actualizamos o status de sincronização no local
    cliente.isSynced = true;

    await cliente.save();
  }
  
  /// Sincroniza todos os clientes pendentes
  Future<void> syncPending() async {
    // Obter todos os clientes pendentes de sincronização
    final pendentes = await local.getPendingSync();

    // Sincronizar cada cliente pendente
    for (final cliente in pendentes) {
      await syncCliente(cliente);
    }
  }
}
