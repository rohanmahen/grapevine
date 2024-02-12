import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/models/event.dart';

class DatabaseService {
  final String userID;

  DatabaseService({this.userID});

  // Collection References
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference circleCollection =
      FirebaseFirestore.instance.collection("circles");

  final CollectionReference usernameCollection =
      FirebaseFirestore.instance.collection("usernames");

  // Set collection data when a user registers or when they
  Future updateUserData(String userName, String userEmail, String userFullName,
      DateTime userBirthday, String userSex) async {
    return await userCollection.doc(userID).set({
      "userName": userName,
      "userFullName": userFullName,
      "userEmail": userEmail,
      "userBirthday": userBirthday,
      "userSex": userSex,
      "userCircles": [],
      "userOptedInEvents": [],
      "potentialCircles": [],
      "userOptedOutEvents": [],
      "userTokens": [],
    });
  }

  Future createUsernameDocument(String username) async {
    return await usernameCollection.doc(username).set({
      "id": userID,
    });
  }

  Future<bool> usernameExists(String username) async {
    var userName = await usernameCollection.doc(username).get();
    if (userName.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future circleExists(String circleTitle) async {
    try {
      var circleName = await circleCollection.doc(circleTitle).get();
      if (circleName.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // create Circle functionality
  Future createCircle(String circleTitle, String circleDescription,
      List<String> circleMembers, String circleFormation) async {
    Map<String, dynamic> data = {
      "connectedCircles": [],
      "circleTitle": circleTitle,
      "circleDescription": circleDescription,
      "circleMembers": circleMembers,
      "circleFormation": circleFormation,
    };

//  return await circleCollection.add(data); was the old return statement this should change it up.
    return await circleCollection.doc(circleTitle).set(data);
  }

  // add user to circle
  Future addUserToCircle(String userName, String circleID) async {
    return await circleCollection.doc(circleID).update({
      "circleMembers": FieldValue.arrayUnion([
        userName,
      ])
    });
  }

  // add circle to confirmed circles list for user
  Future addCircleToUser(String userID, String circleId) async {
    return await userCollection.doc(userID).update({
      "userCircles": FieldValue.arrayUnion([
        circleId,
      ])
    });
  }

  // add circle to potential circles list for user
  Future addCircleToPotentialCircles(String userID, String circleID) async {
    return await userCollection.doc(userID).update({
      "potentialCircles": FieldValue.arrayUnion([
        circleID,
      ])
    });
  }

  MyUserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return MyUserData(
      userID: userID,
      userEmail: data["userEmail"],
      userName: data["userName"],
      userFullName: data["userFullName"],
      userBirthday: data.toString().contains('userBirthday')
          ? data["userBirthday"].toDate()
          : DateTime(2001, 1, 1),
      userSex: data.toString().contains('userSex') ? data["userSex"] : "Other",
      userCircles: data["userCircles"],
      optedInEvents: data["userOptedInEvents"],
      optedOutEvents: data["userOptedOutEvents"],
      potentialCircles: data["potentialCircles"],
      userTokens:
          data.toString().contains('userTokens') ? data["userTokens"] : [],
    );
  }

  // Stream for user data document snapshot
  Stream<MyUserData> get userDataStream {
    return userCollection.doc(userID).snapshots().map(userDataFromSnapshot);
  }

  // Future document snapshot of circle given circleID
  Future<DocumentSnapshot> getCircleData(String circleID) async {
    return await circleCollection.doc(circleID).get();
  }

  // Future doucment snapshot of user given userId
  Future<DocumentSnapshot> getUserData(String userID) async {
    return await userCollection.doc(userID).get();
  }

  // Future that declines circle invitation given circleID and userID
  Future removePotentialCircle(String userID, String circleID) async {
    return await userCollection.doc(userID).update({
      "potentialCircles": FieldValue.arrayRemove(
        [
          circleID,
        ],
      )
    });
  }

// Follow Circle within a circle
  Future followCircle(String circleTitle, String circleID) async {
    return await circleCollection.doc(circleID).update({
      "connectedCircles": FieldValue.arrayUnion(
        [
          circleTitle,
        ],
      )
    });
  }

// remove member from circle
  Future removeMemberFromCircle(String circleID, String username) async {
    return await circleCollection.doc(circleID).update({
      "circleMembers": FieldValue.arrayRemove(
        [
          username,
        ],
      ),
    });
  }

// add event to user opted in events
  Future addEventToOptedInEvents(String eventID, String userID) async {
    return await userCollection.doc(userID).update({
      "userOptedInEvents": FieldValue.arrayUnion(
        [
          eventID,
        ],
      ),
    });
  }

// Add event to user opted out events
  Future addEventToOptedOutEvents(String eventID, String userID) async {
    return await userCollection.doc(userID).update({
      "userOptedOutEvents": FieldValue.arrayUnion(
        [
          eventID,
        ],
      ),
    });
  }

  // Create event
  Future createEvent(
    String eventTitle,
    String eventDescription,
    String eventLocation,
    DateTime eventDate,
    List<dynamic> invitedCircles,
    String eventLink,
    String eventType,
  ) async {
    Map<String, dynamic> data = {
      "eventTitle": eventTitle,
      "eventDescription": eventDescription,
      "eventLocation": eventLocation,
      "eventDate": eventDate,
      "invitedCircles": invitedCircles,
      "eventLink": eventLink,
      "eventType": eventType,
      "optedInUsers": {},
      "optedOutUsers": [],
      "boost": 1.0,
    };

    return await eventCollection.add(data);
  }

  // Get event list from query snapshot (use w/ stream below)
  List<Event> eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map(
          (doc) => Event(
            eventID: doc.id,
            eventTitle: doc["eventTitle"],
            eventLocation: doc["eventLocation"],
            eventDate: doc["eventDate"].toDate(),
            eventDescription: doc["eventDescription"],
            eventLink: doc.data().toString().contains('eventLink')
                ? doc.get('eventLink')
                : '',
            eventType: doc.data().toString().contains('eventType')
                ? doc.get('eventType')
                : '',
            boost: doc["boost"],
            eventTime: doc["eventDate"], // CHANGE THIS,
            optedInUsers: doc["optedInUsers"],
            optedOutUsers: doc["optedOutUsers"],
            invitedCircles: doc["invitedCircles"],
          ),
        )
        .toList();
  }

  // Event stream for feed
  Stream<List<Event>> get eventStream {
    return eventCollection
        // Filtering for upcoming events
        .where(
          "eventDate",
          isGreaterThanOrEqualTo: Timestamp.fromDate(
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
          ),
        )
        .snapshots()
        .map(
          eventListFromSnapshot,
        );
  }

// Opt in to an event
  Future optIn(
      String userName, List<dynamic> userCircles, String eventID) async {
    // optIn needs to do 4 things,

    // first it should push the username and
    // all associated userCircles into the event's optedInUsers dictionary
    await eventCollection.doc(eventID).set(
        {
          "optedInUsers": {
            userName: userCircles,
          },
        },
        SetOptions(
          merge: true,
        ));

    // Then it should add the eventID to the list of userOptedInEvents
    await addEventToOptedInEvents(eventID, userID);

    // It should also remove the event from the optedOutEvents if they are there.
    await removeEventfromOptedOutEvents(eventID, userID);

    // Then it should remove the user from the optedOutUsers for the event if they are there.
    await eventCollection.doc(eventID).update(
      {
        "optedOutUsers": FieldValue.arrayRemove([
          userName,
        ])
      },
    );
  }

// Opt out functionality
  Future optOut(String userName, String eventID) async {
    // The opt out functionality should do 4 things
    // First it should push only the username to the event's optedOutUsers set
    await eventCollection.doc((eventID)).update(
      {
        "optedOutUsers": FieldValue.arrayUnion(
          [
            userName,
          ],
        )
      },
    );
    // Next the opt out functionality should add the event ID to the user's optedOutEvents
    await addEventToOptedOutEvents(eventID, userID);

    // The opt out function should then also remove the event from the user optedInEvents
    await removeEventfromOptedInEvents(eventID, userID);

    // The opt out function should also remove the user from the optedInUsers in event if they opted in then out.

    /// WEIRD SOLUTION; YOU NEED SET NOT UPDATE BECAUSE FIREBASE BUG!!!!
    await eventCollection.doc(eventID).set(
      {
        "optedInUsers": {
          userName: FieldValue.delete(),
        },
      },
      SetOptions(merge: true),
    );
  }

// remove event to user opted in events
  Future removeEventfromOptedInEvents(String eventID, String userID) async {
    return await userCollection.doc(userID).update({
      "userOptedInEvents": FieldValue.arrayRemove(
        [
          eventID,
        ],
      ),
    });
  }

// remove event to user opted out events
  Future removeEventfromOptedOutEvents(String eventID, String userID) async {
    return await userCollection.doc(userID).update({
      "userOptedOutEvents": FieldValue.arrayRemove(
        [
          eventID,
        ],
      ),
    });
  }

// Invite circles to an event
  Future inviteCirclesToEvent(
      String eventID, List<dynamic> invitedCircles) async {
    await eventCollection.doc(eventID).set(
      {
        "invitedCircles": FieldValue.arrayUnion(
          invitedCircles,
        )
      },
      SetOptions(merge: true),
    );
  }

// Remove user circle (for leaving a circle)
  Future removeUserCircle(String userID, String circleID) async {
    return await userCollection.doc(userID).update({
      "userCircles": FieldValue.arrayRemove(
        [
          circleID,
        ],
      )
    });
  }
}
