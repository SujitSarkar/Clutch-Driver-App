import 'package:clutch_driver_app/core/constants/app_color.dart';
import 'package:clutch_driver_app/core/constants/app_string.dart';
import 'package:clutch_driver_app/core/router/app_router.dart';
import 'package:clutch_driver_app/core/widgets/normal_card.dart';
import 'package:clutch_driver_app/core/widgets/text_widget.dart';
import 'package:flutter/Material.dart';

class LoadTile extends StatelessWidget {
  const LoadTile({super.key,required this.loadType});
  final String loadType;

  @override
  Widget build(BuildContext context) {
    return NormalCard(
      padding: const EdgeInsets.all(12),
      bgColor: AppColor.primaryColor.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(text: '${AppString.contact}: CBC34534'),
                BodyText(text: '${AppString.load}: MB657'),
                BodyText(text: '${AppString.pickup}: Laverton North'),
                BodyText(text: '${AppString.destination}: Calac'),
                BodyText(text: '${AppString.commodity}: Fertilizer'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const BodyText(text: '${AppString.quantity}: 1P'),
                const SizedBox(height: 30),
                loadType == AppString.loadTypeList.first
                    ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      minimumSize: const Size(80, 28)),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.preStartChecklist);
                    },
                    child: const BodyText(text: AppString.start, textColor: Colors.white))
                    : loadType == AppString.loadTypeList.last
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
