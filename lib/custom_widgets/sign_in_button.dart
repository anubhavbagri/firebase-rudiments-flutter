import 'package:todo_app_firebase/screens/notes.dart';
import 'package:todo_app_firebase/services/dynamic_size.dart';
import 'package:todo_app_firebase/utils/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: DynamicSize.safeVertical! * .08),
        child: _isSigningIn
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(CustomColors.orange),
              )
            : TextButton(
                child: Text(
                  'Sign in',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                ),
                style: TextButton.styleFrom(
                  fixedSize: Size(
                    DynamicSize.safeHorizontal! * .43,
                    DynamicSize.safeVertical! * .06,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: CustomColors.orange,
                  elevation: 3,
                ),
                onPressed: () async {
                  setState(() {
                    _isSigningIn = true;
                  });

                  User? user = await Authentication.signInWithGoogle();

                  if (user != null) {
                    setState(() {
                      _isSigningIn = false;
                    });

                    Get.off(
                      () => MyNotes(user: user),
                      transition: Transition.leftToRightWithFade,
                    );
                  }
                },
              ));
  }
}
