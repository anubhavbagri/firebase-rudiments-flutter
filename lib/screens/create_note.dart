import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/utils/database_helper.dart';
import 'package:todo_app_firebase/utils/note_modal.dart';

class CreateNote extends StatelessWidget {
  final DocumentSnapshot<Note>? document;
  CreateNote({this.document, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String text = "";
    text = document == null ? "" : document!.data()!.title;
    TextEditingController textEditingController =
        new TextEditingController(text: text);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: document == null
              ? Text('Create a New Note')
              : Text('Update note'),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                controller: textEditingController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration.collapsed(
                  hintText: 'What do you want to save today?',
                  // hintStyle:
                ),
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.multiline,
                // minLines: 1,
                maxLines: 5,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Cancel'),
                  style: OutlinedButton.styleFrom(primary: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    Timestamp myTimeStamp = Timestamp.fromDate(DateTime.now());
                    if (document == null) {
                      Database.addNote(
                        Note(
                            title: textEditingController.text,
                            uid: Database.user!.uid,
                            dateTime: myTimeStamp),
                      );
                    } else {
                      Database.updateNoteById(
                        document!.id,
                        Note(
                          title: textEditingController.text,
                          dateTime: myTimeStamp,
                        ),
                      );
                    }
                    Get.back();
                  },
                  child: document == null ? Text('Add') : Text('Update'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    elevation: 2,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
            ),
          ],
        ),
      ),
    );
  }
}
