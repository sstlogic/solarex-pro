import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:solarex/first_phase/screenUI/home/home_screen.dart';
import 'package:solarex/second_phase/screens/Login/login_screen.dart';
import 'package:solarex/second_phase/screens/Signup/signup_screen.dart';
import 'package:solarex/utils/colors_app.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/image_app.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../theme/style.dart';

import '../../theme/style.dart';

class FirstHomeScreen extends StatefulWidget {
  static String routeName = "/demoscreen";

  const FirstHomeScreen({Key? key}) : super(key: key);

  @override
  State<FirstHomeScreen> createState() => _FirstHomeScreenState();
}

class _FirstHomeScreenState extends State<FirstHomeScreen> {
  int pageIndex = 0;

  final List<Widget> _demo = [
    Container(
      // height: 300,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'My Solarex Rep',
            style: textsemiBoldBlue,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Help your Solarex Rep keep improving and fueling their business',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    Container(
      // height: 300,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Solarex Rep Office',
            style: textsemiBoldBlue,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Manage your schedule and book appointments all in one place',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fullWidth = ConstantClass.fullWidth(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(margin: EdgeInsets.only(left: fullWidth * .24, right: fullWidth * .24), child: Image.asset('assets/image_logo1.png')),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 300,
              width: double.infinity,
              child: PageView(
                children: _demo,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CarouselIndicator(
              count: _demo.length,
              index: pageIndex,
              color: kPrimaryLightDarkColor,
              cornerRadius: 20,
              width: 10,
              height: 10,
              activeColor: kPrimaryDarkColor,
            ),
            const SizedBox(
              height: 30,
            ),
            Column(),
            Padding(
              padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, bottom: defaultbuttonSpace),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    });
                  },
                  child: Text(
                    'My Solarex Rep'.toUpperCase(),
                    style: textBtn,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, bottom: defaultbuttonSpace),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    // ConstantClass.toastMessage(toastMessage: "Coming soon");
                  },
                  child: Text(
                    'Solarex Rep Office'.toUpperCase(),
                    style: textBtn,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, bottom: defaultbuttonSpace),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));

                    // _launchUrl("https://solarexpro.com/sign-for-app/");
                    // ConstantClass.toastMessage(toastMessage: "Coming soon");
                  },
                  child: Text(
                    'Sign up'.toUpperCase(),
                    style: textBtn,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, bottom: defaultbuttonSpace),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () {
                    ConstantClass.toastMessage(toastMessage: "Coming soon");
                  },
                  child: Text(
                    'Admin'.toUpperCase(),
                    style: textBtn,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }
}
