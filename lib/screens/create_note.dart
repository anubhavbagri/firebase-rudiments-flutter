import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/services/dynamic_size.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';
import 'package:todo_app_firebase/utils/database_helper.dart';
import 'package:todo_app_firebase/utils/note_modal.dart';

class CreateNote extends StatelessWidget {
  final DocumentSnapshot<Note>? document;
  CreateNote({this.document, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.headline5!.copyWith(
          color: CustomColors.matte,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        );

    // ignore: unused_local_variable
    String text = "";
    text = document == null ? "" : document!.data()!.title;
    TextEditingController textEditingController =
        new TextEditingController(text: text)
          ..selection = TextSelection.collapsed(offset: text.length);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: DynamicSize.safeVertical! * .18,
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back_ios_new_rounded),
              ),
              Spacer(),
              Padding(
                padding:
                    EdgeInsets.only(left: DynamicSize.safeHorizontal! * .035),
                child: document == null
                    ? Text('Create a New Note', style: titleStyle)
                    : Text('Update note', style: titleStyle),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DynamicSize.safeHorizontal! * .04,
                vertical: DynamicSize.safeVertical! * .01,
              ),
              child: TextField(
                controller: textEditingController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: CustomColors.peach,
                decoration: InputDecoration(
                  hintText: 'What do you want to save today?',
                  hintStyle: Theme.of(context).textTheme.headline6!.copyWith(
                        color: CustomColors.matte.withOpacity(0.3),
                        fontWeight: FontWeight.w400,
                      ),
                  counterText: '',
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 22),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                maxLength: 150,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                scrollPhysics: NeverScrollableScrollPhysics(),
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter
                ],
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
                              name: FirebaseAuth
                                  .instance.currentUser!.displayName!,
                              uid: Database.user!.uid,
                              dateTime: myTimeStamp),
                        );
                      } else {
                        Database.updateNoteById(
                          document!.id,
                          Note(
                            title: textEditingController.text,
                            name:
                                FirebaseAuth.instance.currentUser!.displayName!,
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
              height: DynamicSize.safeVertical! * .04,
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
