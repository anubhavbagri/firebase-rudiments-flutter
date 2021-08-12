import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/screens/create_note.dart';
import 'package:todo_app_firebase/screens/notes.dart';
import 'package:todo_app_firebase/screens/user_info_screen.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final User? _user;

  const HomePage({Key? key, User? user})
      : _user = user,
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: index == 0 ? MyNotes() : UserInfoScreen(user: widget._user),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Get.to(CreateNote());
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        notchMargin: 5,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: index,
          onTap: (val) {
            setState(() {
              index = val;
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
                color: index == 0 ? CustomColors.appNavy : Colors.grey,
              ),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: index == 1 ? CustomColors.appNavy : Colors.grey,
              ),
              label: 'person',
            ),
          ],
        ),
      ),
    ));
  }
}
