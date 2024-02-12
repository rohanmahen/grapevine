import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grapevine_app/services/auth.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

// Date time stuff
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

// !!! SET UP FORM VALIDATORS + USERNAME CHECKS!!!!
class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();

  Mixpanel mixpanel;

  @override
  void initState() {
    super.initState();
    initMixpanel();
  }

  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init("e34af985dc928cc250efdbd9e3718a95",
        optOutTrackingDefault: false);
  }

  // Text form field values
  String email = "";
  String password = "";
  String fullName = "";
  String userName = "";
  DateTime userBirthday;
  String userSex = "";

  // Error string
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ensures keyboard push widgets
      appBar: AppBar(
        title: Text(
          "Register".toUpperCase(),
          style: title3.copyWith(
            color: grapevineBlack,
          ),
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: grapevineWhite, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: grapevinePurple, //change your color here
        ),
      ),
      extendBodyBehindAppBar: false,
      extendBody: false,
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 736,
                  width: 360,
                  decoration:
                      grapevineBoxDecoration.copyWith(color: grapevineWhite),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                          ),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Create username", isDense: true),
                            validator: (val) {
                              if (validName
                                  .hasMatch(val.trim().toLowerCase())) {
                                return null;
                              } else {
                                return "Invalid username";
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                userName = val.trim().toLowerCase();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Align(
                            child: Text(
                              "something your friends will recognise",
                              style: subHead.copyWith(color: grapevineGrey),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                                isDense: true, labelText: "Create password"),
                            validator: (val) => val.length < 6
                                ? "Password must be longer than 6 characters"
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Align(
                            child: Text(
                              "something you'll remember!!",
                              style: subHead.copyWith(color: grapevineGrey),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              isDense: true,
                            ),
                            validator: (val) {
                              if (validEmail.hasMatch(val.trim())) {
                                return null;
                              } else {
                                return "Enter a valid email";
                              }
                            },
                            obscureText: false,
                            onChanged: (val) {
                              setState(() {
                                email = val.trim();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Align(
                            child: Text(
                              "incase you forget your password!",
                              style: subHead.copyWith(color: grapevineGrey),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Full name", isDense: true),
                            validator: (val) {
                              if (validFullName.hasMatch(val.trim())) {
                                return null;
                              } else {
                                return "This field is required.";
                              }
                            },
                            obscureText: false,
                            onChanged: (val) {
                              setState(() {
                                fullName = val.trim();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Align(
                            child: Text(
                              "so everyone knows it's you!",
                              style: subHead.copyWith(color: grapevineGrey),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: DateTimeField(
                            validator: (val) =>
                                val == null ? "This field is required" : null,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Your Birthday", isDense: true),
                            format: DateFormat("yMMMMd"),
                            onShowPicker: (context, currentValue) async {
                              var date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1980),
                                  initialDate: currentValue ?? DateTime(2001),
                                  lastDate: DateTime.now());
                              setState(() {
                                if (date != null) {
                                  userBirthday = date;
                                }
                              });
                              return date;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Align(
                            child: Text(
                              "so we can throw you a party!",
                              style: subHead.copyWith(color: grapevineGrey),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: DropdownButtonFormField(
                            isDense: true,
                            validator: (val) =>
                                val == null ? "This field is required" : null,
                            items: [
                              DropdownMenuItem(
                                value: "Male",
                                child: Text(
                                  "he/him",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Female",
                                child: Text(
                                  "she/her",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Other",
                                child: Text(
                                  "they/them/other",
                                ),
                              ),
                            ],
                            decoration: textInputDecoration.copyWith(
                              isDense: true,
                              labelText: "Pronouns",
                            ),
                            // add description validator with 150 character limit.

                            onChanged: (val) {
                              setState(() {
                                userSex = val;
                                print(val);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Align(
                            child: Text(
                              "so we can ensure Grapevine is inclusive!",
                              style: subHead.copyWith(color: grapevineGrey),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: 37,
                          width: 141,
                          decoration: grapevineBoxDecoration.copyWith(
                              color: grapevineGreen),
                          child: GestureDetector(
                            behavior: HitTestBehavior
                                .translucent, // ensures you can click anywhere on the button
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                if (await _db.usernameExists(userName)) {
                                  setState(() {
                                    error = "username taken :(";
                                  });
                                } else {
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email,
                                          password,
                                          fullName,
                                          userName,
                                          userBirthday,
                                          userSex);
                                  if (result == null) {
                                    setState(() {
                                      error = "This e-mail is already taken :(";
                                    });
                                  } else {
                                    mixpanel.identify(
                                      result.userID,
                                    );
                                    mixpanel.getPeople().set(
                                          r"$name",
                                          fullName,
                                        );
                                    mixpanel.getPeople().set(
                                          r"$email",
                                          email,
                                        );
                                    mixpanel.getPeople().set(
                                          "Username",
                                          userName,
                                        );
                                    mixpanel.track(
                                      "Sign Up",
                                    );
                                    mixpanel.flush();
                                  }
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                "REGISTER",
                                textAlign: TextAlign.center,
                                style: headLine.copyWith(color: grapevineWhite),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          error,
                          style: subHead,
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
    );
  }
}
