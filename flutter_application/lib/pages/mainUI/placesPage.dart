import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  final CollectionReference revRef = FirebaseFirestore.instance.collection("SocialHouse");

  @override
  void initState() {
    super.initState();
    _placessFuture = getAllPlaces(filter_val);
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
      ),
    );
  }

  Widget placesList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: FutureBuilder(
              future: getAllPlaces(filter_val),
              builder: (context, snapshot) {
    if (snapshot.hasData) {
      List<dynamic> places = snapshot.data;
      List<dynamic> filteredPlaces = [];
      if (places.isNotEmpty) { // check if the list is not empty
        for (int i = 0; i < places.length; i++) {
          print(places[i].name);
          if (places[i].name.toString().toLowerCase().contains(_searchText.toLowerCase())) {
            filteredPlaces.add(places[i]);
          }
        }
      }
      // use filteredPlaces instead of places

    return ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return filteredPlaces[index];
                    },
                    separatorBuilder:
                        (BuildContext context, int index) => Divider(
                      height: 40,
                    ),
                    itemCount: filteredPlaces.length,
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error fetching places'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ],
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

// class CustomSearchDelegate extends SearchDelegate {
// // Demo list to show querying
//   List<String> searchTerms = [
//     "Apple",
//     "Banana",
//     "Mango",
//     "Pear",
//     "Watermelons",
//     "Blueberries",
//     "Pineapples",
//     "Strawberries"
//   ];
//
// // first overwrite to
// // clear the search text
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: Icon(Icons.clear),
//       ),
//     ];
//   }
//
// // second overwrite to pop out of search menu
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         close(context, null);
//       },
//       icon: Icon(Icons.arrow_back),
//     );
//   }
//
// // third overwrite to show query result
//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var fruit in searchTerms) {
//       if (fruit.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(fruit);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
//
// // last overwrite to show the
// // querying process at the runtime
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var fruit in searchTerms) {
//       if (fruit.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(fruit);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
// }
//
