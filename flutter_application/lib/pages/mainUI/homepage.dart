import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/authentication/login.dart';
import '../authentication/update.dart';
import '../authentication/register.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/database.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TP extends StatelessWidget {
  var myUser;
  var userAuth;
  TP({Key key}) : super(key: key);

  void setUser(var User) {
    this.myUser = User;
  }

  void setAuth(var auth) {
    this.userAuth = auth;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TPage(
        myUser: this.myUser,
        userAuth: this.userAuth,
      ),
    );
  }
}

class TPage extends StatefulWidget {
  var myUser;
  var userAuth;

  TPage({Key key, this.myUser, this.userAuth}) : super(key: key);

  @override
  TePage createState() => TePage(myUser: this.myUser, userAuth: this.userAuth);
}

class TePage extends State<TPage> {
  UserModel myUser;
  var userAuth;
  TePage({this.myUser, this.userAuth});
  @override
  Widget build(BuildContext context) {
    int page = 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.amber,
        leading: Container(
          margin: const EdgeInsets.all(10.0),
        ),
        title: Text(
          'Home Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 40.0),
              child: GestureDetector(
                onTap: () {
                  try {
                    Navigator.of(context, rootNavigator: true)
                        .pushReplacement(MaterialPageRoute(
                            builder: (context) => UpdatePage(
                                  myUser: this.myUser,
                                  userAuth: this.userAuth,
                                )));
                  } catch (e, stacktrace) {
                    print(e);
                    print(stacktrace);
                  }
                },
                child: Icon(
                  Icons.account_circle,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  try {
                    this.userAuth.SignOut();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => LoginPage()));
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  } catch (e, stacktrace) {
                    print(e);
                    print(stacktrace);
                  }
                },
                child: Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ],
      ),
    );
  }
}
