import 'package:flutter/material.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:grapevine_app/shared/functions.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CreatePrivateEvent extends StatefulWidget {
  @override
  State<CreatePrivateEvent> createState() => _CreatePrivateEventState();
}

class _CreatePrivateEventState extends State<CreatePrivateEvent> {
  final _formKey = GlobalKey<FormState>();

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

  // TO-DO
  // Set up form validators for circle creation to ensure db changes do not take place without safe additions/deletions
  // Required fields for all except members!! Are the main validators to check.

  String eventTitle;
  String eventDescription;
  String eventLocation;
  DateTime eventDate = DateTime.now();
  TimeOfDay eventTime = TimeOfDay.fromDateTime(DateTime.now());
  String invitedCircles = " "; // String must not be null.
  String error = "";
  String eventLink;
  bool posted = false;
  String eventType = "private";

  @override
  Widget build(BuildContext context) {
    // ensure this is always the my user data model when fetching user data from the collection.
    final user = Provider.of<MyUserData>(context);

    final DatabaseService db = DatabaseService(userID: user.userID);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(
          "ADD PRIVATE EVENT",
          style: title3.copyWith(color: grapevineBlack),
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
      body: SingleChildScrollView(
        // to avoid overflow
        child: Center(
          // center the container holding the form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container( // container holding the form and all buttons
                height: 620,
                width: 360,
                decoration:
                    grapevineBoxDecoration.copyWith(color: grapevineWhite),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Event Title Form Field
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 24,
                          left: 32,
                          right: 32,
                        ),
                        // Event Title Form Field
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          decoration: textInputDecoration.copyWith(
                              labelText: "Event Title", isDense: true),
                          validator: (val) =>
                              val.isEmpty ? "This field is required" : null,
                          onChanged: (val) {
                            setState(() {
                              eventTitle = val;
                            });
                          },
                        ),
                      ),
                      // Event Title Helper Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Align(
                          child: Text(
                            "Vault Tonight?, etc.",
                            style: subHead.copyWith(
                              color: grapevineGrey,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      SizedBox(height: 8), // Spacer

                      // Event Description Form Field & Helper Text

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          decoration: textInputDecoration.copyWith(
                            labelText: "Event Description",
                            isDense: true,
                          ),
                          validator: (val) =>
                              val.isEmpty ? "This field is required" : null,
                          onChanged: (val) {
                            setState(() {
                              eventDescription = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Align(
                          child: Text(
                            "Club night at KCL, etc.",
                            style: subHead.copyWith(color: grapevineGrey),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Date Time Fields
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          decoration: textInputDecoration.copyWith(
                              labelText: "Venue", isDense: true),
                          validator: (val) =>
                              val.isEmpty ? "This field is required" : null,
                          onChanged: (val) {
                            setState(() {
                              eventLocation = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Align(
                          child: Text(
                            "WC2B 4BG, Egg Nightclub, etc.",
                            style: subHead.copyWith(color: grapevineGrey),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 32,
                              ),
                              child: DateTimeField(
                                initialValue: DateTime.now(),
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Event Date", isDense: true),
                                format: DateFormat("dd/MM/yy"),
                                onShowPicker: (context, currentValue) async {
                                  var date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                  setState(() {
                                    if (date != null) {
                                      eventDate = date;
                                    }
                                  });
                                  return date;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 32),
                              child: DateTimeField(
                                initialValue: DateTime.now(),
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Event Time", isDense: true),
                                format: DateFormat("HH:mm"),
                                onShowPicker: (context, currentValue) async {
                                  var time = await showTimePicker(
                                      initialEntryMode:
                                          TimePickerEntryMode.input,
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          DateTime.now()),
                                      builder: (context, child) {
                                        return MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(
                                                    alwaysUse24HourFormat:
                                                        true),
                                            child: child);
                                      });
                                  setState(() {
                                    if (eventTime != null) {
                                      eventTime = time;
                                    }
                                  });

                                  return DateTimeField.convert(time);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Invite Circles Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: "Invite Circles",
                            isDense: true,
                          ),
                           validator: (val) =>
                              val.isEmpty ? "This field is required" : null,
                          onChanged: (val) {
                            setState(() {
                              invitedCircles = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Align(
                          child: Text(
                            "Eg: @KCL_finance, @LSE_French, etc.",
                            style: subHead.copyWith(color: grapevineGrey),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: "Event Link?",
                            isDense: true,
                          ),
                          onChanged: (val) {
                            setState(() {
                              eventLink = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      // Create button
                      Container(
                        height: 37,
                        width: 141,
                        decoration: grapevineBoxDecoration.copyWith(
                            color: grapevineGreen),
                        child: GestureDetector(
                          behavior: HitTestBehavior
                              .translucent, // ensures you can click anywhere on the button
                          onTap: () async {
                            var result =
                                await Connectivity().checkConnectivity();

                            if (result == ConnectivityResult.none) {
                              setState(() {
                                error = "No internet connection";
                              });
                              return;
                            }

                            if (_formKey.currentState.validate()) {
                              if (posted == false) {
                                setState(() {
                                  posted = true;
                                });

                                // make sure they havent posted this event twice!
                                // Make sure every field is not null.
                                // Get Date
                                DateTime selectedDate = DateTime(
                                    eventDate.year,
                                    eventDate.month,
                                    eventDate.day,
                                    eventTime.hour,
                                    eventTime.minute);
                                // retrieve invited Circles
                                List<String> circlesInvited =
                                    getCircles(invitedCircles)
                                        .map((s) => s.substring(1))
                                        .toList();

                                // Create event and retrieve event ID
                                String eventID = await db
                                    .createEvent(
                                        eventTitle,
                                        eventDescription,
                                        eventLocation,
                                        selectedDate,
                                        circlesInvited,
                                        eventLink,
                                        eventType)
                                    .then((value) => value.id);

                                // Opt user into event
                                await db.optIn(
                                    user.userName, user.userCircles, eventID);

                                // Invite every valid circle
                                await db.inviteCirclesToEvent(
                                    eventID, circlesInvited);

                                // Track event creation
                                mixpanel.track(
                                  'Event Created',
                                );

                                return Navigator.pop(context);
                              } else {
                                // They've already posted it they are just spamming the button!

                              }
                            }
                          },
                          child: Center(
                            child: Text(
                              "CREATE",
                              textAlign: TextAlign.center,
                              style: headLine.copyWith(color: grapevineWhite),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  error,
                  style: subHead,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
