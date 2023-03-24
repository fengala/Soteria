import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_login_ui/services/database.dart';

import '../services/auth.dart';

import '../pages/mainUI/reviewForSocials.dart';
import 'package:intl/intl.dart';

var events;

Future<List<Review>> getSpecificReviews(
    int filter_val, String socialHouseId) async {
  List<Object> events =
      await DatabaseService().getReviews(socialHouseId) as List<Object>;
  print("here lol");
  var length = events.length;
  List<Review> eves = [];

  for (var i = 0; i < length; i++) {
    String jsonString = jsonEncode(events[i]);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    String name = jsonMap['username'];
    String desc = jsonMap['description'];
    int upvotes = jsonMap['num_upvotes'];
    int comments = jsonMap['num_comments'];
    String time = jsonMap['time'];
    String id = jsonMap['id'];
    String userId = jsonMap['userId'];
    bool anonymous = jsonMap['anonynmous'];
    int shape = 0;
    int ver = 0;

    if (await DatabaseService()
            .userUpvoteCheckReview(id, UserAuth.auth.currentUser.uid, 0) ==
        true) {
      shape = 1;
    }

    if (await DatabaseService().userVerCheck(userId) == true) {
      //print(ver);
      ver = 1;
    }
    eves.add(Review(
      name: name,
      comments: comments.toString(),
      upvotes: upvotes.toString(),
      time: time,
      id: id,
      description: desc,
      hasUpvote: shape,
      ver: ver,
      anonymous: anonymous,
    ));
  }

  print("here too lol");

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
