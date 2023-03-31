import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
  // Future getPet(String pid) async {
  //   final value = await petRef.doc(pid).get();
  //   _value = value as MockPetRef;
  //   final data = value.data() as Map<String, dynamic>;
  //   return data;
  // }

  @override
  Future<DocumentSnapshot> getPet(String pid) async {
    final DocumentSnapshot snapshot = await petRef.doc(pid).get();
    return snapshot;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // setUpAll(() async {
  //   await Firebase.initializeApp();
  // });
  final MockFirebaseAuth mockAuth = MockFirebaseAuth();
  final UserAuth auth = UserAuth();
  final MockPetRef pet = MockPetRef();
  setUp(() => null);
  tearDown(() => null);

  test("Check ", () async {
    final String pid = "your-petition-id-here";
    //final DatabaseService database = MockPetRef();
    expect(pid, "your-petition-id-here");
  });

  test("Getting Petitions", () async {
    var instance = FakeFirebaseFirestore();
    var uid = '12';
    instance.collection("petitions").add({'title': "Ejjj", 'num_upvotes': 34});

    var snapshot = await instance.collection("petitions").get();
    expect(snapshot.docs.first.get("title"), "Ejjj");
  });

  // print("#########################");
  // print("#  User Story #3 Tests  #");
  // print("#########################");
  // print("");
  group('User Story #3 tests', () {
    test("Getting Emergency Contacts", () async {
      var instance = FakeFirebaseFirestore();
      var uid = "OUSN107";
      var contact1 = "3210213921";
      var contact2 = "2132321312";
      var contact3 = "5210232311";
      instance.collection("users").doc(uid).set({
        'username': "test_user@purdue.edu",
        'password': "123456",
        'name': "Test testing",
        'emergency_contacts': [contact1, contact2, contact3],
        'phone_number': "1232323132",
        'verified': true,
      });

      var snapshot = await instance.collection("users").doc(uid).get();
      Map<String, dynamic> data = await snapshot.data();
      expect(data['emergency_contacts'].length, 3);
      expect(data['emergency_contacts'][0], contact1);
      expect(data['emergency_contacts'][1], contact2);
      expect(data['emergency_contacts'][2], contact3);
      print("Test Passed");
    });

    test("Empty Emergency Contacts Checking", () async {
      var instance = FakeFirebaseFirestore();
      var uid = "OUSN107";
      var contact1 = "3210213921";
      var contact2 = "";
      var contact3 = "5210232311";
      instance.collection("users").doc(uid).set({
        'username': "test_user@purdue.edu",
        'password': "123456",
        'name': "Test testing",
        'emergency_contacts': [contact1, contact2, contact3],
        'phone_number': "1232323132",
        'verified': true,
      });

      var snapshot = await instance.collection("users").doc(uid).get();
      Map<String, dynamic> data = await snapshot.data();
      expect(data['emergency_contacts'].length, 3);
      expect(data['emergency_contacts'][0], contact1);
      expect(data['emergency_contacts'][1], contact2);
      expect(data['emergency_contacts'][2], contact3);
      print("Test Passed");
    });
  });

  // print("#########################");
  // print("#  User Story #4 Tests  #");
  // print("#########################");
  // print("");
  group('User Story #4 tests', () {
    test("Updating an Emergency Contact", () async {
      var instance = FakeFirebaseFirestore();
      var uid = "OUSN107";
      var contact1 = "3210213921";
      var contact2 = "2132321312";
      var contact3 = "";

      instance.collection("users").doc(uid).set({
        'username': "test_user@purdue.edu",
        'password': "123456",
        'name': "Test testing",
        'emergency_contacts': [contact1, contact2, contact3],
        'phone_number': "1232323132",
        'verified': true,
      });

      var snapshot = await instance.collection("users").doc(uid).get();
      Map<String, dynamic> data = await snapshot.data();

      for (int i = 1; i < data['emergency_contacts'].length + 1; i++) {
        print("Current emergency contanct number $i: " +
            data['emergency_contacts'][i - 1]);
      }

      expect(data['emergency_contacts'].length, 3);
      expect(data['emergency_contacts'][0], contact1);
      expect(data['emergency_contacts'][2], contact3);

      var new_contact = "1234567890";
      var new_contact3 = "9292343411";
      print("Resetting phone number 1 from $contact1 to $new_contact");
      print("Resetting phone number 3 from $contact1 to $new_contact3");

      contact1 = new_contact;
      contact3 = new_contact3;

      print("New contact 1: " + contact1);
      print("New contact 3: " + contact3);

      instance.collection("users").doc(uid).update({
        'emergency_contacts': [contact1, contact2, contact3],
      });

      var snapshot2 = await instance.collection("users").doc(uid).get();
      Map<String, dynamic> data2 = await snapshot2.data();

      expect(data2['emergency_contacts'].length, 3);
      expect(data2['emergency_contacts'][0], new_contact);
      expect(data2['emergency_contacts'][2], new_contact3);

      print("After Update");
      for (int i = 1; i < data2['emergency_contacts'].length + 1; i++) {
        print("Latest emergency contanct number $i: " +
            data2['emergency_contacts'][i - 1]);
      }
      print("Test Passed");
    });

    group('Invalid Inputs to Emergency Contacts', () {
      test("1. Null input to Emergency Contacts Check", () async {
        var instance = FakeFirebaseFirestore();
        var uid = "OUSN107";
        //Check for null value
        var contact1 = null;
        var contact2 = "2132312411";
        var contact3 = "1234567897";
        contact1 = contact1.toString();
        contact2 = contact2.toString();
        contact3 = contact3.toString();
        print("Input for Contact 1 is given as: " + contact1);
        print("Input for Contact 2 is given as: " + contact2);
        print("Input for Contact 3 is given as: " + contact3);
        print("");

        var err_msg = "";
        RegExp regex = RegExp(r'^\d+$');

        if ((contact1 == null ||
                contact1.length != 10 ||
                !regex.hasMatch(contact1)) &&
            (contact1 != "")) {
          print("Invalid value for contact 1");
          print("Make sure that the number is a numerical value of 10 digits");
          contact1 = "";
          print("Setting contact 1 as an empty field");
          err_msg = "Null Check";
          print("");
        }
        expect("Null Check", err_msg);
        expect("", contact1);
        err_msg = "";

        if ((contact2 == null ||
                contact2.length != 10 ||
                !regex.hasMatch(contact2)) &&
            (contact2 != "")) {
          print("Invalid value for contact 2");
          print("Make sure that the number is a numerical value of 10 digits");
          contact2 = "";
          print("Setting contact 2 as an empty field");
          err_msg = "Null Check";
          print("");
        }
        expect("", err_msg);
        expect("2132312411", contact2);
        err_msg = "";

        if ((contact3 == null ||
                contact3.length != 10 ||
                !regex.hasMatch(contact3)) &&
            (contact3 != "")) {
          print("Invalid value for contact 3");
          print("Make sure that the number is a numerical value of 10 digits");
          contact3 = "";
          print("Setting contact 3 as an empty field");
          err_msg = "Null Check";
          print("");
        }
        expect("", err_msg);
        expect("1234567897", contact3);
        err_msg = "";

        instance.collection("users").doc(uid).set({
          'username': "test_user@purdue.edu",
          'password': "123456",
          'name': "Test testing",
          'emergency_contacts': [contact1, contact2, contact3],
          'phone_number': "1232323132",
          'verified': true,
        });

        var snapshot = await instance.collection("users").doc(uid).get();
        Map<String, dynamic> data = await snapshot.data();
        expect(data['emergency_contacts'].length, 3);
        expect(data['emergency_contacts'][0], contact1);
        expect(data['emergency_contacts'][1], contact2);
        expect(data['emergency_contacts'][2], contact3);

        for (int i = 1; i < data['emergency_contacts'].length + 1; i++) {
          print("Fetched emergency contanct number $i from database: " +
              data['emergency_contacts'][i - 1]);
        }
        print("Test Passed");
      });

      test("2. Non-numeric input to Emergency Contacts Check", () async {
        var instance = FakeFirebaseFirestore();
        var uid = "OUSN107";
        // Check for non-numerical value
        var contact1 = "in12vali4d";
        var contact2 = "2132312411";
        var contact3 = "1234567897";
        contact1 = contact1.toString();
        contact2 = contact2.toString();
        contact3 = contact3.toString();
        print("Input for Contact 1 is given as: " + contact1);
        print("Input for Contact 2 is given as: " + contact2);
        print("Input for Contact 3 is given as: " + contact3);
        print("");

        var err_msg = "";
        RegExp regex = RegExp(r'^\d+$');

        if ((contact1 == null ||
                contact1.length != 10 ||
                !regex.hasMatch(contact1)) &&
            (contact1 != "")) {
          print("Invalid value for contact1");
          print("Make sure that the number is a numerical value of 10 digits");
          contact1 = "";
          print("Setting contact1 as an empty field");
          err_msg = "Non-Numeric String Check";
          print("");
        }
        expect("Non-Numeric String Check", err_msg);
        expect("", contact1);
        err_msg = "";

        if ((contact2 == null ||
                contact2.length != 10 ||
                !regex.hasMatch(contact2)) &&
            (contact2 != "")) {
          print("Invalid value for contact 2");
          print("Make sure that the number is a numerical value of 10 digits");
          contact2 = "";
          print("Setting contact 2 as an empty field");
          err_msg = "Non-Numeric String Check";
          print("");
        }
        expect("", err_msg);
        expect("2132312411", contact2);
        err_msg = "";

        if ((contact3 == null ||
                contact3.length != 10 ||
                !regex.hasMatch(contact3)) &&
            (contact3 != "")) {
          print("Invalid value for contact 3");
          print("Make sure that the number is a numerical value of 10 digits");
          contact3 = "";
          print("Setting contact 3 as an empty field");
          err_msg = "Non-Numeric String Check";
          print("");
        }
        expect("", err_msg);
        expect("1234567897", contact3);
        err_msg = "";

        instance.collection("users").doc(uid).set({
          'username': "test_user@purdue.edu",
          'password': "123456",
          'name': "Test testing",
          'emergency_contacts': [contact1, contact2, contact3],
          'phone_number': "1232323132",
          'verified': true,
        });

        var snapshot = await instance.collection("users").doc(uid).get();
        Map<String, dynamic> data = await snapshot.data();
        expect(data['emergency_contacts'].length, 3);
        expect(data['emergency_contacts'][0], contact1);
        expect(data['emergency_contacts'][1], contact2);
        expect(data['emergency_contacts'][2], contact3);

        for (int i = 1; i < data['emergency_contacts'].length + 1; i++) {
          print("Fetched emergency contanct number $i from database: " +
              data['emergency_contacts'][i - 1]);
        }
        print("Test Passed");
      });

      test("3. Exactly 10 digit numeric input to Emergency Contacts Check",
          () async {
        var instance = FakeFirebaseFirestore();
        var uid = "OUSN107";
        //Check for exatcly 10 digit value
        var contact1 = "1221312";
        var contact2 = "122133432423423412";
        var contact3 = "1234567897";
        contact1 = contact1.toString();
        contact2 = contact2.toString();
        contact3 = contact3.toString();
        print("Input for Contact 1 is given as: " + contact1);
        print("Input for Contact 2 is given as: " + contact2);
        print("Input for Contact 3 is given as: " + contact3);
        print("");

        var err_msg = "";
        RegExp regex = RegExp(r'^\d+$');

        if ((contact1 == null ||
                contact1.length != 10 ||
                !regex.hasMatch(contact1)) &&
            (contact1 != "")) {
          print("Invalid value for contact 1");
          print("Make sure that the number is a numerical value of 10 digits");
          contact1 = "";
          print("Setting contact 1 as an empty field");
          err_msg = "Number is not exactly 10 digits";
          print("");
        }
        expect("Number is not exactly 10 digits", err_msg);
        expect("", contact1);
        err_msg = "";

        if ((contact2 == null ||
                contact2.length != 10 ||
                !regex.hasMatch(contact2)) &&
            (contact2 != "")) {
          print("Invalid value for contact 2");
          print("Make sure that the number is a numerical value of 10 digits");
          contact2 = "";
          print("Setting contact 2 as an empty field");
          err_msg = "Number is not exactly 10 digits";
          print("");
        }
        expect("Number is not exactly 10 digits", err_msg);
        expect("", contact2);
        err_msg = "";

        if ((contact3 == null ||
                contact3.length != 10 ||
                !regex.hasMatch(contact3)) &&
            (contact3 != "")) {
          print("Invalid value for contact 3");
          print("Make sure that the number is a numerical value of 10 digits");
          contact3 = "";
          print("Setting contact 3 as an empty field");
          err_msg = "Number is not exactly 10 digits";
          print("");
        }
        expect("", err_msg);
        expect("1234567897", contact3);
        err_msg = "";

        instance.collection("users").doc(uid).set({
          'username': "test_user@purdue.edu",
          'password': "123456",
          'name': "Test testing",
          'emergency_contacts': [contact1, contact2, contact3],
          'phone_number': "1232323132",
          'verified': true,
        });

        var snapshot = await instance.collection("users").doc(uid).get();
        Map<String, dynamic> data = await snapshot.data();
        expect(data['emergency_contacts'].length, 3);
        expect(data['emergency_contacts'][0], contact1);
        expect(data['emergency_contacts'][1], contact2);
        expect(data['emergency_contacts'][2], contact3);

        for (int i = 1; i < data['emergency_contacts'].length + 1; i++) {
          print("Fetched emergency contanct number $i from database: " +
              data['emergency_contacts'][i - 1]);
        }
        print("Test Passed");
      });
    });
  });

  // print("#########################");
  // print("#  User Story #5 Tests  #");
  // print("#########################");
  // print("");
  group('User Story #5 tests', () {
    test("View Social Venue's Star Based Rating", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";
      var rating = "3.0";
      print("Rating of a Social Venue with ID OUSN107: " + rating);
      instance.collection("SocialHouse").doc(vid).set({
        'contact': "president@kdrpurdue.com",
        'description':
            "Average Cumulative GPA: 3.24/Events without alcohol: 5/Conduct Reporting: Level 2/*the higher the level, the worse the compliance",
        'location': "1134 Northwestern Ave, West Lafayette, IN 47906",
        'num_comments': "1",
        'num_rating': rating,
        'num_reviews': "5",
        'title': "Kappa Delta Rho",
      });

      var snapshot = await instance.collection("SocialHouse").doc(vid).get();
      Map<String, dynamic> data = await snapshot.data();
      print("Rating fetched by database of the Social Venue with ID OUSN107: " +
          data['num_rating']);
      expect(data['num_rating'], rating);
      print("Test Passed");
    });

    test("1 decimal precision of Social Venue's Star Based Rating", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";
      var rating = "2.6777777777777777777";
      var rounded_val = double.parse(rating).toStringAsFixed(1);
      print("Rating of a Social Venue with ID OUSN107: " + rating);
      instance.collection("SocialHouse").doc(vid).set({
        'contact': "president@kdrpurdue.com",
        'description':
            "Average Cumulative GPA: 3.24/Events without alcohol: 5/Conduct Reporting: Level 2/*the higher the level, the worse the compliance",
        'location': "1134 Northwestern Ave, West Lafayette, IN 47906",
        'num_comments': "1",
        'num_rating': rounded_val,
        'num_reviews': "5",
        'title': "Kappa Delta Rho",
      });

      var snapshot = await instance.collection("SocialHouse").doc(vid).get();
      Map<String, dynamic> data = await snapshot.data();
      print("Rating fetched by database of the Social Venue with ID OUSN107: " +
          data['num_rating']);
      expect(data['num_rating'], rounded_val);
      print("Test Passed");
    });
  });

  // print("#########################");
  // print("#  User Story #6 Tests  #");
  // print("#########################");
  // print("");
  group('User Story #6 tests', () {
    test("View Social Venue's Accredited Information", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";
      var contact = "president@kdrpurdue.com";
      var desc =
          "Average Cumulative GPA: 3.24/Events without alcohol: 5/Conduct Reporting: Level 2/*the higher the level, the worse the compliance";
      var loc = "1134 Northwestern Ave, West Lafayette, IN 47906";
      var comments = "1";
      var rating = "4.1";
      var reviews = "5";
      var title = "Kappa Delta Rho";
      instance.collection("SocialHouse").doc(vid).set({
        'contact': contact,
        'description': desc,
        'location': loc,
        'num_comments': comments,
        'num_rating': rating,
        'num_reviews': reviews,
        'title': title,
      });

      var snapshot = await instance.collection("SocialHouse").doc(vid).get();
      Map<String, dynamic> data = await snapshot.data();
      expect(data['contact'], contact);
      expect(data['description'], desc);
      expect(data['location'], loc);
      expect(data['num_comments'], comments);
      expect(data['num_rating'], rating);
      expect(data['num_reviews'], reviews);
      expect(data['title'], title);
      print("Test Passed");
    });

    test("1 decimal precision of Social Venue's Star Based Rating", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";
      var rating = "2.6777777777777777777";
      var rounded_val = double.parse(rating).toStringAsFixed(1);
      print("Rating of a Social Venue with ID OUSN107: " + rating);
      instance.collection("SocialHouse").doc(vid).set({
        'contact': "president@kdrpurdue.com",
        'description':
            "Average Cumulative GPA: 3.24/Events without alcohol: 5/Conduct Reporting: Level 2/*the higher the level, the worse the compliance",
        'location': "1134 Northwestern Ave, West Lafayette, IN 47906",
        'num_comments': "1",
        'num_rating': rounded_val,
        'num_reviews': "5",
        'title': "Kappa Delta Rho",
      });

      var snapshot = await instance.collection("SocialHouse").doc(vid).get();
      Map<String, dynamic> data = await snapshot.data();
      print("Rating fetched by database of the Social Venue with ID OUSN107: " +
          data['num_rating']);
      expect(data['num_rating'], rounded_val);
      print("Test Passed");
    });
  });

  group('User story 7 Tests', () {
    test("Getting the rating review ratio", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";
      var rating = "2.6777777777777777777";
      var rounded_val = double.parse(rating).toStringAsFixed(1);
      instance.collection("SocialHouse").doc(vid).set({
        'contact': "president@kdrpurdue.com",
        'description':
            "Average Cumulative GPA: 3.24/Events without alcohol: 5/Conduct Reporting: Level 2/*the higher the level, the worse the compliance",
        'location': "1134 Northwestern Ave, West Lafayette, IN 47906",
        'num_comments': "1",
        'num_rating': rounded_val,
        'num_reviews': "5",
        'title': "Kappa Delta Rho",
      });

      var snapshot = await instance.collection("SocialHouse").doc(vid).get();
      Map<String, dynamic> data = await snapshot.data();
      print("Rating fetched by database of the Social Venue with ID OUSN107: " +
          data['num_rating']);

      double needd = double.parse(data['num_reviews']);

      double ratis = double.parse(rounded_val);
      double val = (needd / ratis);

      expect("1.9", val.toStringAsFixed(1));
      print("Test Passed");
    });
  });

  group("User Story 8 tests", () {
    test("Getting a review", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";

      instance.collection("reviews").doc(vid).set({
        'anonymous': false,
        'description': "Great!!",
        'num_comments': 1,
        'num_upvotes': 1,
        'Social House': "Alpha Ki",
        'rating': 3,
        'replies': []
      });
      var snapshot = await instance.collection("reviews").doc(vid).get();
      Map<String, dynamic> data = await snapshot.data();

      expect("Great!!", data['description']);
      print("test passed!!");
    });

    test("2. having no replies", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";

      instance.collection("reviews").doc(vid).set({
        'anonymous': false,
        'description': "Great!!",
        'num_comments': 1,
        'num_upvotes': 1,
        'Social House': "Alpha Ki",
        'rating': 3,
        'replies': []
      });
      var snapshot = await instance.collection("reviews").doc(vid).get();
      Map<String, dynamic> data = await snapshot.data();

      expect(0, data['replies'].length);
      print("test passed!!");
    });
  });

  group("User story 9 tests", () {
    test("1. Testing upvote of a review", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";

      instance.collection("reviews").doc(vid).set({
        'anonymous': false,
        'description': "Great!!",
        'num_comments': 1,
        'num_upvotes': 1,
        'Social House': "Alpha Ki",
        'rating': 3,
        'replies': []
      });
      print("Updating the upvtotes\n");

      instance.collection("reviews").doc(vid).update({'num_upvotes': 2});
      var snapshot = await instance.collection("reviews").doc(vid).get();
      Map<String, dynamic> data = await snapshot.data();

      expect(2, data['num_upvotes']);
      print("Tests passed!!");
    });
    test("2. Testing upvote of a review twice, that is downvoting", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";

      instance.collection("reviews").doc(vid).set({
        'anonymous': false,
        'description': "Great!!",
        'num_comments': 1,
        'num_upvotes': 1,
        'Social House': "Alpha Ki",
        'rating': 3,
        'replies': []
      });
      print("Updating the upvtotes\n");

      instance.collection("reviews").doc(vid).update({'num_upvotes': 0});
      var snapshot = await instance.collection("reviews").doc(vid).get();
      Map<String, dynamic> data = await snapshot.data();

      expect(0, data['num_upvotes']);
      print("Tests passed!!");
    });
  });

  group("Unit tests for User story 10", () {
    test("1. tests adding a review", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";
      instance.collection("reviews").add({
        'anonymous': false,
        'description': "Great!!",
        'num_comments': 1,
        'num_upvotes': 1,
        'Social House': "Alpha Ki",
        'rating': 3,
        'replies': []
      });

      var contact = "president@kdrpurdue.com";
      var desc =
          "Average Cumulative GPA: 3.24/Events without alcohol: 5/Conduct Reporting: Level 2/*the higher the level, the worse the compliance";
      var loc = "1134 Northwestern Ave, West Lafayette, IN 47906";
      var comments = "1";
      var rating = "4.1";
      var reviews = "5";
      var title = "Alpha Ki";
      instance.collection("SocialHouse").doc(vid).set({
        'contact': contact,
        'description': desc,
        'location': loc,
        'num_comments': comments,
        'num_rating': rating,
        'num_reviews': reviews,
        'title': title,
      });

      instance.collection("SocialHouse").doc(vid).update({'num_reviews': 6});

      var snapshot = await instance.collection("reviews").get();
      expect(title, snapshot.docs.first.get("Social House"));
      expect("Great!!", snapshot.docs.first.get("description"));
      print("The title is correct\n");
      var snapshot2 = await instance.collection("SocialHouse").doc(vid).get();
      Map<String, dynamic> data = await snapshot2.data();

      expect(6, data['num_reviews']);
      print("Test passed");
    });
  });

  group("Unit test cases for User story 11", () {
    test("1. give a rating to a social house", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";
      instance.collection("reviews").add({
        'anonymous': false,
        'description': "Great!!",
        'num_comments': 1,
        'num_upvotes': 1,
        'Social House': "Alpha Ki",
        'rating': 3,
        'replies': []
      });

      var contact = "president@kdrpurdue.com";
      var desc =
          "Average Cumulative GPA: 3.24/Events without alcohol: 5/Conduct Reporting: Level 2/*the higher the level, the worse the compliance";
      var loc = "1134 Northwestern Ave, West Lafayette, IN 47906";
      var comments = "1";
      var rating = "4.1";
      var reviews = "5";
      var title = "Alpha Ki";
      instance.collection("SocialHouse").doc(vid).set({
        'contact': contact,
        'description': desc,
        'location': loc,
        'num_comments': comments,
        'num_rating': rating,
        'num_reviews': reviews,
        'title': title,
      });

      instance.collection("SocialHouse").doc(vid).update({'num_rating': 4.8});

      var snapshot2 = await instance.collection("SocialHouse").doc(vid).get();
      Map<String, dynamic> data = await snapshot2.data();

      expect(4.8, data['num_rating']);
      print("test passing");
    });

    test("2. reduce the rating of a social house", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";
      instance.collection("reviews").add({
        'anonymous': false,
        'description': "Great!!",
        'num_comments': 1,
        'num_upvotes': 1,
        'Social House': "Alpha Ki",
        'rating': 3,
        'replies': []
      });

      var contact = "president@kdrpurdue.com";
      var desc =
          "Average Cumulative GPA: 3.24/Events without alcohol: 5/Conduct Reporting: Level 2/*the higher the level, the worse the compliance";
      var loc = "1134 Northwestern Ave, West Lafayette, IN 47906";
      var comments = "1";
      var rating = "4.1";
      var reviews = "5";
      var title = "Alpha Ki";
      instance.collection("SocialHouse").doc(vid).set({
        'contact': contact,
        'description': desc,
        'location': loc,
        'num_comments': comments,
        'num_rating': rating,
        'num_reviews': reviews,
        'title': title,
      });

      instance.collection("SocialHouse").doc(vid).update({'num_rating': 3.5});

      var snapshot2 = await instance.collection("SocialHouse").doc(vid).get();
      Map<String, dynamic> data = await snapshot2.data();

      expect(3.5, data['num_rating']);
      print("test passing");
    });
  });

  group("test cases for User story 12", () {
    test("1. adding a reply to the rating", () async {
      var instance = FakeFirebaseFirestore();
      var vid = "OUSN107";
      instance.collection("reviews").doc(vid).set({
        'anonymous': false,
        'description': "Great!!",
        'num_comments': 1,
        'num_upvotes': 1,
        'Social House': "Alpha Ki",
        'rating': 3,
        'replies': []
      });

      print("adding a review");
      instance.collection("reviews").doc(vid).update({
        'replies': ["This is a review"]
      });

      var snapshot2 = await instance.collection("reviews").doc(vid).get();
      Map<String, dynamic> data = await snapshot2.data();

      print("checking length");
      expect(1, data['replies'].length);
      print("the output");
      expect("This is a review", data['replies'][0]);
    });
  });
}
