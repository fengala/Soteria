import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';

import 'tweet.dart';

// var petitions = DatabaseService().getPetitions();
// var p = json.decode(petitions as String);

// for (var i = 0; i < 5; i++) {
//   print(i);
// }

var tweets = getAllPetitions();

Future<List<Tweet>> getAllPetitions() async {
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

    // print("##########");
    // print(petitions[i]);
    // print(title);
    print(ver);
    // print('Length: $length');
    // print("##########");
    tweeds.add(Tweet(
      avatar:
          'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
      username: name,
      name: name,
      text: title,
      comments: comments.toString(),
      retweets: '23K',
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
  return tweeds;
}
