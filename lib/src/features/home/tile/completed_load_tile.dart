import 'package:flutter/material.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../src/features/home/provider/home_provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/normal_card.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../src/features/home/model/load_model.dart';

class CompletedLoadTile extends StatelessWidget {
  const CompletedLoadTile({super.key, required this.loadModel});
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
                BodyText(
                    text:
                        '${AppString.contact}: ${loadModel.contractNo ?? ''}'),
                BodyText(text: '${AppString.load}: ${loadModel.loadRef ?? ''}'),
                BodyText(
                    text:
                        '${AppString.pickup}: ${loadModel.pickup?.suburb ?? ''}'),
                BodyText(
                    text:
                        '${AppString.destination}: ${loadModel.destination?.suburb ?? ''}'),
                BodyText(
                    text:
                        '${AppString.commodity}: ${loadModel.commodity ?? ''}'),
                BodyText(
                    text:
                        '${AppString.releaseNo}: ${loadModel.releaseNo ?? ''}'),
                BodyText(
                    text:
                        '${AppString.deliveryNo}: ${loadModel.deliveryNo ?? ''}'),
                if (loadModel.showRate != null)
                  BodyText(
                      text:
                          '${AppString.loadRate}: ${loadModel.showRate ?? ''}'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BodyText(
                    text: '${AppString.quantity}: ${loadModel.qty ?? '0'}'),
                const SizedBox(height: 80),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: loadModel.editable != null &&
                                loadModel.editable == true
                            ? AppColor.primaryColor
                            : AppColor.disableColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        minimumSize: const Size(80, 28)),
                    onPressed: () {
                      if (loadModel.editable != null &&
                          loadModel.editable == true) {
                        HomeProvider.instance.editButtonOnTap(model: loadModel);
                      } else {
                        showToast('Not eligible to edit!');
                      }
                    },
                    child: const BodyText(
                        text: AppString.edit, textColor: Colors.white))
              ],
            ),
          )
        ],
      ),
    );
  }
}
