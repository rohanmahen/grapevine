import 'package:flutter/material.dart';
import 'package:grapevine_app/models/event.dart';
import 'package:flutter/services.dart';
import 'package:grapevine_app/shared/constants.dart';

class CopyEventLink extends StatelessWidget {
  final Event event;
  CopyEventLink({this.event});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Event Link: \n\n${event.eventLink} \n\nWould you like to copy this link?",
      ),
      actions: [
        TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(
              "No",
              style: title2,
            )),
        TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: event.eventLink));

              Navigator.pop(context);
            },
            child: Text(
              "Yes",
              style: title2,
            )),
      ],
    );
  }
}
