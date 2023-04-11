import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/authentication/login.dart';
import 'package:google_maps_webservice/places.dart' as lund;

//import 'package:google_maps_webservice/directions.dart';
//import 'package:google_maps_webservice/places.dart';

import '../authentication/update.dart';
import '../mainUI/placesPage.dart';
import '../../models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';

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

  @override
  void initState() {
    super.initState();
    _getUserLocation();
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
      Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(40.424, -86.929),
        infoWindow: InfoWindow(
          title: 'Phi Kappa',
          snippet: 'Fraternity',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(40.427, -86.916),
        infoWindow: InfoWindow(
          title: 'Alpha Alpha Alpha',
          snippet: 'Fraternity',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_3'),
        position: LatLng(40.426, -86.914),
        infoWindow: InfoWindow(
          title: 'Omega Delta Kappa',
          snippet: 'Fraternity',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_4'),
        position: LatLng(40.4230716, -86.9199115),
        infoWindow: InfoWindow(
          title: 'Triangle frat',
          snippet: 'Fraternity',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_4'),
        position: LatLng(40.4284818, -86.9876795),
        infoWindow: InfoWindow(
          title: 'Chi Omega',
          snippet: 'Fraternity',
        ),
      ),
      Marker(
        markerId: MarkerId('marker_4'),
        position: LatLng(40.4295616, -86.989587),
        infoWindow: InfoWindow(
          title: 'Alpha Tau Omega',
          snippet: 'Fraternity',
        ),
      ),
      if (_currentLocation != null)
        Marker(
          markerId: MarkerId('marker_5'),
          position:
              LatLng(_currentLocation.latitude, _currentLocation.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: 'Your Location',
            snippet: 'You are here',
          ),
        ),
    ]);
    return Scaffold(
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
                    //this.userAuth.SignOut();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => LoginPage()));
                    // Navigator.of(context, rootNavigator: true).pushReplacement(
                    //     MaterialPageRoute(builder: (context) => PlacesPage()));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlacesPage()),
                    );
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
              zoomControlsEnabled: true,
              myLocationEnabled: true, // enable my location button
              markers: markers),
        ),
        Positioned(
          bottom: 70.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            height: 100.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: markers.length,
              itemBuilder: (BuildContext context, int index) {
                Marker marker = markers.elementAt(index);
                return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          mapController.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                            target: marker.position,
                            zoom: 15.0,
                            // bearing: 45.0,
                            // tilt: 45.0
                          )));
                        },
                        child: Stack(children: [
                          Center(
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 20.0,
                                  ),
                                  height: 125.0,
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
                                                marker.infoWindow.title,
                                                style: TextStyle(
                                                    fontSize: 12.5,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                marker.infoWindow.snippet,
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Container(
                                                width: 170.0,
                                                child: Text(
                                                  marker.infoWindow.snippet,
                                                  style: TextStyle(
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              )
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
                    );
              },
            ),
          ),
        ),
      ]),
    );
  }
}
