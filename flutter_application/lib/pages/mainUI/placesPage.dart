import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/places.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/places.dart';

int filter_val = 0;

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
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showFilterMenu(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              var user = FirebaseAuth.instance.currentUser;

              await DatabaseService().updateVerification(user.uid);

              // setState(() {
              //   _petitionsFuture = getAllPetitions(filter_val);
              // });
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
              separatorBuilder: (BuildContext context, int index) => Divider(
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

  void showFilterMenu(BuildContext context) {
    final List<String> filters = [
      'Newest',
      'Oldest',
      'High Upvotes',
      'Low Upvotes',
      'High Replies',
      'Low Replies'
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 50, 0, 0),
      items: filters.asMap().entries.map((entry) {
        int index = entry.key;
        String filter = entry.value;
        return PopupMenuItem<String>(
          value: filter,
          child: Row(
            children: [
              Expanded(
                child: Text(filter),
              ),
              if (index == filter_val)
                Icon(
                    Icons.check), // Show a checkmark icon for the selected item
            ],
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          if (value == 'Newest') {
            filter_val = 0;
          } else if (value == 'Oldest') {
            filter_val = 1;
          } else if (value == 'High Upvotes') {
            filter_val = 2;
          } else if (value == 'Low Upvotes') {
            filter_val = 3;
          } else if (value == 'High Replies') {
            filter_val = 4;
          } else if (value == 'Low Replies') {
            filter_val = 5;
          }
        });
      }
    });
  }
}
