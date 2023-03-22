import 'dart:convert';

import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'place.dart';

Future<List<Place>> getAllPlaces() async {
  List<Object> places = await DatabaseService().getPlaces() as List<Object>;
  var length = places.length;
  List<Place> vens = [];

  for (var i = 0; i < length; i++) {
    String jsonString = jsonEncode(places[i]);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    //print(jsonMap);

    String title = jsonMap['title'];
    int comments = jsonMap['num_comments'];
    String desc = jsonMap['description'];
    int rating = jsonMap['num_rating'];
    String id = jsonMap['id'];
    String address = jsonMap['location'];
    String contact = jsonMap['contact'];

    vens.add(Place(
      name: title,
      comments: comments.toString(),
      id: id,
      description: desc,
      rating: rating.toString(),
      location: address,
      contact: contact,
    ));

    //print(id);
    // print("Here!");
  }

  //print(vens);

  return vens;
}
