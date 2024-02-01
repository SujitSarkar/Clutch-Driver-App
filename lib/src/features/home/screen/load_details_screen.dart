import 'package:clutch_driver_app/core/constants/app_string.dart';
import 'package:clutch_driver_app/core/router/app_router.dart';
import 'package:clutch_driver_app/core/widgets/solid_button.dart';
import 'package:clutch_driver_app/core/widgets/text_field_widget.dart';
import 'package:clutch_driver_app/core/widgets/text_widget.dart';
import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/utils/google_map_service.dart';
import '../../../../core/utils/validator.dart';
import '../provider/home_provider.dart';

class LoadDetailsScreen extends StatefulWidget {
  const LoadDetailsScreen({super.key});

  @override
  State<LoadDetailsScreen> createState() => _LoadDetailsScreenState();
}

class _LoadDetailsScreenState extends State<LoadDetailsScreen> {
  final TextEditingController pickupTareWeight = TextEditingController();
  final TextEditingController pickupGrossWeight = TextEditingController();
  final TextEditingController deliveryTareWeight = TextEditingController();
  final TextEditingController deliveryGrossWeight = TextEditingController();
  final TextEditingController note = TextEditingController();
  final TextEditingController calculatedNett = TextEditingController();

  @override
  void initState() {
    pickupTareWeight.addListener(calculateNett);
    pickupGrossWeight.addListener(calculateNett);
    deliveryTareWeight.addListener(calculateNett);
    deliveryGrossWeight.addListener(calculateNett);
    super.initState();
  }

  void calculateNett() {
    final HomeProvider homeProvider = Provider.of(context, listen: false);
    homeProvider.debouncing(
      fn: () async {
        if (deliveryGrossWeight.text.isNotEmpty &&
            deliveryTareWeight.text.isNotEmpty) {
          calculatedNett.text =
              '${parseTextFieldDataToDouble(deliveryGrossWeight) - parseTextFieldDataToDouble(deliveryTareWeight)}';
        } else {
          calculatedNett.text =
              '${parseTextFieldDataToDouble(pickupTareWeight) - parseTextFieldDataToDouble(pickupGrossWeight)}';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title:
              const TitleText(text: AppString.details, textColor: Colors.white),
          titleSpacing: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: TextSize.pagePadding),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, AppRouter.profile),
                child: const CircleAvatar(
                    child: Icon(Icons.person, color: AppColor.primaryColor)),
              ),
            )
          ],
        ),
        body: _bodyUI(homeProvider, size, context));
  }

  Widget _bodyUI(HomeProvider homeProvider, Size size, BuildContext context) =>
      Column(
        children: [
          ///Cancel & Save Button
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const BodyText(
                      text: AppString.cancel,
                      textColor: AppColor.disableColor,
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name == AppRouter.pendingLoad);
                    },
                    child: const BodyText(
                      text: AppString.save,
                      textColor: AppColor.primaryColor,
                    )),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.all(TextSize.pagePadding),
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
                    onTap: () async {
                      await openGoogleMaps(
                          23.829315406238095, 90.42004168093032);
                    },
                    child: const ButtonText(text: 'Open Route in Google Map')),
                const SizedBox(height: TextSize.pagePadding),

                ///Note
                TextFormFieldWidget(
                  controller: note,
                  labelText: AppString.note,
                  hintText: 'Enter ${AppString.note}',
                  minLine: 3,
                  maxLine: 5,
                ),
                const SizedBox(height: TextSize.textGap),

                ///Pickup Weight
                TextFormFieldWidget(
                  controller: pickupTareWeight,
                  labelText: AppString.pickupTareWeight,
                  hintText: 'Enter ${AppString.pickupTareWeight}',
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: TextSize.textGap),
                TextFormFieldWidget(
                  controller: pickupGrossWeight,
                  labelText: AppString.pickupGrossWeight,
                  hintText: 'Enter ${AppString.pickupGrossWeight}',
                  textInputType: TextInputType.number,
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
                  controller: deliveryGrossWeight,
                  labelText: AppString.deliveryGrossWeight,
                  hintText: 'Enter ${AppString.deliveryGrossWeight}',
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: TextSize.textGap),
                TextFormFieldWidget(
                  controller: deliveryTareWeight,
                  labelText: AppString.deliveryTareWeight,
                  hintText: 'Enter ${AppString.deliveryTareWeight}',
                  textInputType: TextInputType.number,
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
                        controller: calculatedNett,
                        labelText: AppString.calculatedNett,
                        hintText: AppString.calculatedNett,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TextSize.pagePadding),

                ///Complete Delivery Button
                SolidButton(
                    onTap: () {},
                    child: const ButtonText(text: AppString.completeDelivery)),
                const SizedBox(height: TextSize.pagePadding),
              ],
            ),
          ),
        ],
      );
}
