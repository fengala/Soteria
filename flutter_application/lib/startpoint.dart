import 'package:flutter/material.dart';
import 'package:flutter_login_ui/petitionpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'events.dart';
import 'login.dart';
import 'homepage.dart';
import 'resourcespage.dart';
import 'tweets.dart';
import 'package:pandabar/pandabar.dart';

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
      // appBar: AppBar(
      //   elevation: 1,
      //   backgroundColor: Colors.amber,
      //   leading: Container(
      //     margin: const EdgeInsets.all(10.0),
      //     //child: CircleAvatar(
      //     //backgroundImage: AssetImage('nanou.jpeg'),
      //     //  ),
      //   ),
      //   title: Text(
      //     'Home Page',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      extendBody: true,
      // body: SizedBox.expand(
      //   child: PageView(
      //     controller: _pageController,
      //     onPageChanged: (index) {
      //       setState(() {
      //         page = index;
      //       });
      //     },
      //     children: [
      //       Container(
      //         color: Colors.white,
      //       ),
      //       Container(
      //         color: Colors.red,
      //       ),
      //       Container(
      //         color: Colors.green,
      //       ),
      //       Container(
      //         color: Colors.yellow,
      //       ),
      //     ],
      //   ),
      // ),
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
            icon: Icons.edit_document,
            title: 'qwert',
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
            //_pageController.jumpToPage(page);
          });
          //Navigator.push(context, newMethod(id));
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
      // body: Builder(
      //   builder: (context) {
      //     switch (page) {
      //       case 1:
      //         return Container(TestP());
      //       case 2:
      //         return Container(color: Colors.blue.shade900);
      //       case 3:
      //         return Container(TestP);
      //       case 4:
      //         return Container(color: Colors.yellow.shade700);
      //       default:
      //         return Container();
      //     }
      //   },
      // ),
    );
  }

  // MaterialPageRoute<dynamic> newMethod(id) {
  //   switch (id) {
  //     case 1:
  //       return MaterialPageRoute(builder: ((context) => HomePage()));
  //     case 2:
  //       return MaterialPageRoute(builder: ((context) => PetitionPage()));
  //     case 3:
  //       return MaterialPageRoute(builder: ((context) => TestPage()));
  //     case 4:
  //       return MaterialPageRoute(builder: ((context) => TestPage()));
  //     default:
  //       return MaterialPageRoute(builder: ((context) => HomePage()));
  //   }
  // }
}
