import 'package:intl/intl.dart';
import '../../../../core/constants/static_list.dart';
import '../../../../core/widgets/loading_widget.dart';
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
import '../../../../shared/date_time_picker.dart';
import '../provider/home_provider.dart';

class LoadDetailsScreen extends StatefulWidget {
  const LoadDetailsScreen({super.key});

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
                    onPressed: () async => await saveButtonOnTap(homeProvider),
                    child: homeProvider.functionLoading
                        ? const LoadingWidget(color: AppColor.primaryColor)
                        : const BodyText(
                            text: AppString.save,
                            textColor: AppColor.primaryColor,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodyText(text: '${AppString.contact}: ${homeProvider.selectedPendingLoadModel?.contractNo??''}'),
                        BodyText(text: '${AppString.quantity}: ${homeProvider.selectedPendingLoadModel?.qty??'0'}'),
                      ],
                    ),
                    BodyText(text: '${AppString.load}: ${homeProvider.selectedPendingLoadModel?.loadRef??''}'),
                    BodyText(text: '${AppString.pickup}: ${homeProvider.selectedPendingLoadModel?.pickup?.country??''}'),
                    BodyText(text: '${AppString.destination}: ${homeProvider.selectedPendingLoadModel?.destination?.country??''}'),
                    BodyText(text: '${AppString.commodity}: ${homeProvider.selectedPendingLoadModel?.commodity??''}'),
                    BodyText(text: '${AppString.noteForDriver}: ${homeProvider.selectedPendingLoadModel?.noteForDriver??''}'),
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
                    TextFormFieldWidget(
                      controller: pickupTareWeight,
                      labelText: AppString.pickupTareWeight,
                      hintText: AppString.pickupTareWeight,
                      textInputType: TextInputType.number,
                      required: true,
                    ),
                    const SizedBox(height: TextSize.textGap),
                    TextFormFieldWidget(
                      controller: pickupGrossWeight,
                      labelText: AppString.pickupGrossWeight,
                      hintText: AppString.pickupGrossWeight,
                      textInputType: TextInputType.number,
                      required: true,
                    ),
                    const SizedBox(height: TextSize.textGap),
                    SolidButton(
                        onTap: () {
                          pushTo(AppRouter.loadAttachment,
                              arguments: StaticList.loadWeightType.first);
                        },
                        backgroundColor: AppColor.disableColor,
                        child: const ButtonText(text: AppString.upload)),
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

                    ///Delivery Weight
                    TextFormFieldWidget(
                      controller: deliveryGrossWeight,
                      labelText: AppString.deliveryGrossWeight,
                      hintText: AppString.deliveryGrossWeight,
                      textInputType: TextInputType.number,
                      required: true,
                    ),
                    const SizedBox(height: TextSize.textGap),
                    TextFormFieldWidget(
                      controller: deliveryTareWeight,
                      labelText: AppString.deliveryTareWeight,
                      hintText: AppString.deliveryTareWeight,
                      textInputType: TextInputType.number,
                      required: true,
                    ),
                    const SizedBox(height: TextSize.textGap),

                    SolidButton(
                        onTap: () {
                          pushTo(AppRouter.loadAttachment,
                              arguments: StaticList.loadWeightType.last);
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
                        onTap: () async =>
                            await completeButtonOnTap(homeProvider),
                        child: homeProvider.functionLoading
                            ? const LoadingWidget()
                            : const ButtonText(
                                text: AppString.completeDelivery)),
                    const SizedBox(height: TextSize.pagePadding),
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
