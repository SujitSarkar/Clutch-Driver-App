import 'package:clutch_driver_app/core/constants/app_string.dart';
import 'package:clutch_driver_app/core/widgets/text_widget.dart';
import 'package:clutch_driver_app/src/features/home/provider/home_provider.dart';
import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/solid_button.dart';

class LoadDateRangePickerWidget extends StatelessWidget {
  const LoadDateRangePickerWidget({super.key, required this.loadType});
  final String loadType;

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final double height = MediaQuery.of(context).size.height;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: height * .7,
        padding: const EdgeInsets.only(top: 12),
        decoration: const BoxDecoration(
            color: AppColor.cardColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    )),
                const SizedBox(height: 16),
                SfDateRangePicker(
                  maxDate: DateTime.now().add(const Duration(days: 1825)),
                  onSelectionChanged: homeProvider.dateRangeOnSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  todayHighlightColor: AppColor.primaryColor,
                  headerStyle: DateRangePickerHeaderStyle(
                      textStyle: TextStyle(color: AppColor.textColor)),
                  yearCellStyle: DateRangePickerYearCellStyle(
                      textStyle: TextStyle(color: AppColor.textColor),
                      todayTextStyle: TextStyle(color: AppColor.textColor)),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: TextStyle(color: AppColor.textColor))),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: TextStyle(color: AppColor.textColor),
                      todayTextStyle: TextStyle(color: AppColor.textColor)),
                  selectionTextStyle: const TextStyle(color: Colors.white),
                  rangeTextStyle: const TextStyle(color: AppColor.primaryColor),
                  selectionColor: AppColor.primaryColor,
                  startRangeSelectionColor: AppColor.primaryColor,
                  endRangeSelectionColor: AppColor.primaryColor,
                  rangeSelectionColor: AppColor.primaryColor.withOpacity(0.1),
                  initialSelectedRange: PickerDateRange(
                      homeProvider.filterStartDate,
                      homeProvider.filterEndDate),
                ),
                const SizedBox(height: 20),
                SolidButton(
                    onTap: () async {
                      setState(() {});
                      await homeProvider.dateFilterButtonOnTap(loadType: loadType);
                    },
                    child: homeProvider.functionLoading
                        ? const LoadingWidget()
                        : const ButtonText(text: AppString.applyDateRange)),
              ]),
        ),
      );
    });
  }
}
