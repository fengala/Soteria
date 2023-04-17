import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/mainUI/homepage.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:google_maps_webservice/places.dart' as lund;
import '';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/authentication/login.dart';
import 'package:flutter_login_ui/pages/mainUI/socialHouse.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:google_maps_webservice/places.dart' as lund;
import '';
//import 'package:google_maps_webservice/directions.dart';
//import 'package:google_maps_webservice/places.dart';

import '../../models/places.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../authentication/update.dart';
import '../mainUI/placesPage.dart';
import '../../models/user.dart';
import 'package:location/location.dart';

import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';

class MyApp extends StatelessWidget {
  var myUser;
  var userAuth;
  var safe_spots;
  var safe_count;
  var real_time_updating;
  var real_time_;
  var search_UI;
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
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  var myUser;
  var userAuth;

  MapSample({Key key, this.myUser, this.userAuth}) : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Location _location = Location();
  LatLng _currentLocation;
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
  MapSampleState({this.myUser, this.userAuth});

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.amber,
        leading: Container(
          margin: const EdgeInsets.all(10.0),
        ),
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: GestureDetector(
                onTap: () {
                  try {
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
                    this.userAuth.SignOut();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => LoginPage()));
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
          Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: IconButton(
                onPressed: () {
                  try {
                    this.userAuth.SignOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                        MaterialPageRoute(builder: (context) => PlacesPage()));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlacesPage()),
                    );
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapSample()),
                    );
                        */
                  } catch (e, stacktrace) {
                    print(e);
                    print(stacktrace);
                  }
                },
                icon: const Icon(Icons.search),
              )),
          InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: googleApikey,
                    mode: Mode.overlay,
                    types: [],
                    strictbounds: false,
                    components: [lund.Component(lund.Component.country, 'us')],
                    //google_map_webservice package
                    onError: (err) {
                      print(err);
                    });

                if (place != null) {
                  setState(() {
                    location = place.description.toString();
                  });

                  //form google_maps_webservice package
                  final plist = lund.GoogleMapsPlaces(
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
                  var mapController = await _controller.future;
                  //move map camera to selected place with animation
                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: temp, zoom: 17)));
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Card(
                  child: Center(
                    child: Container(
                        padding: EdgeInsets.only(right: 10),
                        width: 210,
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
              Navigator.pop(this.context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TPage()),
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
              onPressed: () {
                setState(() {
                  _pins.add(_createWeightedLatLng(
                      latLng.latitude, latLng.longitude, 1));
                  _heatmaps.clear();
                  _heatmaps.add(_createHeatmap());
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
