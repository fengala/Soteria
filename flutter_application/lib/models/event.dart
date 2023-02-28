import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth.dart';
import '../services/database.dart';
import 'eventdetails.dart';

class Event extends StatelessWidget {
  final String name;
  final String title;
  String comments;
  String upvotes;
  final String time;
  final String id;
  final String description;
  final String when;

  final int hasupvote;
  final int hasRSVP;

  Event(
      {Key key,
        @required this.name,
        @required this.title,
        @required this.comments,
        @required this.upvotes,
        @required this.time,
        @required this.description,
        @required this.when,
        @required this.id,
        @required this.hasupvote,
        @required this.hasRSVP})
      : super(key: key);

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
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5.0),
          //child: Text(
          //this.username,
          //style: TextStyle(
          //color: Colors.black,
          //fontWeight: FontWeight.bold,
          //),
          //),
        ),
        Text(
          '@$name · $time',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Spacer(),
        // IconButton(
        //   icon: Icon(
        //     FontAwesomeIcons.plus,
        //     size: 14.0,
        //     color: Colors.grey,
        //   ),
        //   onPressed: () {
        //     print('Pressed ID: $id');
        //   },
        // ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => eventdetails(
                  title: title,
                  time: time,
                  when: when,
                  description: description,
                  replies: ["Reply 1", "Reply 2", "Reply 3"],
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

  Widget eventText() {
    return Text(
      title,
      overflow: TextOverflow.clip,
    );
  }

  Widget eventButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          eventIconButton1(FontAwesomeIcons.comment, this.comments),
          this.hasupvote == 1
              ? eventIconButton2_1(FontAwesomeIcons.heart, this.upvotes)
              : eventIconButton2(FontAwesomeIcons.solidHeart, this.upvotes),
          this.hasRSVP == 1
              ? eventIconButton3_1(FontAwesomeIcons.calendarCheck, "RSVP")
              : eventIconButton3(FontAwesomeIcons.solidCalendarCheck, "RSVP"),
        ],
      ),
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

  Widget eventIconButton2(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            print("Pressed Undo Upvote");
            Future x = DatabaseService()
                .userUpvoteCheckEve(id, UserAuth.auth.currentUser.uid, 1);
            if (x == true) {
              print(this.upvotes);
              icon = FontAwesomeIcons.solidHeart;
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

  Widget eventIconButton2_1(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            print("Pressed Upvote");
            Future x = DatabaseService()
                .userUpvoteCheckEve(id, UserAuth.auth.currentUser.uid, 1);
            if (x == true) {
              print(this.upvotes);
              icon = FontAwesomeIcons.solidHeart;
            }
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


  Widget eventIconButton3(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            print("Pressed RSVP");
            Future x = DatabaseService()
                .userRSVPCheckEve(id, UserAuth.auth.currentUser.uid);
            if (x == true) {
              icon = FontAwesomeIcons.calendarCheck;
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


  Widget eventIconButton3_1(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            print("Pressed RSVP 2");
            Future x = DatabaseService()
                .userRSVPCheckEve(id, UserAuth.auth.currentUser.uid);
            if (x == true) {
              icon = FontAwesomeIcons.solidCalendarCheck;
            }
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
