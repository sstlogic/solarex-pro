import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/first_phase/screenUI/splash/splash_screen.dart';

class LoaderClass extends StatefulWidget {
  static String routeName = "/loader";


  @override
  State<LoaderClass> createState() => _LoaderClassState();
}

class _LoaderClassState extends State<LoaderClass> {

  @override
  void initState() {
    // TODO: implement initState

    gotoNext();

    super.initState();
  }

  gotoNext(){
    Future.delayed(const Duration(seconds: 1), (){
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 700),
          child: SplashScreen(),
        ),
      );

    });
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: ConstantClass.fullWidth(context),
        height: ConstantClass.fullHeight(context),
        child: Stack(
          children: [


            Align(
              alignment: Alignment.center,
              child: Container(
                width: ConstantClass.fullWidth(context) * .30,
                height: ConstantClass.fullWidth(context) * .30,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.white70, width: 1.0, style: BorderStyle.solid),
                    boxShadow: [BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SpinKitCircle(
                      color: Colors.white,
                      size: 50.0,
                    ),

                    SizedBox(
                      height: 10,
                    ),


                    Text("Loading...",
                    style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),)
                  ],
                ),
              ),
            )





          ],
        ),
      ),
    );
  }
}
