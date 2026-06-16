import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'cliente.g.dart';

// Modelo de dados do Cliente para a base de dados Isar
@collection
class Cliente {
  // ID interno do Isar
  Id isarId = Isar.autoIncrement;

  // ID universal usado no Firebase
  @Index(unique: true)
  String id = const Uuid().v4();

  // Dados do cliente
  late String nome;

  late String telefone;

  // Controle de datas
  DateTime createdAt = DateTime.now();

  DateTime updatedAt = DateTime.now();

  // Controle de sincronização
  @Index()
  bool isSynced = false;

  // Soft Delete
  @Index()
  bool isDeleted = false;
}
