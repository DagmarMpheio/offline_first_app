import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

part 'cliente.g.dart';

@HiveType(typeId: 0)
class Cliente extends HiveObject {

  // ID usado no Firebase
  @HiveField(0)
  String id = const Uuid().v4();

  // Dados do cliente
  @HiveField(1)
  String nome;

  @HiveField(2)
  String telefone;

  // Controle de datas
  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  // Controle de sincronização
  @HiveField(5)
  bool isSynced;

  // Soft Delete
  @HiveField(6)
  bool isDeleted;


  Cliente({
    required this.nome,
    required this.telefone,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}