import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/authentication/loadingPage.dart';
import 'package:flutter_login_ui/pages/mainUI/petitionpage.dart';
import 'package:flutter_login_ui/pages/authentication/register.dart';
import 'package:flutter_login_ui/pages/navigation/startpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
// void main() => runApp(MyApp());

class Login extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soteria',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: LoginPage(title: 'Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  String email;
  String password;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  UserAuth userAuth = new UserAuth();
  var user;

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool remember = false;
    /*  userAuth.user = FirebaseAuth.instance.currentUser;
    var user_detail;

    getTheUser(user_detail, userAuth.user.uid);
    userAuth.user1 = new UserModel(
        userAuth.user.uid,
        user_detail['name'],
        user_detail['username'],
        user_detail['password'],
        user_detail['emergency_contacts'],
        user_detail['phone_number']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeP(
                  myUser: userAuth.user1,
                  userAuth: userAuth,
                )));
                */
    final usernameField = TextField(
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
    final rememberMe = Checkbox(
      activeColor: Colors.amber,
      value: isChecked,
      onChanged: (bool value) {
        setState(() {
          remember = value;
        });
      },
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          try {
            email = email.trim();
            password = password.trim();

            print(FirebaseAuth.instance.currentUser);

            user = await userAuth.signIn(email, password);
            print("HII");
            userAuth.user = user;

            //r  print(UserAuth.user.uid);
            //r  print(UserAuth.user.uid);

            try {
              var user_detail =
                  await DatabaseService().getUser(userAuth.user.uid);
              print(user_detail['remember']);
              userAuth.user1 = new UserModel(
                  userAuth.user.uid,
                  user_detail['name'],
                  user_detail['username'],
                  user_detail['password'],
                  user_detail['emergency_contacts'],
                  user_detail['phone_number'],
                  user_detail['remember']);
              print(userAuth.user1);
              userAuth.user1.loggedIn = remember;
              await DatabaseService().updatePref(remember, userAuth.user.uid);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeP(
                            myUser: userAuth.user1,
                            userAuth: userAuth,
                          )));

              print(user_detail['username']);
              print(user_detail);
              print(user_detail.runtimeType);
            } catch (e, stacktrace) {
              print(e);
              print(stacktrace);
              print("error");
            }
            print("hello");
          } catch (x) {
            print("There has been an exception");
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
                    child: Text(UserAuth.errors(x.code)))));
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final hintText = DefaultTextStyle(
        style: style,
        child: Text(
          "Not Registered yet?",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ));
    final createAccount = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 3.75, 5.0, 3.75),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
        },
        child: Text("Create Account",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
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
                  SizedBox(height: 45.0),
                  usernameField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(
                    height: 35.0,
                  ),
                  loginButton,
                  SizedBox(
                    height: 15.0,
                  ),
                  hintText,
                  SizedBox(
                    height: 5.0,
                  ),
                  createAccount,
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SizedBox(width: 5.0),
                    Text("Remember Me",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontFamily: 'Rubic')),
                    SizedBox(
                        height: 20.0,
                        child: Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    Colors.amber // Your color
                                ),
                            child: rememberMe))
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
