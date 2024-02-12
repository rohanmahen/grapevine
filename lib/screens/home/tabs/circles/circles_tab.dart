import 'package:flutter/material.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/screens/home/tabs/circles/mini_circle_tile.dart';
import 'package:grapevine_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:grapevine_app/services/database.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'circle_tile.dart';

class CirclesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyUserData user = Provider.of<MyUserData>(context);
    // final db = DatabaseService(userID: user.userID);

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            StreamBuilder<Object>(
              stream: DatabaseService(userID: user.userID).userDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  MyUserData userData = snapshot.data;
                  // List<dynamic> circles = userData.userCircles;
                  // ignore: unused_local_variable
                  List<dynamic> potentialCircles =
                      userData.potentialCircles.reversed.toList();

                  // add lower cylinder for potential circles!
                  if (potentialCircles.length != 0) {
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Circle Invitations",
                            style: title2,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: deviceWidth - 32,
                          child: Container(
                            height: 100,
                            child: MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: potentialCircles.length,
                                // shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 100,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 16,
                                ),
                                itemBuilder: (context, index) {
                                  // return CircleTile(circleID: circles[index]);
                                  return MiniCircleTile(
                                      circleID: potentialCircles[index]);
                                  // );

                                  // Return my circles widgets
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Loading();
                }
              },
            ),
            Expanded(
              child: StreamBuilder<Object>(
                stream: DatabaseService(userID: user.userID).userDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    MyUserData userData = snapshot.data;
                    List<dynamic> circles = userData.userCircles;
                    List<dynamic> potentialCircles =
                        userData.potentialCircles.reversed.toList();

                    if (potentialCircles.length == 0) {
                      return Column(
                        children: [
                          Expanded(
                            child: Container(
                              height: deviceHeight - 100,
                              width: deviceWidth - 32,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  child: MediaQuery.removePadding(
                                    removeTop:
                                        true, // this removes top padding on UI
                                    context: context,
                                    child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: circles.length,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 32,
                                        mainAxisExtent: 120,
                                      ),
                                      itemBuilder: (context, index) {
                                        return CircleTile(
                                            circleID: circles[index]);
                                        // Return my circles widgets
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "My Circles",
                              style: title2,
                            ),
                          ),
                          Container(
                            height: deviceHeight - 300,
                            width: deviceWidth - 32,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                child: MediaQuery.removePadding(
                                  removeTop:
                                      true, // this removes top padding on UI
                                  context: context,
                                  child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: circles.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 32,
                                      mainAxisExtent: 120,
                                    ),
                                    itemBuilder: (context, index) {
                                      return CircleTile(
                                          circleID: circles[index]);
                                      // Return my circles widgets
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return Loading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
