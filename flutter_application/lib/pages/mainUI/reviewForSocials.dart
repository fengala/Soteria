import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/mainUI/placesPage.dart';
import 'package:flutter_login_ui/pages/mainUI/socialHouse.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/reviews.dart';
import '../../models/replies.dart';
import '../../models/reply.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/reviewdetails.dart';

Future _eventsFuture;
int filter_val = 0;
int filter_val2 = 5;

class reviewForSocials extends StatelessWidget {
  final String id;

  reviewForSocials({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reviews',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BulletinBoardPage(id: id),
    );
  }
}

class BulletinBoardPage extends StatefulWidget {
  final String id;
  BulletinBoardPage({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _BulletinBoardState createState() => _BulletinBoardState(3);
}

class AnonymousCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  AnonymousCheckbox({this.initialValue = false, this.onChanged});

  @override
  _AnonymousCheckboxState createState() => _AnonymousCheckboxState();
}

class _AnonymousCheckboxState extends State<AnonymousCheckbox> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text("Anonymous"),
      value: _value,
      onChanged: (newValue) {
        setState(() {
          _value = newValue;
          widget.onChanged(newValue);
        });
      },
    );
  }
}

class _BulletinBoardState extends State<BulletinBoardPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool isAnonymous = false;
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();
  double _rating;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  _BulletinBoardState(this._rating);

  Stream<QuerySnapshot<Map<String, dynamic>>> reviewForSocialsStream() {
    return firestore.collection('reviews').snapshots();
  }

  @override
  void initState() {
    super.initState();
    _eventsFuture = getSpecificReviews(filter_val, filter_val2, widget.id);
    reviewForSocialsStream()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      initEventsFuture();
    });
  }

  void initEventsFuture() {
    if (this.mounted) {
      setState(() {
        _eventsFuture = getSpecificReviews(filter_val, filter_val2, widget.id);
      });
    }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlacesPage()),
            );
          },
        ),
        title: Text(
          'Reviews',
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
            icon: Icon(Icons.star),
            onPressed: () {
              showFilterMenu2(context);
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
                _eventsFuture =
                    getSpecificReviews(filter_val, filter_val2, widget.id);
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (this.mounted) {
            setState(() {
              _eventsFuture =
                  getSpecificReviews(filter_val, filter_val2, widget.id);
            });
          }
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
                title: Text("Write a Review"),
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
                            borderSide:
                                BorderSide(color: Colors.black45, width: 3.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black45, width: 2.0),
                          ),
                          hintStyle: TextStyle(fontSize: 20),
                          hintText: "Enter your review description here",
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        unratedColor: Colors.amber.withAlpha(50),
                        itemCount: 5,
                        itemSize: 50.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            //print(rating);
                            _rating = rating;
                            print(_rating);
                          });
                        },
                        updateOnDrag: true,
                      ),
                      AnonymousCheckbox(
                        initialValue: isAnonymous,
                        onChanged: (newValue) {
                          setState(() {
                            isAnonymous = newValue;
                            //print(isAnonymous);
                          });
                        },
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("CANCEL"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("CREATE"),
                    onPressed: () async {
                      var user = await DatabaseService()
                          .getUser(UserAuth.auth.currentUser.uid);
                      if (_rating == 0) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Error"),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.close),
                                DefaultTextStyle(
                                  style: style,
                                  child: Text(
                                    "Must give a rating from 1 to 5!",
                                    textAlign: TextAlign.center,
                                    style: style.copyWith(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        var user = await DatabaseService()
                            .getUser(UserAuth.auth.currentUser.uid);
                        var eve = await DatabaseService().addReviewToVenue(
                          widget.id,
                          user['username'],
                          myController.text,
                          isAnonymous,
                          UserAuth.auth.currentUser.uid,
                          _rating,
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget eventList() {
    //print("turky");
    Future load() async {
      var myFuture =
          await getSpecificReviews(filter_val, filter_val2, widget.id) as List;
      return myFuture;
    }

    return FutureBuilder(
      future: getSpecificReviews(filter_val, filter_val2, widget.id),
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
          return Center(child: Text('Error fetching reviews'));
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
      'Low Replies',
      'High Rating',
      'Low Rating',
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
          } else if (value == 'High Rating') {
            filter_val = 6;
          } else if (value == 'Low Rating') {
            filter_val = 7;
          }
        });
      }
    });
  }

  void showFilterMenu2(BuildContext context) {
    final List<String> filters = [
      'Ratings 1-2',
      'Ratings 2-3',
      'Ratings 3-4',
      'Ratings 4-5',
      'Default',
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
              if (index == filter_val2)
                Icon(
                    Icons.check), // Show a checkmark icon for the selected item
            ],
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          if (value == 'Ratings 1-2') {
            filter_val2 = 0;
            filter_val = 6;
          } else if (value == 'Ratings 2-3') {
            filter_val2 = 1;
            filter_val = 6;
          } else if (value == 'Ratings 3-4') {
            filter_val2 = 2;
            filter_val = 6;
          } else if (value == 'Ratings 4-5') {
            filter_val2 = 3;
            filter_val = 6;
          } else if (value == 'Default') {
            filter_val2 = 4;
            filter_val = 6;
          }
        });
      }
    });
  }
}

