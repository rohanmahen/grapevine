import 'package:flutter/material.dart';
import 'package:grapevine_app/screens/authenticate/landing_page.dart';
import 'package:grapevine_app/shared/constants.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Onboarding extends StatefulWidget {
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double unitHeightValue = deviceHeight * 0.01;
    // 64px is 7x unit height value
    // 32px is 3.5x* unit height value

    return Container(
      decoration: inAppBackground,
      child: Scaffold(
        body: Container(
          padding:
              const EdgeInsets.only(top: 60, bottom: 32, left: 32, right: 32),
          child: IntroductionScreen(
            done: Text(
              "Go!",
              style: title1.copyWith(color: grapevinePurple),
            ),
            onDone: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LandingPage(),
                ),
              );
            },
            next: const Icon(
              Icons.arrow_forward,
              size: 40,
              color: grapevineGreen,
            ),
            pages: [
              PageViewModel(
                  titleWidget: RichText(
                    text: TextSpan(
                        style: title2.copyWith(fontSize: 7 * unitHeightValue),
                        children: [
                          TextSpan(
                            text: "👋 \nWelcome to",
                            style: title2.copyWith(
                                fontSize: 7* unitHeightValue, color: grapevineBlack),
                          ),
                          TextSpan(
                            text: " Grape",
                            style: title2.copyWith(
                                fontSize:7* unitHeightValue, color: grapevinePurple),
                          ),
                          TextSpan(
                            text: "vine",
                            style: title2.copyWith(
                                fontSize: 7* unitHeightValue, color: grapevineGreen),
                          )
                        ]),
                  ),
                  bodyWidget: Text(
                    "where you can discover events and the social groups going.",
                    style: body.copyWith(fontSize: 3.5*unitHeightValue),
                  )),
              PageViewModel(
                  titleWidget: RichText(
                    text: TextSpan(
                        style: title2.copyWith(fontSize: 7* unitHeightValue),
                        children: [
                          TextSpan(
                            text: "👥 \nCreate",
                            style: title2.copyWith(
                                fontSize: 7* unitHeightValue, color: grapevinePurple),
                          ),
                          TextSpan(
                              text: " and ",
                              style: title2.copyWith(
                                  fontSize: 7* unitHeightValue, color: grapevineBlack)),
                          TextSpan(
                            text: "Join",
                            style: title2.copyWith(
                                fontSize: 7* unitHeightValue, color: grapevineGreen),
                          ),
                          TextSpan(
                              text: " Circles",
                              style: title2.copyWith(
                                  fontSize: 7* unitHeightValue, color: grapevineBlack)),
                        ]),
                  ),
                  bodyWidget: Text(
                    "which reflect the groups of people you hang out with irl!",
                    style: body.copyWith(fontSize: 3.5*unitHeightValue),
                  )),
              PageViewModel(
                titleWidget: RichText(
                  text:
                      TextSpan(style: title2.copyWith(fontSize: 7* unitHeightValue), children: [
                    TextSpan(
                      text: "🎉 \nDiscover ",
                      style:
                          title2.copyWith(fontSize: 7* unitHeightValue, color: grapevineGreen),
                    ),
                    TextSpan(
                      text: "and ",
                      style:
                          title2.copyWith(fontSize: 7* unitHeightValue, color: grapevineBlack),
                    ),
                    TextSpan(
                      text: "Add ",
                      style:
                          title2.copyWith(fontSize: 7* unitHeightValue, color: grapevinePurple),
                    ),
                    TextSpan(
                        text: "Events",
                        style: title2.copyWith(
                            fontSize: 7* unitHeightValue, color: grapevineBlack)),
                  ]),
                ),
                bodyWidget: Text(
                  // "Tap to see who's going 👀\nSwipe ➡️ to show interest and invite other circles!\n",
                  "👆tap to see who's going 👀\n\nswipe ➡️ to show interest and invite other circles! ",
                  style: body.copyWith(fontSize: 3.5*unitHeightValue),
                ),
              ),
            ],
            baseBtnStyle: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
            ),
            dotsDecorator: DotsDecorator(
              size: const Size.square(16.0),
              activeSize: const Size(32.0, 10.0),
              color: grapevineGreen,
              activeColor: grapevinePurple,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }
}
