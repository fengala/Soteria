import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'events.dart';
import 'home.dart';
import 'login.dart';
import 'tweets.dart';
import 'package:pandabar/pandabar.dart';

class PetitionP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petitions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PetitionPage(),
    );
  }
}

class PetitionPage extends StatefulWidget {
  PetitionPage({Key key}) : super(key: key);

  @override
  _PetitionPageState createState() => _PetitionPageState();
}

class _PetitionPageState extends State<PetitionPage> {
  @override
  Widget build(BuildContext context) {
    String page = 'Grey';
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
          'Petition Board',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: listOfTweets(),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.pen),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => LoginPage()));
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Create a Petition"),
                    // content: TextField(
                    //   autofocus: true,
                    //   decoration: InputDecoration(
                    //       hintText: "Enter your petition description here"),
                    // ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0),
                              ),
                              hintStyle: TextStyle(fontSize: 15),
                              hintText: "Enter your petition title here"),
                        ),
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: 15),
                              hintText: "Enter your petition description here"),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text("CANCEL"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ));
        },
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
      // extendBody: true,
      // bottomNavigationBar: PandaBar(
      //   buttonData: [
      //     PandaBarButtonData(
      //       id: 'Grey',
      //       icon: Icons.home,
      //       title: 'Home',
      //     ),
      //     PandaBarButtonData(
      //       id: 'Blue',
      //       icon: Icons.edit_document,
      //       title: 'Petitions',
      //     ),
      //     PandaBarButtonData(
      //       id: 'Red',
      //       icon: Icons.event,
      //       title: 'Events',
      //     ),
      //     PandaBarButtonData(
      //       id: 'Resources',
      //       icon: Icons.lightbulb,
      //       title: 'Resources',
      //     ),
      //   ],
      //   onChange: (id) {
      //     setState(() {
      //       page = id;
      //       // Navigator.push(
      //       //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      //     });
      //     // Navigator.push(
      //     //     context, MaterialPageRoute(builder: ((context) => LoginPage())));
      //   },
      //   buttonColor: Colors.white,
      //   buttonSelectedColor: Colors.amber,
      //   fabIcon: Icon(Icons.sos, size: 40),
      //   fabColors: [Colors.amber, Colors.amber],
      //   onFabButtonPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => LoginPage()));
      //   },
      // ),
    );
  }

  MaterialPageRoute<dynamic> newMethod(id) {
    switch (id) {
      case 1:
        PandaBar(buttonSelectedColor: Colors.red);
        return MaterialPageRoute(builder: ((context) => HomePage()));
      case 2:
        return MaterialPageRoute(builder: ((context) => PetitionPage()));
      case 3:
        PandaBar(buttonSelectedColor: Colors.red);
        return MaterialPageRoute(builder: ((context) => EventsPage()));
      case 4:
        return MaterialPageRoute(builder: ((context) => PetitionPage()));
      default:
        return MaterialPageRoute(builder: ((context) => HomePage()));
    }
  }

  Widget listOfTweets() {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return tweets[index];
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
        ),
        itemCount: tweets.length,
      ),
    );
  }
}
