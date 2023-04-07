
import 'package:flutter/material.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:url_launcher/url_launcher.dart';

class DialpadScreen extends StatelessWidget {
  const DialpadScreen({Key? key, }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child:
          DialPad(
              enableDtmf: true,
              // enableDtmf: true,
              outputMask: "0000000000",
              backspaceButtonIconColor: Colors.red,
              buttonTextColor: Colors.white,
              dialOutputTextColor: Colors.white,
              keyPressed: (value){
              },
              makeCall: (number) async {
                // _makePhoneCall(number);
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: number,
                );
                if (await launchUrl(launchUri)) {
                await launchUrl(launchUri);
                } else {
                throw 'Could not launch ${Uri.parse("tel://${number}")}';
                }
              }
          )
      ),
    );
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
