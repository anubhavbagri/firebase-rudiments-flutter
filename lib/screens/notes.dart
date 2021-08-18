import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/custom_widgets/snackbar.dart';
import 'package:todo_app_firebase/screens/create_note.dart';
import 'package:todo_app_firebase/screens/user_info_screen.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';
import 'package:todo_app_firebase/utils/database_helper.dart';
import 'package:todo_app_firebase/utils/note_modal.dart';

enum NoteQuery {
  titleAsc,
  titleDesc,
  dateAsc,
  dateDesc,
}

extension on Query<Note> {
  ///Create a firebase query from a [NoteQuery]
  Query<Note> queryBy(NoteQuery query) {
    switch (query) {
      case NoteQuery.titleAsc:
      case NoteQuery.titleDesc:
        return orderBy('title', descending: query == NoteQuery.titleDesc);
      case NoteQuery.dateAsc:
      case NoteQuery.dateDesc:
        return orderBy('dateTime', descending: query == NoteQuery.dateDesc);
    }
  }
}

class MyNotes extends StatefulWidget {
  final User? _user;
  const MyNotes({Key? key, User? user})
      : _user = user,
        super(key: key);

  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  late Stream<QuerySnapshot<Note>> _notes;

  late Query<Note> _notesQuery;

  void _updateNotesQuery(NoteQuery query) {
    setState(() {
      Database.updateNoteRef(FirebaseAuth.instance.currentUser!.uid);
      _notesQuery = Database.notesRef.queryBy(query);
      _notes = _notesQuery.snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateNotesQuery(NoteQuery.dateAsc); //sorting date in ascending order
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Notes'),
          leading: PopupMenuButton<NoteQuery>(
            onSelected: _updateNotesQuery,
            icon: Icon(
              Icons.sort,
            ),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: NoteQuery.titleAsc,
                  child: Text('Sort by Title ascending'),
                ),
                const PopupMenuItem(
                  value: NoteQuery.titleDesc,
                  child: Text('Sort by Title descending'),
                ),
                const PopupMenuItem(
                  value: NoteQuery.dateAsc,
                  child: Text('Sort by Date ascending'),
                ),
                const PopupMenuItem(
                  value: NoteQuery.dateDesc,
                  child: Text('Sort by Date descending'),
                ),
              ];
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: () {
                Get.to(() => UserInfoScreen(user: widget._user));
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot<Note>>(
                  stream: _notes,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Note>> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Icon(
                          Icons.report_gmailerrorred_rounded,
                          size: 80,
                          color: Colors.orange,
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              CustomColors.orange),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: Key(snapshot.data!.docs[index].id),
                            background: Container(
                              color: CustomColors.matte,
                            ),
                            onDismissed: (direction) {
                              Database.deleteNoteById(
                                  snapshot.data!.docs[index].id);
                              CustomSnackBar.show('Note dismissed');
                            },
                            child: Card(
                              color: Colors.white10,
                              child: ListTile(
                                title: Text(
                                  snapshot.data!.docs[index].data().title,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () async {
                                  ///storing document of a particular document id
                                  DocumentReference docRef = Database.notesRef
                                      .doc(snapshot.data!.docs[index].id);
                                  DocumentSnapshot<Note> docSnap = await docRef
                                      .get() as DocumentSnapshot<Note>;

                                  ///navigate to createNote screen
                                  Get.to(CreateNote(document: docSnap));
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.orange,
          onPressed: () {
            Get.to(CreateNote());
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
