class Circle {
  final String circleID;
  final String circleTitle;
  final String circleDescription;
  final List<dynamic> circleMembers;
  final List<dynamic> connectedCircles;
  final String circleFormation;

  Circle(
      {this.circleID,
      this.circleTitle,
      this.circleDescription,
      this.circleMembers,
      this.connectedCircles,
      this.circleFormation});
}
