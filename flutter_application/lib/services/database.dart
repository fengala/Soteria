import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import './auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");

  Future register(String username, String password, String name,
      List<String> emergency_contacts, String phone_number) async {
    return await userRef.doc(uid).set({
      'username': username,
      'password': password,
      'name': name,
      'emergency_contacts': emergency_contacts,
      'phone_number': phone_number
    });
  }

  Future updateUser(String username, String password, String name,
      List<String> emergency_contacts, String phone_number) async {
    return await userRef.doc(uid).set({
      'username': username,
      'password': password,
      'name': name,
      'emergency_contacts': emergency_contacts,
      'phone_number': phone_number
    });
  }

  Future getUser(String uid) async {
    final value = await userRef.doc(uid).get();

    final data = value.data() as Map<String, dynamic>;

    /* UserModel user = new UserModel(
        uid,
        data['name'] as String,
        data['username'] as String,
        data['password'] as String,
        data['emergency_contacts'] as List<String>,
        data['phone_number'] as String);
    return user;
    */
    return data;
  }

  Stream<QuerySnapshot> get User {
    return userRef.snapshots();
  }
}
