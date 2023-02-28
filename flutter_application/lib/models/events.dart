import 'dart:convert';

import 'package:flutter_login_ui/services/database.dart';

import 'event.dart';

var events = getAllEvents();

Future<List<Event>> getAllEvents() async {
  List<Object> events = await DatabaseService().getEvents() as List<Object>;
  var length = events.length;
  List<Event> eves = [];

  for (var i = 0; i < length; i++) {
    String jsonString = jsonEncode(events[i]);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    String name = jsonMap['username'];
    String title = jsonMap['title'];
    String desc = jsonMap['description'];
    int upvotes = jsonMap['num_upvotes'];
    int comments = jsonMap['num_comments'];
    String time = jsonMap['time'];
    String id = jsonMap['id'];
    String when = jsonMap['when'];
    int shape = 0;
    eves.add(Event(
        name: name,
        title: title,
        comments: comments.toString(),
        upvotes: upvotes.toString(),
        time: time,
        id: id,
        when: when,
        description: desc));
  }
  return eves;
}


// var events = [
//   Event(
//     name: 'kgovil',
//     title: 'KUSH GOMVIL',
//     description: 'HELLO',
//     comments: '243',
//     upvotes: '23',
//     time: 'Feb 24, 2025',
//   ),
//   Event(
//     name: 'fgala',
//     title: 'FEN GAMLA',
//     description: 'HELLO!!!',
//     comments: '23',
//     upvotes: '23',
//     time: 'Feb 26, 2023',
//   ),
// ];
//
