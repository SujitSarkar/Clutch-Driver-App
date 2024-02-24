import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/page_navigator.dart';
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
                onTap: () => pushTo(AppRouter.profile),
                child: const CircleAvatar(
                    child: Icon(Icons.person, color: AppColor.primaryColor)),
              ),
            )
          ],
        ),
        body: _bodyUI(homeProvider, size));
  }

  Widget _bodyUI(HomeProvider homeProvider, Size size) =>
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(text: '${AppString.contact}: ${homeProvider.selectedPendingLoadModel?.contractNo}'),
                    BodyText(text: '${AppString.quantity}: ${homeProvider.selectedPendingLoadModel?.qty}'),
                  ],
                ),
                BodyText(text: '${AppString.load}: ${homeProvider.selectedPendingLoadModel?.loadRef}'),
                BodyText(text: '${AppString.pickup}: ${homeProvider.selectedPendingLoadModel?.pickup?.country}'),
                BodyText(text: '${AppString.destination}: ${homeProvider.selectedPendingLoadModel?.destination?.country}'),
                BodyText(text: '${AppString.commodity}: ${homeProvider.selectedPendingLoadModel?.commodity}'),
                const SizedBox(height: TextSize.textGap),

                ///Open Route in Google Map
                SolidButton(
                    onTap: () async {
                      // await openGoogleMaps(
                      //     23.829315406238095, 90.42004168093032);
                    },
                    child: const ButtonText(text: 'Open Route in Google Map')),
                const SizedBox(height: TextSize.pagePadding),

                ///Note
                TextFormFieldWidget(
                  controller: note,
                  labelText: AppString.note,
                  hintText: AppString.note,
                  minLine: 3,
                  maxLine: 5,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: TextSize.textGap),

                ///Pickup Weight
                TextFormFieldWidget(
                  controller: pickupTareWeight,
                  labelText: AppString.pickupTareWeight,
                  hintText: AppString.pickupTareWeight,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: TextSize.textGap),
                TextFormFieldWidget(
                  controller: pickupGrossWeight,
                  labelText: AppString.pickupGrossWeight,
                  hintText: AppString.pickupGrossWeight,
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
                  hintText: AppString.deliveryGrossWeight,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: TextSize.textGap),
                TextFormFieldWidget(
                  controller: deliveryTareWeight,
                  labelText: AppString.deliveryTareWeight,
                  hintText: AppString.deliveryTareWeight,
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
