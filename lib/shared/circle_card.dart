import 'package:flutter/material.dart';
import 'constants.dart';

class CircleCard extends StatelessWidget {
  final String circleTitle;

  CircleCard({this.circleTitle});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 16,
        right: 16,
      ),
      child: Container(
          decoration: grapevineBoxDecoration.copyWith(
              color: grapevineWhite,
              border: Border.all(color: grapevineGreen.withAlpha(122))),
          width: deviceWidth - 32,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text(
                "@"+this.circleTitle,
                style: headLine.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          )),
    );
  }
}
