// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:solarex/first_phase/screenUI/splash/splash_screen.dart';
// import 'package:solarex/utils/routes.dart';
// import '../../../../theme/style.dart';
// /*
//  *  28-05-2022 11:41:19 +5:30 UTC
//  */
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(statusBarColor: Colors.black));
//
//     return MaterialApp(
//       title: 'Solarex',
//       // theme: theme(),
//       debugShowCheckedModeBanner: false,
//       home: const SplashScreen(),
//       initialRoute: SplashScreen.routeName,
//       routes: routes,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solarex/first_phase/screenUI/splash/splash_screen.dart';
import 'package:solarex/theme/style.dart';
import 'package:solarex/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(414, 736),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Solarex',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: child,
          initialRoute: SplashScreen.routeName,
          routes: routes,
        );
      },
      child: const SplashScreen(),
    );
  }
}
