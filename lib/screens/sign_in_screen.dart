import 'package:flutter/material.dart';
import 'package:todo_app_firebase/custom_widgets/sign_in_button.dart';
import 'package:todo_app_firebase/services/constants.dart';
import 'package:todo_app_firebase/services/dynamic_size.dart';
import 'package:todo_app_firebase/utils/authentication.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    DynamicSize().init(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: DynamicSize.safeVertical! * .2,
              ),
              Container(
                height: DynamicSize.safeVertical! * .24,
                child: SvgPicture.asset(
                  'assets/logo.svg',
                ),
              ),
              SizedBox(
                height: DynamicSize.safeVertical! * .07,
              ),
              Text(
                'Capture Ideas',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: CustomColors.matte,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(
                height: DynamicSize.safeVertical! * .02,
              ),
              Text(
                SIGN_IN_INFO,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: CustomColors.matte.withOpacity(0.3),
                      fontWeight: FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
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
                      CustomColors.orange,
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
