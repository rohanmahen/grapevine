import 'package:flutter/material.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/screens/authenticate/authenticate.dart';
import 'package:grapevine_app/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // accesses the user stream with the provider of.
    final user = Provider.of<MyUser>(context);
    // return Home or Authenticate depending on sign in status.
    if (user == null) {
      return Authenticate();
    } else {
      return MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      );
    }
  }
}
