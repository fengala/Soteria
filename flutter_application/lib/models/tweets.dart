import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'tweet.dart';
import 'package:intl/intl.dart';

// var petitions = DatabaseService().getPetitions();
// var p = json.decode(petitions as String);

// for (var i = 0; i < 5; i++) {
//   print(i);
// }
// int filter_val = 4;
//var tweets = getAllPetitions();

Future<List<Tweet>> getAllPetitions(int filter_val) async {
  List<Object> petitions =
      await DatabaseService().getPetitions() as List<Object>;
  var length = petitions.length;
  List<Tweet> tweeds = [];

  for (var i = 0; i < length; i++) {
    // tweeds[i] = Tweet(avatar: petitions., username: username, name: name, text: text, comments: comments, retweets: retweets, favorites: favorites)
    // List<Object> petitions =
    //     await DatabaseService().getPetitions() as List<Object>;
    // var pet = json(petitions[0]);
    String jsonString = jsonEncode(petitions[i]);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    String name = jsonMap['username'];
    String title = jsonMap['tile'];
    String desc = jsonMap['description'];
    int upvotes = jsonMap['num_upvotes'];
    int comments = jsonMap['num_comments'];
    String time = jsonMap['time'];
    String id = jsonMap['id'];
    String userId = jsonMap['userId'];
    int shape = 0;
    int ver = 0;

    if (await DatabaseService()
            .userUpvoteCheckPet(id, UserAuth.auth.currentUser.uid, 0) ==
        true) {
      shape = 1;
    }

    if (await DatabaseService().userVerCheck(userId) == true) {
      ver = 1;
    }

    tweeds.add(Tweet(
      avatar:
          'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
      username: name,
      name: name,
      text: title,
      comments: comments.toString(),
      favorites: upvotes.toString(),
      time: time,
      id: id,
      description: desc,
      i: shape,
      userId: userId,
      ver: ver,
    ));
    // print("Here!");
  }
  if (filter_val == 0) {
    tweeds.sort((a, b) {
      DateTime a_time = DateFormat('MM/dd/yyyy hh:mm a').parse(a.time);
      DateTime b_time = DateFormat('MM/dd/yyyy hh:mm a').parse(b.time);
      return b_time.compareTo(a_time);
    });
  }
  if (filter_val == 1) {
    tweeds.sort((a, b) {
      DateTime a_time = DateFormat('MM/dd/yyyy hh:mm a').parse(a.time);
      DateTime b_time = DateFormat('MM/dd/yyyy hh:mm a').parse(b.time);
      return a_time.compareTo(b_time);
    });
  } else if (filter_val == 2) {
    // tweeds.sort(favor)
    tweeds.sort((a, b) => b.favorites.compareTo(a.favorites));
  } else if (filter_val == 3) {
    // tweeds.sort(favor)
    tweeds.sort((a, b) => a.favorites.compareTo(b.favorites));
  } else if (filter_val == 4) {
    // tweeds.sort(favor)
    tweeds.sort((a, b) => b.comments.compareTo(a.comments));
  } else if (filter_val == 5) {
    // tweeds.sort(favor)
    tweeds.sort((a, b) => a.comments.compareTo(b.comments));
  }

  return tweeds;
}
