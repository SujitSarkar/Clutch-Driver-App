import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: 25,
          width: 25,
          child: Platform.isIOS
              ? CupertinoActivityIndicator(color: color ??  Colors.white)
              : CircularProgressIndicator(
                  color: color ?? Colors.white)),
    );
  }
}
