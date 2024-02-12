import 'package:flutter/material.dart';
import 'package:grapevine_app/models/event.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:provider/provider.dart';
import 'event_card.dart';

class PrivateEventFeed extends StatelessWidget {
  final Set<dynamic> userOptedInEvents;
  final Set<dynamic> userOptedOutEvents;
  final List<Event> rankedEvents;

  PrivateEventFeed(
      {this.userOptedInEvents, this.userOptedOutEvents, this.rankedEvents});

  @override
  Widget build(BuildContext context) {
    final MyUserData user = Provider.of<MyUserData>(context);

    return Container(
      child: Column(
        children: [
          // Add card view builder
          Expanded(
            child: Container(
              child: ListView.builder(
                padding:
                    EdgeInsets.only(bottom: 150), // Eliminate starting padding
                shrinkWrap: true,
                itemCount: rankedEvents.length,
                itemBuilder: (context, index) {
                  if (rankedEvents[index].eventType != "private") {
                    return Container(); // the event is public
                  } else if (userOptedOutEvents
                      .contains(rankedEvents[index].eventID)) {
                    return Container(); // you are already opted out
                  } else if (userOptedInEvents
                      .contains(rankedEvents[index].eventID)) {
                    return Container(); // you are already opted in
                  } else if (user.userCircles
                      .toSet()
                      .intersection(
                        rankedEvents[index].invitedCircles.toSet(),
                      )
                      .isEmpty) {
                    return Container(); // you are not invited to the event
                  } else { // you havent seen it (opted in or out), its private, and you are invited! so display it!
                    return EventCard(
                      event: rankedEvents[index],
                      optedIn: null,
                    );
                  }
                  
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
