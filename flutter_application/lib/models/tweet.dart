import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/tweetdetails.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Tweet extends StatelessWidget {
  final String avatar;
  final String username;
  final String name;
  final String text;
  final String comments;
  final String retweets;
  final String favorites;
  final String time;
  final String id;
  final String description;

  const Tweet(
      {Key key,
      @required this.avatar,
      @required this.username,
      @required this.name,
      @required this.text,
      @required this.comments,
      @required this.retweets,
      @required this.time,
      @required this.favorites,
      @required this.id,
      @required this.description})
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
                builder: (context) => tweetdetails(
                  title: text,
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
          tweetIconButton(FontAwesomeIcons.comment, this.comments),
          tweetIconButton(FontAwesomeIcons.heart, this.favorites),
        ],
      ),
    );
  }

  Widget tweetIconButton(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.0,
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
