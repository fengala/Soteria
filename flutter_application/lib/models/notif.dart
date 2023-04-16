import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Notif extends StatefulWidget {
  final String username;
  final String text;
  final String time;
  final String id;

  Notif({
    Key key,
    @required this.username,
    @required this.text,
    @required this.time,
    @required this.id,
  }) : super(key: key);

  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          notifAvatar(),
          notifBody(context),
        ],
      ),
    );
  }

  Widget notifAvatar() {
    return Container(
      margin: const EdgeInsets.all(10.0),
    );
  }

  Widget notifBody(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          notifHeader(context),
          notifText(),
          notifButtons(),
        ],
      ),
    );
  }

  Widget notifHeader(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          return Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5.0),
              ),
              Text(
                '${widget.time}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          );
        }
    );
  }

  Widget notifText() {
    return Text(
      widget.text,
      overflow: TextOverflow.clip,
    );
  }

  Widget notifButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          notifIconButton(FontAwesomeIcons.xmark, "Read"),

        ],
      ),
    );
  }

  Widget notifIconButton(IconData icon, String text) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.xmark),
          onPressed: () {
            print("Pressed Cancel");
            // setState(() {
            //   _notifsFuture = getAllNotifs();
            // });
          },
          iconSize: 16.0,
          color: Colors.black45,
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