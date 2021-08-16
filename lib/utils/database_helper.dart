import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app_firebase/utils/note_modal.dart';

class Database {
  static User? user = FirebaseAuth.instance.currentUser;

  static var noteRef = FirebaseFirestore.instance
      .collection('users')̥
      .doc(user!.uid)
      .collection('notes')
      .withConverter<Note>(
        fromFirestore: (snapshot, _) => Note.fromJson(snapshot.data()!),
        toFirestore: (note, _) => note.toJson(),
      );
}
