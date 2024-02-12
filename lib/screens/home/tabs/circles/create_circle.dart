import 'package:flutter/material.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:grapevine_app/shared/functions.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:grapevine_app/services/messaging.dart';

class CreateCircle extends StatefulWidget {
  @override
  _CreateCircleState createState() => _CreateCircleState();
}

class _CreateCircleState extends State<CreateCircle> {
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

  final _formKey = GlobalKey<FormState>();

  // TO-DO
  // Set up form validators for circle creation to ensure db changes do not take place without safe additions/deletions
  // Required fields for all except members!! Are the main validators to check.

  String circleTitle = "";
  String circleDescription = "";
  String circleMembers = " ";
  String circleFormation = "";

  String error = "";
  @override
  Widget build(BuildContext context) {
    // ensure this is always the my user data model when fetching user data from the collection.
    final user = Provider.of<MyUserData>(context);
    // ignore: unused_local_variable
    final DatabaseService db = DatabaseService(userID: user.userID);
    // double deviceWidth = MediaQuery.of(context).size.width;

    final MessagingService fcm = MessagingService();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(
          "Create Circle".toUpperCase(),
          style: title2.copyWith(color: grapevineBlack),
        ),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Container(
                height: 497,
                width: 360,
                decoration:
                    grapevineBoxDecoration.copyWith(color: grapevineWhite),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          decoration:
                              textInputDecoration.copyWith(labelText: "Title",isDense: true),
                          validator: (val) {
                            if (validName.hasMatch(val.trim().toLowerCase())) {
                              return null;
                            } else {
                              return "Invalid title";
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              circleTitle = val.trim().toLowerCase();
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Align(
                          child: Text(
                            "KCL Tennis Team etc.",
                            style: subHead.copyWith(color: grapevineGrey),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          decoration: textInputDecoration.copyWith(
                            labelText: "Description",
                            isDense: true,
                          ),
                          validator: (val) =>
                              val.isEmpty ? "This field is required" : null,
                          onChanged: (val) {
                            setState(() {
                              circleDescription = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Align(
                          child: Text(
                            "Eg: The KCL degenerate gamblers",
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
                            labelText: "Add Members",
                            isDense: true,
                          ),
                          // add description validator with 150 character limit.

                          onChanged: (val) {
                            setState(() {
                              circleMembers = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Align(
                          child: Text(
                            "Eg: @johndoe @janedoe",
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
                        child: DropdownButtonFormField(
                          isDense: true,
                          validator: (val) =>
                              val == null ? "This field is required" : null,
                          items: [
                            DropdownMenuItem(
                              value: "University",
                              child: Text("University"),
                            ),
                            DropdownMenuItem<String>(
                              value: "Work",
                              child: Text("Work"),
                            ),
                            DropdownMenuItem<String>(
                              value: "Club/Team",
                              child: Text("Club/Team"),
                            ),
                            DropdownMenuItem<String>(
                              value: "Friends",
                              child: Text("Friends"),
                            ),
                          ],
                          decoration: textInputDecoration.copyWith(
                            labelText: "How did you meet?",
                            isDense: true,
                          ),
                          // add description validator with 150 character limit.

                          onChanged: (val) {
                            setState(() {
                              circleFormation = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Align(
                          child: Text(
                            "Eg: University, Work, Friends, etc ",
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
                            var result =
                                await Connectivity().checkConnectivity();

                            if (result == ConnectivityResult.none) {
                              setState(() {
                                error = "No internet connection";
                              });
                              return;
                            }

                            if (_formKey.currentState.validate()) {
                              if (await db.circleExists(circleTitle)) {
                                // circle name is taken
                                setState(() {
                                  error = "That circle name is taken :(";
                                });
                              } else {
                                // Circle name is not taken and its validated
                                // retrieve members
                                List<String> members = getMembers(circleMembers)
                                    .map((s) => s.substring(1))
                                    .map((s) => s.toLowerCase())
                                    .toList();

                                // Make the circle
                                await db.createCircle(
                                  circleTitle,
                                  circleDescription,
                                  [user.userName],
                                  circleFormation,
                                );

                                // Set circleID as title
                                String circleID = circleTitle;

                                // Add circle to potential circles for every VALID user in members
                                for (var i = 0; i < members.length; i++) {
                                  if (members[i] != user.userName) {
                                    // Make sure they don't add their own name to the potential circles list
                                    if (await db.usernameExists(members[i])) {
                                      // Check if username exists
                                      var userID =
                                          await db // If they exist, get their userID
                                              .usernameCollection
                                              .doc(members[i])
                                              .get()
                                              .then((snapshot) =>
                                                  snapshot.get("id"));
                                      await db.addCircleToPotentialCircles(
                                          // Add the circle to their user's potential circles
                                          userID,
                                          circleID);
                                    }
                                  }
                                }
                                // Add circle to current user circles
                                await db.addCircleToUser(user.userID, circleID);

                                // Add user to circle
                                await db.addUserToCircle(
                                    user.userName, circleID);

                                
                                

                                // Add mixpanel analytics
                                mixpanel.track(
                                  "Create Circle",
                                );
  // subscribe the device to the circles                         
                                await fcm.subscribeToCircle(circleID);

                                return Navigator.pop(context); // Head back out
                              }
                            } else {
                              // unvalidated!

                            }
                          },
                          child: Center(
                            child: Text(
                              "CREATE",
                              textAlign: TextAlign.center,
                              style: headLine.copyWith(color: grapevineWhite),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                error,
                style: subHead,
              )
            ],
          ),
        ),
      ),
    );
  }
}
