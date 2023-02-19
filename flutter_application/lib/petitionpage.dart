import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tweets.dart';

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
        backgroundColor: Color.fromARGB(230, 231, 213, 19),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.pen),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => LoginPage()));
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Create a Petition"),
                    // content: TextField(
                    //   autofocus: true,
                    //   decoration: InputDecoration(
                    //       hintText: "Enter your petition description here"),
                    // ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0),
                              ),
                              hintStyle: TextStyle(fontSize: 15),
                              hintText: "Enter your petition title here"),
                        ),
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: 15),
                              hintText: "Enter your petition description here"),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildBottomIconButton(Icons.home, Colors.blue),
            buildBottomIconButton(Icons.search, Colors.black45),
            buildBottomIconButton(Icons.notifications, Colors.black45),
            buildBottomIconButton(Icons.mail_outline, Colors.black45),
          ],
        ),
      ),
    );
  }

  Widget buildBottomIconButton(IconData icon, Color color) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
      ),
      onPressed: () {},
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
      ),
    );
  }
}
