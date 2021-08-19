import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/services/size_config.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';
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
              ? Text(
                  'Create a New Note',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(
                  'Update note',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeHorizontal! * .04,
                vertical: SizeConfig.safeVertical! * .02,
              ),
              child: TextField(
                controller: textEditingController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: CustomColors.peach,
                decoration: InputDecoration.collapsed(
                  hintText: 'What do you want to save today?',
                  hintStyle: Theme.of(context).textTheme.headline6!.copyWith(
                        color: CustomColors.matte.withOpacity(0.3),
                        fontWeight: FontWeight.w400,
                      ),
                ),
                style: TextStyle(fontSize: 22),
                keyboardType: TextInputType.multiline,
                // minLines: 1,
                maxLines: 5,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: Colors.grey[300],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.times),
                    color: CustomColors.matte.withOpacity(0.8),
                    iconSize: 26,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Card(
                  color: CustomColors.peach,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.check),
                    color: CustomColors.matte.withOpacity(0.8),
                    iconSize: 26,
                    onPressed: () {
                      Timestamp myTimeStamp =
                          Timestamp.fromDate(DateTime.now());
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
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeVertical! * .04,
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
