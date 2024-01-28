import 'package:clutch_driver_app/core/constants/app_string.dart';
import 'package:clutch_driver_app/core/router/app_router.dart';
import 'package:clutch_driver_app/core/widgets/solid_button.dart';
import 'package:clutch_driver_app/core/widgets/text_field_widget.dart';
import 'package:clutch_driver_app/core/widgets/text_widget.dart';
import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../provider/home_provider.dart';

class LoadDetailsScreen extends StatelessWidget {
  const LoadDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: TextSize.pagePadding),
              child: InkWell(
                onTap: ()=> Navigator.pushNamed(context, AppRouter.profile),
                child: const CircleAvatar(
                    child: Icon(Icons.person, color: AppColor.primaryColor)),
              ),
            )
          ],
        ),
        drawer: const Drawer(child: AppDrawer()),
        body: _bodyUI(homeProvider, size, context));
  }

  Widget _bodyUI(HomeProvider homeProvider, Size size, BuildContext context) =>
      Column(
        children: [
          ///Cancel Button
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const BodyText(
                    text: AppString.cancel,
                    textColor: AppColor.primaryColor,
                  )),
            ),
          ),

          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: TextSize.pagePadding),
              children: [
                ///Details
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(text: '${AppString.contact}: CBC34534'),
                    BodyText(text: '${AppString.quantity}: 1P'),
                  ],
                ),
                const BodyText(text: '${AppString.load}: MB657'),
                const BodyText(text: '${AppString.pickup}: Laverton North'),
                const BodyText(text: '${AppString.destination}: Calac'),
                const BodyText(text: '${AppString.commodity}: Fertilizer'),
                const SizedBox(height: TextSize.textGap),

                ///Open Route in Google Map
                SolidButton(
                    onTap: () {},
                    child: const ButtonText(text: 'Open Route in Google Map')),
                const SizedBox(height: TextSize.pagePadding),

                ///Note
                TextFormFieldWidget(
                  controller: homeProvider.note,
                  labelText: AppString.note,
                  hintText: 'Enter ${AppString.note}',
                  minLine: 3,
                  maxLine: 5,
                ),
                const SizedBox(height: TextSize.textGap),

                ///Pickup Weight
                TextFormFieldWidget(
                  controller: homeProvider.pickupTareWeight,
                  labelText: AppString.pickupTareWeight,
                  hintText: 'Enter ${AppString.pickupTareWeight}',
                ),
                const SizedBox(height: TextSize.textGap),
                TextFormFieldWidget(
                  controller: homeProvider.pickupGrossWeight,
                  labelText: AppString.pickupGrossWeight,
                  hintText: 'Enter ${AppString.pickupGrossWeight}',
                ),
                const SizedBox(height: TextSize.textGap),
                SolidButton(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.loadAttachment);
                    },
                    backgroundColor: AppColor.disableColor,
                    child: const ButtonText(text: AppString.upload)),
                const SizedBox(height: TextSize.pagePadding),

                ///Delivery Weight
                TextFormFieldWidget(
                  controller: homeProvider.deliveryTareWeight,
                  labelText: AppString.deliveryTareWeight,
                  hintText: 'Enter ${AppString.deliveryTareWeight}',
                ),
                const SizedBox(height: TextSize.textGap),
                TextFormFieldWidget(
                  controller: homeProvider.deliveryGrossWeight,
                  labelText: AppString.deliveryGrossWeight,
                  hintText: 'Enter ${AppString.deliveryGrossWeight}',
                ),
                const SizedBox(height: TextSize.textGap),
                SolidButton(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.loadAttachment);
                    },
                    backgroundColor: AppColor.disableColor,
                    child: const ButtonText(text: AppString.upload)),
                const SizedBox(height: TextSize.pagePadding),

                ///Calculated Nett
                Row(
                  children: [
                    const BodyText(text: '${AppString.calculatedNett}:'),
                    const SizedBox(width: TextSize.pagePadding),
                    Expanded(
                      child: TextFormFieldWidget(
                          controller: homeProvider.calculatedNett,
                          labelText: AppString.calculatedNett,
                          hintText: 'Enter ${AppString.calculatedNett}'),
                    ),
                  ],
                ),
                const SizedBox(height: TextSize.pagePadding),
                SolidButton(
                    onTap: () {},
                    child: const ButtonText(text: AppString.complete)),
                const SizedBox(height: TextSize.pagePadding),
              ],
            ),
          ),
        ],
      );
}
