import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/replies.dart';
import 'package:flutter_login_ui/models/reply.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';

class tweetdetails extends StatefulWidget {
  final String title;
  final String description;
  final List<Reply> replies;
  final String pid;

  tweetdetails({
    Key key,
    @required this.title,
    @required this.description,
    @required this.replies,
    @required this.pid,
  }) : super(key: key);

  @override
  _TweetDetailsPageState createState() => _TweetDetailsPageState();
}

Future _petitionsFuture;

class _TweetDetailsPageState extends State<tweetdetails> {
  final myController2 = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _mounted = false;

  Stream<QuerySnapshot<Map<String, dynamic>>> petitionsStream() {
    return firestore.collection('Petitions').snapshots();
  }

  @override
  void initState() {
    super.initState();
    _mounted = true;

    _petitionsFuture = getAllRepliesPet(widget.pid);
    petitionsStream().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      // Trigger an automatic update
      if (_mounted) {
        setState(() {
          initPetitionsFuture();
        });
      }
    });
  }

  void initPetitionsFuture() {
    setState(() {
      _petitionsFuture = getAllRepliesPet(widget.pid);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController2.dispose();
    _mounted = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Petition",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: replyList(),
            ),
          ),
        ],
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
                      title: Text("Enter Your Reply"),
                      content: SingleChildScrollView( child:Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: myController2,
                            autofocus: true,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(fontSize: 15),
                                hintText: "Type here"),
                            keyboardType: TextInputType.multiline,
                            minLines: null,
                            maxLines: null,
                          ),
                        ],
                      ),
                      ),
                      actions: [
                        TextButton(
                            child: Text("CANCEL"),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        TextButton(
                            child: Text("REPLY"),
                            onPressed: () async {
                              var user = await DatabaseService()
                                  .getUser(UserAuth.auth.currentUser.uid);

                              var pet = await DatabaseService()
                                  .addReplyToAPetition(widget.pid,
                                      user['username'], myController2.text);
                              Navigator.pop(context);
                              if (_mounted) {
                                setState(() {
                                  initPetitionsFuture();
                                });
                              }
                            })
                      ],
                    ));
          },
        ),
      ),
    );
  }

  Widget replyList() {
    return FutureBuilder(
      future: getAllRepliesPet(widget.pid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> replies = snapshot.data;
          return Container(
            color: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 150.0),
              itemBuilder: (BuildContext context, int index) {
                return replies[index];
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 0,
              ),
              itemCount: replies.length,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching replies'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  /*Widget petitionList() {
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
  }*/
}
