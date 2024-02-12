import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Main Colors
const Color grapevineGreen = Color(0xFF5AD39A);
const Color grapevinePurple = Color(0xFF6F2DA8);
const Color grapevineWhite = Color(0xFFFFFFFF);
const Color grapevineBlack = Color(0xFF000000);

// Accent Colors
const Color grapevineGreenAccent = Color(0xFFA4FFD4);
const Color grapevineLightGreenAccent = Color(0xFFedfef6);
const Color grapevineGrey = Color(0xFF8A959E);

// Logos, Icons
var homeIcon = Container(
  height: 32,
  width: 32,
  child: SvgPicture.asset("assets/homeIcon.svg"),
);

var homeIconSelected = Container(
  height: 32,
  width: 32,
  child: SvgPicture.asset("assets/homeIconSelected.svg"),
);

var calendarIcon = Container(
  height: 32,
  width: 32,
  child: SvgPicture.asset("assets/calendarIcon.svg"),
);

var calendarIconSelected = Container(
  height: 32,
  width: 32,
  child: SvgPicture.asset("assets/calendarIconSelected.svg"),
);

var circlesIcon = Container(
  height: 32,
  width: 32,
  child: SvgPicture.asset("assets/circlesIcon.svg"),
);

var circlesIconSelected = Container(
  height: 32,
  width: 32,
  child: SvgPicture.asset("assets/circlesIconSelected.svg"),
);

var userIcon = Container(
  height: 32,
  width: 32,
  child: SvgPicture.asset("assets/userIcon.svg"),
);

var userIconSelected = Container(
  height: 32,
  width: 32,
  child: SvgPicture.asset("assets/userIconSelected.svg"),
);

var createCircleIcon = Container(
  height: 48,
  width: 48,
  child: SvgPicture.asset("assets/createCircle.svg"),
);

var createEventIcon = Container(
  height: 48,
  width: 48,
  child: SvgPicture.asset("assets/createEventIcon.svg"),
);

var logo = Container(
  height: 164,
  width: 178,
  child: SvgPicture.asset("assets/logo.svg"),
);

var logoIcon = Container(
  height: 111.9,
  width: 128.5,
  child: SvgPicture.asset("assets/logo.svg"),
);

var whosIn = Container(
  child: SvgPicture.asset("assets/whosin.svg"),
);

var textIcon = Container(
  width: 162,
  height: 41,
  child: SvgPicture.asset("assets/grapevine.svg"),
);

// Regex, utility variables and constants

RegExp validName = RegExp(
  r"^(?=.{3,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$",
  caseSensitive: false,
  multiLine: false,
);

RegExp validInvite = RegExp(
  r"@(?=.{3,20})(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])",
  caseSensitive: false,
  multiLine: false,
);

RegExp validEmail = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    multiLine: false,
    caseSensitive: true);

RegExp validFullName = RegExp(
  r"^[a-z ,.'-]+$",
  multiLine: false,
  caseSensitive: false,
);

// Backgrounds, Decorations and Shadows

const inAppBackground = BoxDecoration(
  color: Colors.white,
  gradient: LinearGradient(colors: [
    grapevineWhite,
    grapevineLightGreenAccent,
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
);

var textInputDecoration = InputDecoration(
  isDense: true,
  focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: grapevineGreen),
      borderRadius: BorderRadius.circular(8)),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: grapevineGreen),
      borderRadius: BorderRadius.circular(8)),
  labelStyle: body.copyWith(color: grapevineBlack),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: grapevineGreen),
      borderRadius: BorderRadius.circular(8)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: grapevineGreen),
      borderRadius: BorderRadius.circular(8)),
  fillColor: grapevineGreenAccent,
  focusColor: grapevineGreenAccent,
  hoverColor: grapevineGreenAccent,
);

var grapevineBoxDecoration = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(8)),
  boxShadow: [
    grapevineShadow,
  ],
);

var grapevineShadow = BoxShadow(
  color: grapevineGrey.withOpacity(0.1),
  spreadRadius: 0,
  blurRadius: 8,
  offset: Offset(0, 4),
);

// Text Styles

const title1 = TextStyle(
  fontFamily: "Satoshi",
  fontWeight: FontWeight.w800,
  fontSize: 28,
  letterSpacing: 0.64,
);

const title2 = TextStyle(
  fontFamily: "Satoshi",
  fontWeight: FontWeight.w800,
  fontSize: 22,
  letterSpacing: 0.64,
);

const title3 = TextStyle(
  fontFamily: "Satoshi",
  fontWeight: FontWeight.w800,
  fontSize: 18,
  letterSpacing: 0.64,
);

const headLine = TextStyle(
  fontFamily: "Satoshi",
  fontWeight: FontWeight.w800,
  fontSize: 17,
  letterSpacing: 0.64,
);

const body = TextStyle(
  fontFamily: "Satoshi",
  fontWeight: FontWeight.w400,
  fontSize: 14,
  letterSpacing: 0.64,
);

const caption1 = TextStyle(
  fontFamily: "Satoshi",
  fontWeight: FontWeight.w400,
  fontSize: 12,
  letterSpacing: 0.32,
);

const caption2 = TextStyle(
  fontFamily: "Satoshi",
  fontWeight: FontWeight.w400,
  fontSize: 11,
  letterSpacing: 0.32,
);

const subHead = TextStyle(
  fontFamily: "Satoshi",
  fontWeight: FontWeight.w400,
  fontSize: 15,
  letterSpacing: 0.32,
);
