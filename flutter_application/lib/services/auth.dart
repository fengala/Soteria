import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class UserAuth {
  static  final FirebaseAuth auth = FirebaseAuth.instance;

  static Future createUser(String email, String password, String name,
      String phone_number, List<String> emergency_contacts) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential res = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    User user = res.user;

    await DatabaseService(uid: user.uid)
        .register(email, password, name, emergency_contacts, phone_number);

    return user;
  }
}