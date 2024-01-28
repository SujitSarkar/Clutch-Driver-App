import 'package:clutch_driver_app/core/constants/app_color.dart';
import 'package:clutch_driver_app/core/constants/app_string.dart';
import 'package:clutch_driver_app/core/router/app_router.dart';
import 'package:clutch_driver_app/core/widgets/normal_card.dart';
import 'package:clutch_driver_app/core/widgets/text_widget.dart';
import 'package:flutter/Material.dart';

class LoadTile extends StatelessWidget {
  const LoadTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, AppRouter.loadDetails);
      },
      child: NormalCard(
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor),
                      onPressed: () {},
                      child:
                          const BodyText(text: AppString.start, textColor: Colors.white))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
