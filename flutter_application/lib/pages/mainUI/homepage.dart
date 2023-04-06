import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/authentication/login.dart';
import '../authentication/update.dart';
import '../mainUI/placesPage.dart';
import '../../models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TP extends StatelessWidget {
  var myUser;
  var userAuth;
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
  UserModel myUser;
  var userAuth;
  TePage({this.myUser, this.userAuth});
  @override
  Widget build(BuildContext context) {
    int page = 1;
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
                padding: EdgeInsets.only(right: 40.0),
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
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    try {
                      this.userAuth.SignOut();
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => LoginPage()));
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => LoginPage()));
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
                padding: EdgeInsets.only(right: 10.0),
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
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(bottom: 70.0),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(40.424, -86.929), // Chicago
                zoom: 13,
              ),
              zoomControlsEnabled: true,
              markers: Set<Marker>.of([
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
              ]),
            )));
  }
}