class Review extends StatefulWidget {
  final String name;
  String comments;
  String upvotes;
  final String time;
  final String id;
  final String description;
  final int hasUpvote;
  final String userId;
  final int ver;
  final bool anonymous;
  final String rating;

  Review({
    Key key,
    @required this.name,
    @required this.comments,
    @required this.time,
    @required this.upvotes,
    @required this.id,
    @required this.description,
    @required this.hasUpvote,
    @required this.userId,
    @required this.ver,
    @required this.anonymous,
    @required this.rating,
  }) : super(key: key);

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Review> {
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
          eventButtons(),
        ],
      ),
    );
  }

  Widget eventHeader(BuildContext context) {
    return FutureBuilder<List<Reply>>(
      future: getAllRepliesRev(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //print(widget.id);
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
                widget.anonymous ? 'Anonymous' : widget.name,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                ' · ${widget.time}',
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
                      builder: (context) => reviewdetails(
                        description: widget.description,
                        eid: widget.id,
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

  Widget eventText() {
    return Text(
      widget
          .description, //////////////////////////////////////////////////////////
      overflow: TextOverflow.clip,
      style: const TextStyle(fontWeight: FontWeight.bold),
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
          eventIconButton1_1(FontAwesomeIcons.star, this.widget.rating),
          eventIconButton1(FontAwesomeIcons.comments, this.widget.comments),
          this.widget.hasUpvote == 1
              ? eventIconButton2_1(FontAwesomeIcons.heart, this.widget.upvotes)
              : eventIconButton2(
                  FontAwesomeIcons.solidHeart, this.widget.upvotes),
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

  Widget eventIconButton1_1(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.solidStar),
          onPressed: () {
            print("Pressed Rating");
          },
          iconSize: 16.0,
          color: Colors.amber,
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
            Future x = DatabaseService().userUpvoteCheckReview(
                widget.id, UserAuth.auth.currentUser.uid, 1);
            if (x == true) {
              print(this.widget.upvotes);
              icon = FontAwesomeIcons.solidHeart;
            }
            setState(() {
              _eventsFuture =
                  getSpecificReviews(filter_val, filter_val2, widget.id);
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
            Future x = DatabaseService().userUpvoteCheckReview(
                widget.id, UserAuth.auth.currentUser.uid, 1);
            if (x == true) {
              icon = FontAwesomeIcons.solidHeart;
            }
            setState(() {
              _eventsFuture =
                  getSpecificReviews(filter_val, filter_val2, widget.id);
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
