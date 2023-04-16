import 'dart:convert';

import 'package:flutter_login_ui/services/database.dart';
import '../services/auth.dart';
import '../pages/mainUI/notifpage.dart';

//var notifs = getAllNotifs(String uid);

Future<List<Notif>> getAllNotifs(String uid) async {
  List<Object> notifs = await DatabaseService().getNotifs(uid) as List<Object>;
  var length = notifs.length;
  List<Notif> noti = [];

  for (var i = 0; i < length; i++) {
    String jsonString = jsonEncode(notifs[i]);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    String usid = jsonMap['uid'];
    String text = jsonMap['text'];
    String time = jsonMap['time'];
    String id = jsonMap['id'];

    noti.add(Notif(
      uid: usid,
      text: text,
      time: time,
      id: id,
    ));
  }

  return noti;
}
