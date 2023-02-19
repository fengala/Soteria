import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class UserAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future createUser(String email, String password, String name,
      String phone_number, List<String> emergency_contacts) async {
    UserCredential res = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    User user = res.user;

    await DatabaseService(uid: user.uid)
        .register(email, password, name, emergency_contacts, phone_number);

    return user;
  }
}
