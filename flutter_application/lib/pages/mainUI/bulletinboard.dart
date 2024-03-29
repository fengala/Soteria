import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/eventdetails.dart';
import '../../models/events.dart';
import '../../models/replies.dart';
import '../../models/reply.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future _eventsFuture;
int filter_val = 0;

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
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> eventsStream() {
    return firestore.collection('Event').snapshots();
  }

  @override
  void initState() {
    super.initState();
    _eventsFuture = getAllEvents(filter_val);
    eventsStream().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      initEventsFuture();
    });
  }

  void initEventsFuture() {
    setState(() {
      _eventsFuture = getAllEvents(filter_val);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
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
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showFilterMenu(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              var user = FirebaseAuth.instance.currentUser;
              if (user.email.contains("purdue.edu")) {
                await DatabaseService().updateVerification(user.uid);
              }
              setState(() {
                _eventsFuture = getAllEvents(filter_val);
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _eventsFuture = getAllEvents(filter_val);
          });
        },
        child: eventList(),
      ),
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
                      title: Text("Create an Event"),
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
                            TextField(
                              controller: myController4,
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  hintText: "Enter RSVP form (optional)"),
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
                            var user = await DatabaseService()
                                .getUser(UserAuth.auth.currentUser.uid);
                            if (myController.text == "" ||
                                myController2.text == "" ||
                                myController3.text == "") {
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
                              var eve = await DatabaseService().addEvent(
                                  user['name'],
                                  myController.text,
                                  myController2.text,
                                  myController3.text,
                                  myController4.text,
                                  UserAuth.auth.currentUser.uid);
                              Navigator.pop(context);
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

  Widget eventList() {
    Future load() async {
      var myFuture = await getAllEvents(filter_val) as List;
      return myFuture;
    }

    return FutureBuilder(
      future: getAllEvents(filter_val),
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

class Event extends StatefulWidget {
  final String title;
  final String name;
  String comments;
  String upvotes;
  final String time;
  final String when;
  final String id;
  final String description;
  final int hasUpvote;
  final int hasRSVP;
  final String rsvp_form;
  final int alreadyRSVP;
  final String userId;
  final int ver;

  Event({
    Key key,
    @required this.title,
    @required this.name,
    @required this.comments,
    @required this.time,
    @required this.upvotes,
    @required this.id,
    @required this.description,
    @required this.hasUpvote,
    @required this.when,
    @required this.hasRSVP,
    @required this.rsvp_form,
    @required this.alreadyRSVP,
    @required this.userId,
    @required this.ver,
  }) : super(key: key);

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          eventAvatar(),
          eventBody(context),
        ],
      ),
    );
  }

  Widget eventAvatar() {
    return Container(
      margin: const EdgeInsets.all(10.0),
    );
  }

  Widget eventBody(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          eventHeader(context),
          eventText(),
          eventWhen(),
          eventButtons(),
        ],
      ),
    );
  }

  Widget eventHeader(BuildContext context) {
    return FutureBuilder<List<Reply>>(
      future: getAllRepliesEve(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(widget.id);
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
                      builder: (context) => eventdetails(
                        title: widget.title,
                        description: widget.description,
                        eid: widget.id,
                        replies: replies,
                        when: widget.when,
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

  Widget eventText() {
    return Text(
      widget.title,
      overflow: TextOverflow.clip,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget eventWhen() {
    return Text(
      widget.when,
      overflow: TextOverflow.clip,
    );
  }

  Widget eventButtons() {
    //print("Yo $i");
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          this.widget.ver == 1

              /// change this
              ? tweetIconButton0(FontAwesomeIcons.checkToSlot)
              : tweetIconButton0_1(FontAwesomeIcons.checkDouble),
          eventIconButton1(FontAwesomeIcons.comments, this.widget.comments),
          this.widget.hasUpvote == 1
              ? eventIconButton2_1(FontAwesomeIcons.heart, this.widget.upvotes)
              : eventIconButton2(
                  FontAwesomeIcons.solidHeart, this.widget.upvotes),
          this.widget.hasRSVP == 1
              ? this.widget.alreadyRSVP == 1
                  ? eventIconButton3_1(
                      FontAwesomeIcons.solidCalendarCheck, 'RSVP')
                  : eventIconButton3(FontAwesomeIcons.calendarCheck, 'RSVP')
              : eventIconButton3_X(FontAwesomeIcons.calendarXmark, ''),
        ],
      ),
    );
  }

  Widget tweetIconButton0_1(IconData icon) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.x),
          onPressed: () {
            print("Pressed Tick");
          },
          iconSize: 16.0,
          color: Colors.red,
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
        ),
      ],
    );
  }

  Widget tweetIconButton0(IconData icon) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.check),
          onPressed: () {
            print("Pressed Tick");
          },
          iconSize: 16.0,
          color: Colors.green,
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
        ),
      ],
    );
  }

  Widget eventIconButton1(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.comment),
          onPressed: () {
            print("Pressed Comment");
          },
          iconSize: 16.0,
          color: Colors.black45,
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: Text(text,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 14.0,
              )),
        ),
      ],
    );
  }

  Widget eventIconButton2(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            print("Pressed Undo Upvote");
            Future x = DatabaseService().userUpvoteCheckEve(
                widget.id, UserAuth.auth.currentUser.uid, 1);
            if (x == true) {
              print(this.widget.upvotes);
              icon = FontAwesomeIcons.solidHeart;
            }
            setState(() {
              _eventsFuture = getAllEvents(filter_val);
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

  Widget eventIconButton2_1(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            print("Pressed Upvote");
            Future x = DatabaseService().userUpvoteCheckEve(
                widget.id, UserAuth.auth.currentUser.uid, 1);
            if (x == true) {
              icon = FontAwesomeIcons.solidHeart;
            }
            setState(() {
              _eventsFuture = getAllEvents(filter_val);
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

  Widget eventIconButton3_X(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            print("Pressed No RSVP");
          },
          icon: Icon(icon),
          iconSize: 16.0,
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

  Widget eventIconButton3(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            print("Pressed RSVP");
            String form = await DatabaseService()
                .getFormCheck(widget.id, UserAuth.auth.currentUser.uid);
            final uri = Uri.parse(form);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);

              bool rsvp = await showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text("RSVP"),
                        content: Text("Have you RSVP'd for this event?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.pop(context,
                                  false); // Return false when 'No' button clicked
                            },
                          ),
                          TextButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              bool x = await DatabaseService()
                                  .userUpvoteCheckEve(widget.id,
                                      UserAuth.auth.currentUser.uid, 1);
                              x = !x;
                              x = await DatabaseService().userUpvoteCheckEve(
                                  widget.id, UserAuth.auth.currentUser.uid, 1);
                              // Future y = DatabaseService().userUpvoteCheckEve(
                              //     widget.id, UserAuth.auth.currentUser.uid, 1);
                              // Future x = DatabaseService().getEvents();
                              // if (y == false) {
                              //   print(this.widget.upvotes);
                              //   icon = FontAwesomeIcons.solidHeart;
                              // }
                              // if (x == true) {
                              //   icon = FontAwesomeIcons.solidHeart;
                              // }
                              setState(() {
                                _eventsFuture = getAllEvents(filter_val);
                              });

                              // setState(() {
                              //   // _rsvp = true;
                              //   _eventsFuture = getAllEvents(filter_val);
                              //   print("here");
                              // });
                              Navigator.pop(context,
                                  true); // Return true when 'Yes' button clicked
                            },
                          ),
                        ],
                      ));

              print("RSVP: $rsvp");
              if (rsvp) {
                icon = FontAwesomeIcons.solidCalendarCheck;
                Future x = DatabaseService()
                    .addRSVPConfirm(widget.id, UserAuth.auth.currentUser.uid);
                if (x == true) {
                  icon = FontAwesomeIcons.solidCalendarCheck;
                }

                print('DB');
                setState(() {
                  print('setting...');
                  _eventsFuture = getAllEvents(filter_val);
                });
                print('DB done');
              } else {
                icon = FontAwesomeIcons.calendarCheck;
              }

              print('RSVP YES/NO');

              setState(() {
                print('setting...');
                _eventsFuture = getAllEvents(filter_val);
              });

              print('DONE');
            } else {
              throw 'Could not launch rsvp_form';
            }

            setState(() {
              print('setting...');
              _eventsFuture = getAllEvents(filter_val);
            });

            print('EXIT');
          },
          icon: Icon(icon),
          iconSize: 16.0,
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

  Widget eventIconButton3_1(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            print("Pressed RSVP");
            String form = await DatabaseService()
                .getFormCheck(widget.id, UserAuth.auth.currentUser.uid);
            final uri = Uri.parse(form);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
              icon = FontAwesomeIcons.solidCalendarCheck;
            } else {
              throw 'Could not launch rsvp_form';
            }
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
}

class RSVPDialog extends StatefulWidget {
  @override
  _RSVPDialogState createState() => _RSVPDialogState();
}

class _RSVPDialogState extends State<RSVPDialog> {
  // bool _rsvp = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("RSVP"),
      content: Text("Have you RSVP'd for this event?"),
      actions: <Widget>[
        TextButton(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(
                context, false); // Return false when 'No' button clicked
          },
        ),
        TextButton(
          child: Text("Yes"),
          onPressed: () {
            // setState(() {
            //   _rsvp = true;
            // });
            setState(() {
              _eventsFuture = getAllEvents(filter_val);
            });
            Navigator.pop(
                context, true); // Return true when 'Yes' button clicked
          },
        ),
      ],
    );
  }
}
