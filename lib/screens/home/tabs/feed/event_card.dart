import 'package:flutter/material.dart';
import 'package:grapevine_app/models/event.dart';
import 'package:grapevine_app/screens/home/tabs/feed/copy_event_link.dart';
import 'package:grapevine_app/screens/home/tabs/feed/invite_circles_alert.dart';
import 'package:grapevine_app/screens/home/tabs/feed/whos_in.dart';
import 'package:grapevine_app/screens/home/tabs/feed/whos_in_private.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  // Pass in event as argument for displaying/ranking purposes.
  final Event event;
  final dynamic optedIn;
  EventCard({this.event, this.optedIn});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
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

    double deviceWidth = MediaQuery.of(context).size.width;

    DismissDirection direction = DismissDirection.horizontal;

    if (widget.optedIn == true) {
      direction = DismissDirection.endToStart;
    } else if (widget.optedIn == false) {
      direction = DismissDirection.startToEnd;
    } else {}

    _showWhosIn() {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Wrap(
              children: [
                StreamProvider<MyUserData>.value(
                  value: db.userDataStream,
                  initialData: MyUserData(), // need to error fix this!!!
                  child: Center(
                    child: WhosIn(
                      event: widget.event,
                    ),
                  ),
                ),
              ],
            );
          });
    }

    _showWhosInPrivate() {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Wrap(
              children: [
                StreamProvider<MyUserData>.value(
                  value: db.userDataStream,
                  initialData: MyUserData(), // need to error fix this!!!
                  child: Center(
                    child: WhosInPrivate(
                      event: widget.event,
                    ),
                  ),
                ),
              ],
            );
          });
    }

    return Dismissible(
      key: Key(widget.event.eventID),
      direction: direction,
      background: Container(
        color: grapevineGreen,
        child: Center(
          child: Text(
            "Opt In".toUpperCase(),
            style: title1.copyWith(color: grapevineWhite),
          ),
        ),
      ),
      secondaryBackground: Container(
        color: grapevinePurple,
        child: Center(
          child: Text(
            "Opt Out".toUpperCase(),
            style: title1.copyWith(color: grapevineWhite),
          ),
        ),
      ),
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Then they have opted in already
          await db.optOut(user.userName, widget.event.eventID);
          // Track an opt out
          mixpanel.track(
            "Opt Out",
          );
        } else if (direction == DismissDirection.startToEnd) {
          if (widget.event.eventLink != null) {
            if (widget.event.eventLink.isNotEmpty) {
              await showDialog(
                context: context,
                builder: (context) => CopyEventLink(
                  event: widget.event,
                ),
              );
            }
          }
          // Then they have opted out already so

          if (widget.event.eventType != "private") {
            // only let an invite circle happen if the event is not private!
            await showDialog(
              context: context,
              builder: (context) => StreamProvider<MyUserData>.value(
                value: db.userDataStream,
                initialData: MyUserData(), // need to error fix this!!!
                child: InviteCirclesAlert(
                  event: widget.event,
                ),
              ),
            );
          }

          await db.optIn(
            user.userName,
            user.userCircles,
            widget.event.eventID,
          );

          mixpanel.track(
            "Opt In",
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: BoxConstraints(minHeight: 120),
          width: deviceWidth - 16,
          decoration: grapevineBoxDecoration.copyWith(
            color: grapevineWhite,
          ),
          child: Row(
            children: [
              Container(
                width: deviceWidth - 155,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.eventTitle,
                        style: title3.copyWith(fontSize: 18),
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy – HH:mm')
                                .format(widget.event.eventDate) +
                            " @ " +
                            widget.event.eventLocation,
                        style: subHead,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          widget.event.eventDescription,
                          style: body.copyWith(color: grapevineBlack),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  // ADD WHO'S IN BOTTOM SHEET!
                  onTap: () {
                    if (widget.event.eventType == "private") {
                      // show private whos in
                      mixpanel.track("Whos In Check");
                      _showWhosInPrivate();
                      // Check Who's IN w a bottom sheet!
                    } else {
                      mixpanel.track("Whos In Check");
                      _showWhosIn();
                    }
                  },
                  child: Container(
                    child: whosIn,
                    height: 80,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
