import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/screens/sign_in_screen.dart';
import 'package:todo_app_firebase/services/constants.dart';
import 'package:todo_app_firebase/services/size_config.dart';
import 'package:todo_app_firebase/utils/authentication.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';
import 'package:get/get.dart';

class UserInfoScreen extends StatefulWidget {
  final User? _user;
  const UserInfoScreen({Key? key, User? user})
      : _user = user,
        super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  User? _user;
  bool _isSigningOut = false;

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('About'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.safeHorizontal! * .02,
              right: SizeConfig.safeHorizontal! * .02,
              bottom: SizeConfig.safeVertical! * .03,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(),
                _user!.photoURL != null
                    ? ClipOval(
                        child: Material(
                          color: CustomColors.appGrey.withOpacity(0.3),
                          child: Image.network(
                            _user!.photoURL!,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Material(
                          color: CustomColors.appGrey.withOpacity(0.3),
                          child: Padding(
                            padding: EdgeInsets.all(
                                SizeConfig.safeHorizontal! * .02),
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 60,
                              color: CustomColors.appGrey,
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: SizeConfig.safeVertical! * .03),
                Text(
                  'Hello',
                  style: TextStyle(
                    color: CustomColors.appGrey,
                    fontSize: 26,
                  ),
                ),
                SizedBox(height: SizeConfig.safeVertical! * .03),
                Text(
                  _user!.displayName!,
                  style: TextStyle(
                    color: CustomColors.appYellow,
                    fontSize: 26,
                  ),
                ),
                SizedBox(height: SizeConfig.safeVertical! * .03),
                Text(
                  '(${_user!.email})',
                  style: TextStyle(
                    color: CustomColors.appOrange,
                    fontSize: 20,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: SizeConfig.safeVertical! * .03),
                Text(
                  DISCLAIMER,
                  style: TextStyle(
                      color: CustomColors.appGrey.withOpacity(0.8),
                      fontSize: 14,
                      letterSpacing: 0.2),
                ),
                SizedBox(height: SizeConfig.safeVertical! * .03),
                _isSigningOut
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.redAccent,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isSigningOut = true;
                          });
                          await Authentication.signOut();
                          setState(() {
                            _isSigningOut = false;
                          });

                          Get.off(SignInScreen(),
                              transition: Transition.downToUp);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.safeVertical! * .01,
                              bottom: SizeConfig.safeVertical! * .01),
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
