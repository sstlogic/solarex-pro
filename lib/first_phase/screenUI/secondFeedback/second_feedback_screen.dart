import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarex/first_phase/screenUI/home/home_screen.dart';
import 'package:solarex/first_phase/screenUI/secondFeedback/component/body.dart';

import '../../../theme/style.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';

class SecondFeedbackScreen extends StatefulWidget {
  static String routeName = "/secondFeedback";

  const SecondFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<SecondFeedbackScreen> createState() => _SecondFeedbackScreenState();
}

class _SecondFeedbackScreenState extends State<SecondFeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    var fullWidth = ConstantClass.fullWidth(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          "Feedback",
          style:textHeader,
        ),
        actions: [
          PopupMenuButton<int>(
            // onSelected: (item) => handleClick(item),
            onSelected: (item) => Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(value: 0, child:Text("Change Rep")),
            ],
          )
        ],
      ),
      body: Body(),
    );
  }
}
