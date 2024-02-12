import 'package:flutter/material.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/models/circle.dart';
import 'package:grapevine_app/shared/functions.dart';
import 'package:grapevine_app/shared/user_tile.dart';

class WhosInTile extends StatelessWidget {
  final String display; // Works as a proxy for the circleID

  WhosInTile({this.display});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    DatabaseService db = DatabaseService();

    return StreamBuilder(
        stream: db.circleCollection.doc(display).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Circle circle = circleFromSnapshot(display, snapshot.data.data());
            return Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 16,
                right: 16,
              ),
              child: Container(
                  decoration: grapevineBoxDecoration.copyWith(
                      color: grapevineWhite,
                      border: Border.all(color: grapevineGreen.withAlpha(122))),
                  width: deviceWidth - 32,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        "@" + circle.circleTitle,
                        style: headLine.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            );
          } else {
            return ThinTile(
              display: "",
            );
          }
        });
  }
}
