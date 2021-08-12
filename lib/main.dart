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
        bottomAppBarColor: CustomColors.appNavy,
        appBarTheme: AppBarTheme(
          backgroundColor: CustomColors.appOrange,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: CustomColors.appNavy,
        primaryColor: CustomColors.appOrange,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: CustomColors.appOrange),
      ),
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    );
  }
}
