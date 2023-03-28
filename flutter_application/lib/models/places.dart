import 'dart:convert';

import 'package:flutter_login_ui/services/auth.dart';
import 'package:flutter_login_ui/services/database.dart';
import 'place.dart';

Future<List<Place>> getAllPlaces(int filter_val) async {
  List<Object> places = await DatabaseService().getPlaces() as List<Object>;
  var length = places.length;
  List<Place> vens = [];

  for (var i = 0; i < length; i++) {
    String jsonString = jsonEncode(places[i]);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    String title = jsonMap['title'];
    num comments = jsonMap['num_comments'];
    String desc = jsonMap['description'];
    num rating = jsonMap['num_rating'];
    num reviews = jsonMap['num_reviews'];
    double ratio = (rating * 1.0) / (reviews * 1.0);
    String id = jsonMap['id'];
    String address = jsonMap['location'];
    String contact = jsonMap['contact'];
    String acc = jsonMap['acc'];

    vens.add(Place(
      name: title,
      comments: comments.toString(),
      id: id,
      description: desc,
      rating: rating.toString(),
      location: address,
      contact: contact,
      ratio: ratio.toString(),
      acc: acc,
      num_reviews: reviews.toString(),
    ));
  }

  if (filter_val == 0) {
    return vens;
  } else if (filter_val == 1) {
    vens.sort((a, b) => (a.ratio).compareTo(b.ratio));
  } else if (filter_val == 2) {
    vens.sort((a, b) => b.rating.compareTo(a.rating));
  } else if (filter_val == 3) {
    vens.sort((a, b) => a.rating.compareTo(b.rating));
  } else if (filter_val == 4) {
    vens.sort((a, b) => b.comments.compareTo(a.comments));
  } else if (filter_val == 5) {
    vens.sort((a, b) => a.comments.compareTo(b.comments));
  }

  return vens;
}
