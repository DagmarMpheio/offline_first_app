import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_app/core/sync/sync_service.dart';
import 'package:offline_first_app/features/clientes/providers/repository_provider.dart';

final syncServiceProvider =
    Provider<SyncService>((ref) {
  return SyncService(
    ref.watch(
      clienteRepositoryProvider,
    ),
  );
});