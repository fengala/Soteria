import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/services/database.dart';
//import 'package:flutter/services.dart';
import '../../services/auth.dart';
import 'login.dart';
import '../mainUI/homepage.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../mainUI/homepage.dart';
import '../navigation/startpoint.dart';

class resetPage extends StatefulWidget {
  var myUser;
  var userAuth;
  resetPage({Key key, this.title, this.myUser, this.userAuth}) : super(key: key);


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _resetPageState createState() => _resetPageState(myUser, userAuth);
}

//TO-DO:
//Scroll bar
//Contacts (+ button)
//User phone number
class _resetPageState extends State<resetPage> {
  UserModel myUser;
  UserAuth userAuth;
  String name = "";
  String last_name = "";
  String username = "";
  String password = "";
  String password2 = "";
  String phone_number = "";
  String emergency_contact1 = "";
  String emergency_contact2 = "";
  String emergency_contact3 = "";
  _resetPageState(this.myUser, this.userAuth) {

    name = myUser.name.split(" ")[0];
    last_name = myUser.name.split(" ")[1];
    username = myUser.username;
    password = myUser.password;
    phone_number = myUser.phone_number;
    emergency_contact1 = myUser.emergency_contacts[0];
    emergency_contact2 = myUser.emergency_contacts[1];
    emergency_contact3 = myUser.emergency_contacts[2];
  }
  TextEditingController text_widgets = TextEditingController();


  String error_message;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void dispose() {
    text_widgets.dispose();
    super.dispose();
  }

  // GlobalKey<_RegisterPageState> form_key = GlobalKey();


  String validate_password(String val) {
    if (val == null || val.isEmpty) {
      return "This field is mandatory";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final passwordField = TextField(
      controller: TextEditingController(text: password),
      onChanged: (text) {
        password = text;
      },
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final reEnterPassword = TextField(
      onChanged: (text) {
        password2 = text;
      },
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Re-enter the password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final createAccount = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 3.75, 5.0, 3.75),
        onPressed: () async {
          bool prompt = true;

          if (password != password2) {
            prompt = false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    height: 90,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text("Passwords don't match"))));
          } else {
            userAuth.resetPassword(password);
          }

          try {
            if (password == null ||
                password.isEmpty) {
              prompt = false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 100,
                  content: Container(
                      height: 120,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text("There are a few fields missing\n"))));
            } else {
              myUser.password = password;

              print("After changing");

              print(myUser.password);

              var res = await DatabaseService(uid: myUser.uid)
                  .updateUser(myUser.username, password, myUser.name, myUser.emergency_contacts, myUser.phone_number);
            }
          } catch (x) {
            print(x);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    height: 90,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(x.code))));
          }
          if (prompt){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TPage(myUser: this.myUser, userAuth: this.userAuth,)));
            showDialog(context: context, builder: (context) => AlertDialog(
                title: Text("Success!"),
                content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.check),
                      DefaultTextStyle(
                          style: style,
                          child: Text(
                            "Successfully reset password and sent verification details!",
                            textAlign: TextAlign.center,
                            style:
                            style.copyWith(color: Colors.green,),
                          )),
                    ])));
          }
        },
        child: Text("Reset Password",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final backButton = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 3.75, 5.0, 3.75),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeP(myUser: userAuth.user1, userAuth: userAuth,)));
        },
        child: Text("Back to Homepage",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 36, right: 36, top: 36, bottom: 120.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 25.0),
                reEnterPassword,
                SizedBox(
                  height: 5.0,
                ),
                createAccount,
                SizedBox(
                  height: 5.0,
                ),
                backButton,
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
