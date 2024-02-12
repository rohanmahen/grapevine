import 'dart:collection';
import 'package:grapevine_app/models/event.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/models/circle.dart';

import 'constants.dart';

List<String> getMembers(String circleMembers) {
  return validInvite.allMatches(circleMembers).map((m) => m.group(0)).toList();
}

List<String> getCircles(String circlesInvited) {
  return validInvite.allMatches(circlesInvited).map((e) => e.group(0)).toList();
}

Circle circleFromSnapshot(String circleID, LinkedHashMap snapshot) {
  return Circle(
    circleID: circleID,
    circleTitle: snapshot["circleTitle"],
    circleDescription: snapshot["circleDescription"],
    circleMembers: snapshot["circleMembers"],
    connectedCircles: snapshot["connectedCircles"],
    circleFormation: snapshot["circleFormation"],
  );
}

String getInitials(String text) => text.isNotEmpty
    ? text
        .trim()
        .split(RegExp(' +'))
        .map((s) => s[0])
        .take(2)
        .join()
        .toUpperCase()
    : ' ';

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

double score(Event event, MyUserData user) {
  double score = 0;
  double boost = event.boost;
  double inviteScore = 0;
  double popularityScore = 0;
  double circlesOverlapScore = 0;
  // // Non Circle based scores
  
  
  popularityScore = (event.optedInUsers.keys.length) /
      (event.optedOutUsers.length + event.optedInUsers.keys.length);

  if (popularityScore.isNaN || popularityScore.isInfinite || popularityScore.isNegative) {
    popularityScore = 0;
  }

  // Circle based scores

  // Circle overlap score
  event.optedInUsers.removeWhere((key, value) => key == user.userName);
  if (event.optedInUsers.values.isNotEmpty) {
    if (user.userCircles.isNotEmpty) {
      circlesOverlapScore = (user.userCircles.toSet().intersection(
                event.optedInUsers.values.toList()[0].toSet(),
              )).length /
          (user.userCircles.length);
    }
  }

  // invite Score
  if (user.userCircles.isNotEmpty & event.invitedCircles.isNotEmpty) {
    inviteScore = (user.userCircles
            .toSet()
            .intersection(event.invitedCircles.toSet())
            .length) /
        (user.userCircles.length);
  }

  score =
      (inviteScore * 0.1 + popularityScore * 0.1 + circlesOverlapScore * 0.8)
          // invitedCirclesScore * 0.2) *
          *
          boost;

  // print("Event " + event.eventTitle + " has score " + score.toString());
  // print("Invite Score is " + inviteScore.toString());
  // print("Popularity Score is " + popularityScore.toString());
  // print("Circles Overlap Score is "+ circlesOverlapScore.toString());
  // print("//////");
  return score;
}
