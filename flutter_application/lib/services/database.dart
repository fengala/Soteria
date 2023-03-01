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

  Future addReplyToAPetition(String pid, String username, String reply) async {
    final pet = await getPet(pid);
    final list = List<Map>.from(pet['replies']);
    Map map = {
      'username': username,
      'replyText': reply,
      'time': DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now())
    };
    list.add(map);
    await petRef.doc(pid).update({'num_comments': FieldValue.increment(1)});
    await petRef.doc(pid).update({'replies': list});
  }
  // changed addPetition and made reply to petition


  Future getRepliesPet(String pid) async {
    final value = await petRef.doc(pid).get();
    // final Data = querySnapshot.docs.map((doc) => doc.data()).toList();
    final data = value.data() as Map<String, dynamic>;
    return data['replies'];
  }

  Future<bool> userUpvoteCheckPet(String pid, String uid, int change) async {
    final data = await getUser(uid);
    final list = List<String>.from(data['upvotedPetitions']);
    if (!list.contains(pid)) {
      if (change == 1) {
        list.add(pid);
        await userRef.doc(uid).update({'upvotedPetitions': list});
        await petRef.doc(pid).update({'num_upvotes': FieldValue.increment(1)});
      }
      return true;
    }
    if (change == 1) {
      list.remove(pid);
      await userRef.doc(uid).update({'upvotedPetitions': list});
      await petRef.doc(pid).update({'num_upvotes': FieldValue.increment(-1)});
    }
    return false;
  }

  Future<int> upvoteCountCheckPet(String pid) async {
    DocumentSnapshot snapshot = await petRef.doc(pid).get();
    Map<String, dynamic> data = snapshot.data();
    int numUpvotes = data['num_upvotes'];
    return numUpvotes;
  }


  /**
   * EVENTS
   */

  Future addEvent(String username, String title, String desc, String when) async {
    List<String> replies;
    return await FirebaseFirestore.instance.collection("Event").doc().set({
      'username': username,
      'title': title,
      'description': desc,
      'when': when,
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


  Future<bool> userUpvoteCheckEve(String eid, String uid, int change) async {
    final data = await getUser(uid);
    final list = List<String>.from(data['upvotedEvents']);
    if (!list.contains(eid)) {
      if (change == 1) {
        list.add(eid);
        await userRef.doc(uid).update({'upvotedEvents': list});
        await eveRef.doc(eid).update({'num_upvotes': FieldValue.increment(1)});
      }
      return true;
    }
    if (change == 1) {
      list.remove(eid);
      await userRef.doc(uid).update({'upvotedEvents': list});
      await eveRef.doc(eid).update({'num_upvotes': FieldValue.increment(-1)});
    }
    return false;
  }

  Future<int> upvoteCountCheckEve(String eid) async {
    DocumentSnapshot snapshot = await eveRef.doc(eid).get();
    Map<String, dynamic> data = snapshot.data();
    int numUpvotes = data['num_upvotes'];
    return numUpvotes;
  }

  Future<bool> userRSVPCheckEve(String eid, String uid) async {
    final data = await getUser(uid);
    final list = List<String>.from(data['RSVPEvents']);
    if (!list.contains(eid)) {
      list.add(eid);
      await userRef.doc(uid).update({'RSVPEvents': list});
      await eveRef.doc(eid).update({'num_rsvp': FieldValue.increment(1)});
      return true;
    }
    return false;
  }

  Future addReplyToAEvent(String eid, String username, String reply) async {
    final eve = await getEve(eid);
    final list = List<Map>.from(eve['replies']);
    Map map = {
      'username': username,
      'replyText': reply,
      'time': DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now())
    };
    list.add(map);
    await eveRef.doc(eid).update({'num_comments': FieldValue.increment(1)});
    await eveRef.doc(eid).update({'replies': list});
  }
  // changed addPetition and made reply to petition


  Future getRepliesEve(String eid) async {
    final value = await eveRef.doc(eid).get();
    final data = value.data() as Map<String, dynamic>;
    return data['replies'];
  }

  Future getEve(String eid) async {
    final value = await eveRef.doc(eid).get();
    final data = value.data() as Map<String, dynamic>;
    return data;
  }


}
