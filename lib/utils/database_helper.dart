import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/custom_widgets/snackbar.dart';
import 'package:todo_app_firebase/utils/note_modal.dart';

class Database {
  static User? user = FirebaseAuth.instance.currentUser;

  //To update notes reference object by passing current user id
  static void updateNoteRef(String uid) {
    notesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notes')
        .withConverter<Note>(
          fromFirestore: (snapshot, _) =>
              Note.fromJson(snapshot.data()!), //converting to Note object
          toFirestore: (note, _) => note.toJson(),
        );
  }

  //To update or modify your notes, you have to give a reference for your particular collection
  static var notesRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('notes')
      .withConverter<Note>(
        fromFirestore: (snapshot, _) =>
            Note.fromJson(snapshot.data()!), //converting to Note object
        toFirestore: (note, _) => note.toJson(),
      );

  //notes will be storing all the query snapshots of note object and we are fetching it with the help of notesRef object
  static Stream<QuerySnapshot<Note>> notes = notesRef
      .snapshots(); // it will be storing all the snapshots of note datatype from notes collection of the current user which is logging in our app

  static Future<void> addNote(Note data) {
    // Call the user's CollectionReference to add a new user
    return notesRef
        .add(data)
        .then((value) => CustomSnackBar.show(
              'Note Added',
              Icons.check,
            ))
        .catchError((e) => print('Failed to add note: $e'));
  }

  static Future<void> deleteNoteById(String documentId) {
    //each note is representing a document in firebase which has its own unique ID
    return notesRef
        .doc(documentId)
        .delete()
        .then((value) => print('Note deleted'))
        .catchError((e) => print('Failed to delete note $e'));
  }

  static Future<void> updateNoteById(String documentId, Note note) {
    //to update the title of the note in firebase
    return notesRef
        .doc(documentId)
        .update({'title': note.title})
        .then((value) => print('Note updated'))
        .catchError((e) => print('Failed to update note: $e'));
  }
}
