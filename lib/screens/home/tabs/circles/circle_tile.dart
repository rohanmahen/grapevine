import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/shared/functions.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:grapevine_app/models/circle.dart';
import 'circle_detail.dart';

class CircleTile extends StatefulWidget {
  final String circleID;

  CircleTile({this.circleID});

  @override
  _CircleTileState createState() => _CircleTileState();
}

class _CircleTileState extends State<CircleTile> {
  @override
  Widget build(BuildContext context) {
    final MyUserData user = Provider.of<MyUserData>(context);
    final db = DatabaseService(userID: user.userID);

    return FutureBuilder<DocumentSnapshot>(
        future: db.circleCollection.doc(widget.circleID).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Circle circle = circleFromSnapshot(widget.circleID, snapshot.data.data());

            return Column(
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
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StreamProvider<MyUserData>.value(
                            value: db.userDataStream,
                            initialData: MyUserData(),
                            child: Center(
                              child: CircleDetail(
                                circleID: widget.circleID,
                              ),
                            ),
                          ),
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
                      style: caption1.copyWith(
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
