import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/replies.dart';
import 'package:flutter_login_ui/models/tweetdetails.dart';
import 'package:flutter_login_ui/pages/mainUI/petitionpage.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'reply.dart';

class Tweet extends StatelessWidget {
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

  Tweet(
      {Key key,
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
      @required this.i})
      : super(key: key);

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
      future: getAllReplies(id),
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
                '@$name · $time',
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
                        title: text,
                        description: description,
                        pid: id,
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
      text,
      overflow: TextOverflow.clip,
    );
  }

  Widget tweetButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          tweetIconButton1(FontAwesomeIcons.comment, this.comments),
          this.i == 1
              ? tweetIconButton2_1(FontAwesomeIcons.heart, this.favorites)
              : tweetIconButton2(FontAwesomeIcons.solidHeart, this.favorites),
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
          onPressed: () {
            print("Pressed Upvote");
            Future x = DatabaseService()
                .userUpvoteCheckPet(id, UserAuth.auth.currentUser.uid, 1);
            if (x == true) {
              print(this.favorites);
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

  Widget tweetIconButton2_1(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            print("Pressed Upvote");
            Future x = DatabaseService()
                .userUpvoteCheckPet(id, UserAuth.auth.currentUser.uid, 1);
            if (x == true) {
              print(this.favorites);
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
