import 'package:flutter/material.dart';
import 'package:flutter_login_ui/petitionpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home.dart';
import 'login.dart';
import 'tweets.dart';
import 'package:pandabar/pandabar.dart';

class EventsP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: EventsPage(),
    );
  }
}

class EventsPage extends StatefulWidget {
  EventsPage({Key key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    int page = 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.amber,
        leading: Container(
          margin: const EdgeInsets.all(10.0),
          //child: CircleAvatar(
          //backgroundImage: AssetImage('nanou.jpeg'),
          //  ),
        ),
        title: Text(
          'Events Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: PandaBar(
        buttonData: [
          PandaBarButtonData(
            id: 1,
            icon: Icons.home,
            title: 'Home',
          ),
          PandaBarButtonData(
            id: 2,
            icon: Icons.edit_document,
            title: 'Petitions',
          ),
          PandaBarButtonData(
            id: 3,
            icon: Icons.event,
            title: 'Events',
          ),
          PandaBarButtonData(
            id: 4,
            icon: Icons.lightbulb,
            title: 'Resources',
          ),
        ],
        onChange: (id) {
          setState(() {
            page = id;
          });
          Navigator.push(context, newMethod(id));
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
      body: Builder(
        builder: (context) {
          switch (page) {
            case 1:
              return Container(color: Colors.grey.shade900);
            case 2:
              return Container(color: Colors.blue.shade900);
            case 3:
              return Container(color: Colors.red.shade900);
            case 4:
              return Container(color: Colors.yellow.shade700);
            default:
              return Container();
          }
        },
      ),
    );
  }

  MaterialPageRoute<dynamic> newMethod(id) {
    switch (id) {
      case 1:
        return MaterialPageRoute(builder: ((context) => HomePage()));
      case 2:
        return MaterialPageRoute(builder: ((context) => PetitionPage()));
      case 3:
        return MaterialPageRoute(builder: ((context) => EventsPage()));
      case 4:
        return MaterialPageRoute(builder: ((context) => PetitionPage()));
      default:
        return MaterialPageRoute(builder: ((context) => HomePage()));
    }
  }
}
