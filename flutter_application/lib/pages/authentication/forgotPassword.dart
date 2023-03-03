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

class forgotPage extends StatefulWidget {
  var myUser;
  var userAuth;
  forgotPage({Key key, this.title, this.myUser, this.userAuth})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _forgotPageState createState() => _forgotPageState();
}

//TO-DO:
//Scroll bar
//Contacts (+ button)
//User phone number
class _forgotPageState extends State<forgotPage> {
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
  String email = "";
  _forgotPageState() {}
  TextEditingController text_widgets = TextEditingController();

  String error_message;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void dispose() {
    text_widgets.dispose();
    super.dispose();
  }

  // GlobalKey<_RegisterPageState> form_key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final username = TextField(
      onChanged: (text) {
        email = text;
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final sendResetMail = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 3.75, 5.0, 3.75),
        onPressed: () async {
          email = email.trim();
          UserAuth.forgotPassword(email);

          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: Text("Success!"),
                  content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.check),
                        DefaultTextStyle(
                            style: style,
                            child: Text(
                              "Successfully sent email",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                color: Colors.green,
                              ),
                            )),
                      ])));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Text("Send password reset"),
      ),
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 36, right: 36, top: 36, bottom: 120.0),
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
                  username,
                  SizedBox(
                    height: 5.0,
                  ),
                  sendResetMail,
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
