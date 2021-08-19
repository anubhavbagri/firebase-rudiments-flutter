import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/services/dynamic_size.dart';

class CustomSnackBar {
  final String message;

  const CustomSnackBar({
    required this.message,
  });

  static show(String message) {
    Get.rawSnackbar(
      backgroundColor: Colors.white,
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.black,
        ),
      ), // message
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text(
          'Close',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      margin: EdgeInsets.symmetric(
          vertical: DynamicSize.safeVertical! * .03,
          horizontal: DynamicSize.safeHorizontal! * .04),
      borderColor: Colors.red,
      borderRadius: 10,
      borderWidth: 2,
      boxShadows: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 3.0,
        )
      ],
      isDismissible: false,
      duration: Duration(hours: 2),
    );
  }
}
