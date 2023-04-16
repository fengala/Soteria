import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_ui/models/user.dart';
import 'package:flutter_login_ui/services/auth.dart';

import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;
  final String pid;
  final String eid;
  final String vid;
  final String nid;

  var safe_counts;
  // var safe_places
  DatabaseService({this.uid, this.pid, this.eid, this.vid, this.nid});

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference petRef =
      FirebaseFirestore.instance.collection("Petitions");
  final CollectionReference eveRef =
      FirebaseFirestore.instance.collection("Event");
  final CollectionReference venRef =
      FirebaseFirestore.instance.collection("SocialHouse");
  final CollectionReference revRef =
      FirebaseFirestore.instance.collection("reviews");
  final CollectionReference notRef =
    FirebaseFirestore.instance.collection("notifications");

  /**
   * USER
   */

  Future register(String username, String password, String name,
      emergency_contacts, String phone_number, bool remember) async {
    return await userRef.doc(uid).set({
      'username': username,
      'password': password,
      'name': name,
      'emergency_contacts': emergency_contacts,
      'phone_number': phone_number,
      'upvotedPetitions': [],
      'upvotedReviews': [],
      'remember': remember,
      'upvotedEvents': [],
      'RSVPEvents': [],
      'verified': false,
      'anon': false,
    });
  }

  Future updateUser(String username, String password, String name,
      emergency_contacts, String phone_number, bool anon) async {
    return await userRef.doc(uid).update({
      'username': username,
      'password': password,
      'name': name,
      'emergency_contacts': emergency_contacts,
      'phone_number': phone_number,
      'anon': anon,
    });
  }

  Future updateVerification(String uid) async {
    return await userRef.doc(uid).update({'verified': true});
  }

  Future updatePref(bool value, String uid) async {
    return await userRef.doc(uid).update({
      'remember': value,
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
    return await userRef.doc(uid).update({
      'password': password,
    });
  }

  /**
   * PETITIONS
   */

  Future addPetition(
      String username, String title, String descprition, String uid) async {
    List<String> replies;
    return await FirebaseFirestore.instance.collection("Petitions").doc().set({
      'username': username,
      'tile': title,
      'description': descprition,
      'num_upvotes': 0,
      'num_comments': 0,
      'replies': [],
      'time': DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now()),
      'userId': uid
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

  Future<bool> userVerCheck(String uid) async {
    //print(uid);
    final data = await getUser(uid);
    //print(uid);
    final flag = data['verified'] as bool;
    //print(flag);
    return flag;
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

  Future addEvent(String username, String title, String desc, String when,
      String form, String uid) async {
    List<String> replies;
    int hform;
    if (form.length > 0) {
      hform = 1;
    } else {
      hform = 0;
    }
    return await FirebaseFirestore.instance.collection("Event").doc().set({
      'username': username,
      'title': title,
      'description': desc,
      'when': when,
      'num_upvotes': 0,
      'num_comments': 0,
      'replies': [],
      'rsvp_form': form,
      'hasRSVP': hform,
      'time': DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now()),
      'userId': uid,
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
    if (list.contains(eid)) {
      return true;
    }
    return false;
  }

  Future<bool> addRSVPConfirm(String eid, String uid) async {
    final data = await getUser(uid);
    final list = List<String>.from(data['RSVPEvents']);
    if (!list.contains(eid)) {
      list.add(eid);
      await userRef.doc(uid).update({'RSVPEvents': list});
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

  Future getFormCheck(String eid, String uid) async {
    DocumentSnapshot snapshot = await eveRef.doc(eid).get();
    Map<String, dynamic> data = snapshot.data();
    String form = data['rsvp_form'];
    return form;
  }

  /**
   * Social Venues Backend
   */

  Future getPlaces() async {
    QuerySnapshot querySnapshot = await venRef.get();
    final Data = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      return {...data, 'id': id};
    }).toList();
    return Data;
  }

  Future getVenue(String social_venue_id) async {
    final value = await venRef.doc(social_venue_id).get();
    final data = value.data() as Map<String, dynamic>;
    return data;
  }

  Future getReviews(String str) async {
    QuerySnapshot querySnapshot =
        await revRef.where("ownerSocialHouse", isEqualTo: str).get();

    final Data = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      return {...data, 'id': id};
    }).toList();
    return Data;
  }

  Future getReviewsByStar(String str, int x) async {
    x++;
    QuerySnapshot querySnapshot = null;
    if (x != 4) {
      querySnapshot = await revRef
          .where("ownerSocialHouse", isEqualTo: str)
          .where("rating", isGreaterThanOrEqualTo: x)
          .where("rating", isLessThan: x + 1)
          .orderBy("rating", descending: true)
          .get();
    } else {
      querySnapshot = await revRef
          .where("ownerSocialHouse", isEqualTo: str)
          .where("rating", isGreaterThanOrEqualTo: x)
          .where("rating", isLessThanOrEqualTo: x + 1)
          .orderBy("rating", descending: true)
          .get();
    }
    final Data = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      return {...data, 'id': id};
    }).toList();
    return Data;
  }

  Future addReviewToVenue(String social_venue_id, String username,
      String review, bool anonymous, String uid, double rating) async {
    if (review.length != 0) {
      await venRef
          .doc(social_venue_id)
          .update({'num_comments': FieldValue.increment(1)});
    }

    DocumentSnapshot snapshot = await venRef.doc(social_venue_id).get();
    Map<String, dynamic> data = snapshot.data();
    num rate = data['num_rating'];
    num ppl = data['num_reviews'];
    num x = (((rate * ppl) + rating) / (ppl + 1)) - rate;

    await venRef
        .doc(social_venue_id)
        .update({'num_rating': FieldValue.increment(x)});
    await venRef
        .doc(social_venue_id)
        .update({'num_reviews': FieldValue.increment(1)});

    return await FirebaseFirestore.instance.collection("reviews").doc().set({
      'username': username,
      'description': review,
      'rating': rating,
      'num_upvotes': 0,
      'num_comments': 0,
      'replies': [],
      'time': DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now()),
      'userId': uid,
      'anonynmous': anonymous,
      'ownerSocialHouse': social_venue_id
    });
  }

  Future<bool> userUpvoteCheckReview(String pid, String uid, int change) async {
    final data = await getUser(uid);
    final list = List<String>.from(data['upvotedReviews']);
    if (!list.contains(pid)) {
      if (change == 1) {
        list.add(pid);
        await userRef.doc(uid).update({'upvotedReviews': list});
        await revRef.doc(pid).update({'num_upvotes': FieldValue.increment(1)});
      }
      return true;
    }
    if (change == 1) {
      list.remove(pid);
      await userRef.doc(uid).update({'upvotedReviews': list});
      await revRef.doc(pid).update({'num_upvotes': FieldValue.increment(-1)});
    }
    return false;
  }

  Future getRepliesRev(String eid) async {
    final value = await revRef.doc(eid).get();
    final data = value.data() as Map<String, dynamic>;
    return data['replies'];
  }

  Future getReview(String eid) async {
    final value = await revRef.doc(eid).get();
    final data = value.data() as Map<String, dynamic>;
    return data;
  }

  Future addReplyToAReview(String eid, String username, String reply) async {
    final eve = await getReview(eid);
    final list = List<Map>.from(eve['replies']);
    Map map = {
      'username': username,
      'replyText': reply,
      'time': DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now())
    };
    list.add(map);
    await revRef.doc(eid).update({'num_comments': FieldValue.increment(1)});
    await revRef.doc(eid).update({'replies': list});
  }

  Future getFilteredReviews(String str) async {
    revRef.where("ownerSocialHouse", isEqualTo: str);

    QuerySnapshot querySnapshot =
        await revRef.where("ownerSocialHouse", isEqualTo: str).get();
    final Data = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      return {...data, 'id': id};
    }).toList();
    return Data;
  }

  Future getUserRating(String placeId, String userId) async {
    revRef
        .where("ownerSocialHouse", isEqualTo: placeId)
        .where("userId", isEqualTo: userId);

    QuerySnapshot querySnapshot = await revRef
        .where("ownerSocialHouse", isEqualTo: placeId)
        .where("userId", isEqualTo: userId)
        .get();

    final Data = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      num rating = data['rating'];
      return rating;
    }).toList();

    return Data;
  }

  /**
   * NOTIFICATIONS
   */

  Future getNotifs(String uid) async {
    QuerySnapshot querySnapshot = await
                        notRef.where("uid", isEqualTo: uid).get();
    final Data = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      return {...data, 'id': id};
    }).toList();
    return Data;
  }

  Future addNotif(String rid) async {
    final value = await revRef.doc(rid).get();
    final data = value.data() as Map<String, dynamic>;
    String usid = data["userId"];
    String socialHouseId = data["ownerSocialHouse"];

    final valueven = await venRef.doc(socialHouseId).get();
    final dataven = valueven.data() as Map<String, dynamic>;
    String name = dataven["title"];

    String message = "You have a new reply to your review of the venue $name";

    return await FirebaseFirestore.instance.collection("notifications").doc().set({
      'uid': usid,
      'text': message,
      'time': DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now()),
    });
  }

  Future removeNotif(String nid) async {
    return await notRef.doc(nid).delete();
  }

}
