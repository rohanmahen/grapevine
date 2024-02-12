import 'package:flutter/material.dart';
import 'package:grapevine_app/models/event.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/screens/home/tabs/feed/whos_in_tile.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:provider/provider.dart';

class WhosIn extends StatefulWidget {
  final Event event;

  WhosIn({this.event});

  @override
  _WhosInState createState() => _WhosInState();
}

class _WhosInState extends State<WhosIn> {
  @override
  Widget build(BuildContext context) {
    final MyUserData user = Provider.of<MyUserData>(context);

    // Filter all the circles going that are also circles of the users

    Set userCircles = Set();

    if (user.userCircles != null) {
      userCircles = user.userCircles.toSet();
    }

    Set<dynamic> optedInCircles = {};
    List<dynamic> yourCircles = [];
    List<dynamic> otherCircles = [];

    if (widget.event.optedInUsers.values.isNotEmpty) {
      widget.event.optedInUsers.removeWhere((key, value) =>
          key == user.userName); // Remove the user from these events

      if (widget.event.optedInUsers.values.toList().isNotEmpty) {
        // Check empty

        optedInCircles = widget.event.optedInUsers.values.toList()[0].toSet();
        // Get opted In circles

        yourCircles = // All the circles you are a part of
            userCircles.intersection(optedInCircles).toList();

        otherCircles = // All the circles you are not a part of
            optedInCircles.difference(userCircles).toList();
      }
    }

    double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: deviceHeight * 0.7),
      decoration: grapevineBoxDecoration.copyWith(
        color: grapevineWhite,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your Circles Going",
                  style: title2,
                ),
              ), // ADD STREAM BUILDER
               ListView.builder(
                    padding: EdgeInsets.only(bottom: 25),
                    shrinkWrap: true,
                    itemCount: yourCircles.length,
                    itemBuilder: (context, index) {
                      if (yourCircles.isNotEmpty) {
                        return WhosInTile(
                          display: yourCircles[index],
                        );
                      } else {
                        return Container();
                      }
                    }),
            
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Other Circles Going",
                  style: title2,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 125),
                    shrinkWrap: true,
                    itemCount: otherCircles.length,
                    itemBuilder: (context, index) {
                      if (otherCircles.isNotEmpty) {
                        return WhosInTile(
                          display: otherCircles[index],
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
