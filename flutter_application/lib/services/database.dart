import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userRef =
  FirebaseFirestore.instance.collection("users");

  Future register(String useranme, String password, String name,
      List<String> emergency_contacts, String phone_number) async {
    return await userRef.doc(uid).set({
      'username': useranme,
      'password': password,
      'name': name,
      'emergency_contacts': emergency_contacts,
      'phone_number': phone_number
    });
  }
}