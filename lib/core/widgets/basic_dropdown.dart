import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../constants/text_size.dart';
import 'text_widget.dart';

// ignore: must_be_immutable
class BasicDropdown extends StatelessWidget {
  final List<String> items;
  String? selectedValue;
  final String hintText;
  final Function(String) onChanged;
  final double? width;
  final double? buttonHeight;
  final double? dropdownWidth;

  BasicDropdown(
      {super.key,
        required this.items,
        required this.selectedValue,
        required this.hintText,
        required this.onChanged,
        this.width,
        this.buttonHeight = 45,
        this.dropdownWidth});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(hintText,
            style: const TextStyle(color: AppColor.textFieldHintColor),
            overflow: TextOverflow.ellipsis),
        style:
        TextStyle(color: AppColor.textColor, fontSize: TextSize.bodyText),
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: BodyText(text:
          item,
          ),
        ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          selectedValue = value;
          onChanged(selectedValue!);
        },
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down, size: 20),
          iconSize: 14,
          iconEnabledColor: AppColor.textFieldHintColor,
          iconDisabledColor: Colors.grey,
        ),
        buttonStyleData: ButtonStyleData(
          height: buttonHeight,
          width: width?? double.infinity,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.grey, width: 0.5),
              color: Colors.white),
          elevation: 0,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 500,
          width: dropdownWidth ?? MediaQuery.of(context).size.width * .9,
          padding: null,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          elevation: 8,
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(10),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
          // offset: const Offset(-10, 0),
        ),
      ),
    );
  }
}
