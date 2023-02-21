import 'package:flutter/material.dart';
import 'package:flutter_login_ui/petitionpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'startpoint.dart';
import 'login.dart';
import 'tweets.dart';
import 'package:pandabar/pandabar.dart';

class TP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TPage(),
    );
  }
}

class TPage extends StatefulWidget {
  TPage({Key key}) : super(key: key);

  @override
  TePage createState() => TePage();
}

class TePage extends State<TPage> {
  @override
  Widget build(BuildContext context) {
    int page = 1;
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
          'Home Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
