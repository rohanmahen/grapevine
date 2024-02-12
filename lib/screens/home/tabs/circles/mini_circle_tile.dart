import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/models/circle.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/shared/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:grapevine_app/services/messaging.dart';

class MiniCircleTile extends StatefulWidget {
  final String circleID;

  MiniCircleTile({this.circleID});

  @override
  State<MiniCircleTile> createState() => _MiniCircleTileState();
}

class _MiniCircleTileState extends State<MiniCircleTile> {
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
    final fcm = MessagingService();

    return FutureBuilder<DocumentSnapshot>(
        future: db.circleCollection.doc(widget.circleID).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Circle circle = circleFromSnapshot(widget.circleID, snapshot.data.data());

            return Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    boxShadow: [
                      grapevineShadow,
                    ],
                    shape: BoxShape.circle,
                    color: grapevineGreen,
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                              "Would you like to join ${circle.circleTitle}?"),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  await db.addCircleToUser(
                                    // If they accept add the circle to the user!
                                    user.userID,
                                    circle.circleID,
                                  );

                                  await db.addUserToCircle(
                                    // Add the user to the circle now that they have accepted the request
                                    user.userName,
                                    circle.circleID,
                                  );
                                  await db.removePotentialCircle(
                                    // Remove it from the potential circle
                                    user.userID, circle.circleID,
                                  );
                                  mixpanel.track(
                                    "Join Circle",
                                  );

                                  await fcm.subscribeToCircle(circle.circleID);

                                  Navigator.pop(context);
                                },
                                child: Text("Yes")),
                            TextButton(
                                onPressed: () async {
                                  await db.removePotentialCircle(
                                      user.userID, circle.circleID);
                                  Navigator.pop(context);
                                },
                                child: Text("No"))
                          ],
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        getInitials(circle.circleTitle),
                        style: title2.copyWith(color: grapevineWhite),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 1.0,
                    ),
                    child: Text(
                      truncateWithEllipsis(
                          12, "@" + circle.circleTitle.toUpperCase()),
                      style: caption2.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
