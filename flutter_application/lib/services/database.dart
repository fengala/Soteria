import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_ui/models/user.dart';
import 'package:flutter_login_ui/services/auth.dart';

import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;
  final String pid;
  final String eid;
  DatabaseService({this.uid, this.pid, this.eid});

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference petRef =
      FirebaseFirestore.instance.collection("Petitions");
  final CollectionReference eveRef =
      FirebaseFirestore.instance.collection("Event");

  /**
   * USER
   */

  Future register(String username, String password, String name,
      emergency_contacts, String phone_number) async {
    return await userRef.doc(uid).set({
      'username': username,
      'password': password,
      'name': name,
      'emergency_contacts': emergency_contacts,
      'phone_number': phone_number,
      'upvotedPetitions': []
    });
  }

  Future updateUser(String username, String password, String name,
      emergency_contacts, String phone_number) async {
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

    return data;
  }

  Future<bool> userUpvoteCheck(String pid, String uid, int change) async {
    // Map person = getUser(uid) as Map;
    final data = await getUser(uid);
    // final upvotedPetitions = List<String>.from(userData['upvotedPetitions']);
    final list = List<String>.from(data['upvotedPetitions']);
    if (!list.contains(pid)) {
      // print("Doesnt't contain");
      if (change == 1) {
        // print(list);
        list.add(pid);
        await userRef.doc(uid).update({'upvotedPetitions': list});
        await petRef.doc(pid).update({'num_upvotes': FieldValue.increment(1)});
      }
      return true;
    }
    //print(list);
    if (change == 1) {
      list.remove(pid);
      await userRef.doc(uid).update({'upvotedPetitions': list});
      await petRef.doc(pid).update({'num_upvotes': FieldValue.increment(-1)});
    }
    // print("Contains");
    return false;
    // print(uid);
    // print(list);
    // print(data['username']);
    // print(pid);
    // return true;
  }

  Future<int> upvoteCountCheck(String pid) async {
    // await petRef.doc(pid).update({'num_upvotes': FieldValue.increment(1)});
    // await petRef.doc(pid).get({'num_upvotes'});
    // print("Contains");
    DocumentSnapshot snapshot = await petRef.doc(pid).get();
    Map<String, dynamic> data = snapshot.data();
    int numUpvotes = data['num_upvotes'];
    return numUpvotes;
  }

  Stream<QuerySnapshot> get User {
    return userRef.snapshots();
  }

  Future resetPassword(String password) async {
    return await userRef.doc(uid).set({
      'password': password,
    });
  }

  /**
   * PETITIONS
   */

  Future addPetition(String username, String title, String descprition) async {
    List<String> replies;
    return await FirebaseFirestore.instance.collection("Petitions").doc().set({
      'username': username,
      'tile': title,
      'description': descprition,
      'num_upvotes': 0,
      'num_comments': 0,
      'replies': [],
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

  Future updatePet(String username, String title, String descprition,
      String upvotes, String comments, List<String> replies) async {
    return await petRef.doc(pid).set({
      'username': username,
      'tile': title,
      'description': descprition,
      'num_upvotes': upvotes,
      'num_comments': comments,
      'replies': replies,
    });
  }

  Future getPet(String pid) async {
    final value = await petRef.doc(pid).get();
    final data = value.data() as Map<String, dynamic>;
    return data;
  }

  /**
   * EVENTS
   */

  Future addEvent(String username, String title, String descprition) async {
    List<String> replies;
    return await FirebaseFirestore.instance.collection("Event").doc().set({
      'username': username,
      'tile': title,
      'description': descprition,
      'num_upvotes': 0,
      'num_comments': 0,
      'replies': replies,
      'time': DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now())
    });
  }

  Future getEvents() async {
    QuerySnapshot querySnapshot = await eveRef.get();
    final Data = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      return {...data, 'id': id};
    }).toList();
    return Data;
  }

  Future getEvent(String eid) async {
    final value = await eveRef.doc(eid).get();
    final data = value.data() as Map<String, dynamic>;
    return data;
  }

  Future addReplyToAPetition(String pid, String username, String reply) async {
    final pet = await getPet(pid);
    final list = List<Map>.from(pet['replies']);
    Map map = {
      'username': username,
      'replyText': reply,
      'time': DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now())
    };
    list.add(map);
    await petRef.doc(pid).update({'replies': list});
  }

  // changed addPetition and made reply to petition

  Future getReplies(String pid) async {
    final value = await petRef.doc(pid).get();
    // final Dataa = querySnapshot.docs.map((doc) => doc.data()).toList();
    final data = value.data() as Map<String, dynamic>;
    print(data['replies']);
    return data['replies'];
  }
}
