import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  setUpAll(() async {
    await Firebase.initializeApp();
  });
  final MockFirebaseAuth mockAuth = MockFirebaseAuth();
  final UserAuth auth = UserAuth();
  final MockPetRef pet = MockPetRef();
  setUp(() => null);
  tearDown(() => null);

  test("emit occurs", () async {
    expectLater(auth.user, emitsInOrder([null]));
  });

  // test("petition fetching", () async {
  //   expectLater(pet.getPet("pid"), _value);
  // });

  // final DatabaseService database = MockPetRef();
  // final DocumentSnapshot snapshot = await database.petRef.doc("eiasgsd").get();
  // print("#################");
  // print(snapshot);

  test("Check if petition with given pid exists", () async {
    final String pid = "6U0v4g14HAXcJcbECR6e";
    final DatabaseService database = MockPetRef();
    final DocumentSnapshot snapshot = await pet.getPet(pid);
    print(snapshot);
    final bool exists = snapshot.exists;
    expect(exists, isTrue);
  });

  test("Check ", () async {
    final String pid = "your-petition-id-here";
    //final DatabaseService database = MockPetRef();
    expect(pid, "your-petition-id-here");
  });
  
    test("getting petitions", () async {
    var instance = FakeFirebaseFirestore();
    var uid = '12';
    instance.collection("petitions").add({'title': "Ejjj", 'num_upvotes': 34});

    var snapshot = await instance.collection("petitions").get();
    expect(snapshot.docs.first.get("title"), "Ejjj");
  });
}
}
