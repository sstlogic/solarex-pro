

import 'package:flutter/material.dart';
import 'package:solarex/first_phase/screenUI/shareScreen/component/body.dart';

import '../../../theme/style.dart';
import '../../../utils/theme.dart';
import '../viewShareScreen/view_share_screen.dart';

class ShareScreen extends StatefulWidget {
  static String routeName = "/shareScreen";

  const ShareScreen({Key? key}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
                Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Share",
          style:textStrHeader,
        ),
        actions: [

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              InkWell(
                onTap: (){

                  Navigator.pushNamed(context, ViewShareScreen.routeName).then((value) => (){
                    Navigator.pop(context);
                  });
                  },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    "view shared".toUpperCase(),
                    style:textBtnLiteBlue,
                  ),
                ),
              ),

            ],
          )
        ],
      ),
      body: Body(),
    );
  }
}
