import 'package:flutter/material.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/screens/home/tabs/feed/event_card.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/models/event.dart';

class CalendarTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyUserData user = Provider.of<MyUserData>(context);
    // final DatabaseService db = DatabaseService(userID: user.userID);
    var events = Provider.of<List<Event>>(context);
    Set<dynamic> userOptedInEvents = user.optedInEvents.toSet();
    

    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                padding:
                    EdgeInsets.only(bottom: 150), // Eliminate starting padding
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  if (userOptedInEvents.contains(events[index].eventID)) {
                    // Pruning event tiles for Opted In Events
                    return EventCard(
                      event: events[index],
                      optedIn: true,
                    );
                  } else {
                    return Container();
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
