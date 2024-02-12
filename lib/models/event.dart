import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventID;
  final String eventTitle;
  final String eventDescription;
  final String eventLocation;
  final DateTime eventDate;
  final Timestamp eventTime;
  final String eventLink;
  final String eventType;
  final List<dynamic> invitedCircles;
  final Map<dynamic, dynamic> optedInUsers;
  final List<dynamic> optedOutUsers;
  final double boost;

  Event({
    this.eventID,
    this.eventTitle,
    this.eventDescription,
    this.eventLocation,
    this.eventDate,
    this.eventTime,
    this.invitedCircles,
    this.eventLink,
    this.eventType,
    this.optedInUsers,
    this.optedOutUsers,
    this.boost,
  });
}
