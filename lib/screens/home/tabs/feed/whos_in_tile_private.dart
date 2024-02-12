import 'package:flutter/material.dart';
import 'package:grapevine_app/shared/constants.dart';


class WhosInTilePrivate extends StatelessWidget {
  final String display;

  WhosInTilePrivate({this.display});

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
                "@" + display,
                style: headLine.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          )),
    );
  }
}
