import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/mainUI/socialHouse.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Place extends StatelessWidget {
  final String name;
  String comments;
  String ratio;
  final String id;
  final String description;
  String rating;
  String num_reviews;
  String user_rate;
  final String location;
  final String contact;
  final String acc;

  Place({
    Key key,
    @required this.name,
    @required this.comments,
    @required this.id,
    @required this.description,
    @required this.rating,
    @required this.location,
    @required this.contact,
    @required this.ratio,
    @required this.acc,
    @required this.num_reviews,
    @required this.user_rate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          placeAvatar(),
           placeBody(context),
        ],
      ),
    );
  }

  Widget placeAvatar() {
    return Container(
      margin: const EdgeInsets.all(10.0),
    );
  }

  Widget placeBody(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          placeHeader(context),
          placeText(),
          placeButtons(context),
        ],
      ),
    );
  }

  Widget placeHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5.0),
        ),
        Icon(Icons.location_on),
        Text(
          '$location',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => socialHousePage(
                          title: name,
                          id: id,
                          description: description,
                          contact: contact,
                          num_stars: rating,
                          user_rate: user_rate,
                        )));
          },
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.plus,
              size: 14.0,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget placeText() {
    return Text(
      name,
      overflow: TextOverflow.clip,
    );
  }

  Widget placeButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          placeIconButton1(FontAwesomeIcons.comment, this.comments),
          placeIconButton2(FontAwesomeIcons.solidStar, rating + "  ||  " + num_reviews + "  ratings"),
          // IconButton(
          //   icon: Icon(
          //     Icons.info_outline,
          //     size: 24.0,
          //     color: Colors.grey,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return SimpleDialog(
          //           title: Text("Accredited Information"),
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.all(16.0),
          //               child: Text(acc),
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget placeIconButton1(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.comment),
          onPressed: () {
            print("Pressed Comment");
          },
          iconSize: 16.0,
          color: Colors.amber,
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget placeIconButton2(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            print("Pressed Rating");
            icon = FontAwesomeIcons.solidStar;
          },
          icon: Icon(icon),
          iconSize: 16.0,
          color: Colors.amber,
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}
