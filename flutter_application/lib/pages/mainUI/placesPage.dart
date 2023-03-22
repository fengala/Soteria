import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/places.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/places.dart';

class PlacesP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venues',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PlacesPage(),
    );
  }
}

class PlacesPage extends StatefulWidget {
  PlacesPage({Key key}) : super(key: key);

  @override
  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  Future<List<dynamic>> _placessFuture;

  @override
  void initState() {
    super.initState();
    _placessFuture = getAllPlaces();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

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
          'Social Venues',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _placessFuture = getAllPlaces();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _placessFuture = getAllPlaces();
          });
        },
        child: placesList(),
      ), //
    );
  }

  Widget placesList() {
    Future load() async {
      var myFuture = await getAllPlaces() as List;
      return myFuture;
    }

    return FutureBuilder(
      future: getAllPlaces(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> venues = snapshot.data;
          return Container(
            color: Colors.white,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return venues[index];
              },
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(
                    height: 0,
                  ),
              itemCount: venues.length,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching venues'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}