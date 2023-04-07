// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:solarex/theme/style.dart';

import '../../theme/colors.dart';

class CustomTextFields extends StatelessWidget {
  CustomTextFields(
      {super.key,
      required this.width,
      required this.lable,
      required this.hintText,
      required this.controllers,
      required this.fieldValidator,
      required this.enable,
      required this.keyboardType,
      required this.onPress,
      this.maxlength});

  double width;
  String lable;
  String hintText;
  VoidCallback onPress;
  TextEditingController controllers;
  FormFieldValidator<String> fieldValidator;
  bool enable;
  TextInputType keyboardType;
  int? maxlength;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width,
                  height: 70,
                  // margin: const EdgeInsets.only(left: 14, right: 14),
                  child: TextFormField(
                    maxLength: maxlength,
                    controller: controllers,
                    validator: fieldValidator,
                    enabled: enable,
                    style: kText14SemiBoldBlack,
                    decoration: InputDecoration(
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        isDense: true,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorAppMain),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorAppMain),
                        ),
                        fillColor: Colors.white,
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorAppMain),
                        ),
                        // border: const OutlineInputBorder(),
                        labelText: lable,

                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorAppMain),
                        ),
                        counterText: "",
                        hintText: hintText,
                        labelStyle: kText14SemiBoldGrey,
                        errorStyle: kText12SemiBoldRed,
                        hintStyle: kText14SemiBoldGrey),
                    keyboardType: keyboardType,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
