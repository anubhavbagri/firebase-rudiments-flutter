import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/constants.dart';
import '../services/size_config.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get.off(UserInfoScreen(user: user));
    }
    return firebaseApp;
  }

  static Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    //Trigger the authentication flow
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        // Once signed in, return the UserCredential
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        //return user Object from user credential
        user = userCredential.user;
        return user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // The account already exists with a different credential
          // Authentication.customSnackBar(ERROR_1);
        } else if (e.code == 'invalid-credential') {
          // Authentication.customSnackBar(ERROR_2);
        }
      } catch (e) {
        // Authentication.customSnackBar(ERROR_3);
      }
    }
  }

  static customSnackBar(String message) {
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
          vertical: SizeConfig.safeVertical! * .03,
          horizontal: SizeConfig.safeHorizontal! * .04),
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
