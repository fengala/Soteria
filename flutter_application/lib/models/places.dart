import 'dart:convert';

import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'place.dart';
import 'package:intl/intl.dart';

// var petitions = DatabaseService().getPetitions();
// var p = json.decode(petitions as String);

// for (var i = 0; i < 5; i++) {
//   print(i);
// }
// int filter_val = 4;
//var tweets = getAllPetitions();

Future<List<Place>> getAllPlaces() async {
  List<Object> places =
  await DatabaseService().getPlaces() as List<Object>;
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

    vens.add(Place(
      name: title,
      comments: comments.toString(),
      id: id,
      description: desc,
      rating: rating.toString(),
    ));

    //print(id);
    // print("Here!");
  }

  //print(vens);

  return vens;
}
