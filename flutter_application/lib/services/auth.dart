import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_ui/models/User.dart';
import 'database.dart';

class UserAuth {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static User user;

  static Future createUser(String email, String password, String name,
      String phone_number, List<String> emergency_contacts) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential res = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    user = res.user;

    print(user.uid);

    await DatabaseService(uid: user.uid)
        .register(email, password, name, emergency_contacts, phone_number);

    return user;
  }

  static Future signIn(String email, String password) async {
    UserCredential res =
        await auth.signInWithEmailAndPassword(email: email, password: password);

    User user = res.user;

    print(res);
    return user;
  }

  static String errors(String code) {
    switch (code) {
      case 'EMAIL_ALREADY_IN_USE':
        return "This email is already in use";
      default:
        return "Authentication Failed";
    }
  }
}
