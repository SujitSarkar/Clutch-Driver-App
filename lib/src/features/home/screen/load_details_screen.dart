import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/google_map_service.dart';
import '../../../../core/constants/static_list.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/normal_card.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/utils/validator.dart';
import '../../../../shared/date_time_picker.dart';
import '../../drawer/widget/address_details_widget.dart';
import '../../drawer/widget/load_details_widget.dart';
import '../provider/home_provider.dart';

class LoadDetailsScreen extends StatefulWidget {
  const LoadDetailsScreen({super.key, required this.fromPage});
  final String fromPage;

  @override
  State<LoadDetailsScreen> createState() => _LoadDetailsScreenState();
}

class _LoadDetailsScreenState extends State<LoadDetailsScreen> {
  final TextEditingController pickupDate = TextEditingController();
  final TextEditingController pickupTime = TextEditingController();
  final TextEditingController pickupTareWeight = TextEditingController();
  final TextEditingController pickupGrossWeight = TextEditingController();

  final TextEditingController deliveryDate = TextEditingController();
  final TextEditingController deliveryTime = TextEditingController();
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onInit();
    });
    super.initState();
  }

  @override
  void dispose() {
    pickupTareWeight.removeListener(calculateNett);
    pickupGrossWeight.removeListener(calculateNett);
    deliveryTareWeight.removeListener(calculateNett);
    deliveryGrossWeight.removeListener(calculateNett);
    super.dispose();
  }

  Future<void> onInit() async {
    final HomeProvider homeProvider = Provider.of(context, listen: false);
    await homeProvider.getLoadWeight();

    if (homeProvider.loadWeightModel!.data!.pickup!.pickupDate != null) {
      pickupDate.text = DateFormat('yyyy-MM-dd')
          .format(homeProvider.loadWeightModel!.data!.pickup!.pickupDate!);
    }
    pickupTime.text =
        homeProvider.loadWeightModel!.data!.pickup!.pickupTime ?? '';
    pickupTareWeight.text =
        homeProvider.loadWeightModel!.data!.pickup!.pickupTareWeight ?? '';
    pickupGrossWeight.text =
        homeProvider.loadWeightModel!.data!.pickup!.pickupGrossWeight ?? '';

    if (homeProvider.loadWeightModel!.data!.deli!.deliveryDate != null) {
      deliveryDate.text = DateFormat('yyyy-MM-dd')
          .format(homeProvider.loadWeightModel!.data!.deli!.deliveryDate!);
    }
    deliveryTime.text =
        homeProvider.loadWeightModel!.data!.deli!.deliveryTime ?? '';
    deliveryTareWeight.text =
        homeProvider.loadWeightModel!.data!.deli!.deliveryTareWeight ?? '';
    deliveryGrossWeight.text =
        homeProvider.loadWeightModel!.data!.deli!.deliveryGrossWeight ?? '';
    note.text = homeProvider.loadWeightModel!.data!.note!.noteByDriver ?? '';
  }

  void calculateNett() {
    final HomeProvider homeProvider = Provider.of(context, listen: false);
    homeProvider.debouncing(
      fn: () async {
        if (deliveryGrossWeight.text.isNotEmpty &&
            deliveryTareWeight.text.isNotEmpty) {
          calculatedNett.text =
              '${roundDouble(parseTextFieldDataToDouble(deliveryGrossWeight) - parseTextFieldDataToDouble(deliveryTareWeight))}';
        } else {
          calculatedNett.text =
              '${roundDouble(parseTextFieldDataToDouble(pickupGrossWeight) - parseTextFieldDataToDouble(pickupTareWeight))}';
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
          title: const TitleText(
              text: AppString.loadDetails, textColor: Colors.white),
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
        body: homeProvider.loadDetailsLoading
            ? const LoadingWidget(color: AppColor.primaryColor)
            : _bodyUI(homeProvider, size));
  }

  Widget _bodyUI(HomeProvider homeProvider, Size size) => Column(
        children: [
          ///Cancel & Save Button
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => popScreen(),
                    child: const BodyText(
                      text: AppString.cancel,
                      textColor: AppColor.disableColor,
                    )),
                TextButton(
                    onPressed: () async {
                      if (widget.fromPage != AppRouter.upcomingLoad) {
                        await saveButtonOnTap(homeProvider);
                      }
                    },
                    child: homeProvider.functionLoading
                        ? const LoadingWidget(color: AppColor.primaryColor)
                        : BodyText(
                            text: AppString.save,
                            textColor: widget.fromPage != AppRouter.upcomingLoad
                                ? AppColor.primaryColor
                                : AppColor.disableColor,
                          )),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(TextSize.pagePadding),
              child: Form(
                key: homeProvider.loadDetailsFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Details
                    if (homeProvider.selectedPendingLoadModel != null)
                      NormalCard(
                        padding: const EdgeInsets.all(12),
                        bgColor: AppColor.primaryColor.withOpacity(0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Load info
                            LoadDetailsWidget(
                                model: homeProvider.selectedPendingLoadModel!),
                            const SizedBox(height: TextSize.textGap),

                            ///Pickup Details
                            const BodyText(
                              text: AppString.pickup,
                              fontWeight: FontWeight.bold,
                            ),
                            AddressDetailsWidget(
                              model: homeProvider.selectedPendingLoadModel!,
                              destinationType: DestinationType.pickup,
                            ),
                            const SizedBox(height: TextSize.textGap),

                            ///Destination Details
                            const BodyText(
                              text: AppString.destination,
                              fontWeight: FontWeight.bold,
                            ),
                            AddressDetailsWidget(
                              model: homeProvider.selectedPendingLoadModel!,
                              destinationType: DestinationType.destibation,
                            ),

                            ///Driver Note
                            if (homeProvider
                                    .selectedPendingLoadModel?.noteForDriver !=
                                null)
                              BodyText(
                                  text:
                                      '${AppString.noteForDriver}: ${homeProvider.selectedPendingLoadModel?.noteForDriver ?? ''}'),
                            const SizedBox(height: TextSize.textGap),
                          ],
                        ),
                      ),
                    const SizedBox(height: TextSize.textGap),

                    ///Open Route in Google Map
                    SolidButton(
                        onTap: () async {
                          double originLat = double.parse(homeProvider
                                  .selectedPendingLoadModel?.pickup?.lat ??
                              "0.0");
                          double originLong = double.parse(homeProvider
                                  .selectedPendingLoadModel?.pickup?.lon ??
                              "0.0");
                          double destLat = double.parse(homeProvider
                                  .selectedPendingLoadModel?.destination?.lat ??
                              "0.0");
                          double destLong = double.parse(homeProvider
                                  .selectedPendingLoadModel?.destination?.lon ??
                              "0.0");
                          await openGoogleMapsWithLatLong(
                              originLat: originLat,
                              originLong: originLong,
                              destLat: destLat,
                              destLong: destLong);
                        },
                        child:
                            const ButtonText(text: 'Open Route in Google Map')),
                    const SizedBox(height: TextSize.pagePadding),

                    if (widget.fromPage != AppRouter.upcomingLoad)
                      Column(
                        children: [
                          ///Note
                          TextFormFieldWidget(
                            controller: note,
                            labelText: AppString.note,
                            hintText: AppString.note,
                            minLine: 2,
                            maxLine: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: TextSize.textGap),

                          ///Pickup Date
                          TextFormFieldWidget(
                            controller: pickupDate,
                            labelText: AppString.pickupDate,
                            hintText: AppString.pickupDate,
                            textInputType: TextInputType.number,
                            required: true,
                            readOnly: true,
                            onTap: () async {
                              DateTime? dateTime = await pickDate(context);
                              if (dateTime != null) {
                                pickupDate.text =
                                    DateFormat('yyyy-MM-dd').format(dateTime);
                              }
                            },
                          ),
                          const SizedBox(height: TextSize.textGap),

                          ///Pickup time
                          TextFormFieldWidget(
                            controller: pickupTime,
                            labelText: AppString.pickupTime,
                            hintText: AppString.pickupTime,
                            required: true,
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? timeOfDay = await pickTime(context);
                              if (timeOfDay != null) {
                                pickupTime.text = formatTimeOfDay(timeOfDay);
                              }
                            },
                          ),
                          const SizedBox(height: TextSize.textGap),

                          ///Pickup Tare weight
                          TextFormFieldWidget(
                            controller: pickupTareWeight,
                            labelText: AppString.pickupTareWeight,
                            hintText: AppString.pickupTareWeight,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                          ),
                          const SizedBox(height: TextSize.textGap),

                          ///Pickup Gross weight
                          TextFormFieldWidget(
                            controller: pickupGrossWeight,
                            labelText: AppString.pickupGrossWeight,
                            hintText: AppString.pickupGrossWeight,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                          ),
                          const SizedBox(height: TextSize.textGap),
                          SolidButton(
                              onTap: () {
                                pushTo(AppRouter.loadAttachment,
                                    arguments: StaticList.loadWeightType.first);
                              },
                              backgroundColor: AppColor.disableColor,
                              child: ButtonText(
                                  text:
                                      '${AppString.upload} (${homeProvider.loadWeightModel?.data?.pickup?.pickupAttachments?.length})')),
                          const SizedBox(height: TextSize.pagePadding),

                          ///Delivery Date
                          TextFormFieldWidget(
                            controller: deliveryDate,
                            labelText: AppString.deliveryDate,
                            hintText: AppString.deliveryDate,
                            required: true,
                            readOnly: true,
                            onTap: () async {
                              DateTime? dateTime = await pickDate(context);
                              if (dateTime != null) {
                                deliveryDate.text =
                                    DateFormat('yyyy-MM-dd').format(dateTime);
                              }
                            },
                          ),
                          const SizedBox(height: TextSize.textGap),
                          //Delivery Time
                          TextFormFieldWidget(
                            controller: deliveryTime,
                            labelText: AppString.deliveryTime,
                            hintText: AppString.deliveryTime,
                            required: true,
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? timeOfDay = await pickTime(context);
                              if (timeOfDay != null) {
                                deliveryTime.text = formatTimeOfDay(timeOfDay);
                              }
                            },
                          ),
                          const SizedBox(height: TextSize.textGap),

                          ///Delivery Gross Weight
                          TextFormFieldWidget(
                            controller: deliveryGrossWeight,
                            labelText: AppString.deliveryGrossWeight,
                            hintText: AppString.deliveryGrossWeight,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            required: true,
                          ),
                          const SizedBox(height: TextSize.textGap),

                          ///Delivery Tare Weight
                          TextFormFieldWidget(
                            controller: deliveryTareWeight,
                            labelText: AppString.deliveryTareWeight,
                            hintText: AppString.deliveryTareWeight,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            required: true,
                          ),
                          const SizedBox(height: TextSize.textGap),

                          SolidButton(
                              onTap: () {
                                pushTo(AppRouter.loadAttachment,
                                    arguments: StaticList.loadWeightType.last);
                              },
                              backgroundColor: AppColor.disableColor,
                              child: ButtonText(
                                  text:
                                      '${AppString.upload} (${homeProvider.loadWeightModel?.data?.deli?.deliveryAttachments?.length})')),
                          const SizedBox(height: TextSize.pagePadding),

                          ///Calculated Nett
                          Row(
                            children: [
                              const BodyText(
                                  text: '${AppString.calculatedNett}:'),
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
                              onTap: () async =>
                                  await completeButtonOnTap(homeProvider),
                              child: homeProvider.functionLoading
                                  ? const LoadingWidget()
                                  : const ButtonText(
                                      text: AppString.completeDelivery)),
                          const SizedBox(height: TextSize.pagePadding),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Future<void> saveButtonOnTap(HomeProvider homeProvider) async {
    final body = {
      'load_id': homeProvider.selectedPendingLoadModel?.id,
      'pickup_time': pickupTime.text,
      'pickup_date': pickupDate.text,
      'pickup_tare_weight': pickupTareWeight.text,
      'pickup_gross_weight': pickupGrossWeight.text,
      'pickup_net_weight':
          homeProvider.loadWeightModel?.data?.pickup?.pickupNetWeight,
      'delivery_time': deliveryTime.text,
      'delivery_date': deliveryDate.text,
      'delivery_tare_weight': deliveryTareWeight.text,
      'delivery_gross_weight': deliveryGrossWeight.text,
      'delivery_net_weight':
          homeProvider.loadWeightModel?.data?.deli?.deliveryNetWeight,
      'note_by_driver': note.text.trim(),
      'status': 3,
    };
    await homeProvider.saveOrCompleteLoadWeight(body: body);
    await onInit();
  }

  Future<void> completeButtonOnTap(HomeProvider homeProvider) async {
    if (!homeProvider.loadDetailsFormKey.currentState!.validate()) {
      return;
    }
    final body = {
      'load_id': homeProvider.selectedPendingLoadModel?.id,
      'pickup_time': pickupTime.text,
      'pickup_date': pickupDate.text,
      'pickup_tare_weight': pickupTareWeight.text,
      'pickup_gross_weight': pickupGrossWeight.text,
      'pickup_net_weight':
          homeProvider.loadWeightModel?.data?.pickup?.pickupNetWeight,
      'delivery_time': deliveryTime.text,
      'delivery_date': deliveryDate.text,
      'delivery_tare_weight': deliveryTareWeight.text,
      'delivery_gross_weight': deliveryGrossWeight.text,
      'delivery_net_weight':
          homeProvider.loadWeightModel?.data?.deli?.deliveryNetWeight,
      'note_by_driver': note.text.trim(),
      'status': 4,
    };
    await homeProvider.saveOrCompleteLoadWeight(body: body);
  }
}
