import 'package:flutter/material.dart';
import 'package:solarex/first_phase/screenUI/feedback/component/body.dart';
import 'package:solarex/first_phase/screenUI/home/home_screen.dart';
import 'package:solarex/utils/constants.dart';
import '../../../../theme/style.dart';

class FeedbackScreen extends StatelessWidget {
  static String routeName = "/feedback";

  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fullWidth = ConstantClass.fullWidth(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          "Feedback",
          style: textHeader,
        ),
        actions: [
          PopupMenuButton<int>(
            // onSelected: (item) => handleClick(item),
            onSelected: (item) => Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.routeName, (Route<dynamic> route) => false),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(value: 0, child: Text("Change Rep")),
            ],
          )
        ],
      ),
      body: Body(),
    );
  }
}
