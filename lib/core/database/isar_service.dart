import 'package:isar/isar.dart';
import 'package:offline_first_app/features/clientes/data/models/cliente.dart';
import 'package:path_provider/path_provider.dart';

// Serviço para gerenciar a base de dados Isar
class IsarService {

  // Instância da base de dados Isar
  static late Isar instance;

  // Método para inicializar a base de dados Isar
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    // Abrin a base de dados Isar com o esquema do Cliente
    instance = await Isar.open(
      [ClienteSchema],
      directory: dir.path, // Diretório onde os dados serão armazenados
      inspector:
          true, // Permite visualizar o base de dados Isar durante o desenvolvimento
    );
  }

  // Método para fechar a base de dados Isar
  static Future<void> close() async {
    await instance.close();
  }
}
