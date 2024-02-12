import 'package:flutter/material.dart';
import 'package:grapevine_app/screens/home/tabs/feed/private_events_feed.dart';
import 'package:grapevine_app/screens/home/tabs/feed/public_events_feed.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/models/event.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/shared/functions.dart';
import 'package:grapevine_app/shared/constants.dart';

class FeedTab extends StatefulWidget {
  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  int index = 0; // tab view index tracker

  @override
  Widget build(BuildContext context) {
    final MyUserData user = Provider.of<MyUserData>(context);
    final DatabaseService db = DatabaseService(userID: user.userID);
    var events = Provider.of<List<Event>>(context);
    Set<dynamic> userOptedInEvents = user.optedInEvents.toSet() ?? {};
    Set<dynamic> userOptedOutEvents = user.optedOutEvents.toSet() ?? {};

    Map<Event, dynamic> scoredEvents = {};

    if (events.isNotEmpty && user != null) {
      for (Event event in events) {
        var eventScore = score(event, user);
        scoredEvents[event] = eventScore;
      }
    }

    final List<Event> rankedEvents = scoredEvents.keys.toList()
      ..sort((a, b) => scoredEvents[b].compareTo(scoredEvents[a]));

    if (index == 0) {
      // Show Public Event Feed
      return Container(
        child: Column(
          children: [
            Padding(
              // THIS PADDED ROW IS JUST THE TAB OPTIONS NEEDS WORK!
              padding: const EdgeInsets.only(left: 16.0, bottom: 4),
              child: Row(
                children: [
                  Container(
                    decoration:
                        grapevineBoxDecoration.copyWith(color: grapevineGreen),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Public",
                            textAlign: TextAlign.center,
                            style: body.copyWith(
                                color: grapevineWhite,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      decoration: grapevineBoxDecoration.copyWith(
                          color: grapevinePurple.withOpacity(0.2)),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Private",
                              textAlign: TextAlign.center,
                              style: body.copyWith(
                                  color: grapevineWhite,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Public Feed View
            Expanded(
              child: StreamProvider<MyUserData>.value(
                value: db.userDataStream,
                initialData: MyUserData(), // need to error fix this!!!
                child: PublicEventFeed(
                  userOptedInEvents: userOptedInEvents,
                  userOptedOutEvents: userOptedOutEvents,
                  rankedEvents: rankedEvents,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Show private feed
      return Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4),
              child: Row(
                children: [
                  Container(
                    decoration: grapevineBoxDecoration.copyWith(
                      color: grapevineGreen.withOpacity(0.5),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Public",
                            textAlign: TextAlign.center,
                            style:  body.copyWith(color: grapevineWhite, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      decoration: grapevineBoxDecoration.copyWith(
                          color: grapevinePurple),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Private",
                              textAlign: TextAlign.center,
                              style:  body.copyWith(color: grapevineWhite, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Feed View
            Expanded(
              child: StreamProvider<MyUserData>.value(
                value: db.userDataStream,
                initialData: MyUserData(), // need to error fix this!!!
                child: PrivateEventFeed(
                  userOptedInEvents: userOptedInEvents,
                  userOptedOutEvents: userOptedOutEvents,
                  rankedEvents: rankedEvents,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
