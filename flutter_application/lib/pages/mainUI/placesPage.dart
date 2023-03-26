import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/places.dart';
import 'package:flutter_login_ui/services/database.dart';

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
    _placessFuture = getAllPlaces(filter_val);
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
              setState(() {
                _placessFuture = getAllPlaces(filter_val);
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _placessFuture = getAllPlaces(filter_val);
          });
        },
        child: placesList(),
      ), //
    );
  }

  Widget placesList() {
    Future load() async {
      var myFuture = await getAllPlaces(filter_val) as List;
      return myFuture;
    }

    return FutureBuilder(
      future: getAllPlaces(filter_val),
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
      'Default',
      'Ratings / Reviews Ratio',
      'High Ratings',
      'Low Ratings',
      'High Reviews',
      'Low Reviews'
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
          if (value == 'Default') {
            filter_val = 0;
          } else if (value == 'Ratings / Reviews Ratio') {
            filter_val = 1;
          } else if (value == 'High Ratings') {
            filter_val = 2;
          } else if (value == 'Low Ratings') {
            filter_val = 3;
          } else if (value == 'High Reviews') {
            filter_val = 4;
          } else if (value == 'Low Reviews') {
            filter_val = 5;
          }
        });
      }
    });
  }
}
