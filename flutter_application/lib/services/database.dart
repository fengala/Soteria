import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference petRef =
      FirebaseFirestore.instance.collection("Petitions");

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

  Future addPetition(String username, String title, String descprition) async {
    List<String> replies;
    return await FirebaseFirestore.instance.collection("Petitions").doc().set({
      'username': username,
      'tile': title,
      'description': descprition,
      'num_upvotes': 0,
      'num_comments': 0,
      'replies': replies,
      'time': DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now())
    });
  }

  Future getPetitions() async {
    QuerySnapshot querySnapshot = await petRef.get();
    // final Dataa = querySnapshot.docs.map((doc) => doc.data()).toList();
    final Dataa = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      return {...data, 'id': id};
    }).toList();
    return Dataa;
  }
}
