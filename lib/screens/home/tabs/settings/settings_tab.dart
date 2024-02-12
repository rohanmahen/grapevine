import 'package:flutter/material.dart';
import 'package:grapevine_app/screens/home/tabs/settings/opted_out_events.dart';
import 'package:grapevine_app/services/auth.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:grapevine_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/models/event.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  AuthService _auth = AuthService();

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

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    final MyUserData user = Provider.of<MyUserData>(context);

    final DatabaseService db = DatabaseService(userID: user.userID);

    return StreamBuilder<MyUserData>(
        stream: DatabaseService(userID: user.userID).userDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Center(
                            child: Text(
                          user.getInitials(), // get initials from user stream from database
                          style: title1.copyWith(color: grapevineWhite),
                        )),
                        height: 104,
                        width: 104,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: grapevineGreen,
                            boxShadow: [
                              grapevineShadow,
                            ]),
                      ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      height: 88,
                      width: deviceWidth - 32,
                      decoration: grapevineBoxDecoration.copyWith(
                          color: grapevineWhite),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          //
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "@" + user.userName,
                                style: title2,
                              ),
                              Text(
                                user.userFullName,
                                style: subHead.copyWith(color: grapevineGrey),
                              ),
                              Text(
                                user.userEmail,
                                style: subHead.copyWith(color: grapevineGrey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      height: 48,
                      width: deviceWidth - 32,
                      decoration: grapevineBoxDecoration.copyWith(
                          color: grapevinePurple),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  "Are you sure you would like to sign out?"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await _auth.signOut();
                                      mixpanel.track("Sign Out");
                                    },
                                    child: Text("Yes")),
                                TextButton(
                                    onPressed: () async {
                                      return Navigator.pop(context);
                                    },
                                    child: Text("No"))
                              ],
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            "SIGN OUT",
                            textAlign: TextAlign.center,
                            style: headLine.copyWith(color: grapevineWhite),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 48,
                      width: deviceWidth - 32,
                      decoration: grapevineBoxDecoration.copyWith(
                          color: grapevineGreen),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  "Are you sure you would like to delete your account?"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await _auth.signOut();
                                      mixpanel.track("Account Deletion");
                                      mixpanel.flush();
                                    },
                                    child: Text("Yes")),
                                TextButton(
                                    onPressed: () {
                                      return Navigator.pop(context);
                                    },
                                    child: Text("No")),
                              ],
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            "DELETE ACCOUNT",
                            textAlign: TextAlign.center,
                            style: headLine.copyWith(color: grapevineWhite),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 48,
                      width: deviceWidth - 32,
                      decoration: grapevineBoxDecoration.copyWith(
                          color: grapevinePurple),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StreamProvider<MyUserData>.value(
                                value: db.userDataStream,
                                initialData:
                                    MyUserData(), // need to error fix this!!!
                                child: Center(
                                  child: StreamProvider<List<Event>>.value(
                                    value: db.eventStream,
                                    initialData: [],
                                    child: Center(
                                      child: OptedOut(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );

                          mixpanel.track("View Opted Out Events");
                        },
                        child: Center(
                          child: Text(
                            "VIEW OPTED OUT EVENTS",
                            textAlign: TextAlign.center,
                            style: headLine.copyWith(color: grapevineWhite),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
