import 'package:flutter/material.dart';
import 'package:grapevine_app/models/event.dart';
import 'package:grapevine_app/screens/home/tabs/feed/whos_in_tile.dart';
import 'package:grapevine_app/screens/home/tabs/feed/whos_in_tile_private.dart';
import 'package:grapevine_app/shared/constants.dart';

class WhosInPrivate extends StatefulWidget {
  final Event event;

  WhosInPrivate({this.event});

  @override
  _WhosInPrivateState createState() => _WhosInPrivateState();
}

class _WhosInPrivateState extends State<WhosInPrivate> {
  @override
  Widget build(BuildContext context) {

    List invitedCircles = widget.event.invitedCircles.toList();
    List optedInUsers = widget.event.optedInUsers.keys.toList();


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
                  "Circles Invited",
                  style: title2,
                ),
              ), // ADD STREAM BUILDER
               ListView.builder(
                    padding: EdgeInsets.only(bottom: 25),
                    shrinkWrap: true,
                    itemCount: invitedCircles.length,
                    itemBuilder: (context, index) {
                      if (invitedCircles.isNotEmpty) {
                        return WhosInTile(
                        display: invitedCircles[index],
                        );
                      } else {
                        return Container();
                      }
                    }),
            
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "People Going",
                  style: title2,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 125),
                    shrinkWrap: true,
                    itemCount: optedInUsers.length,
                    itemBuilder: (context, index) {
                      if (optedInUsers.isNotEmpty) {
                        return WhosInTilePrivate(
                          display: optedInUsers[index],
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
