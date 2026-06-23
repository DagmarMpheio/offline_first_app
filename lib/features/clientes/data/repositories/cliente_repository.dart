import 'package:offline_first_app/features/clientes/data/local/cliente_local_datasource.dart';
import 'package:offline_first_app/features/clientes/data/models/cliente.dart';
import 'package:offline_first_app/features/clientes/data/remote/cliente_remote_datasource.dart';

class ClienteRepository {
  final ClienteLocalDataSource local;
  final ClienteRemoteDataSource remote;

  ClienteRepository({
    required this.local,
    required this.remote,
  });

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
  Future<void> updateCliente(
    Cliente cliente,
  ) async {
    await local.updateCliente(cliente);
  }

  /// DELETE
  Future<void> deleteCliente(
    Cliente cliente,
  ) async {
    await local.deleteCliente(cliente);
  }

  /// Pendentes de sincronização
  Future<List<Cliente>> getPendingSync() {
    return local.getPendingSync();
  }
}