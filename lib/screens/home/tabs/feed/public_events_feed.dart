import 'package:flutter/material.dart';
import 'package:grapevine_app/models/event.dart';
// import 'package:grapevine_app/models/user.dart';
// import 'package:provider/provider.dart';
import 'event_card.dart';

class PublicEventFeed extends StatelessWidget {
  final Set<dynamic> userOptedInEvents;
  final Set<dynamic> userOptedOutEvents;
  final List<Event> rankedEvents;

  PublicEventFeed(
      {this.userOptedInEvents, this.userOptedOutEvents, this.rankedEvents});

  @override
  Widget build(BuildContext context) {
    // final MyUserData user = Provider.of<MyUserData>(context);

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
                  // cannot be private

                  // must not be opted in

                  // must not be opted out

                  if (rankedEvents[index].eventType == "private") {
                    // event is private
                    return Container();
                  } else if (userOptedInEvents
                      .contains(rankedEvents[index].eventID)) {
                    return Container(); // you are opted in
                  } else if (userOptedOutEvents
                      .contains(rankedEvents[index].eventID)) {
                    // you are opted out
                    return Container();
                  } else { // event is not private, you arent in or out show show it!
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
