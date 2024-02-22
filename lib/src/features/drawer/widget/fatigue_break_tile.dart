import 'package:flutter/Material.dart';
import '../../../../src/features/drawer/model/fatigue_management_break_model.dart';
import '../../../../core/widgets/text_widget.dart';

class FatigueBreakTile extends StatelessWidget {
  const FatigueBreakTile({super.key, required this.model});
  final BreakModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: BodyText(text: '${model.breakStartTime}'),
        ),
        Expanded(
          flex: 1,
          child: BodyText(text: '${model.breakEndTime}'),
        ),
        Expanded(
          flex: 2,
          child: BodyText(text: '${model.breakDetails}'),
        ),
      ],
    );
  }
}
