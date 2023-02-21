import 'package:flutter/material.dart';
import 'package:flutter_login_ui/petitionpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'startpoint.dart';
import 'login.dart';
import 'tweets.dart';
import 'package:pandabar/pandabar.dart';

class ResourceP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resources',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ResourcesPage(),
    );
  }
}

class ResourcesPage extends StatefulWidget {
  ResourcesPage({Key key}) : super(key: key);

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
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
          'Resources Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
