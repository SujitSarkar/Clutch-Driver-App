import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 25,
        width: 25,
        child: Platform.isIOS
            ? CupertinoActivityIndicator(color: color ??  Colors.white)
            : CircularProgressIndicator(
                color: color ?? AppColor.secondaryColor));
  }
}
