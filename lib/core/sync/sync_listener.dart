import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_app/features/clientes/providers/connectivity_provider.dart';
import 'package:offline_first_app/features/clientes/providers/sync_provider.dart';

class SyncListener extends ConsumerStatefulWidget {
  final Widget child;

  const SyncListener({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<SyncListener> createState() =>
      _SyncListenerState();
}

class _SyncListenerState
    extends ConsumerState<SyncListener> {

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _startListening();
    });
  }

  void _startListening() {
    final connectivity =
        ref.read(connectivityProvider);

    _subscription =
        connectivity.onConnectionRestored.listen(
      (connected) async {

        if (!connected) return;

        await ref
            .read(syncServiceProvider)
            .sync();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}