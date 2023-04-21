import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
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
import '../../services/auth.dart';
import '../../services/database.dart';
import '../authentication/update.dart';
import '../mainUI/placesPage.dart';
import '../mainUI/notifpage.dart';
import '../../models/user.dart';
import '../mainUI/placesPage.dart';
import 'package:flutter_login_ui/pages/mainUI/socialHouse.dart';

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
  MarkerId _selectedMarkerId;

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
  bool pin_add = false;
  SampleState({this.myUser, this.userAuth});

  Future<List<dynamic>> pins_future;

  Future<List<dynamic>> getAllpoints() async {
    var value = await DatabaseService().getHeatMapData();
    return value['Locations'];
  }

  void _onMarkerTapped(MarkerId markerId) {
    setState(() {
      print("Hellooooo\n");
      _selectedMarkerId = markerId;
      print(markerId);
    });
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
  double hue1;
  double hue2;
  void initPetitions() {
    pins_future.then((list) {
      for (int i = 0; i < list.length; i++) {
        _pins.add(
            WeightedLatLng(point: LatLng(list[i].latitude, list[i].longitude)));
        _pins.add(_createWeightedLatLng(
            list[i].latitude, list[i].longitude, 99999999999999999));
      }
      _heatmaps.clear();

      _heatmaps.add(_createHeatmap());
    });
  }

  void initPetitions2() {
    if (this.mounted) {
      setState(() {
        pins_future = getAllpoints();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pins_future = getAllpoints();
    _buildMarkers();
    hue1 = BitmapDescriptor.hueCyan;
    hue2 = BitmapDescriptor.hueGreen;
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
  var markers;

  // final Gradient gradient = RadialGradient(
  //     colors: [Colors.red, Colors.yellow, Colors.green],
  //     stops: [0.2, 0.5, 0.8]);

  final HeatmapGradient gradient = HeatmapGradient(
      colors: [Colors.green, Colors.yellow, Colors.red],
      startPoints: [0.2, 0.3, 0.8]);

  @override
  Widget build(BuildContext context) {
    initPetitions();
    markers = _buildMarkers();

/*
    markers = Set<Marker>.of([
      //pi kappa phi page
      Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(40.42683167898305, -86.91004304711971),
        infoWindow: InfoWindow(
          title: 'Pi Kappa Phi',
          snippet: 'PZGBqfzO0TQeP3n9oLPc',
        ),
      ),
      Marker(
        //pi kappa phi page
        markerId: MarkerId('marker_2'),
        position: LatLng(40.423816316813756, -86.91266646235619),
        infoWindow: InfoWindow(
          title: 'Phi Delta Theta',
          snippet: 'RyMwQOgO2lQBjIBCkvjI',
        ),
      ),
      Marker(
        // pi kappa phi page
        markerId: MarkerId('marker_3'),
        position: LatLng(40.42763867988644, -86.9176749065325),
        infoWindow: InfoWindow(
          title: 'Phi Sigma Kappa',
          snippet: 'vaUr8Utq4mEZR0GhqzVs',
        ),
      ),
      Marker(
        // pi kappa phi page
        markerId: MarkerId('marker_4'),
        position: LatLng(40.43676689062929, -86.91496347584936),
        infoWindow: InfoWindow(
          title: 'Kappa Delta Rho',
          snippet: 'xUzgjY781qshdk1qQN3Z',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_5'),
        position: LatLng(40.42300892698927, -86.91172201817966),
        infoWindow: InfoWindow(
          title: 'Compliance Frat',
          snippet: 'Rxh4I3iQ8d67AvRzyRmq',
        ),
      ),
      // if (_currentLocation != null)
      //   Marker(
      //     markerId: MarkerId('marker_5'),
      //     position:
      //     LatLng(_currentLocation.latitude, _currentLocation.longitude),
      //     icon:
      //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      //     infoWindow: InfoWindow(
      //       title: 'Your Location',
      //       snippet: 'xUzgjY781qshdk1qQN3Z',
      //     ),
      //   ),
    ]);

    if (_pinLocation != null) {
      markers.add(Marker(
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
      ));
    }
    */
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
                            location != null ? location : 'helloowo',
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
          padding: EdgeInsets.only(bottom: 70.0),
          child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(40.424, -86.929),
                zoom: 13,
              ),
              heatmaps: _heatmaps,
              onTap: _addPin,
              onMapCreated: (GoogleMapController controller) async {
                await _controller.complete(controller);

                _controller.future.then((value) => mapController = value);
              },
              myLocationEnabled: true,
              markers: Set.from(markers.map((Marker marker) {
                return Marker(
                  markerId: marker.markerId,
                  position: marker.position,
                  onTap: () {
                    if (!pin_add) {
                      print(
                          "THis is reaching here and the value of pin_add is: \n");
                      print(pin_add);
                      _onMarkerTapped(marker.markerId);
                    } else {
                      _showConfirmationDialog(_pinLocation);

                      _pinLocation = null;
                      _selectedMarkerId = null;
                    }
                  },
                  icon: (marker.markerId.value == 'marker_5' ||
                          marker.markerId.value == 'marker_6' ||
                          marker.markerId.value == 'marker_7')
                      ? BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen)
                      : BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                );
              }))),
        ),
        Align(
          alignment:
              Alignment.lerp(Alignment.topLeft, Alignment.centerLeft, 0.2),
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
        Positioned(
            bottom: 100.0,
            left: -75.0,
            right: 0.0,
            child: Visibility(
              visible: _selectedMarkerId != null &&
                  _selectedMarkerId.value != "pin" &&
                  !pin_add,
              //...
              // Marker marker = markers.elementAt(index);

              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () async {
                        if (!pin_add) {
                          // Marker marker = markers.elementAt(index);

                          Marker marker = markers.firstWhere(
                              (marker) => marker.markerId == _selectedMarkerId);
                          print(marker.position);
                          mapController.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                            target: marker.position,
                            // zoom: 15.0,
                            // bearing: 45.0,
                            // tilt: 45.0
                          )));
                          var houseInfo = await DatabaseService().getVenue(
                              markers
                                  .firstWhere((marker) =>
                                      marker.markerId == _selectedMarkerId)
                                  .infoWindow
                                  .snippet);
                          String userId = UserAuth.auth.currentUser.uid;
                          double latitude = houseInfo['latitude'];
                          double longitude = houseInfo['longitude'];
                          var geo = GeoPoint(latitude, longitude);
                          List<num> usrate = await DatabaseService()
                              .getUserRating(
                                  markers
                                      .firstWhere((marker) =>
                                          marker.markerId == _selectedMarkerId)
                                      .infoWindow
                                      .snippet,
                                  userId) as List<Object>;
                          num r;
                          if (usrate.isEmpty) {
                            r = 0.0;
                          } else {
                            r = usrate[0];
                          }
                          Navigator.pop(this.context);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => socialHousePage(
                                        title: houseInfo["title"],
                                        id: markers
                                            .firstWhere((marker) =>
                                                marker.markerId ==
                                                _selectedMarkerId)
                                            .infoWindow
                                            .snippet,
                                        description: houseInfo["description"],
                                        contact: houseInfo["contact"],
                                        num_stars:
                                            houseInfo["num_rating"].toString(),
                                        user_rate: r.toString(),
                                        geoLoc: geo,
                                      )));
                        }
                      },
                      child: Stack(children: [
                        Center(
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 20.0,
                                ),
                                height: 70.0,
                                width: 275.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(0.0, 4.0),
                                        blurRadius: 10.0,
                                      ),
                                    ]),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white),
                                    child: Row(children: [
                                      Container(
                                          height: 90.0,
                                          width: 90.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                  topLeft:
                                                      Radius.circular(10.0)),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/Phi Delta Theta.png')))),
                                      SizedBox(width: 5.0),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // markers.elementAt(_selectedMarkerId as int).infoWindow.title,
                                              // markers
                                              //     .firstWhere((marker) =>
                                              //         marker.markerId ==
                                              //         _selectedMarkerId)
                                              //     .infoWindow
                                              //     .title,
                                              // style: TextStyle(
                                              //     fontSize: 12.5,
                                              //     fontWeight: FontWeight.bold),
                                              _selectedMarkerId != null &&
                                                      !pin_add
                                                  ? markers
                                                      .firstWhere((marker) =>
                                                          marker.markerId ==
                                                          _selectedMarkerId)
                                                      .infoWindow
                                                      .title
                                                  : '',
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Click for more info",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ])
                                    ]))))
                      ]))
                  // child: Card(
                  //   child: Padding(
                  //     padding: EdgeInsets.all(8.0),
                  //     child: Text(
                  //       marker.infoWindow.title,
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ),
            ))
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
    if (this.mounted) {
      setState(() {
        _pinLocation = latLng;
        pin_add = true;
        //   markers.add(Marker(
        //   markerId: MarkerId('pin'),
        //   position: _pinLocation,
        //   draggable: true,
        //   onDragEnd: (LatLng newPosition) {
        //     setState(() {
        //       _pinLocation = newPosition;
        //     });
        //   },
        //   onTap: () {
        //     _showConfirmationDialog(_pinLocation);
        //   }, // Add this line
        // ));
      });
    }

    // markers.add(Marker(
    //   markerId: MarkerId('pin'),
    //   position: _pinLocation,
    //   draggable: true,
    //   onDragEnd: (LatLng newPosition) {
    //     setState(() {
    //       _pinLocation = newPosition;
    //     });
    //   },
    //   onTap: () {
    //     _showConfirmationDialog(_pinLocation);
    //   }, // Add this line
    // ));
  }

  Set<Marker> _buildMarkers() {
    var markers = Set<Marker>.of([
      // Marker(
      //   markerId: MarkerId('pin'),
      //   position: _pinLocation,
      //   draggable: true,
      //   onDragEnd: (LatLng newPosition) {
      //     setState(() {
      //       _pinLocation = newPosition;
      //     });
      //   },
      //   onTap: () {
      //     _showConfirmationDialog(_pinLocation);
      //   }, // Add this line
      // ),
      Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(40.42683167898305, -86.91004304711971),
        infoWindow: InfoWindow(
          title: 'Pi Kappa Phi',
          snippet: 'PZGBqfzO0TQeP3n9oLPc',
        ),
      ),
      Marker(
        //pi kappa phi page

        markerId: MarkerId('marker_2'),
        position: LatLng(40.423816316813756, -86.91266646235619),
        infoWindow: InfoWindow(
          title: 'Phi Delta Theta',
          snippet: 'RyMwQOgO2lQBjIBCkvjI',
        ),
        //icon: BitmapDescriptor.defaultMarkerWithHue(240.0)),
      ),
      Marker(
        // pi kappa phi page
        markerId: MarkerId('marker_3'),
        position: LatLng(40.42763867988644, -86.9176749065325),
        infoWindow: InfoWindow(
          title: 'Phi Sigma Kappa',
          snippet: 'vaUr8Utq4mEZR0GhqzVs',
        ),
      ),
      Marker(
        // pi kappa phi page
        markerId: MarkerId('marker_4'),
        position: LatLng(40.43676689062929, -86.91496347584936),
        infoWindow: InfoWindow(
          title: 'Kappa Delta Rho',
          snippet: 'xUzgjY781qshdk1qQN3Z',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_5'),
        position: LatLng(40.424251752591267, -86.90849323834374),
        infoWindow: InfoWindow(
          title: 'Brothers Bar',
          snippet: '3OY2xxBca4EBqbiLvn8P',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_6'),
        position: LatLng(40.423359382397024, -86.90054862019234),
        infoWindow: InfoWindow(
          title: 'Neon Cactus',
          snippet: 'kDeAi0S6dTF86nUVPZs2',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_7'),
        position: LatLng(40.42300892698927, -86.91172201817966),
        infoWindow: InfoWindow(
          title: 'Harrys Chocolate Shop',
          snippet: 'r58LiO7twsGLVGxf0KC0',
        ),
      ),
    ]);

    if (_pinLocation != null) {
      try {
        pin_add = true;
        print(_pinLocation.latitude);
        markers.add(Marker(
          markerId: MarkerId('pin'),
          position: _pinLocation,
          draggable: true,
          onDragEnd: (LatLng newPosition) {
            setState(() {
              print("This is after reaching here3\n");
              _pinLocation = newPosition;
            });
          },

          onTap: () {
            print("This is after reaching here4\n");
            _showConfirmationDialog(_pinLocation);
          }, // Add this line
        ));
      } catch (e, stacktrace) {
        print(stacktrace);
      }
    }
    return markers;
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
      opacity: 1,
    );
  }

  void _showConfirmationDialog(LatLng latLng) {
    if (LatLng != null) {
      print("This is after reaching here");
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
                        latLng.latitude, latLng.longitude, 99999999999999999));
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
      pin_add = false;
    } else {
      print("Hello this is null");
    }
  }
}
