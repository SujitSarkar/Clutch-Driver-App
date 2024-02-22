import 'package:flutter/Material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/static_list.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/normal_card.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../src/features/home/model/load_model.dart';
import '../../../../core/router/page_navigator.dart';
import '../../drawer/screen/prestart_checklist_screen.dart';

class LoadTile extends StatelessWidget {
  const LoadTile({super.key,required this.loadType, required this.loadModel});
  final String loadType;
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
                BodyText(text: '${AppString.contact}: ${loadModel.contractNo}'),
                BodyText(text: '${AppString.load}: ${loadModel.loadRef}'),
                BodyText(text: '${AppString.pickup}: ${loadModel.pickup?.state}'),
                BodyText(text: '${AppString.destination}: ${loadModel.destination?.country}'),
                BodyText(text: '${AppString.commodity}: ${loadModel.commodity}'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BodyText(text: '${AppString.quantity}: ${loadModel.qty}'),
                const SizedBox(height: 30),
                loadType == StaticList.loadTypeList.first
                    ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      minimumSize: const Size(80, 28)),
                    onPressed: () {
                       pushTo(AppRouter.preStartChecklist,
                           arguments: const PreStartChecklistScreen(fromPage: AppRouter.pendingLoad));
                    },
                    child: const BodyText(text: AppString.start, textColor: Colors.white))
                    : loadType == StaticList.loadTypeList.last
                    ? const Icon(Icons.check_circle_outline_outlined,color: AppColor.enableColor)
                    : const SizedBox.shrink()
              ],
            ),
          )
        ],
      ),
    );
  }
}
