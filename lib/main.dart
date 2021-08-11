import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/screens/sign_in_screen.dart';
import 'package:todo_app_firebase/services/size_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    );
  }
}
