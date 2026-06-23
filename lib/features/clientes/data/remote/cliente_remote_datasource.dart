import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteRemoteDatasource {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  CollectionReference get _clientes =>
      firestore.collection("clientes");
}