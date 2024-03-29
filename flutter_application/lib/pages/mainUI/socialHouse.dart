import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/mainUI/reviewForSocials.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/reviews.dart';
import '../../services/auth.dart';
import 'package:flutter_login_ui/pages/mainUI/placesPage.dart';

import '../../services/database.dart';
// void main() => runApp(MyApp());

class socialHousePage extends StatefulWidget {
  final String title;
  final String id;
  final String contact;
  final String description;
  final String num_stars;
  final String user_rate;
  final GeoPoint geoLoc;
  socialHousePage({
    Key key,
    @required this.title,
    @required this.id,
    @required this.description,
    @required this.contact,
    @required this.num_stars,
    @required this.user_rate,
    @required this.geoLoc,
  }) : super(key: key);

  @override
  _socialHousePageState createState() => _socialHousePageState();
}

class _socialHousePageState extends State<socialHousePage> {
  bool _isUnsafe = false;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  UserAuth userAuth = new UserAuth();
  var user;

  @override
  void dispose() {
    super.dispose();
  }

  String assetFixer() {
    String asset = "assets/" + widget.title + "png";
    return asset;
  }

  @override
  Widget build(BuildContext context) {
    bool remember = false;

    //String asset = "assets/" + widget.title + "png";
    List<String> descriptions = widget.description.split("/");
    String asset = 'assets/logo.png';
    if (descriptions.length < 2) {
      for (int c = 0; c < 4; c++) {
        descriptions.add("No valid info");
      }
    } else {
      asset = 'assets/' + widget.title + '.jpg';
      print(asset);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlacesPage()),
            );
          },
        ),
        title: Text(
          'Venue Information',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_comment,
              color: Colors.white,
            ),
            onPressed: () {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => reviewForSocials(id: widget.id)),
                );
              } catch (e, stacktrace) {
                print(e);
                print(stacktrace);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(bottom: 110.0, top: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(asset),
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 37.5,
                    fontFamily: 'Montserrat',
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 2.5),
              ),
              Container(
                height: 70,
                child: Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: SingleChildScrollView(
                    child: RatingBarIndicator(
                      rating: double.parse(widget.num_stars),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 50.0,
                      direction: Axis.horizontal,
                    ),
                  ),
                ),
              ),
              Text(
                "Average Rating: " + widget.num_stars,
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Montserrat',
                    color: Colors.amber.shade700,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.5),
              ),
              SizedBox(
                width: 150.0,
                height: 20.0,
                child: Divider(
                  color: Colors.amber.shade100,
                ),
              ),
              Container(
                height: 70,
                child: Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: SingleChildScrollView(
                    child: RatingBarIndicator(
                      rating: double.parse(widget.user_rate),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 40.0,
                      direction: Axis.horizontal,
                    ),
                  ),
                ),
              ),
              Text(
                "Your Rating: " + widget.user_rate,
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Montserrat',
                    color: Colors.amber.shade700,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                height: 90,
                child: Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: SingleChildScrollView(
                    child: ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.amber,
                      ),
                      title: Text(
                        descriptions[0],
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: 'Montserrat',
                            color: Colors.amber.shade900),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 70,
                child: Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: SingleChildScrollView(
                    child: ListTile(
                      leading: Icon(
                        Icons.local_drink,
                        color: Colors.amber,
                      ),
                      title: Text(
                        descriptions[1],
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: 'Montserrat',
                            color: Colors.amber.shade900),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 70,
                child: Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: SingleChildScrollView(
                    child: ListTile(
                      leading: Icon(
                        Icons.security,
                        color: Colors.amber,
                      ),
                      title: Text(
                        descriptions[2],
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: 'Montserrat',
                            color: Colors.amber.shade900),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 70,
                child: Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: SingleChildScrollView(
                    child: ListTile(
                      leading: Icon(
                        Icons.plagiarism,
                        color: Colors.amber,
                      ),
                      title: Text(
                        descriptions[3],
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: 'Montserrat',
                            color: Colors.amber.shade900),
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Colors.amber,
                  ),
                  title: GestureDetector( child: Text(
                    widget.contact,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                        color: Colors.amber.shade900),
                  ),
    onTap: () {
      if (widget.contact.contains('@')) {
        // If it's an email address
        launch('mailto:$widget.contact');
      } else if (widget.contact.contains('-')) {
        // If it's a phone number
        launch('tel:$widget.contact');
      }
    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () async {
                    LatLng haha = new LatLng(
                        widget.geoLoc.latitude, widget.geoLoc.longitude);
                    await DatabaseService().addHeatMapData(
                        haha); ////////////////////////////////////////////////
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning, color: Colors.yellow),
                        SizedBox(width: 10),
                        Text('Mark as unsafe', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                //padding: EdgeInsets.only(left: 35.0, bottom: 110.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 150.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        try {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    reviewForSocials(id: widget.id)),
                          );
                        } catch (e, stacktrace) {
                          print(e);
                          print(stacktrace);
                        }
                      },
                      child: Text("Reviews"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
