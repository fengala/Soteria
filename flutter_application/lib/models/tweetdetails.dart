import 'dart:io';

import 'package:flutter/material.dart';
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

class _TweetDetailsPageState extends State<tweetdetails> {
  final myController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController2.dispose();
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
          Divider(height: 0.0),
          Expanded(
            ///////////////////////////////////////////////////
            child: ListView.builder(
              itemCount: widget.replies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.replies[index].replyText),
                  subtitle: Text('@${widget.replies[index].username} '
                      '· ${widget.replies[index].time}'),
                );
              },
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
                      content: Column(
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
                          },
                        )
                      ],
                    ));
          },
        ),
      ),
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
