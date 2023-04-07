import 'package:flutter/material.dart';
import 'package:solarex/theme/style.dart';
import '../theme/colors.dart';
import 'image_app.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({Key? key, this.title, this.button1, this.button2, this.height, this.isAssets, this.onButton1Clicked, this.onButton2Clicked})
      : super(key: key);

  final String? title;
  final String? button1;
  final String? button2;
  final double? height;
  final bool? isAssets;
  final VoidCallback? onButton1Clicked;
  final VoidCallback? onButton2Clicked;

  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Wrap(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15.0) //
                    ),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                const SizedBox(
                  height: 10,
                ),
                // alert.png
                widget.isAssets == true
                    ? Image.asset(
                        imgLogo,
                        height: 50,
                        width: 50,
                      )
                    : SizedBox(),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    widget.title!,
                    style: textDesc,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                widget.button2 == null
                    ? Wrap(
                        children: [
                          SizedBox(
                              // width: 80,
                              child: ElevatedButton(
                                  onPressed: widget.onButton1Clicked,
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        side: const BorderSide(color: Colors.transparent),
                                      ))),
                                  child: Text(
                                    widget.button1!,
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ))),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                              onPressed: widget.onButton1Clicked,
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: const BorderSide(color: kPrimaryColor),
                                  ))),
                              child: Text(
                                widget.button1!,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: widget.onButton2Clicked,
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: const BorderSide(color: Colors.transparent),
                                  ))),
                              child: Text(
                                widget.button2!,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
              ])),
        ],
      ),
    );
  }
}
