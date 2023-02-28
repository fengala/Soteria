import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import '../../services/auth.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

//TO-DO:
//Scroll bar
//Contacts (+ button)
//User phone number
class _RegisterPageState extends State<RegisterPage> {
  TextEditingController text_widgets = TextEditingController();
  String name;
  String last_name;
  String username;
  String password;
  String password2;
  String phone_number;
  String emergency_contact1;
  String emergency_contact2;
  String emergency_contact3;

  String error_message;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void dispose() {
    text_widgets.dispose();
    super.dispose();
  }

  // GlobalKey<_RegisterPageState> form_key = GlobalKey();

  String validate_first_name(String val) {
    if (val == null || val.isEmpty) {
      return "This field is mandatory";
    }
    return null;
  }

  String validate_last_name(String val) {
    if (val == null || val.isEmpty) {
      return "This field is mandatory";
    }
    return null;
  }

  String validate_username(String val) {
    if (val == null || val.isEmpty) {
      return "This field is mandatory";
    }
    return null;
  }

  String validate_password(String val) {
    if (val == null || val.isEmpty) {
      return "This field is mandatory";
    }
    return null;
  }

  String validate_phone(String val) {
    if (val == null || val.isEmpty) {
      return "This field is mandatory";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final firstName = TextField(
      onChanged: (text) {
        name = text;

        /*  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    height: 90,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text("Mandatory"))));*/
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "First Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final lastName = TextField(
      onChanged: (text) {
        last_name = text;
        if (last_name == null) {
          /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    height: 90,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text("Mandatory"))));*/
        }
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Last Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final usernameField = TextField(
      onChanged: (text) {
        username = text;
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email Address",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
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
    final phoneNumber = TextField(
      onChanged: (text) {
        phone_number = text;
      },
      keyboardType: TextInputType.phone,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter phone number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final emergencyContactText = DefaultTextStyle(
        style: style,
        child: Text(
          "Emergency contacts:",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ));
    final emergencyContact1 = TextFormField(
      onChanged: (text) {
        emergency_contact1 = text;
      },
      keyboardType: TextInputType.phone,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter emergency contact number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final emergencyContact2 = TextFormField(
      onChanged: (text) {
        emergency_contact2 = text;
      },
      keyboardType: TextInputType.phone,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter emergency contact number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final emergencyContact3 = TextFormField(
      onChanged: (text) {
        emergency_contact3 = text;
      },
      keyboardType: TextInputType.phone,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter emergency contact number",
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
          List list = [
            emergency_contact1,
            emergency_contact2,
            emergency_contact3
          ];

          if (password != password2) {
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
          }

          try {
            if (name == null ||
                name.isEmpty ||
                password == null ||
                password.isEmpty ||
                username == null ||
                username.isEmpty ||
                phone_number == null ||
                phone_number.isEmpty ||
                emergency_contact1 == null ||
                emergency_contact1.isEmpty ||
                emergency_contact2.isEmpty ||
                emergency_contact2 == null ||
                emergency_contact3.isEmpty ||
                emergency_contact3 == null ||
                last_name == null ||
                last_name.isEmpty) {
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
              name = name + " " + last_name;
               UserAuth userAuth = new UserAuth();
              var res = await userAuth.createUser(
                  username, password, name, phone_number, list);
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
                      "We have successfully sent a verification mail to your mail address",
                      textAlign: TextAlign.center,
                      style:
                      style.copyWith(color: Colors.green,),
                    )),
          ])));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Text("Create Account",
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
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Text("Back to Login",
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
                firstName,
                SizedBox(height: 25.0),
                lastName,
                SizedBox(height: 25.0),
                usernameField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 25.0),
                reEnterPassword,
                SizedBox(height: 25.0),
                phoneNumber,
                SizedBox(
                  height: 15.0,
                ),
                emergencyContactText,
                SizedBox(height: 25.0),
                emergencyContact1,
                SizedBox(height: 25.0),
                emergencyContact2,
                SizedBox(height: 25.0),
                emergencyContact3,
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
