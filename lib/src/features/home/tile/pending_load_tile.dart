import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:flutter/Material.dart';
import '../../../../src/features/home/provider/home_provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/normal_card.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../src/features/home/model/load_model.dart';

class PendingLoadTile extends StatelessWidget {
  const PendingLoadTile({super.key, required this.loadModel});
  final LoadDataModel loadModel;

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) => homeProvider.loadDecline(loadId: loadModel.id??0),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          label: 'Decline load',
        ),
      ]),
      child: NormalCard(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BodyText(text: '${AppString.quantity}: ${loadModel.qty??'0'}'),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          minimumSize: const Size(80, 28)),
                      onPressed: () {
                        HomeProvider.instance
                            .pendingLoadStartButtonOnTap(model: loadModel);
                      },
                      child: const BodyText(
                          text: AppString.start, textColor: Colors.white))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
