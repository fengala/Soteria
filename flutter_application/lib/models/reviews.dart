import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_login_ui/services/database.dart';

import '../services/auth.dart';

import '../pages/mainUI/reviewForSocials.dart';
import 'package:intl/intl.dart';

var events;

Future<List<Review>> getSpecificReviews(
    int filter_val, int filter_val2, String socialHouseId) async {

  List<Object> events =
  await DatabaseService().getReviews(socialHouseId) as List<Object>;

  switch (filter_val2) {
    case 0:
      events =
      await DatabaseService().getReviewsByStar(socialHouseId, 0) as List<
          Object>;
      break;
    case 1:
      events =
      await DatabaseService().getReviewsByStar(socialHouseId, 1) as List<
          Object>;
      //print(events.toString());
      break;
    case 2:
      events =
      await DatabaseService().getReviewsByStar(socialHouseId, 2) as List<
          Object>;
      break;
    case 3:
      events =
      await DatabaseService().getReviewsByStar(socialHouseId, 3) as List<
          Object>;
      break;
    case 4:
      events =
      await DatabaseService().getReviews(socialHouseId) as List<Object>;
      break;
    default:
      events =
      await DatabaseService().getReviews(socialHouseId) as List<Object>;
  }

  var length = events.length;
  List<Review> revs = [];

  for (var i = 0; i < length; i++) {
    String jsonString = jsonEncode(events[i]);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    String name = jsonMap['username'];
    String desc = jsonMap['description'];
    int upvotes = jsonMap['num_upvotes'];
    int comments = jsonMap['num_comments'];
    num rating = jsonMap['rating'];
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

    //comment the if if you want to display even empty ratings
    if (desc != "") {
      Review rev = new Review(
        name: name,
        comments: comments.toString(),
        upvotes: upvotes.toString(),
        time: time,
        id: id,
        description: desc,
        hasUpvote: shape,
        ver: ver,
        anonymous: anonymous,
        rating: rating.toString(),
      );

      if (filter_val == 8 && ver == 1) {
        revs.add(rev);
      } else if (filter_val == 9 && ver == 0) {
        revs.add(rev);
      } else if (filter_val != 8 && filter_val != 9) {
        revs.add(rev);
      }
    }
  }

  if (filter_val == 0) {
    revs.sort((a, b) {
      DateTime a_time = DateFormat('MM/dd/yyyy hh:mm a').parse(a.time);
      DateTime b_time = DateFormat('MM/dd/yyyy hh:mm a').parse(b.time);
      return b_time.compareTo(a_time);
    });
  } else if (filter_val == 1) {
    revs.sort((a, b) {
      DateTime a_time = DateFormat('MM/dd/yyyy hh:mm a').parse(a.time);
      DateTime b_time = DateFormat('MM/dd/yyyy hh:mm a').parse(b.time);
      return a_time.compareTo(b_time);
    });
  } else if (filter_val == 2) {
    revs.sort((a, b) => b.upvotes.compareTo(a.upvotes));
  } else if (filter_val == 3) {
    revs.sort((a, b) => a.upvotes.compareTo(b.upvotes));
  } else if (filter_val == 4) {
    revs.sort((a, b) => b.comments.compareTo(a.comments));
  } else if (filter_val == 5) {
    revs.sort((a, b) => a.comments.compareTo(b.comments));
  } else if (filter_val == 6) {
    revs.sort((a, b) => b.rating.compareTo(a.rating));
  } else if (filter_val == 7) {
    revs.sort((a, b) => a.rating.compareTo(b.rating));
  } else if (filter_val == 8) {
    revs.sort((b, a) => a.ver.compareTo(b.ver));
  } else if (filter_val == 9) {
    revs.sort((b, a) => b.ver.compareTo(a.ver));
  }

  return revs;
}
