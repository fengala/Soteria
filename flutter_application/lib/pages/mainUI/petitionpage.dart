import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/tweet.dart';
import 'package:flutter_login_ui/models/user.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/replies.dart';
import '../../models/reply.dart';
import '../../models/tweetdetails.dart';
import '../../models/tweets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future _petitionsFuture;
int filter_val = 0;

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
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  // Future _petitionsFuture;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> petitionsStream() {
    return firestore.collection('Petitions').snapshots();
  }

  @override
  void initState() {
    super.initState();
    _petitionsFuture = getAllPetitions(filter_val);
    petitionsStream().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      // Trigger an automatic update
      initPetitionsFuture();
    });
  }

  void initPetitionsFuture() {
    setState(() {
      _petitionsFuture = getAllPetitions(filter_val);
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
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showFilterMenu(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              var user = FirebaseAuth.instance.currentUser;

              await DatabaseService().updateVerification(user.uid);

              setState(() {
                _petitionsFuture = getAllPetitions(filter_val);
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _petitionsFuture = getAllPetitions(filter_val);
          });
        },
        child: petitionList(),
      ), //petitionList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
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
                      content: SingleChildScrollView(
                        child: Column(
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
                            print(myController.text);
                            print(myController2.text);
                            if (myController.text == "" ||
                                myController2.text == "") {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(Icons.close),
                                            DefaultTextStyle(
                                                style: style,
                                                child: Text(
                                                  "A few fields are missing!",
                                                  textAlign: TextAlign.center,
                                                  style: style.copyWith(
                                                    color: Colors.red,
                                                  ),
                                                )),
                                          ])));
                            } else {
                              var user = await DatabaseService()
                                  .getUser(UserAuth.auth.currentUser.uid);

                              var pet = await DatabaseService().addPetition(
                                  user['name'],
                                  myController.text,
                                  myController2.text,
                                  UserAuth.auth.currentUser.uid);

                              Navigator.pop(context);
                              setState(() {
                                _petitionsFuture = getAllPetitions(filter_val);
                              });
                            }
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
    // Future load() async {
    //   var myFuture = await getAllPetitions(filter_val) as List;
    //   return myFuture;
    // }

    return FutureBuilder(
      future: getAllPetitions(filter_val),
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

  void showFilterMenu(BuildContext context) {
    final List<String> filters = [
      'Newest',
      'Oldest',
      'High Upvotes',
      'Low Upvotes',
      'High Replies',
      'Low Replies'
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 50, 0, 0),
      items: filters.asMap().entries.map((entry) {
        int index = entry.key;
        String filter = entry.value;
        return PopupMenuItem<String>(
          value: filter,
          child: Row(
            children: [
              Expanded(
                child: Text(filter),
              ),
              if (index == filter_val)
                Icon(
                    Icons.check), // Show a checkmark icon for the selected item
            ],
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          if (value == 'Newest') {
            filter_val = 0;
          } else if (value == 'Oldest') {
            filter_val = 1;
          } else if (value == 'High Upvotes') {
            filter_val = 2;
          } else if (value == 'Low Upvotes') {
            filter_val = 3;
          } else if (value == 'High Replies') {
            filter_val = 4;
          } else if (value == 'Low Replies') {
            filter_val = 5;
          }
        });
      }
    });
  }
}

class Tweet extends StatefulWidget {
  final String avatar;
  final String username;
  final String name;
  final String text;
  String comments;
  String retweets;
  String favorites;
  final String time;
  final String id;
  final String description;
  final int i;
  final String userId;
  final int ver;

  Tweet({
    Key key,
    @required this.avatar,
    @required this.username,
    @required this.name,
    @required this.text,
    @required this.retweets,
    @required this.comments,
    @required this.time,
    @required this.favorites,
    @required this.id,
    @required this.description,
    @required this.i,
    @required this.userId,
    @required this.ver,
  }) : super(key: key);

  @override
  _TweetState createState() => _TweetState();
}

class _TweetState extends State<Tweet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetAvatar(),
          tweetBody(context),
        ],
      ),
    );
  }

  Widget tweetAvatar() {
    return Container(
      margin: const EdgeInsets.all(10.0),
    );
  }

  Widget tweetBody(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetHeader(context),
          tweetText(),
          tweetButtons(),
        ],
      ),
    );
  }

  Widget tweetHeader(BuildContext context) {
    return FutureBuilder<List<Reply>>(
      future: getAllRepliesPet(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error loading replies');
        } else if (!snapshot.hasData) {
          return Text('Loading...');
        } else {
          List<Reply> replies = snapshot.data;
          return Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5.0),
              ),
              Text(
                '@${widget.name} · ${widget.time}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => tweetdetails(
                        title: widget.text,
                        description: widget.description,
                        pid: widget.id,
                        replies: replies,
                      ),
                    ),
                  );
                },
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.plus,
                    size: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget tweetText() {
    return Text(
      widget.text,
      overflow: TextOverflow.clip,
    );
  }

  Widget tweetButtons() {
    //print("Yo $i");
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          tweetIconButton1(FontAwesomeIcons.comment, this.widget.comments),
          this.widget.i == 1
              ? tweetIconButton2_1(
                  FontAwesomeIcons.heart, this.widget.favorites)
              : tweetIconButton2(
                  FontAwesomeIcons.solidHeart, this.widget.favorites),
        ],
      ),
    );
  }

  Widget tweetIconButton1(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.comment),
          onPressed: () {
            print("Pressed Comment");
            setState(() {
              _petitionsFuture = getAllPetitions(filter_val);
            });
          },
          iconSize: 16.0,
          color: Colors.black45,
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget tweetIconButton2(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            print("Pressed Undo Upvote");
            Future x = DatabaseService().userUpvoteCheckPet(
                widget.id, UserAuth.auth.currentUser.uid, 1);
            if (x == true) {
              print(this.widget.favorites);
              icon = FontAwesomeIcons.solidHeart;
            }
            setState(() {
              _petitionsFuture = getAllPetitions(filter_val);
            });
          },
          icon: Icon(icon),
          iconSize: 16.0,
          color: Colors.amber,
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget tweetIconButton2_1(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            print("Pressed Upvote");
            Future x = DatabaseService().userUpvoteCheckPet(
                widget.id, UserAuth.auth.currentUser.uid, 1);
            if (x == true) {
              print(this.widget.favorites);
              icon = FontAwesomeIcons.solidHeart;
            }
            setState(() {
              _petitionsFuture = getAllPetitions(filter_val);
            });
          },
          icon: Icon(icon),
          iconSize: 16.0,
          color: Colors.black45,
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}
