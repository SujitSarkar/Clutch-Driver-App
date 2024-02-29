import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class SearchField extends StatelessWidget {
  const SearchField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.onTap,
      this.textInputType,
      this.textCapitalization,
      this.textAlign = TextAlign.left,
      this.prefixIcon,
      this.suffixColor,
      this.prefixColor,
      this.suffixOnTap,
      this.prefixOnTap,
      this.onChanged,
      this.onEditingComplete,
      this.contentPadding,
      this.focusNode});

  final TextEditingController controller;
  final String hintText;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final IconData? prefixIcon;
  final Color? suffixColor;
  final Color? prefixColor;
  final TextAlign? textAlign;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final Function()? suffixOnTap;
  final Function()? prefixOnTap;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return TextFormField(
      controller: controller,
      onTap: onTap,
      focusNode: focusNode,
      onChanged: (val) {
        if (onChanged != null) {
          onChanged!(val);
        }
      },
      onEditingComplete: onEditingComplete,
      keyboardType: textInputType ?? TextInputType.text,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      textAlign: textAlign!,
      style: TextStyle(
          color: AppColor.textColor, fontWeight: FontWeight.w500, fontSize: 14),
      decoration: InputDecoration(
          alignLabelWithHint: true,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide.none),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide.none),
          fillColor: Colors.blueGrey.shade50,
          filled: true,
          isDense: true,
          contentPadding: contentPadding ?? const EdgeInsets.all(12),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintStyle:
              const TextStyle(color: AppColor.textFieldHintColor, fontSize: 14),
          labelStyle:
              const TextStyle(color: AppColor.textFieldHintColor, fontSize: 14),
          prefixIcon: prefixIcon != null
              ? InkWell(
                  onTap: prefixOnTap,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, left: 10),
                    child: Icon(prefixIcon,
                        size: 20, color: prefixColor ?? AppColor.primaryColor),
                  ),
                )
              : null,
          suffixIconConstraints: BoxConstraints.loose(size),
          prefixIconConstraints: BoxConstraints.loose(size),
          suffixIcon: controller.text.isNotEmpty? InkWell(
            onTap: suffixOnTap,
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.close, size: 20,color: Colors.grey),
            ),
          ):null),
    );
  }
}
