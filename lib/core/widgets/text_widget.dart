import 'package:flutter/Material.dart';
import '../constants/app_color.dart';
import '../constants/text_size.dart';

class BodyText extends StatelessWidget {
  const BodyText(
      {super.key,
      required this.text,
      this.textColor,
      this.fontWeight,
      this.textAlign});

  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign?? TextAlign.start,
        style: TextStyle(
            color: textColor ?? AppColor.textColor,
            fontSize: TextSize.bodyText,
            fontWeight: fontWeight ?? FontWeight.w400));
  }
}

class SmallText extends StatelessWidget {
  const SmallText(
      {super.key,
        required this.text,
        this.textColor,
        this.fontWeight,
        this.textAlign});

  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign?? TextAlign.start,
        style: TextStyle(
            color: textColor ?? AppColor.textColor,
            fontSize: TextSize.smallText,
            fontWeight: fontWeight ?? FontWeight.w400));
  }
}

class TitleText extends StatelessWidget {
  const TitleText(
      {super.key,
        required this.text,
        this.textColor,
        this.fontWeight,
        this.textAlign});

  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign?? TextAlign.start,
        style: TextStyle(
            color: textColor ?? AppColor.textColor,
            fontSize: TextSize.titleText,
            fontWeight: fontWeight ?? FontWeight.w500));
  }
}

class LargeTitleText extends StatelessWidget {
  const LargeTitleText(
      {super.key,
        required this.text,
        this.textColor,
        this.fontWeight,
        this.textAlign});

  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign?? TextAlign.start,
        style: TextStyle(
            color: textColor ?? AppColor.textColor,
            fontSize: TextSize.largeTitleText,
            fontWeight: fontWeight ?? FontWeight.w500));
  }
}

class ButtonText extends StatelessWidget {
  const ButtonText(
      {super.key,
        required this.text,
        this.textColor,
        this.fontWeight,
        this.textAlign});

  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign?? TextAlign.start,
        style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: TextSize.buttonText,
            fontWeight: fontWeight ?? FontWeight.w500));
  }
}
