import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Tweet extends StatelessWidget {
  final String username;
  final String name;
  final String description;
  final String comments;
  final String votes;

  const Tweet(
      {Key key,
       this.username,
       this.name,
       this.description,
       this.comments,
       this.votes})
      : super(key: key);

  factory Tweet.fromFirestore(
  DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
  final data = snapshot.data();
    return Tweet(
      username: data['username'],
      name: data['name'],
      description: data['description'],
      comments: data['comments'],
      votes: data['votes'], key: data['key'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (username != null) "username": username,
      if (description != null) "description": description,
      if (comments != null) "comments": comments,
      if (votes != null) "votes": votes,
    };
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetAvatar(),
          tweetBody(),
        ],
      ),
    );
  }

  Widget tweetAvatar() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      //child: CircleAvatar(
      //backgroundImage: NetworkImage(this.avatar),
      //),
    );
  }

  Widget tweetBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetHeader(),
          tweetText(),
          tweetButtons(),
        ],
      ),
    );
  }

  Widget tweetHeader() {
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
        Spacer(),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.plus,
            size: 14.0,
            color: Colors.grey,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget tweetText() {
    return Text(
      name,
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
          //tweetIconButton(FontAwesomeIcons.retweet, this.retweets),
          tweetIconButton(FontAwesomeIcons.heart, this.votes),
          //tweetIconButton(FontAwesomeIcons.share, ''),
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