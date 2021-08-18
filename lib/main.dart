import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/screens/sign_in_screen.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Gilroy',
            ),
        // bottomAppBarColor: CustomColors.matte,
        appBarTheme: AppBarTheme(
          backgroundColor: CustomColors.orange,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.white,
        // primaryColor: CustomColors.orange,
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: CustomColors.orange),
      ),
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    );
  }
}
