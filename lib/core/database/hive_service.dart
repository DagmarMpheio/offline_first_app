import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:offline_first_app/features/clientes/data/models/cliente.dart';

class HiveService {
  // Nome da Box
  static const String clienteBoxName = 'clientes';

  // Instância da Box
  static late Box<Cliente> clientesBox;

  // Inicializa o Hive
  static Future<void> init() async {
    // Inicializa o Hive para Flutter
    await Hive.initFlutter();

    // Registra o Adapter gerado
    Hive.registerAdapter(ClienteAdapter());

    // Abre a Box de clientes
    clientesBox = await Hive.openBox<Cliente>(
      clienteBoxName,
    );
  }

  // Fecha todas as Boxes
  static Future<void> close() async {
    await Hive.close();
  }
}