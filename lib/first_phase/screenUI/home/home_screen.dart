import 'package:flutter/material.dart';
import '../../../../theme/style.dart';
import 'package:solarex/first_phase/screenUI/home/component/body.dart';

import '../../../utils/colors_app.dart';
import '../../../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var fullWidth = ConstantClass.fullWidth(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kPrimaryDarkColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white70,
        title: const Text(
          "Welcome",
          style: textHeader,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: fullWidth * .02),
            child: const Center(
                child: Text(
                  "v1.0.0",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                )),
          )
        ],
      ),
      body: const SafeArea(child: Body()),
    );
  }
}
