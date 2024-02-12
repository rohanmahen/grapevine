import 'package:flutter/material.dart';
import 'constants.dart';

class GvDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 32,
      thickness: 1,
      color: grapevineGrey.withAlpha(122),
      indent: 64,
      endIndent: 64,
    );
  }
}
