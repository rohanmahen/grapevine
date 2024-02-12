import 'package:flutter/material.dart';
import 'package:grapevine_app/screens/authenticate/register.dart';
import 'package:grapevine_app/screens/authenticate/sign_in.dart';
import 'package:grapevine_app/shared/constants.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Ensures keyboard doesn't push widgets
      body: Container(
        decoration: inAppBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo,
              SizedBox(
                height: 64,
              ),
              Container(
                height: 74,
                width: 300,
                decoration:
                    grapevineBoxDecoration.copyWith(color: grapevineGreen),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: Center(
                    child: Text(
                      "SIGN IN",
                      textAlign: TextAlign.center,
                      style: title2.copyWith(color: grapevineWhite),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                height: 74,
                width: 300,
                decoration:
                    grapevineBoxDecoration.copyWith(color: grapevinePurple),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Center(
                    child: Text(
                      "REGISTER",
                      textAlign: TextAlign.center,
                      style: title2.copyWith(color: grapevineWhite),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
