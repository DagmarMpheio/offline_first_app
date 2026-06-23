import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

part 'cliente.g.dart';

@HiveType(typeId: 0)
class Cliente extends HiveObject {
  // ID usado no Firebase
  @HiveField(0)
  //String id = const Uuid().v4();
  String id;

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
    String? id,
    required this.nome,
    required this.telefone,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Converte o objeto Cliente para um Map<String, dynamic> para armazenamento no Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  // Cria uma instância de Cliente a partir de um Map<String, dynamic> obtido do Firebase
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
        nome: map['nome'] ?? '',
        telefone: map['telefone'] ?? '',
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
        isDeleted: map['isDeleted'] ?? false,
      )
      ..id = map['id']
      ..isSynced = true;
  }
}
