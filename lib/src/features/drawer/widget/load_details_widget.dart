import 'package:flutter/cupertino.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../home/model/load_model.dart';

class LoadDetailsWidget extends StatelessWidget {
  const LoadDetailsWidget({super.key, required this.model});
  final LoadDataModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BodyText(text: '${AppString.contact}: ${model.contractNo ?? ''}'),
            BodyText(text: '${AppString.quantity}: ${model.qty ?? '0'}'),
          ],
        ),
        BodyText(text: '${AppString.load}: ${model.loadRef ?? ''}'),
        BodyText(text: '${AppString.commodity}: ${model.commodity ?? ''}'),
      ],
    );
  }
}
