import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/mainUI/bulletinboard.dart';
import 'package:pandabar/pandabar.dart';

import '../authentication/login.dart';
import '../mainUI/homepage.dart';
import '../mainUI/petitionpage.dart';
import '../mainUI/resourcepage.dart';

class HomeP extends StatelessWidget {
  var myUser;
  var userAuth;
  HomeP({Key key, this.myUser, this.userAuth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petitions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(
        myUser: this.myUser,
        userAuth: this.userAuth,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  var myUser;
  var userAuth;
  HomePage({Key key, this.myUser, this.userAuth}) : super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState(myUser: this.myUser, userAuth: this.userAuth);
}

class _HomePageState extends State<HomePage> {
  @override
  int page = 0;
  int _currentIndex = 0;
  var myUser;
  var userAuth;
  _HomePageState({this.myUser, this.userAuth});
  final List<Widget> _children = [
    TP(),
    PetitionP(),
    BulletinBoardP(),
    ResourceP(),
    //TP()
  ];

  @override
  Widget build(BuildContext context) {
    TP Obj = _children[0];
    Obj.setUser(this.myUser);
    Obj.setAuth(this.userAuth);
    return Scaffold(
      extendBody: true,
      body: _children[page],
      bottomNavigationBar: PandaBar(
        buttonData: [
          PandaBarButtonData(
            id: 0,
            icon: Icons.home,
            title: 'Home',
          ),
          PandaBarButtonData(
            id: 1,
            icon: Icons.edit,
            //was edit_document
            title: 'Petitions',
          ),
          PandaBarButtonData(
            id: 2,
            icon: Icons.event,
            title: 'Events',
          ),
          PandaBarButtonData(
            id: 3,
            icon: Icons.lightbulb,
            title: 'Resources',
          ),
        ],
        onChange: (id) {
          setState(() {
            page = id;
          });
        },
        buttonColor: Colors.white,
        buttonSelectedColor: Colors.amber,
        fabIcon: Icon(Icons.sos, size: 40),
        fabColors: [Colors.amber, Colors.amber],
        onFabButtonPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
      ),
    );
  }
}
