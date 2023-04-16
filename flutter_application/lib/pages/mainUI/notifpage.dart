import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/user.dart';
import 'package:flutter_login_ui/pages/navigation/startpoint.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/notifs.dart';

Future _notifsFuture;

class NotifsP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NotifsPage(),
    );
  }
}

class NotifsPage extends StatefulWidget {
  NotifsPage({Key key}) : super(key: key);

  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifsPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);


  var user_id = FirebaseAuth.instance.currentUser.uid;
  //var user_details = await DatabaseService().getUser(user_fir.uid);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> notifsStream() {
    return firestore.collection('Notifications').snapshots();
  }

  @override
  void initState() {
    super.initState();
    print(user_id);
    _notifsFuture = getAllNotifs(user_id);
    notifsStream().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      // Trigger an automatic update
      initNotifsFuture();
    });
  }

  void initNotifsFuture() {
    setState(() {
      _notifsFuture = getAllNotifs(user_id);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.amber,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //TODO
          },
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                _notifsFuture = getAllNotifs(user_id);
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _notifsFuture = getAllNotifs(user_id);
          });
        },
        child: notificationsList(),
      ),
    );
  }

  Widget notificationsList() {
    return FutureBuilder(
      future: getAllNotifs(user_id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> notifs = snapshot.data;
          return Container(
            color: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 150.0),
              itemBuilder: (BuildContext context, int index) {
                return notifs[index];
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 0,
              ),
              itemCount: notifs.length,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching notifs'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Notif extends StatefulWidget {
  final String uid;
  final String text;
  final String time;
  final String id;

  Notif({
    Key key,
    @required this.uid,
    @required this.text,
    @required this.time,
    @required this.id,
  }) : super(key: key);

  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          notifAvatar(),
          notifBody(context),
        ],
      ),
    );
  }

  Widget notifAvatar() {
    return Container(
      margin: const EdgeInsets.all(10.0),
    );
  }

  Widget notifBody(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          notifHeader(context),
          notifText(),
          notifText2(),
          //notifButtons(),
        ],
      ),
    );
  }

  Widget notifHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 0.0),
        ),
        Text(
          '@${widget.time}',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () async {
            print("Pressed Cancel");

            Future x = DatabaseService().removeNotif(widget.id);

            setState(() {
              _notifsFuture = getAllNotifs(widget.uid);
            });
          },
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.xmark,
              size: 16.0,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget notifText() {
    return Text(
      widget.text,
      overflow: TextOverflow.clip,
    );
  }

  Widget notifText2() {
    return Text(
      "",
      //widget.text,
      overflow: TextOverflow.clip,
    );
  }

  Widget notifButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 0.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          notifIconButton(FontAwesomeIcons.xmark, ""),

        ],
      ),
    );
  }

  Widget notifIconButton(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.xmark),
          onPressed: () {
            print("Pressed Cancel");
            setState(() {
              _notifsFuture = getAllNotifs(widget.uid);
            });
          },
          iconSize: 16.0,
          color: Colors.black45,
        ),
        Container(
          margin: const EdgeInsets.all(0.0),
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
