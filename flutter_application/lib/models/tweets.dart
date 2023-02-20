import 'package:cloud_firestore/cloud_firestore.dart';
import 'tweet.dart';
import 'package:firebase_auth/firebase_auth.dart';

var tweets = [
  Tweet(
    username: 'kgovil',
    name: 'KUSH GOMVIL',
    description: 'HELLO',
    comments: '243',
    votes: '23',
  ),
  Tweet(
    username: 'fgala',
    name: 'FEN GAMLA',
    description: 'HELLO!!!',
    comments: '23',
    votes: '23',
  ),
];

FirebaseFirestore db = FirebaseFirestore.instance;
var tweets2 = db.collection("Petitions").get().then(
  (res) => print("Successfully completed"),
  onError: (e) => print("Error completing: $e"),
  );