import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
