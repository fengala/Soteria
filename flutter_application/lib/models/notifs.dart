import 'dart:convert';

import 'package:flutter_login_ui/services/database.dart';
import '../services/auth.dart';
import '../pages/mainUI/notifpage.dart';

var notifs = getAllNotifs();

Future<List<Notif>> getAllNotifs() async {
  List<Object> notifs = await DatabaseService().getNotifs() as List<Object>;
  var length = notifs.length;
  List<Notif> noti = [];

  for (var i = 0; i < length; i++) {
    String jsonString = jsonEncode(notifs[i]);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    String name = jsonMap['username'];
    String text = jsonMap['text'];
    String time = jsonMap['time'];
    String id = jsonMap['id'];

    noti.add(Notif(
      username: name,
      text: text,
      time: time,
      id: id,
    ));
  }

  return noti;
}
