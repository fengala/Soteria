import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

// class Upvote {
//   // final CollectionReference petRef =
//   //     FirebaseFirestore.instance.collection("Petitions");
//   int initial_val = 0;
//   String petition_id = null;
//   bool checkParamter(dynamic paramter) {
//     if (paramter is String) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   // bool checkPetitionExistence(String id) {
//   //   petRef.doc(id).get()
//   // }

//   Future<int> check() async =>
//       await DatabaseService().upvoteCountCheckPet(petition_id);
// }

// void main() {
//   setUpAll(() async {
//     await Firebase.initializeApp();
//   });
//   test('Get Petition function should detect if petitions exists', () async {
//     // final counter = Counter();
//     Future pet = await DatabaseService().getPet("Thisstringisnotapetitionid");

//     // counter.increment();

//     expect(pet, "OK");
//   });
// }
// void main() {
//   setUpAll(() async {
//     await Firebase.initializeApp();
//   });

//   testWidgets('Get Petition function should detect if petitions exists',
//       (WidgetTester tester) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     // Your test code here
//     Future pet = await DatabaseService().getPet("Thisstringisnotapetitionid");
//     expect(pet, "OK");
//   });
// }

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });
  group('getPet()', () {
    testWidgets('returns null if the document does not exist',
        (WidgetTester tester) async {
      final result = await DatabaseService().getPet('nonexistent-pet-id');
      expect(result, null);
    });

    // test('returns the document data if it exists', () async {
    //   // Create a test document to fetch
    //   final testPetData = {'name': 'Test Pet', 'species': 'Dog'};
    //   final testPetId = 'test-pet-id';
    //   await petRef.doc(testPetId).set(testPetData);

    //   // Fetch the test document
    //   final result = await DatabaseService().getPet(testPetId);
    //   expect(result, testPetData);

    //   // Clean up the test document
    //   await petRef.doc(testPetId).delete();
    // });
  });
}
