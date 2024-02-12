import 'package:flutter/material.dart';
import 'package:grapevine_app/screens/home/tabs/circles/create_circle.dart';
import 'package:grapevine_app/screens/home/tabs/feed/create_event.dart';
import 'package:grapevine_app/screens/home/tabs/feed/create_private_event.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/shared/constants.dart';

class CreateSheet extends StatefulWidget {
  @override
  State<CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends State<CreateSheet> {
  @override
  Widget build(BuildContext context) {
    final MyUserData user = Provider.of<MyUserData>(context);
    final DatabaseService db = DatabaseService(userID: user.userID);

    final deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      height: deviceHeight * 0.41,
      decoration: grapevineBoxDecoration.copyWith(
        color: grapevineWhite,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Text(
                "Do you want to...",
                style: title1,
              ),
            ),
          ),
          Expanded(
              child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration:
                      grapevineBoxDecoration.copyWith(color: grapevineWhite),
                  child: ListTile(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreamProvider.value(
                            value: db.userDataStream,
                            initialData: MyUserData(),
                            child: CreateCircle(),
                          ),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.add_circle_outline,
                      color: grapevineGreen,
                    ),
                    title: Text(
                      'Start a Circle',
                      style: headLine.copyWith(
                          color: grapevineBlack, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration:
                      grapevineBoxDecoration.copyWith(color: grapevineWhite),
                  child: ListTile(
                    subtitle: Text("everyone can see this event"),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreamProvider.value(
                            value: db.userDataStream,
                            initialData: MyUserData(),
                            child: CreateEvent(),
                          ),
                        ),
                      );
                      //Create a circle logic and streams added
                    },
                    leading: Icon(
                      Icons.add_box_outlined,
                      color: grapevineGreen,
                    ),
                    title: Text(
                      'Share a Public Event',
                      style: headLine.copyWith(
                          color: grapevineBlack, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration:
                      grapevineBoxDecoration.copyWith(color: grapevineWhite),
                  child: ListTile(
                    subtitle: Text("only invited circles can see this event"),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreamProvider.value(
                            value: db.userDataStream,
                            initialData: MyUserData(),
                            child: CreatePrivateEvent(),
                          ),
                        ),
                      );
                      //Create a circle logic and streams added
                    },
                    leading: Icon(
                      Icons.add_box,
                      color: grapevineGreen,
                    ),
                    title: Text(
                      'Add a Private Event',
                      style: headLine.copyWith(
                          color: grapevineBlack, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
