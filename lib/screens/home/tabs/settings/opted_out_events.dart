import 'package:flutter/material.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/screens/home/tabs/feed/event_card.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/models/event.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:flutter/services.dart';

class OptedOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyUserData user = Provider.of<MyUserData>(context);

    var events = Provider.of<List<Event>>(context);

    Set<dynamic> userOptedOutEvents = {};

    if (user.optedOutEvents != null) {
      userOptedOutEvents = user.optedOutEvents.toSet();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false, // ensures keyboard doesn't push widgets
      appBar: AppBar(
        title: Text(
          "Opted out Events".toUpperCase(),
          style: title2.copyWith(color: grapevineBlack),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: grapevineWhite, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: grapevinePurple, //change your color here
        ),
      ),
      extendBodyBehindAppBar: false,
      extendBody: true,
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: 150), // Eliminate starting padding
                  shrinkWrap: true,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    if (userOptedOutEvents.contains(events[index].eventID)) {
                      // Pruning event tiles for Opted In Events
                      return EventCard(
                        event: events[index],
                        optedIn: false,
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
      ),
    );
  }
}
