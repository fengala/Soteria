import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/mainUI/reviewForSocials.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../services/auth.dart';
import 'package:flutter_login_ui/pages/mainUI/placesPage.dart';
// void main() => runApp(MyApp());

class socialHousePage extends StatefulWidget {
  final String title;
  final String id;
  final String contact;
  final String description;
  final String num_stars;

  socialHousePage(
      {Key key,
      @required this.title,
      @required this.id,
      @required this.description,
      @required this.contact,
        @required this.num_stars})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _socialHousePageState createState() => _socialHousePageState();
}

class _socialHousePageState extends State<socialHousePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  UserAuth userAuth = new UserAuth();
  var user;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool remember = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Venue Informaiton'),
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
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage('assets/frat.png'),
            ),
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Montserrat',
                  color: Colors.amber.shade900,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5),
            ),
            RatingBarIndicator(
              rating: double.parse(widget.num_stars),
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 50.0,
              direction: Axis.horizontal,
            ),
            Text(
              "Rating: " + widget.num_stars,
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
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.amber,
                ),
                title: Text(
                  widget.description,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
                      color: Colors.amber.shade900),
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
                title: Text(
                  widget.contact,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20.0,
                      color: Colors.amber.shade900),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 35.0, bottom: 110.0),
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
                        builder: (context) => reviewForSocials(id: widget.id)),
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
    );
  }
}
