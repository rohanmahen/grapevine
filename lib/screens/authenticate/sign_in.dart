import 'package:flutter/material.dart';
import 'package:grapevine_app/services/auth.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  Mixpanel mixpanel;

  @override
  void initState() {
    super.initState();
    initMixpanel();
  }

  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init("faketoken",
        optOutTrackingDefault: false);
  }

  String email = "";
  String password = "";

  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: grapevineWhite, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
         iconTheme: IconThemeData(
          color: grapevinePurple, //change your color here
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: false,
      body: Container(
        decoration: inAppBackground,
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                decoration: inAppBackground,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 518,
                      width: 360,
                      decoration: grapevineBoxDecoration.copyWith(
                          color: grapevineWhite),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            logo,
                            SizedBox(
                              height: 32,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: "email"),
                                onChanged: (val) {
                                  setState(() {
                                    email = val.trim();
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Align(
                                child: Text(
                                  "example@grapevineapp.co.uk",
                                  style: subHead.copyWith(color: grapevineGrey),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: "password"),
                                obscureText: true,
                                onChanged: (val) {
                                  password = val;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Align(
                                child: Text(
                                  "shhhh it's a secret",
                                  style: subHead.copyWith(color: grapevineGrey),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              height: 37,
                              width: 141,
                              decoration: grapevineBoxDecoration.copyWith(
                                  color: grapevineGreen),
                              child: GestureDetector(
                                behavior: HitTestBehavior
                                    .translucent, // ensures you can click anywhere on the button
                                onTap: () async {
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);

                                  if (result == null) {
                                    setState(() {
                                      error = "Please enter valid details :)";
                                    });
                                  } else {
                                    mixpanel.identify(
                                      result.userID,
                                    );
                                    mixpanel.track(
                                      "Sign In",
                                    );
                                    mixpanel.flush();
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    "SIGN IN",
                                    textAlign: TextAlign.center,
                                    style: headLine.copyWith(
                                        color: grapevineWhite),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              error,
                              style: subHead.copyWith(
                                color: grapevineGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
