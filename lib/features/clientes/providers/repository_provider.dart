import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_app/features/clientes/data/local/cliente_local_datasource.dart';
import 'package:offline_first_app/features/clientes/data/remote/cliente_remote_datasource.dart';
import 'package:offline_first_app/features/clientes/data/repositories/cliente_repository.dart';

final clienteRepositoryProvider =
    Provider<ClienteRepository>((ref) {
  return ClienteRepository(
    local: ClienteLocalDataSource(),
    remote: ClienteRemoteDataSource(),
  );
});