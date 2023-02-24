import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/tweets.dart';

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
      ),
      body: listOfTweets(),
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
                      title: Text("Create a Petition"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(
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
                            autofocus: true,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 15),
                                hintText:
                                    "Enter your petition description here"),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text("CANCEL"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ));
          },
        ),
      ),
    );
  }

  Widget listOfTweets() {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return tweets[index];
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
        ),
        itemCount: tweets.length,
        //itemCount: tweets.length,
      ),
    );
  }
}
