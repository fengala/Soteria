import 'package:flutter/material.dart';

class eventdetails extends StatefulWidget {
  final String title;
  final String description;
  final String time;
  final List<String> replies;

  eventdetails({
    Key key,
    @required this.title,
    @required this.description,
    @required this.replies,
    @required this.time,
  }) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<eventdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0.0),
          Expanded(
            child: ListView.builder(
              itemCount: widget.replies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.replies[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}