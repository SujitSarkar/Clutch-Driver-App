import 'package:flutter/material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/widgets/text_widget.dart';

class NoLoadFoundWidget extends StatelessWidget {
  const NoLoadFoundWidget({super.key, required this.onRefresh});

  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BodyText(
              text: 'No load found', textColor: AppColor.secondaryTextColor),
          TextButton(
              onPressed: onRefresh,
              child: const ButtonText(
                  text: 'Refresh', textColor: AppColor.primaryColor))
        ],
      ),
    );
  }
}
