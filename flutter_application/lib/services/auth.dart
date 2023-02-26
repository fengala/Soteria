import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import 'database.dart';

class UserAuth {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  User user;
  UserModel user1;

    Future createUser(String email, String password, String name,
      String phone_number,  emergency_contacts) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential res = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    this.user = res.user;

    print(user.uid);

    await DatabaseService(uid: user.uid)
        .register(email, password, name, emergency_contacts, phone_number);

    return user;
  }

   Future signIn(String email, String password) async {
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
  Future resetPassword(String password) async {
    this.user.updatePassword(password);
    this.user.sendEmailVerification();

    var res = await DatabaseService(uid: user.uid).resetPassword(password);
    return res;
  }

  static Future staySignedIn() async {
    var res = await auth.setPersistence(Persistence.LOCAL);

    return res;
  }

     Future SignOut() async {
    var res = await auth.signOut();
    return res;
  }
}
