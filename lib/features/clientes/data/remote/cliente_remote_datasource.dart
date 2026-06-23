import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offline_first_app/features/clientes/data/models/cliente.dart';

class ClienteRemoteDataSource {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _clientes =>
          _firestore.collection('clientes');

  /// CREATE / UPDATE
  Future<void> saveCliente(
    Cliente cliente,
  ) async {
    await _clientes
        .doc(cliente.id)
        .set(cliente.toMap());
  }

  /// DELETE
  Future<void> deleteCliente(
    String id,
  ) async {
    await _clientes.doc(id).delete();
  }

  /// GET ALL
  Future<List<Cliente>> getClientes() async {
    final snapshot =
        await _clientes.get();

    return snapshot.docs
        .map(
          (doc) =>
              Cliente.fromMap(doc.data()),
        )
        .toList();
  }
}