import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/authentication/forgotPassword.dart';
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


class socialHousePage extends StatefulWidget {
  socialHousePage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _socialHousePageState createState() => _socialHousePageState();
}

class _socialHousePageState extends State<socialHousePage> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  UserAuth userAuth = new UserAuth();
  var user;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool remember = false;
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage('assets/frat.png'),
            ),
            Text(
              'Phi Delta Fraternity',
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Montserrat',
                  color: Colors.amber.shade100,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5),
            ),
            SizedBox(
              width: 150.0,
              height: 20.0,
              child: Divider(
                color: Colors.amber.shade100,
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.amber,
                ),
                title: Text(
                  'This is text about Phi Delta. Blah Blah Blah. Blah Blah Blah. Blah Blah Blah. Blah Blah Blah. Blah Blah Blah. Blah Blah Blah.',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
                      color: Colors.amber.shade900),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.teal,
                ),
                title: Text(
                  'contact@gmail.com',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20.0,
                      color: Colors.amber.shade900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
