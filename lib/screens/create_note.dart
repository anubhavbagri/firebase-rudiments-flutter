import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateNote extends StatelessWidget {
  const CreateNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String text = "";
    TextEditingController textEditingController = new TextEditingController();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Create a New Note'),
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
                maxLines: null,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Cancel'),
                  style: OutlinedButton.styleFrom(primary: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(),
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
