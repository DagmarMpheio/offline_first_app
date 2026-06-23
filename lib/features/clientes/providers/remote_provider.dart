import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_app/features/clientes/data/remote/cliente_remote_datasource.dart';

// Provider para o ClienteRemoteDataSource, permitindo que ele seja injetado em outros lugares do aplicativo.
final clienteRemoteProvider =
    Provider<ClienteRemoteDataSource>(
  (ref) {
    return ClienteRemoteDataSource();
  },
);