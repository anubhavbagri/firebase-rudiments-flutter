import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/screens/sign_in_screen.dart';
import 'package:todo_app_firebase/services/constants.dart';
import 'package:todo_app_firebase/services/size_config.dart';
import 'package:todo_app_firebase/utils/authentication.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CustomColors.peach,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: SizeConfig.safeVertical! * .27,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 2.0,
                          top: 2.0,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            color: CustomColors.matte,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, 15),
                  child: Container(
                    width: SizeConfig.safeHorizontal! * .26,
                    height: SizeConfig.safeHorizontal! * .26,
                    decoration: ShapeDecoration.fromBoxDecoration(
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2.5),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: _user!.photoURL != null
                              ? NetworkImage(
                                  _user!.photoURL!,
                                )
                              : NetworkImage(
                                  DUMMY_PROFILE,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.safeVertical! * .05),
            Text(
              _user!.displayName!,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: CustomColors.matte,
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
            ),
            SizedBox(height: SizeConfig.safeVertical! * .01),
            Text(
              '${_user!.email}',
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: CustomColors.matte.withOpacity(0.3),
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: SizeConfig.safeVertical! * .03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.grey[300],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.github),
                    color: CustomColors.matte,
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: SizeConfig.safeHorizontal! * .05),
                Card(
                  color: Colors.grey[300],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.linkedinIn),
                    color: CustomColors.matte,
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: SizeConfig.safeHorizontal! * .05),
                Card(
                  color: Colors.grey[300],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.behance),
                    color: CustomColors.matte,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.safeVertical! * .03),
            Text(
              DISCLAIMER,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: CustomColors.matte.withOpacity(0.3),
                    fontWeight: FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            _isSigningOut
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : TextButton(
                    child: Text(
                      'Sign Out',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                    ),
                    style: TextButton.styleFrom(
                      fixedSize: Size(
                        SizeConfig.safeHorizontal! * .8,
                        SizeConfig.safeVertical! * .06,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: CustomColors.orange,
                      elevation: 3,
                    ),
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await Authentication.signOut();
                      setState(() {
                        _isSigningOut = false;
                      });
                      Get.off(
                        () => SignInScreen(),
                        transition: Transition.downToUp,
                      );
                    },
                  ),
            SizedBox(height: SizeConfig.safeVertical! * .15),
          ],
        ),
      ),
    );
  }
}
