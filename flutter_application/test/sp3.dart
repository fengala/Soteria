import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([_mockUser]);
  }
}

class MockPetRef extends Mock implements DatabaseService {
  @override
  Future<DocumentSnapshot> getPet(String pid) async {
    final DocumentSnapshot snapshot = await petRef.doc(pid).get();
    return snapshot;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUp(() => null);
  tearDown(() => null);

  // print("#########################");
  // print("#  User Story #2 Tests  #");
  // print("#########################");
  // print("");
  group('User Story #2 tests', () {
    test("Getting Notifications", () async {
      var instance = FakeFirebaseFirestore();
      var id = "4S0EXFVs6DYCBEd0vB6N";
      var text =
          "You have a new reply to your review of the venue Pi Kappa Phi";
      var time = "04/18/2023 10:50 PM";
      var recipient_id = "receiver_id1";
      instance
          .collection("notifications")
          .doc(id)
          .set({'text': text, 'time': time, 'uid': recipient_id});

      var snapshot = await instance.collection("notifications").doc(id).get();
      Map<String, dynamic> data = await snapshot.data();
      expect(data['text'], text);
      print("Test Passed");
    });

    test("Getting Notifications", () async {
      var instance = FakeFirebaseFirestore();
      var id = "reciever";
      var time = "04/18/2023 10:50 PM";
      var recipient_id = "id107";
      var text = "Reply to $recipient_id";
      instance
          .collection("notifications")
          .doc(id)
          .set({'text': text, 'time': time, 'uid': recipient_id});

      var snapshot = await instance.collection("notifications").doc(id).get();
      Map<String, dynamic> data = await snapshot.data();
      expect(data['uid'], recipient_id);
      print("Test Passed");
    });

    // test("Empty Emergency Contacts Checking", () async {
    //   var instance = FakeFirebaseFirestore();
    //   var uid = "OUSN107";
    //   var contact1 = "3210213921";
    //   var contact2 = "";
    //   var contact3 = "5210232311";
    //   instance.collection("users").doc(uid).set({
    //     'username': "test_user@purdue.edu",
    //     'password': "123456",
    //     'name': "Test testing",
    //     'emergency_contacts': [contact1, contact2, contact3],
    //     'phone_number': "1232323132",
    //     'verified': true,
    //   });

    //   var snapshot = await instance.collection("users").doc(uid).get();
    //   Map<String, dynamic> data = await snapshot.data();
    //   expect(data['emergency_contacts'].length, 3);
    //   expect(data['emergency_contacts'][0], contact1);
    //   expect(data['emergency_contacts'][1], contact2);
    //   expect(data['emergency_contacts'][2], contact3);
    //   print("Test Passed");
    // });
  });

  // print("#########################");
  // print("#  User Story #3 Tests  #");
  // print("#########################");
  // print("");
  group('User Story #3 tests', () {
    test("Verified Users Check", () async {
      var instance = FakeFirebaseFirestore();
      var uid1 = "1";
      var name1 = "User1";
      var email1 = "user1@gmail.com";
      var verified1 = true;
      instance
          .collection("users")
          .doc(uid1)
          .set({'name': name1, 'email': email1, 'verified': verified1});
      var snapshot1 = await instance.collection("users").doc(uid1).get();
      Map<String, dynamic> data1 = await snapshot1.data();

      var uid2 = "2";
      var name2 = "User2";
      var email2 = "user2@gmail.com";
      var verified2 = false;
      instance
          .collection("users")
          .doc(uid2)
          .set({'name': name2, 'email': email2, 'verified': verified2});
      var snapshot2 = await instance.collection("users").doc(uid2).get();
      Map<String, dynamic> data2 = await snapshot2.data();

      var uid3 = "3";
      var name3 = "User3";
      var email3 = "user3@gmail.com";
      var verified3 = true;
      instance
          .collection("users")
          .doc(uid3)
          .set({'name': name3, 'email': email3, 'verified': verified3});
      var snapshot3 = await instance.collection("users").doc(uid3).get();
      Map<String, dynamic> data3 = await snapshot3.data();

      expect(data1['verified'], verified1);
      expect(data2['verified'], verified2);
      expect(data3['verified'], verified3);
      print("Test Passed");
    });

    test("Filer to show only verified users", () async {
      var instance = FakeFirebaseFirestore();
      var uid1 = "1";
      var name1 = "User1";
      var email1 = "user1@gmail.com";
      var verified1 = true;
      instance
          .collection("users")
          .doc(uid1)
          .set({'name': name1, 'email': email1, 'verified': verified1});
      var snapshot1 = await instance.collection("users").doc(uid1).get();
      Map<String, dynamic> data1 = await snapshot1.data();

      var uid2 = "2";
      var name2 = "User2";
      var email2 = "user2@gmail.com";
      var verified2 = false;
      instance
          .collection("users")
          .doc(uid2)
          .set({'name': name2, 'email': email2, 'verified': verified2});
      var snapshot2 = await instance.collection("users").doc(uid2).get();
      Map<String, dynamic> data2 = await snapshot2.data();

      var uid3 = "3";
      var name3 = "User3";
      var email3 = "user3@gmail.com";
      var verified3 = true;
      instance
          .collection("users")
          .doc(uid3)
          .set({'name': name3, 'email': email3, 'verified': verified3});
      var snapshot3 = await instance.collection("users").doc(uid3).get();
      Map<String, dynamic> data3 = await snapshot3.data();

      var uid4 = "4";
      var name4 = "User4";
      var email4 = "user4@gmail.com";
      var verified4 = false;
      instance
          .collection("users")
          .doc(uid4)
          .set({'name': name4, 'email': email4, 'verified': verified4});
      var snapshot4 = await instance.collection("users").doc(uid4).get();
      Map<String, dynamic> data4 = await snapshot4.data();

      var verified_only = [];
      if (data1['verified']) {
        verified_only.add(data1['name']);
      }
      if (data2['verified']) {
        verified_only.add(data2['name']);
      }
      if (data3['verified']) {
        verified_only.add(data3['name']);
      }
      if (data4['verified']) {
        verified_only.add(data4['name']);
      }
      expect(verified_only.length, 2);
      expect(verified_only[0], data1['name']);
      expect(verified_only[1], data3['name']);
      print("Test Passed");
    });
  });

  // print("#########################");
  // print("#  User Story #1 Tests  #");
  // print("#########################");
  // print("");
  group('User Story #1 tests', () {
    test("Getting Organization Website URLs ", () async {
      var instance = FakeFirebaseFirestore();
      var id1 = "1";
      var org_name1 = "Org X";
      var url1 = "www.orgnamex.com";
      instance
          .collection("resources")
          .doc(id1)
          .set({'name': org_name1, 'url': url1});

      var snapshot1 = await instance.collection("resources").doc(id1).get();
      Map<String, dynamic> data1 = await snapshot1.data();

      var id2 = "2";
      var org_name2 = "Org Y";
      var url2 = "www.orgnamey.com";
      instance
          .collection("resources")
          .doc(id2)
          .set({'name': org_name2, 'url': url2});

      var snapshot2 = await instance.collection("resources").doc(id2).get();
      Map<String, dynamic> data2 = await snapshot2.data();

      var id3 = "3";
      var org_name3 = "Org Z";
      var url3 = "www.orgnamez.com";
      instance
          .collection("resources")
          .doc(id3)
          .set({'name': org_name3, 'url': url3});

      var snapshot3 = await instance.collection("resources").doc(id3).get();
      Map<String, dynamic> data3 = await snapshot3.data();

      expect(data1['name'], org_name1);
      expect(data1['url'], url1);
      expect(data2['name'], org_name2);
      expect(data2['url'], url2);
      expect(data3['name'], org_name3);
      expect(data3['url'], url3);
      print("Test Passed");
    });

    test("Getting Organization Contacts ", () async {
      var instance = FakeFirebaseFirestore();
      var id1 = "1";
      var org_name1 = "Org X";
      var contact_info1 = "1234567890";
      instance
          .collection("resources")
          .doc(id1)
          .set({'name': org_name1, 'number': contact_info1});

      var snapshot1 = await instance.collection("resources").doc(id1).get();
      Map<String, dynamic> data1 = await snapshot1.data();

      var id2 = "2";
      var org_name2 = "Org Y";
      var contact_info2 = "9876543210";
      instance
          .collection("resources")
          .doc(id2)
          .set({'name': org_name2, 'number': contact_info2});

      var snapshot2 = await instance.collection("resources").doc(id2).get();
      Map<String, dynamic> data2 = await snapshot2.data();

      var id3 = "3";
      var org_name3 = "Org Z";
      var contact_info3 = "5432109876";
      instance
          .collection("resources")
          .doc(id3)
          .set({'name': org_name3, 'number': contact_info3});

      var snapshot3 = await instance.collection("resources").doc(id3).get();
      Map<String, dynamic> data3 = await snapshot3.data();

      expect(data1['name'], org_name1);
      expect(data1['number'], contact_info1);
      expect(data2['name'], org_name2);
      expect(data2['number'], contact_info2);
      expect(data3['name'], org_name3);
      expect(data3['number'], contact_info3);
      print("Test Passed");
    });
  });
}
