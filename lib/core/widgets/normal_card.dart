import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class NormalCard extends StatelessWidget {
  const NormalCard(
      {super.key,
      required this.child,
      this.bgColor,
      this.borderRadius,
      this.padding});
  final Widget child;
  final Color? bgColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor ?? AppColor.cardColor,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
      elevation: 0.0,
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
        ),
        child: child,
      ),
    );
  }
}
