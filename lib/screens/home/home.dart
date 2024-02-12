import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grapevine_app/models/event.dart';
import 'package:grapevine_app/screens/home/tabs/create/create_sheet.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'tabs/settings/settings_tab.dart';
import 'tabs/feed/feed_tab.dart';
import 'tabs/calendar/calendar_tab.dart';
import 'tabs/circles/circles_tab.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// notification save token to db
Future<void> saveTokenToDatabase(String token) async {
  // Assume user is logged in for this example
  String userId = FirebaseAuth.instance.currentUser.uid;

  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'userTokens': FieldValue.arrayUnion([token]),
  });
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> setupToken() async {
    // Get the token each time the application loads
    dynamic token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  // Subscribe to the universal topic
  Future<void> subscribeToUniversalTopic() async {
    // Subscribe to a the all topic
    await FirebaseMessaging.instance.subscribeToTopic('universal');
  }

  // Initialise index for tabs
  int _currentIndex = 0;

  // Very important notification set up
  @override
  void initState() {
    super.initState();
// Request Permissions for Notifications on iOS

    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
// set up token and send to db
    setupToken();
    // subscribe to universal topic
    subscribeToUniversalTopic();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    final db = DatabaseService(userID: user.userID);

    final tabNames = ["Feed", "My Upcoming Events", "", "Circles", "Profile"];
    // set up tabs list for displaying widgets !! ADD STREAM WRAPPERS AROUND SUITABLE WIDGETS
    final tabs = [
      // Feed Tab
      StreamProvider<MyUserData>.value(
        value: db.userDataStream,
        initialData: MyUserData(), // need to error fix this!!!
        child: StreamProvider<List<Event>>.value(
          value: db.eventStream,
          initialData: [],
          child: Center(
            child: FeedTab(),
          ),
        ),
      ),

      // Calendar Tab
      StreamProvider<MyUserData>.value(
        value: db.userDataStream,
        initialData: MyUserData(), // need to error fix this!!!
        child: StreamProvider<List<Event>>.value(
          value: db.eventStream,
          initialData: [],
          child: Center(
            child: CalendarTab(),
          ),
        ),
      ),

      // Create Sheet
      Container(),

      // Circles Tab
      StreamProvider<MyUserData>.value(
        value: db.userDataStream,
        initialData: MyUserData(), // need to error fix this!!!
        child: Center(
          child: CirclesTab(),
        ),
      ),

      // Settings Tab
      StreamProvider<MyUserData>.value(
        value: db.userDataStream,
        initialData: MyUserData(), // need to error fix this!!!
        child: StreamProvider<List<Event>>.value(
          value: db.eventStream,
          initialData: [],
          child: Center(
            child: SettingsTab(),
          ),
        ),
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                  onPressed: () {
                    // Add notifications navigator!
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: grapevinePurple,
                  )),
            ),
          ],
          centerTitle: false,
          title: Text(
            "${tabNames[_currentIndex]}",
            style: title2.copyWith(
              color: grapevineBlack,
            ),
          ),
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: grapevineWhite, // <-- SEE HERE
            statusBarIconBrightness:
                Brightness.dark, //<-- For Android SEE HERE (dark icons)
            statusBarBrightness:
                Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
          elevation: 0,
          iconTheme: IconThemeData(
            color: grapevinePurple, //change your color here
          ),
        ),
        resizeToAvoidBottomInset:
            false, // ensures keyboard doesn't push widgets
        extendBodyBehindAppBar:
            true, // ensures app bar isn't pushing widgets down
        extendBody: false, // extends the body to the top of the screen
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              grapevineShadow,
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0)),
            color: grapevineWhite,
          ),
          child: Theme(
            // implemented to avoid splash on icon selection
            data: ThemeData(
                // splashColor: Colors.white,
                // highlightColor: Colors.transparent,
                ),
            child: SingleChildScrollView(
              // this is implemented to avoid overflow errors on the navbar; very crappy fix
              physics: NeverScrollableScrollPhysics(), // ensures no scroll
              child: BottomNavigationBar(
                showSelectedLabels: true,
                showUnselectedLabels: true,
                unselectedLabelStyle:
                    body.copyWith(fontSize: 12, color: grapevineBlack),
                selectedLabelStyle:
                    body.copyWith(fontSize: 12, color: grapevineBlack),
                selectedItemColor: grapevineGreen,
                unselectedItemColor: grapevinePurple,
                items: [
                  BottomNavigationBarItem(
                    // For you page icon
                    icon: Icon(
                      Icons.home,
                    ),
                    label: "Feed",
                  ),
                  BottomNavigationBarItem(
                    // Calendar Page icon
                    icon: Icon(
                      Icons.calendar_month_outlined,
                    ),
                    // icon: calendarIcon,
                    label: "My Events",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_box_rounded,
                    ),
                    label: "Create",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.circle_outlined,
                    ),
                    label: "Circles",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                    ),
                    label: "Profile",
                  ),
                ],
                type: BottomNavigationBarType.fixed, //fixes navbar in place
                elevation: 0, // gets rid of shadow on navbar

                backgroundColor:
                    Colors.transparent, // lets container styling take over
                currentIndex: _currentIndex,
                onTap: (index) {
                  if (index == 2) {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return Wrap(children: [
                            StreamProvider<MyUserData>.value(
                              value: db.userDataStream,
                              initialData:
                                  MyUserData(), // need to error fix this!!!
                              child: StreamProvider<List<Event>>.value(
                                value: db.eventStream,
                                initialData: [],
                                child: Center(
                                  child: CreateSheet(),
                                ),
                              ),
                            ),
                          ]);
                        });
                    return;
                  }
                  // sets the current index as the clicked icon's index
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
        body: Container(
          decoration: inAppBackground,
          child: SafeArea(
            child: Center(
              // displays the correct widget given the index
              child: tabs[_currentIndex],
            ),
          ),
        ),
      ),
    );
  }
}
