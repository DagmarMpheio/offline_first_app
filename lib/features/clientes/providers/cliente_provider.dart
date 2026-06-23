import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_app/features/clientes/data/local/cliente_local_datasource.dart';
import 'package:offline_first_app/features/clientes/data/models/cliente.dart';
import 'package:offline_first_app/features/clientes/data/repositories/cliente_repository.dart';
import 'package:offline_first_app/features/clientes/providers/repository_provider.dart';

// Provider para o ClienteLocalDataSource, permitindo que seja injetado em diferentes partes da app.
final clienteLocalProvider = Provider<ClienteLocalDataSource>((ref) {
  return ClienteLocalDataSource();
});

// Provider para escutar alterações na lista de clientes em tempo real.
/* final clientesProvider = StreamProvider((ref) {
  final datasource = ref.watch(clienteLocalProvider);

  return datasource.watchClientes();
}); */

final clientesProvider = StreamProvider<List<Cliente>>((ref) {
  return ref.watch(clienteRepositoryProvider).watchClientes();
});

// Provider para o ClienteNotifier, que gerencia operações de CRUD e sincronização de clientes.
/* final clienteNotifierProvider =
    Provider<ClienteNotifier>((ref) {
  return ClienteNotifier(
    ref.watch(clienteLocalProvider),
  );
}); */

final clienteNotifierProvider = Provider<ClienteNotifier>((ref) {
  return ClienteNotifier(ref.watch(clienteRepositoryProvider));
});

// Classe responsável por gerenciar operações de CRUD e sincronização de clientes.
/* class ClienteNotifier {
  final ClienteLocalDataSource _datasource;

  ClienteNotifier(this._datasource);

  Future<void> add(Cliente cliente) async {
    await _datasource.addCliente(cliente);
  }

  Future<void> update(Cliente cliente) async {
    await _datasource.updateCliente(cliente);
  }

  Future<void> delete(Cliente cliente) async {
    await _datasource.deleteCliente(cliente);
  }
} */

class ClienteNotifier {
  final ClienteRepository repository;

  ClienteNotifier(this.repository);

  Future<void> add(Cliente cliente) async {
    await repository.addCliente(cliente);
  }

  Future<void> update(Cliente cliente) async {
    await repository.updateCliente(cliente);
  }

  Future<void> delete(Cliente cliente) async {
    await repository.deleteCliente(cliente);
  }
}
