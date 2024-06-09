import 'package:flutter/material.dart';
import '../constants/app_color.dart';

void modalBottomSheet(
    {required BuildContext context,
    required Widget child,
    double? height,
    bool? isScrollControlled}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled ?? true,
      builder: (context) => Container(
            height: height ?? MediaQuery.of(context).size.height * .7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 3,
                  width: 50,
                  margin: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                      color: AppColor.textFieldHintColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                const SizedBox(height: 12),
                Expanded(child: child)
              ],
            ),
          ));
}
