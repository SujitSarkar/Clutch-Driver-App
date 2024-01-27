import 'package:flutter/Material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget(
      {super.key,
      required this.child,
      this.enabled = true,
      this.baseColor,
      this.highlightColor});

  final Widget child;
  final bool enabled;
  final Color? highlightColor;
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      enabled: enabled,
      child: child,
    );
  }
}
