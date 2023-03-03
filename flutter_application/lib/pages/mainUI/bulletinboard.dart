import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/events.dart';
import '../../services/auth.dart';
import '../../services/database.dart';

class BulletinBoardP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bulletin Board',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BulletinBoardPage(),
    );
  }
}

class BulletinBoardPage extends StatefulWidget {
  BulletinBoardPage({Key key}) : super(key: key);

  @override
  _BulletinBoardState createState() => _BulletinBoardState();
}

class _BulletinBoardState extends State<BulletinBoardPage> {
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  Future<List<dynamic>> _BulletinFuture;
  @override
  void initState() {
    super.initState();
    _BulletinFuture = getAllEvents();
  }
  void initBulletinFuture() {
    setState(() {
      _BulletinFuture = getAllEvents();
    });
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myController2.dispose();
    myController3.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.amber,
        leading: Container(
          margin: const EdgeInsets.all(10.0),
        ),
        title: Text(
          'Bulletin Board',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _BulletinFuture = getAllEvents();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _BulletinFuture = getAllEvents();
          });
        },
        child: eventList(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: FloatingActionButton(
          child: Icon(
            FontAwesomeIcons.pen,
            color: Colors.amber,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Create an Event"),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: myController,
                        autofocus: true,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black45, width: 3.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black45, width: 2.0),
                            ),
                            hintStyle: TextStyle(fontSize: 20),
                            hintText: "Enter your event title here"),
                      ),
                      TextField(
                        controller: myController3,
                        autofocus: true,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            hintStyle: TextStyle(fontSize: 15),
                            hintText: "When is the event"),
                      ),
                      TextField(
                        controller: myController2,
                        autofocus: true,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 15),
                            hintText:
                            "Enter your event description here"),
                        keyboardType: TextInputType.multiline,
                        minLines: null,
                        maxLines: null,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        child: Text("CANCEL"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    TextButton(
                      child: Text("CREATE"),
                      onPressed: () async {
                        var user = await DatabaseService()
                            .getUser(UserAuth.auth.currentUser.uid);

                        var eve = await DatabaseService().addEvent(
                            user['username'],
                            myController.text, myController2.text, myController3.text);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }

  // Widget listOfEvents() {
  //   return Container(
  //     color: Colors.white,
  //     child: ListView.separated(
  //       itemBuilder: (BuildContext context, int index) {
  //         return events[index];
  //       },
  //       separatorBuilder: (BuildContext context, int index) => Divider(
  //         height: 0,
  //       ), itemCount: events.length,
  //     ),
  //   );
  // }

  Widget eventList() {
    Future load() async {
      var myFuture = await getAllEvents() as List;
      return myFuture;
    }

    return FutureBuilder(
      future: getAllEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> events = snapshot.data;
          return Container(
            color: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 150.0),
              itemBuilder: (BuildContext context, int index) {
                return events[index];
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 0,
              ),
              itemCount: events.length,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching events'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }




}