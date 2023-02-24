import 'dart:convert';
import 'dart:ffi';

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
    // print("##########");
    // print(petitions[i]);
    // print(title);
    // print(desc);
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
    ));
    // print("Here!");
  }
  return tweeds;
}

// var tweets = [
//   Tweet(
//     avatar:
//         'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
//     username: 'Flutter',
//     name: 'kgovil',
//     text: 'Test 1',
//     comments: '243',
//     retweets: '23K',
//     favorites: '112K',
//   ),
//   Tweet(
//     avatar:
//         'https://pbs.twimg.com/profile_images/1033695141901623301/W-VnxCiG_400x400.jpg',
//     username: 'Flutter',
//     name: 'jain455',
//     text: 'Test 2',
//     comments: '46',
//     retweets: '4K',
//     favorites: '17K',
//   ),
//   Tweet(
//     avatar:
//         'https://pbs.twimg.com/profile_images/1168932726461935621/VRtfrDXq_400x400.png',
//     username: 'Flutter',
//     name: 'mohant19',
//     text: 'Test 3',
//     comments: '305',
//     retweets: '20K',
//     favorites: '1M',
//   ),
//   Tweet(
//     avatar:
//         'https://pbs.twimg.com/profile_images/808350098178670592/bYyZI8Bp_400x400.jpg',
//     username: 'Flutter',
//     name: 'fgala',
//     text: 'Test 4',
//     comments: '1K',
//     retweets: '70K',
//     favorites: '2M',
//   ),
//   Tweet(
//     avatar:
//         'https://pbs.twimg.com/profile_images/1033695141901623301/W-VnxCiG_400x400.jpg',
//     username: 'Flutter',
//     name: 'tylaman',
//     text: 'Test 5',
//     comments: '46',
//     retweets: '4K',
//     favorites: '17K',
//   ),
//   Tweet(
//     avatar:
//         'https://pbs.twimg.com/profile_images/1033695141901623301/W-VnxCiG_400x400.jpg',
//     username: 'Flutter',
//     name: 'kgovil',
//     text: 'Test 6',
//     comments: '46',
//     retweets: '4K',
//     favorites: '17K',
//   ),
//   Tweet(
//     avatar:
//         'https://pbs.twimg.com/profile_images/1033695141901623301/W-VnxCiG_400x400.jpg',
//     username: 'Flutter',
//     name: 'jain455',
//     text: 'Test 7',
//     comments: '46',
//     retweets: '4K',
//     favorites: '17K',
//   ),
//   Tweet(
//     avatar:
//         'https://pbs.twimg.com/profile_images/1033695141901623301/W-VnxCiG_400x400.jpg',
//     username: 'Flutter',
//     name: 'mohant19',
//     text: 'Test 8',
//     comments: '46',
//     retweets: '4K',
//     favorites: '17K',
//   ),
//   Tweet(
//     avatar:
//         'https://pbs.twimg.com/profile_images/1033695141901623301/W-VnxCiG_400x400.jpg',
//     username: 'Flutter',
//     name: 'fgala',
//     text: 'Test 9',
//     comments: '46',
//     retweets: '4K',
//     favorites: '17K',
//   ),
// ];
