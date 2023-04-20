import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/mainUI/homepage.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:google_maps_webservice/places.dart' as heat;

import '';
import 'package:flutter_login_ui/pages/authentication/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database.dart';

import '../authentication/update.dart';
import '../mainUI/placesPage.dart';
import '../../models/user.dart';
import 'package:location/location.dart';

import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'notifpage.dart';

class MyApp extends StatelessWidget {
  var myUser;
  var userAuth;
  var safe_spots;
  var safe_count;
  var real_time_updating;
  var real_time_;
  var search_UI;

  MyApp({Key key}) : super(key: key);

  void setUser(var User) {
    this.myUser = User;
  }

  void setAuth(var auth) {
    this.userAuth = auth;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(
        myUser: this.myUser,
        userAuth: this.userAuth,
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  var myUser;
  var userAuth;

  MapSample({Key key, this.myUser, this.userAuth}) : super(key: key);

  @override
  SampleState createState() => SampleState(
        myUser: this.myUser,
        userAuth: this.userAuth,
      );
}

class SampleState extends State<MapSample> {
  Location _location = Location();
  LatLng _currentLocation;

  GoogleMapController mapController;

  String location = "Search Location";
  String googleApikey = "AIzaSyA6cWdgxqlc6-esOxU_ihLS1mb5nSjgXwE";

  Completer<GoogleMapController> _controller = Completer();

  final Set<WeightedLatLng> _pins = {};
  final Set<Heatmap> _heatmaps = {};

  LatLng _pinLocation; // Added

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  LatLng _heatmapLocation = LatLng(40.424, -86.929);
  /*
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
      */

  UserModel myUser;
  var userAuth;
  SampleState({this.myUser, this.userAuth});

  Future<List<dynamic>> pins_future;

  Future<List<dynamic>> getAllpoints() async {
    var value = await DatabaseService().getHeatMapData();
    return value['Locations'];
  }

  Future<void> _getUserLocation() async {
    try {
      var userLocation = await _location.getLocation();
      setState(() {
        _currentLocation =
            LatLng(userLocation.latitude, userLocation.longitude);
      });
    } catch (e) {
      print('Could not get the user\'s location: $e');
      // show a snackbar or dialog to inform the user about the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not get the user\'s location: $e'),
      ));
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> petitionsStream() {
    return firestore.collection('heatMap').snapshots();
  }

  @override
  void initPetitions() {
    pins_future.then((list) {
      for (int i = 0; i < list.length; i++) {
        _pins.add(_createWeightedLatLng(
            list[i].latitude, list[i].longitude, 90000000000000000));
      }
      _heatmaps.clear();

      _heatmaps.add(_createHeatmap());
    });
  }

  void initPetitions2() {
    setState(() {
      pins_future = getAllpoints();
    });
  }

  @override
  void initState() {
    super.initState();
    pins_future = getAllpoints();
    // print(pins_future.then((list) {
    //   print("This is the initial length");
    //   print(list.length);
    // }));

    //   _heatmaps.add(_createHeatmap());

    petitionsStream().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      // Trigger an automatic update
      initPetitions2();
    });
  }

  final List<Color> colors = [
    Color(0xFF00FF00),
    Color(0xFFFFFF00),
    Color(0xFFFF0000)
  ];
  final List<double> stops = [
    0.2,
    0.5,
    0.8,
  ];

  // final Gradient gradient = RadialGradient(
  //     colors: [Colors.red, Colors.yellow, Colors.green],
  //     stops: [0.2, 0.5, 0.8]);

  final HeatmapGradient gradient = HeatmapGradient(
      colors: [Colors.green, Colors.red], startPoints: [0.2, 0.8]);

