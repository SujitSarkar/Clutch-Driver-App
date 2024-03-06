import 'package:flutter/Material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/normal_card.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../src/features/home/model/load_model.dart';

class UpcomingLoadTile extends StatelessWidget {
  const UpcomingLoadTile({super.key, required this.loadModel});

  final LoadDataModel loadModel;

  @override
  Widget build(BuildContext context) {
    return NormalCard(
      padding: const EdgeInsets.all(12),
      bgColor: AppColor.primaryColor.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(text: '${AppString.contact}: ${loadModel.contractNo??''}'),
                BodyText(text: '${AppString.load}: ${loadModel.loadRef??''}'),
                BodyText(text: '${AppString.pickup}: ${loadModel.pickup?.state??''}'),
                BodyText(text: '${AppString.destination}: ${loadModel.destination?.state??''}'),
                BodyText(text: '${AppString.commodity}: ${loadModel.commodity??''}'),
                BodyText(text: '${AppString.releaseNo}: ${loadModel.releaseNo??''}'),
                BodyText(text: '${AppString.deliveryNo}: ${loadModel.deliveryNo??''}'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
                alignment: Alignment.topRight,
                child: BodyText(
                    text: '${AppString.quantity}: ${loadModel.qty??'0'}',
                    textAlign: TextAlign.end)),
          )
        ],
      ),
    );
  }
}
