import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarex/Theme/colors.dart';

const fontFamilyInter = 'Inter';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Inter",
    appBarTheme: appBarTheme(),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.grey, // Status bar
      systemNavigationBarColor: Colors.grey,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    color: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 22,
    ),
  );
}

//---------Phase one------------
const textHeader = TextStyle(
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
  fontSize: 16.0,
);

const kTextbuttonStyleColorAppMain = TextStyle(
  fontWeight: FontWeight.bold,
  color: colorAppMain,
  fontFamily: fontFamilyInter,
  fontSize: 16.0,
);
const kText14SemiBoldBlack = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.black,
  fontSize: 14.0,
);
const kText14SemiBoldGrey = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.grey,
  fontSize: 14.0,
);
const kText12SemiBoldRed = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.red,
  fontSize: 14.0,
);

const textDescription = TextStyle(
  fontWeight: FontWeight.w300,
  color: Colors.black,

  height: 1.5,
  // the height between text, default is 1.0
  fontSize: 30.0,
);

const textProfileName = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.black,
  fontSize: 16.0,
);
const text16 = TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.black,
  fontFamily: fontFamilyInter,
  fontSize: 16.0,
);
const textsemiBold = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.black,
  fontSize: 30.0,
);
const textsemiBoldBlue = TextStyle(
  fontWeight: FontWeight.w600,
  color: kPrimaryColor,
  fontSize: 30.0,
);
const textOnTime = TextStyle(
  fontWeight: FontWeight.w300,
  color: Colors.black,

  height: 1.5,
  // the height between text, default is 1.0
  fontSize: 30.0,
);
const textNormal = TextStyle(
  fontWeight: FontWeight.w300,
  color: Colors.black,

  height: 1.5,
  // the height between text, default is 1.0
  fontSize: 30.0,
);
const textNormal18 = TextStyle(
  fontWeight: FontWeight.w300,
  color: Colors.black,
  fontSize: 46.0,
);
const textBtn = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontSize: 14.0,
);

const textDesc = TextStyle(
  fontWeight: FontWeight.w500,
  color: kSecondaryColor,
  fontSize: 14.0,
);
const textBtnBlue = TextStyle(
  fontWeight: FontWeight.w700,
  color: kPrimaryColor,
  fontSize: 14.0,
);
const textStrBtn = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontSize: 14.0,
);

const textStrHeader = TextStyle(
  fontWeight: FontWeight.bold,
  color: kPrimaryDarkColor,
  fontFamily: fontFamilyInter,
  fontSize: 16.0,
);

const textBtnLiteBlue = TextStyle(
  fontWeight: FontWeight.w700,
  color: kPrimaryDarkColor,
  fontFamily: fontFamilyInter,
  fontSize: 14.0,
);

const textBtngrey = TextStyle(
  fontWeight: FontWeight.w700,
  color: kSecondaryColor,
  fontFamily: fontFamilyInter,
  fontSize: 14.0,
);

const textLiteBlueDec = TextStyle(
  fontWeight: FontWeight.w500,
  color: kPrimaryDarkColor,
  fontFamily: fontFamilyInter,
  fontSize: 18.0,
);

//---------Phase Second------------
const textHeading = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontFamily: fontFamilyInter,
  fontSize: 16.0,
);
const textHeading2 = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontFamily: fontFamilyInter,
  fontSize: 20.0,
);
const text16Black = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.black,
  fontFamily: fontFamilyInter,
  fontSize: 16.0,
);

const text16BlackN = TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.black,
  fontFamily: fontFamilyInter,
  fontSize: 16.0,
);

const text14grey = TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.grey,
  fontFamily: fontFamilyInter,
  fontSize: 14.0,
);
const text14Black = TextStyle(
  fontWeight: FontWeight.w100,
  color: Colors.black,
  fontFamily: fontFamilyInter,
  fontSize: 14.0,
);

const text14BlackBold = TextStyle(
  fontWeight: FontWeight.w700,
  color: Colors.black,
  fontFamily: fontFamilyInter,
  fontSize: 14.0,
);
const text18Black = TextStyle(
  fontWeight: FontWeight.w700,
  color: Colors.black,
  fontSize: 18.0,
);

const text30Black = TextStyle(
  fontWeight: FontWeight.normal,
  color: Colors.black,
  fontStyle: FontStyle.italic,
  fontFamily: fontFamilyInter,
  fontSize: 26.0,
);

const textbottomMenu = TextStyle(
  fontWeight: FontWeight.w300,
  color: Colors.yellowAccent,
  fontFamily: fontFamilyInter,
  fontSize: 10.0,
);

const text14White = TextStyle(
  fontWeight: FontWeight.w500,
  color: Colors.white,
  fontFamily: fontFamilyInter,
  fontSize: 10.0,
);

const textDialogbutton = TextStyle(
  fontWeight: FontWeight.bold,
  color: kPrimaryDarkColor,
  fontFamily: fontFamilyInter,
  fontSize: 16.0,
);
