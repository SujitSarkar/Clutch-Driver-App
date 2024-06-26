import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/static_list.dart';
import '../../../../core/widgets/normal_card.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../src/features/home/model/load_model.dart';
import '../provider/home_provider.dart';

class UpcomingLoadTile extends StatelessWidget {
  const UpcomingLoadTile({super.key, required this.loadModel});

  final LoadDataModel loadModel;

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) => homeProvider.loadDecline(
              loadId: loadModel.id ?? 0, loadType: StaticList.loadTypeList[1]),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          label: AppString.declineLoad,
        ),
      ]),
      child: NormalCard(
        padding: const EdgeInsets.all(12),
        bgColor: AppColor.primaryColor.withOpacity(0.1),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                      text:
                          '${AppString.contact}: ${loadModel.contractNo ?? ''}'),
                  BodyText(
                      text: '${AppString.load}: ${loadModel.loadRef ?? ''}'),
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
            Column(
              children: [
                BodyText(
                    text: '${AppString.quantity}: ${loadModel.qty ?? '0'}',
                    textAlign: TextAlign.end),
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
                      HomeProvider.instance
                          .previewButtonOnTap(model: loadModel);
                    },
                    child: const BodyText(
                        text: AppString.preview, textColor: Colors.white))
              ],
            )
          ],
        ),
      ),
    );
  }
}
