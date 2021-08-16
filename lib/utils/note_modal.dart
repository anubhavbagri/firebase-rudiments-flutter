import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String title;
  final String? uid;
  final Timestamp? dateTime;
  Note({required this.title, this.uid, this.dateTime});

  //this will convert json data to Note object
  Note.fromJson(Map<String, Object?> json)
      : this(
            title: json['title']! as String,
            uid: json['uid'] as String,
            dateTime: json['dateTime'] as Timestamp);

  //this will convert Note object to Json data(or adding data from our application to firebase)
  Map<String, Object?> toJson() {
    return {'title': title, 'uid': uid, 'dateTime': dateTime};
  }
}
