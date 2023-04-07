import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class LoadingSpinner extends StatelessWidget {
  final Color? color;
  const LoadingSpinner({
    this.color = kPrimaryColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoActivityIndicator(color: color);
    } else {
      return CircularProgressIndicator(color: color);
    }
  }
}
