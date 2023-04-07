import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarex/utils/image_app.dart';
import 'package:solarex/first_phase/screenUI/home/home_screen.dart';

import '../../utils/colors_app.dart';
import '../../utils/constants.dart';

class ScreenFour extends StatelessWidget {
  const ScreenFour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));
    var fullHeight = ConstantClass.fullHeight(context);
    var fullWidth = ConstantClass.fullWidth(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: const Text(
          "Feedback",
          style: TextStyle(color: kPrimaryColor, fontSize: 16),
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
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.only(top: fullHeight * .05),
            child: Column(
              children:  [
                Center(
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 80,

                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(300)),
                          child: CircleAvatar(
                            backgroundColor: Color(0xff6E83B7),
                            radius: 40,
                            backgroundImage: AssetImage(imguser),
                          )),
                    ),
                  ),
                ),
                Text("${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()}"),
              ],
            ),
          )),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(top: fullHeight * .05),
            child: Column(
              children: [
                Text(
                  "Was ${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()} on time?",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  minimumSize: const Size.fromHeight(40), // NEW
                ),
                onPressed: () {},
                child: const Text(
                  "ON TIME",
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  minimumSize: const Size.fromHeight(40), // NEW
                ),
                onPressed: () {},
                child: const Text(
                  "LATE",
                ),
              ),
            ),
          ),
          // Row(
          //   children: [
          //     Expanded(
          //         child: Padding(
          //       padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
          //       child: Align(
          //         alignment: FractionalOffset.bottomCenter,
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             primary: Colors.black,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(6),
          //             ),
          //             minimumSize: const Size.fromHeight(50), // NEW
          //           ),
          //           onPressed: () {},
          //           child: const Text(
          //             "ENTER NEW CODE",
          //           ),
          //         ),
          //       ),
          //     )),
          //     Expanded(
          //         child: Padding(
          //       padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
          //       child: Align(
          //         alignment: FractionalOffset.bottomCenter,
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             primary: kPrimaryColor,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(6),
          //             ),
          //             minimumSize: const Size.fromHeight(50), // NEW
          //           ),
          //           onPressed: () {},
          //           child: const Text(
          //             "CONTINUE",
          //           ),
          //         ),
          //       ),
          //     ))
          //   ],
          // )
        ],
      )),
    );
  }
}
