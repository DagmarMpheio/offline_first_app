import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_app/core/database/hive_service.dart';
import 'package:offline_first_app/core/sync/sync_listener.dart';
import 'package:offline_first_app/features/clientes/presentation/pages/clientes_page.dart';
import 'package:offline_first_app/features/clientes/providers/sync_provider.dart';
import 'package:offline_first_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await HiveService.init();

  runApp(
    ProviderScope(
      child: SyncListener(child: AppInitializer(child: MyApp())),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline First',
      home: const ClientesPage(),
    );
  }
}

class AppInitializer extends ConsumerStatefulWidget {
  const AppInitializer({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<AppInitializer> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(syncServiceProvider).sync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
