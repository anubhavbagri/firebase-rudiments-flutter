import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app_firebase/custom_widgets/snackbar.dart';
import 'package:todo_app_firebase/screens/home_page.dart';

import '../services/constants.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.off(() => HomePage(user: user));
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
      }
      // on FirebaseAuthException catch (e) {
      //   if (e.code == 'account-exists-with-different-credential') {
      //      The account already exists with a different credential
      //     CustomSnackBar.show(ERROR_1);
      //   } else if (e.code == 'invalid-credential') {
      //     CustomSnackBar.show(ERROR_2);
      //   } else {
      //     CustomSnackBar.show('Something went wrong 🚧 Try again');
      //   }
      // }
      catch (e) {
        CustomSnackBar.show(ERROR_3);
      }
    }
  }

  static Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      CustomSnackBar.show(SIGNOUT_ERROR);
    }
  }
}
