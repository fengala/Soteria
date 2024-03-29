import 'dart:convert';

import 'package:flutter_login_ui/services/database.dart';

import '../services/auth.dart';

import '../pages/mainUI/bulletinboard.dart';
import 'package:intl/intl.dart';

var events = getAllEvents(0);

Future<List<Event>> getAllEvents(int filter_val) async {
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
    int hasForm = jsonMap['hasRSVP'];
    String userId = jsonMap['userId'];
    int shape = 0;
    int shape2 = 0;
    int ver = 0;

    if (await DatabaseService()
            .userUpvoteCheckEve(id, UserAuth.auth.currentUser.uid, 0) ==
        true) {
      shape = 1;
    }
    if (await DatabaseService()
            .userRSVPCheckEve(id, UserAuth.auth.currentUser.uid) ==
        true) {
      shape2 = 1;
    }
    if (await DatabaseService().userVerCheck(userId) == true) {
      //print(ver);
      ver = 1;
    }
    eves.add(Event(
      name: name,
      title: title,
      comments: comments.toString(),
      upvotes: upvotes.toString(),
      time: time,
      id: id,
      when: when,
      description: desc,
      hasRSVP: hasForm,
      hasUpvote: shape,
      alreadyRSVP: shape2,
      ver: ver,
    ));
  }

  if (filter_val == 0) {
    eves.sort((a, b) {
      DateTime a_time = DateFormat('MM/dd/yyyy hh:mm a').parse(a.time);
      DateTime b_time = DateFormat('MM/dd/yyyy hh:mm a').parse(b.time);
      return b_time.compareTo(a_time);
    });
  }
  if (filter_val == 1) {
    eves.sort((a, b) {
      DateTime a_time = DateFormat('MM/dd/yyyy hh:mm a').parse(a.time);
      DateTime b_time = DateFormat('MM/dd/yyyy hh:mm a').parse(b.time);
      return a_time.compareTo(b_time);
    });
  } else if (filter_val == 2) {
    // tweeds.sort(favor)
    eves.sort((a, b) => b.upvotes.compareTo(a.upvotes));
  } else if (filter_val == 3) {
    // tweeds.sort(favor)
    eves.sort((a, b) => a.upvotes.compareTo(b.upvotes));
  } else if (filter_val == 4) {
    // tweeds.sort(favor)
    eves.sort((a, b) => b.comments.compareTo(a.comments));
  } else if (filter_val == 5) {
    // tweeds.sort(favor)
    eves.sort((a, b) => a.comments.compareTo(b.comments));
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
