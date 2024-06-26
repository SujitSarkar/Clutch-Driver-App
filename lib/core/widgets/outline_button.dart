import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget {
  const OutlineButton(
      {super.key,
      required this.onTap,
      required this.child,
      this.width,
      this.backgroundColor,
      this.borderRadius,
      this.splashColor,
      this.borderColor});
  final Function() onTap;
  final Widget child;
  final double? width;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final WidgetStateProperty<Color?>? splashColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                elevation: 0.0,
                fixedSize: Size(width ?? MediaQuery.of(context).size.width, 45),
                side: BorderSide(color: borderColor ?? Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ??
                        const BorderRadius.all(Radius.circular(5))))
            .copyWith(
                overlayColor: splashColor ??
                    WidgetStateProperty.all(Colors.white.withOpacity(0.5))),
        onPressed: onTap,
        child: child);
  }
}
