import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/authentication/login.dart';
import 'package:flutter_login_ui/pages/mainUI/petitionpage.dart';
import 'package:flutter_login_ui/pages/mainUI/socialHouse.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:google_maps_webservice/places.dart' as refVar;
import '';
//import 'package:google_maps_webservice/directions.dart';
//import 'package:google_maps_webservice/places.dart';

import '../../models/places.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../authentication/update.dart';
import '../mainUI/placesPage.dart';
import '../mainUI/notifpage.dart';
import '../../models/user.dart';
import 'package:location/location.dart';

import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'heat.dart';

class TP extends StatelessWidget {
  var myUser;
  var userAuth;
  var safe_spots;
  var safe_count;
  var real_time_updating;

  TP({Key key}) : super(key: key);

  void setUser(var User) {
    this.myUser = User;
  }

  void setAuth(var auth) {
    this.userAuth = auth;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TPage(
        myUser: this.myUser,
        userAuth: this.userAuth,
      ),
    );
  }
}

class TPage extends StatefulWidget {
  var myUser;
  var userAuth;

  TPage({Key key, this.myUser, this.userAuth}) : super(key: key);

  @override
  TePage createState() => TePage(myUser: this.myUser, userAuth: this.userAuth);
}

class TePage extends State<TPage> {
  Location _location = Location();
  GoogleMapController mapController;
  LatLng _currentLocation;
  String location = "Search Location";
  String googleApikey = "AIzaSyA6cWdgxqlc6-esOxU_ihLS1mb5nSjgXwE";
  String selectedLocation;
  MarkerId _selectedMarkerId;

  void _onMarkerTapped(MarkerId markerId) {
    setState(() {
      _selectedMarkerId = markerId;
    });
  }

  BitmapDescriptor customIcon;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    setCustomIcon();
  }

  void setCustomIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/blue_marker.png");
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

  UserModel myUser;
  var userAuth;
  TePage({this.myUser, this.userAuth});
  @override
  Widget build(BuildContext context) {
    int page = 1;
    var markers = Set<Marker>.of([
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
        markerId: MarkerId('marker_6'),
        position: LatLng(40.424251752591267, -86.90849323834374),
        infoWindow: InfoWindow(
          title: 'Brothers Bar',
          snippet: '3OY2xxBca4EBqbiLvn8P',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_7'),
        position: LatLng(40.423359382397024, -86.90054862019234),
        infoWindow: InfoWindow(
          title: 'Neon Cactus',
          snippet: 'kDeAi0S6dTF86nUVPZs2',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_8'),
        position: LatLng(40.42300892698927, -86.91172201817966),
        infoWindow: InfoWindow(
          title: 'Harrys Chocolate Shop',
          snippet: 'r58LiO7twsGLVGxf0KC0',
        ),
      ),
    ]);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.amber,
        leading: Container(
          margin: const EdgeInsets.all(10),
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
                    components: [
                      refVar.Component(refVar.Component.country, 'us')
                    ],
                    //google_map_webservice package
                    onError: (err) {
                      print(err);
                    });

                if (place != null) {
                  setState(() {
                    location = place.description.toString();
                  });

                  //form google_maps_webservice package
                  final plist = refVar.GoogleMapsPlaces(
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
          padding: EdgeInsets.only(bottom: 70.0),
          child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(40.424, -86.929),
                zoom: 13,
              ),
              // zoomControlsEnabled: true,
              myLocationEnabled: true, // enable my location button
              markers: Set.from(markers.map((Marker marker) {
                return Marker(
                  markerId: marker.markerId,
                  position: marker.position,
                  onTap: () => _onMarkerTapped(marker.markerId),
                );
              }))),
        ),
        Align(
          alignment:
              Alignment.lerp(Alignment.topLeft, Alignment.centerLeft, 0.05),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapSample(
                          myUser: this.myUser,
                          userAuth: this.userAuth,
                        )),
              );
            },
            label: Text('HeatMap'),
            icon: Icon(Icons.map),
            backgroundColor: Colors.amber,
          ),
        ),
        Positioned(
            bottom: 100.0,
            left: -75.0,
            right: 0.0,
            child: Visibility(
              visible: _selectedMarkerId != null,
              //...
              // Marker marker = markers.elementAt(index);

              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () async {
                        // Marker marker = markers.elementAt(index);
                        Marker marker = markers.firstWhere(
                            (marker) => marker.markerId == _selectedMarkerId);
                        mapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                          target: marker.position,
                          // zoom: 15.0,
                          // bearing: 45.0,
                          // tilt: 45.0
                        )));
                        var houseInfo = await DatabaseService().getVenue(markers
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
                                              _selectedMarkerId != null
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
            )),
      ]),
    );
  }
}
