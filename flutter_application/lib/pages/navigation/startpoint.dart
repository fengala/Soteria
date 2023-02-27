import 'package:flutter/material.dart';
import 'package:pandabar/pandabar.dart';

import '../authentication/login.dart';
import '../mainUI/events.dart';
import '../mainUI/homepage.dart';
import '../mainUI/petitionpage.dart';
import '../mainUI/resourcepage.dart';

class HomeP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petitions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int page = 0;
  int _currentIndex = 0;
  final List<Widget> _children = [
    TP(),
    PetitionP(),
    EventsP(),
    ResourceP(),
    //TP()
  ];

  @override
  Widget build(BuildContext context) {
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