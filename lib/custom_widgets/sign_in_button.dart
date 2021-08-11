import 'package:todo_app_firebase/screens/user_info_screen.dart';
import 'package:todo_app_firebase/services/size_config.dart';
import 'package:todo_app_firebase/utils/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.safeVertical! * .03),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
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

                  Get.off(UserInfoScreen(user));
                }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, SizeConfig.safeVertical! * .03,
                    0, SizeConfig.safeVertical! * .03),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: SizeConfig.safeVertical! * .04,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.safeVertical! * .02),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
