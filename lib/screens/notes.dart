import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/custom_widgets/snackbar.dart';
import 'package:todo_app_firebase/screens/create_note.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';
import 'package:todo_app_firebase/utils/database_helper.dart';
import 'package:todo_app_firebase/utils/note_modal.dart';

class MyNotes extends StatefulWidget {
  const MyNotes({Key? key}) : super(key: key);

  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('My Notes'),
          actions: [],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot<Note>>(
                  stream: Database.notes,
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
                              CustomColors.appOrange),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: Key(snapshot.data!.docs[index].id),
                              background: Container(
                                color: CustomColors.appNavy,
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
                                    DocumentSnapshot<Note> docSnap =
                                        await docRef.get()
                                            as DocumentSnapshot<Note>;

                                    ///navigate to createNote screen
                                    Get.to(CreateNote(document: docSnap));
                                  },
                                ),
                              ),
                            );
                          });
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
