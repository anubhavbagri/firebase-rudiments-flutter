import 'package:flutter/material.dart';
import 'package:todo_app_firebase/custom_widgets/sign_in_button.dart';
import 'package:todo_app_firebase/services/constants.dart';
import 'package:todo_app_firebase/services/size_config.dart';
import 'package:todo_app_firebase/utils/authentication.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: CustomColors.appNavy,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.safeHorizontal! * .02,
            right: SizeConfig.safeHorizontal! * .02,
            bottom: SizeConfig.safeVertical! * .03,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/icon.png',
                        height: SizeConfig.safeVertical! * .1,
                      ),
                    ),
                    SizedBox(height: SizeConfig.safeVertical! * .01),
                    Text(
                      'FlutterFire',
                      style: TextStyle(
                        color: CustomColors.appYellow,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      'Authentication',
                      style: TextStyle(
                        color: CustomColors.appOrange,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(INIT_ERROR);
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.appOrange,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
