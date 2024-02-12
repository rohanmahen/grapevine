class MyUser {
  final String userID;
  final String userEmail;
  final String userName;
  final String userFullName;
  final DateTime userBirthday;
  final String userSex;
  final List<dynamic> userCircles; // list of circle IDs
  final List<dynamic> optedInEvents;
  final List<dynamic> potentialCircles;
  final List<dynamic> userTokens;

  MyUser(
      {this.userID,
      this.userEmail,
      this.userName,
      this.userFullName,
      this.userBirthday,
      this.userSex,
      this.userCircles,
      this.optedInEvents,
      this.potentialCircles,
      this.userTokens});
}

class MyUserData {
  final String userID;
  final String userEmail;
  final String userName;
  final String userFullName;
  final DateTime userBirthday;
  final String userSex;
  final List<dynamic> userCircles;
  final List<dynamic> optedInEvents;
  final List<dynamic> potentialCircles;
  final List<dynamic> optedOutEvents;
    final List<dynamic> userTokens;

  MyUserData({
    this.userID,
    this.userEmail,
    this.userName,
    this.userFullName,
    this.userBirthday,
    this.userSex,
    this.userCircles,
    this.optedInEvents,
    this.potentialCircles,
    this.optedOutEvents,
    this.userTokens
  });

  String getInitials() => userFullName.isNotEmpty
      ? userFullName
          .trim()
          .split(RegExp(' +'))
          .map((s) => s[0])
          .take(2)
          .join()
          .toUpperCase()
      : ' ';
}