  @override
  Widget build(BuildContext context) {
    initPetitions();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.amber,
        leading: Container(
          margin: const EdgeInsets.all(10.0),
        ),
        title: Text(
          'Heat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: GestureDetector(
                onTap: () {
                  try {
                    Navigator.pop(this.context);
                    Navigator.of(context, rootNavigator: true)
                        .pushReplacement(MaterialPageRoute(
                            builder: (context) => UpdatePage(
                                  myUser: this.myUser,
                                  userAuth: this.userAuth,
                                )));
                  } catch (e, stacktrace) {
                    print(e);
                    print(stacktrace);
                  }
                },
                child: Icon(
                  Icons.account_circle,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: () {
                  try {
                    Navigator.of(context, rootNavigator: true)
                        .pushReplacement(MaterialPageRoute(
                            builder: (context) => NotifsPage(
                                  myUser: this.myUser,
                                  userAuth: this.userAuth,
                                )));
                  } catch (e, stacktrace) {
                    print(e);
                    print(stacktrace);
                  }
                },
                child: Icon(
                  Icons.notifications,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: IconButton(
                onPressed: () {
                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlacesPage()),
                    );
                  } catch (e, stacktrace) {
                    print(e);
                    print(stacktrace);
                  }
                },
                icon: const Icon(
                  Icons.list_alt_sharp,
                  size: 26,
                ),
              )),
          InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: googleApikey,
                    mode: Mode.overlay,
                    types: [],
                    strictbounds: false,
                    components: [heat.Component(heat.Component.country, 'us')],
                    //google_map_webservice package
                    onError: (err) {
                      print(err);
                    });

                if (place != null) {
                  setState(() {
                    location = place.description.toString();
                  });

                  //form google_maps_webservice package
                  final plist = heat.GoogleMapsPlaces(
                    apiKey: googleApikey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                    //from google_api_headers package
                  );
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  var temp = LatLng(lat, lang);

                  //move map camera to selected place with animation
                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: temp, zoom: 17)));
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Card(
                  child: Center(
                    child: Container(
                        padding: EdgeInsets.only(right: 0),
                        width: 200,
                        child: ListTile(
                          title: Text(
                            location,
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: Icon(Icons.search),
                          dense: true,
                        )),
                  ),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: GestureDetector(
                onTap: () {
                  try {
                    this.userAuth.SignOut();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => LoginPage()));
                    Navigator.pop(this.context);

                    Navigator.of(context, rootNavigator: true).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  } catch (e, stacktrace) {
                    print(e);
                    print(stacktrace);
                  }
                },
                child: Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.only(bottom: 0.0),
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(40.424, -86.929),
              zoom: 13,
            ),
            heatmaps: _heatmaps,
            markers: _buildMarkers(),
            onTap: _addPin,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
          ),
        ),
        Align(
          alignment:
              Alignment.lerp(Alignment.topLeft, Alignment.centerLeft, 0.05),
          child: FloatingActionButton.extended(
            onPressed: () {
              //  Navigator.pop(this.context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TPage(
                          myUser: this.myUser,
                          userAuth: this.userAuth,
                        )),
              );
            },
            label: Text('Map'),
            icon: Icon(Icons.map),
            backgroundColor: Colors.amber,
          ),
        ),
      ]),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _addHeatmap,
      //   label: Text('Add Heatmap'),
      //   icon: Icon(Icons.add_box),
      // ),

      /*
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            onPressed: _goToTheLake,
            label: Text('To the lake!'),
            icon: Icon(Icons.directions_boat),
          ),
          SizedBox(height: 10), // Add some spacing between the buttons
          FloatingActionButton.extended(
            onPressed: _addHeatmap,
            label: Text('Add Heatmap'),
            icon: Icon(Icons.add_box),
          ),
          FloatingActionButton.extended(
            onPressed: _addHeatmap,
            label: Text('Add Heatmap'),
            icon: Icon(Icons.add_box),
          ),
          FloatingActionButton.extended(
            onPressed: _addHeatmap,
            label: Text('Add Heatmap'),
            icon: Icon(Icons.add_box),
          ),
        ],
      ),
      */
    );
  }

  void _addPin(LatLng latLng) {
    setState(() {
      _pinLocation = latLng;
    });
  }

  Set<Marker> _buildMarkers() {
    if (_pinLocation == null) {
      return {};
    }
    return {
      Marker(
        markerId: MarkerId('pin'),
        position: _pinLocation,
        draggable: true,
        onDragEnd: (LatLng newPosition) {
          setState(() {
            _pinLocation = newPosition;
          });
        },
        onTap: () {
          _showConfirmationDialog(_pinLocation);
        }, // Add this line
      ),
    };
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }

  Heatmap _createHeatmap() {
    return Heatmap(
      heatmapId: HeatmapId('heatmap'),
      points: _pins.toList(),
      gradient: gradient,
      radius: 50,
      opacity: 0.7,
    );
  }

  void _showConfirmationDialog(LatLng latLng) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Do you want to mark this location unsafe?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Drop Pin"),
              onPressed: () async {
                setState(() {
                  _pins.add(_createWeightedLatLng(
                      latLng.latitude, latLng.longitude, 90000000000000000));
                  _heatmaps.clear();
                  _heatmaps.add(_createHeatmap());
                });
                await DatabaseService().addHeatMapData(latLng);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
