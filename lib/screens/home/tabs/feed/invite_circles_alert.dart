import 'package:flutter/material.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/shared/functions.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/models/event.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class InviteCirclesAlert extends StatefulWidget {
  final Event event;
  InviteCirclesAlert({this.event});

  @override
  State<InviteCirclesAlert> createState() => _InviteCirclesAlertState();
}

class _InviteCirclesAlertState extends State<InviteCirclesAlert> {
  List<dynamic> invitedCircles = [];
  List<dynamic> pushedCircles;

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
    final DatabaseService db = DatabaseService(userID: user.userID);

    return AlertDialog(
      title: Text("Do you wanna invite any circle(s) to this event?"),
      content: TextField(
        onChanged: (value) {
          setState(() {
            invitedCircles = getCircles(value)
                .map((s) => s.substring(1).toLowerCase())
                .toList();
          });
        },
        decoration: InputDecoration(hintText: "@grapevine, @KCL_Finance"),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // Filter the circle list.
            await db.inviteCirclesToEvent(widget.event.eventID, invitedCircles);
            mixpanel.track(
              "Invited Circles",
            );
            Navigator.pop(context);
          },
          child: Text("Invite".toUpperCase()),
        ),
      ],
    );
  }
}
