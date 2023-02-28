import 'dart:convert';

import 'package:flutter_login_ui/services/database.dart';

import 'reply.dart';

// var petitions = DatabaseService().getPetitions();
// var p = json.decode(petitions as String);

// for (var i = 0; i < 5; i++) {
//   print(i);
// }

//var replies = getAllReplies();

Future<List<Reply>> getAllReplies(String pid) async {
  List<Object> petitions =
      await DatabaseService().getReplies(pid) as List<Object>;
  var length = petitions.length;
  List<Reply> tweeds = [];

  for (var i = 0; i < length; i++) {
    String jsonString = jsonEncode(petitions[i]);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    String username = jsonMap['username'];
    String replyText = jsonMap['replyText'];
    String time = jsonMap['time'];

    tweeds.add(Reply(
      username: username,
      replyText: replyText,
      time: time,
    ));
  }

  return tweeds;
}
