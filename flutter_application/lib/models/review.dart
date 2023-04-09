import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/replies.dart';
import 'package:flutter_login_ui/models/reply.dart';
import 'package:flutter_login_ui/models/reviewdetails.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth.dart';
import '../services/database.dart';

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
          .description,
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