import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/authentication/loadingPage.dart';
import 'package:flutter_login_ui/pages/authentication/login.dart';
import 'package:flutter_login_ui/pages/mainUI/petitionpage.dart';
import 'package:flutter_login_ui/pages/authentication/register.dart';
import 'package:flutter_login_ui/pages/navigation/startpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() {
    print("completed");
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soteria',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: flashScreen(
        title: 'Flash',
      ),
    );
  }
}

class flashScreen extends StatefulWidget {
  flashScreen({Key key, this.title}) : super(key: key);

  final String title;
  splashScreen createState() => splashScreen();
}

class splashScreen extends State<flashScreen> {
  var user;
  UserAuth userAuth = new UserAuth();
  bool value = false;

  @override
  void initState() {
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        value = false;
        print("The user is not signed in");
      } else {
        value = true;
        print("The user is signed in");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var obj;

    return MaterialApp(
        title: 'Flash_screen',
        home: AnimatedSplashScreen.withScreenFunction(
          duration: 1500,
          splash: ClipOval(
            child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,),
             clipper: MyClip(),
            ),
          splashIconSize: double.infinity,
          screenFunction: () async {
            if (!value) {
              obj = LoginPage();
              return obj;
            } else {
              var user_fir = FirebaseAuth.instance.currentUser;
              var user_details = await DatabaseService().getUser(user_fir.uid);
              print(user_details);
              if (!user_details['remember']) {
                obj = LoginPage();
                return obj;
              }
              userAuth.user = user_fir;
              userAuth.user1 = new UserModel(
                user_fir.uid,
                user_details['name'],
                user_details['username'],
                user_details['password'],
                user_details['emergency_contacts'],
                user_details['phone_number'],
                user_details['remember'],
                user_details['verified'],
              );
              obj = HomeP(
                myUser: userAuth.user1,
                userAuth: userAuth,
              );

              return obj;
            }
          },
          backgroundColor: Colors.amber,
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.leftToRight,
        ));
  }
}

class MyClip extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTWH(10, 93, 410, 475);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}