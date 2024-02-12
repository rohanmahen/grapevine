import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grapevine_app/shared/circle_card.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:grapevine_app/shared/functions.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/shared/gv_divider.dart';
import 'package:grapevine_app/shared/loading.dart';
import 'package:grapevine_app/shared/user_tile.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/models/circle.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:flutter/services.dart';

class CircleDetail extends StatefulWidget {
  final String circleID;

  CircleDetail({this.circleID});

  @override
  State<CircleDetail> createState() => _CircleDetailState();
}

class _CircleDetailState extends State<CircleDetail> {
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
    final MyUserData user = Provider.of<MyUserData>(context);
    final db = DatabaseService(userID: user.userID);
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    List<dynamic> newMembers;
    List<dynamic> newCircles;

    return Scaffold(
      resizeToAvoidBottomInset: false, // ensures keyboard doesn't push widgets
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
      extendBody: true,
      body: Container(
        decoration: inAppBackground,
        child: StreamBuilder<DocumentSnapshot>(
            stream: db.circleCollection
                .doc(widget.circleID)
                .snapshots(), // Listen for circle changes in stream form not future form
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Circle circle =
                    circleFromSnapshot(widget.circleID, snapshot.data.data());
                List<dynamic> members = circle.circleMembers;
                List<dynamic> connectedCircles = circle.connectedCircles;

                return SingleChildScrollView(
                  child: Container(
                    height: deviceHeight + 200,
                    decoration: inAppBackground,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 64.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 104,
                            width: 104,
                            decoration: BoxDecoration(
                              boxShadow: [
                                grapevineShadow,
                              ],
                              // border: Border.all(color: Colors.red), // remove
                              shape: BoxShape.circle,
                              color: grapevineGreen,
                            ),
                            child: Center(
                              child: Text(
                                getInitials(circle.circleTitle),
                                style: title2.copyWith(color: grapevineWhite),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: grapevineBoxDecoration.copyWith(
                                color: grapevineWhite),
                            height: 88,
                            width: 350,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "@" + circle.circleTitle,
                                    style: title2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 24),
                                    child: Text(
                                      circle.circleDescription,
                                      style: subHead.copyWith(
                                          color: grapevineGrey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Members".toUpperCase(),
                            style: title2,
                          ),
                          Container(
                            constraints:
                                BoxConstraints(minHeight: 58, maxHeight: 180),
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              removeBottom: true,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: members.length,
                                  itemBuilder: (context, index) {
                                    return ThinTile(
                                      display: "@" + members[index],
                                    );
                                  }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
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
                                          "Who would you like to invite to ${circle.circleTitle}!"),
                                      content: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            newMembers = getMembers(value)
                                                .map((s) => s.substring(1))
                                                .map((s) => s.toLowerCase())
                                                .toList();
                                          });
                                        },
                                        decoration: InputDecoration(
                                            hintText: "@johndoe, @janedoe"),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            for (var i = 0;
                                                i < newMembers.length;
                                                i++) {
                                              if (newMembers[i] !=
                                                  user.userName) {
                                                // Make sure they don't add their own name to the potential circles list
                                                if (await db.usernameExists(
                                                    newMembers[i])) {
                                                  // Check if username exists
                                                  var userID =
                                                      await db // If they exist get their userID
                                                          .usernameCollection
                                                          .doc(newMembers[i])
                                                          .get()
                                                          .then((snapshot) =>
                                                              snapshot
                                                                  .get("id"));

                                                  await db.addCircleToPotentialCircles(
                                                      // Add the circle to their user's potential circles
                                                      userID,
                                                      circle.circleID);
                                                } else {
                                                  print(
                                                      "username doesnt exist");
                                                }
                                              }
                                            }

                                            Navigator.pop(context);
                                          },
                                          child: Text("invite".toUpperCase()),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    "INVITE MEMBER(S)",
                                    textAlign: TextAlign.center,
                                    style: headLine.copyWith(
                                        color: grapevineWhite),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GvDivider(),
                          Text(
                            "Following Circles".toUpperCase(),
                            style: title2,
                          ),
                          Container(
                            constraints:
                                BoxConstraints(minHeight: 0, maxHeight: 180),
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              removeBottom: true,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: connectedCircles.length,
                                  itemBuilder: (context, index) {
                                    return CircleCard(
                                      circleTitle: connectedCircles[index],
                                    );
                                  }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
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
                                          "Which circle(s) would you like to follow?"),
                                      content: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            newCircles = getCircles(value)
                                                .map((s) => s.substring(1))
                                                .toList();
                                          });
                                        },
                                        decoration: InputDecoration(
                                            hintText:
                                                "@grapevine, @KCL_Finance"),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            for (var i = 0;
                                                i < newCircles.length;
                                                i++) {
                                              if (newCircles[i] !=
                                                  circle.circleTitle) {
                                                // check that they don't add their own circle to followed circles
                                                if (await db.circleExists(
                                                    newCircles[i])) {
                                                  await db.followCircle(
                                                    newCircles[i],
                                                    circle.circleID,
                                                  );
                                                  mixpanel.track(
                                                    "Follow Circle",
                                                  );
                                                } else {
                                                  print(
                                                      "circleName doesnt exist");
                                                }
                                              }
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Text("Follow".toUpperCase()),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    "FOLLOW CIRCLE(S)",
                                    textAlign: TextAlign.center,
                                    style: headLine.copyWith(
                                        color: grapevineWhite),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GvDivider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
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
                                          "Would you like to leave ${circle.circleTitle}?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              await db.removeMemberFromCircle(
                                                  circle.circleID,
                                                  user.userName);
                                              await db.removeUserCircle(
                                                  user.userID, circle.circleID);

                                              Navigator.pop(context);
                                            },
                                            child: Text("Yes")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("No"))
                                      ],
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    "LEAVE CIRCLE",
                                    textAlign: TextAlign.center,
                                    style: headLine.copyWith(
                                        color: grapevineWhite),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Loading();
              }
            }),
      ),
    );
  }
}
