import 'package:flutter/Material.dart';
import '../constants/app_color.dart';

class RefreshIndicatorWidget extends StatelessWidget {
  const RefreshIndicatorWidget(
      {super.key, required this.child, required this.onRefresh});

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        backgroundColor: Colors.white,
        color: AppColor.primaryColor,
        onRefresh: onRefresh,
        child: child);
  }
}
