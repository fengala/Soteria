import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/tweets.dart';

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
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  Future<List<dynamic>> _petitionsFuture;

  @override
  void initState() {
    super.initState();
    _petitionsFuture = getAllPetitions();
  }

  void initPetitionsFuture() {
    setState(() {
      _petitionsFuture = getAllPetitions();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myController2.dispose();
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _petitionsFuture = getAllPetitions();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _petitionsFuture = getAllPetitions();
          });
        },
        child: petitionList(),
      ), //petitionList(),
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
                      title: Text("Create a Petition"),
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
                                      color: Colors.grey, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                ),
                                hintStyle: TextStyle(fontSize: 15),
                                hintText: "Enter your petition title here"),
                          ),
                          TextField(
                            controller: myController2,
                            autofocus: true,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(fontSize: 15),
                                hintText:
                                    "Enter your petition description here"),
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

                            var pet = await DatabaseService().addPetition(
                                user['name'],
                                myController.text,
                                myController2.text);
                            Navigator.pop(context);
                            setState(() {
                              _petitionsFuture = getAllPetitions();
                            });
                          },
                        )
                      ],
                    ));
          },
        ),
      ),
    );
  }

  Widget petitionList() {
    Future load() async {
      var myFuture = await getAllPetitions() as List;
      return myFuture;
    }

    return FutureBuilder(
      future: getAllPetitions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> petitions = snapshot.data;
          return Container(
            color: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 150.0),
              itemBuilder: (BuildContext context, int index) {
                return petitions[index];
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 0,
              ),
              itemCount: petitions.length,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching petitions'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  // return Container(
  //   color: Colors.white,
  //   child: ListView.separated(
  //     itemBuilder: (BuildContext context, int index) {
  //       // var myFuture = await getPetitions() as List;

  //       // List<dynamic> tweets = myFuture as List;
  //       List<Object> list = load() as List<Object>;
  //       return list[index];
  //       // return tweets[index];
  //     },
  //     separatorBuilder: (BuildContext context, int index) => Divider(
  //       height: 0,
  //     ),
  //     itemCount: 5, //tweets.length,
  //     //itemCount: tweets.length,
  //   ),
  // );
}
