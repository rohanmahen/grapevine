import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of grapevine.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      value: AuthService().authStream,
      initialData: null,
      child: Wrapper(),
    );
  }
}
