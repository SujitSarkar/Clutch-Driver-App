import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../core/widgets/truck_dropdown_button.dart';
import '../../../../shared/date_time_picker.dart';
import '../provider/drawer_menu_provider.dart';
import '../widget/additional_fee_checkbox_widget.dart';

class DailyLogbookScreen extends StatefulWidget {
  const DailyLogbookScreen({super.key});

  @override
  State<DailyLogbookScreen> createState() => _DailyLogbookScreenState();
}

class _DailyLogbookScreenState extends State<DailyLogbookScreen> {
  final TextEditingController startTime = TextEditingController();
  final TextEditingController endTime = TextEditingController();
  final TextEditingController startingOdometerReading = TextEditingController();
  final TextEditingController endingOdometerReading = TextEditingController();
  final TextEditingController note = TextEditingController();

  @override
  void initState() {
    final DrawerMenuProvider drawerMenuProvider = Provider.of(context,listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async{
      await drawerMenuProvider.getPreStartChecks(fromPage: 'drawer');
      await drawerMenuProvider.getDailySummary();
      ///Set data to textField
      startTime.text = drawerMenuProvider.preStartDataModel!.data!.logStartTime??'';
      endTime.text = drawerMenuProvider.preStartDataModel!.data!.logEndTime??'';
      startingOdometerReading.text = drawerMenuProvider.preStartDataModel!.data!.startOdoReading??'';
      endingOdometerReading.text = drawerMenuProvider.preStartDataModel!.data!.endOdoReading??'';
      note.text = drawerMenuProvider.preStartDataModel!.data!.logNotes??'';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DrawerMenuProvider drawerMenuProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const TitleText(
              text: AppString.dailyLogbook, textColor: Colors.white),
          titleSpacing: 8,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: TextSize.pagePadding),
              child: InkWell(
                onTap: () =>  pushTo(AppRouter.profile),
                child: const CircleAvatar(
                    child: Icon(Icons.person, color: AppColor.primaryColor)),
              ),
            )
          ],
        ),
        body: drawerMenuProvider.initialLoading
            ? const LoadingWidget(color: AppColor.primaryColor)
            : _bodyUI(drawerMenuProvider,size));
  }

  Widget _bodyUI(DrawerMenuProvider drawerMenuProvider,Size size) =>
      Column(children: [
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
                  onPressed: () async{
                    await drawerMenuProvider.saveDailyLogBook(
                        endTime: endTime.text.trim(),
                        endingOdoMeterReading: endingOdometerReading.text.trim(),
                        notes: note.text.trim());
                  },
                  child: drawerMenuProvider.functionLoading
                      ? const LoadingWidget(color: AppColor.primaryColor)
                      : const BodyText(
                    text: AppString.save,
                    textColor: AppColor.primaryColor,
                  )),
            ],
          ),
        ),

        if(drawerMenuProvider.preStartDataModel!=null &&
            drawerMenuProvider.dailySummaryModel!=null)
        Expanded(
            child: ListView(
          padding: const EdgeInsets.all(TextSize.pagePadding),
          children: [
            ///Truck dropdown
            TruckDropdown(
                items: drawerMenuProvider.ownTruckList,
                selectedValue: drawerMenuProvider.selectedOwnTruck,
                hintText: 'Select Truck',
                buttonHeight: 35,
                onChanged: (value) {
                  drawerMenuProvider.changeOwnTruck(value:value,fromPage: AppRouter.dailyLogbook);
                }),
            const SizedBox(height: TextSize.textGap),

            ///Start time
            TextFormFieldWidget(
              controller: startTime,
              labelText: AppString.startTime,
              hintText: AppString.startTime,
              readOnly: true,
            ),
            const SizedBox(height: TextSize.textGap),

            ///End time
            TextFormFieldWidget(
              controller: endTime,
              labelText: AppString.endTime,
              hintText: AppString.endTime,
              readOnly: true,
              onTap: ()async{
                TimeOfDay? timeOfDay = await pickTime(context);
                if(timeOfDay!=null){
                  endTime.text = formatTimeOfDay(timeOfDay);
                }
              },
            ),
            const SizedBox(height: TextSize.textGap),

            ///Starting Odometer Reading
            TextFormFieldWidget(
              controller: startingOdometerReading,
              labelText: AppString.startingOdometerReading,
              hintText: AppString.startingOdometerReading,
              readOnly: true,
            ),
            const SizedBox(height: TextSize.textGap),

            ///Ending Odometer Reading
            TextFormFieldWidget(
              controller: endingOdometerReading,
              labelText: AppString.endingOdometerReading,
              hintText: AppString.endingOdometerReading,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: TextSize.textFieldGap),

            Row(
              children: [
                const BodyText(text: '${AppString.totalLoadComplete} :'),
                Expanded(child: BodyText(text: '${drawerMenuProvider.dailySummaryModel?.data?.totalLoads}', textAlign: TextAlign.end))
              ],
            ),
            const SizedBox(height: TextSize.textGap),
            Row(
              children: [
                const BodyText(text: '${AppString.totalTonnageDone} :'),
                Expanded(
                    child: BodyText(text: '${drawerMenuProvider.dailySummaryModel?.data?.totalqty}', textAlign: TextAlign.end))
              ],
            ),
            const SizedBox(height: TextSize.textGap),
            Row(
              children: [
                const BodyText(text: '${AppString.totalKmDriven} :'),
                Expanded(child: BodyText(text: '${drawerMenuProvider.dailySummaryModel?.data?.totalkms}', textAlign: TextAlign.end))
              ],
            ),
            const SizedBox(height: TextSize.textFieldGap),

            ///Fatigue Management Checklist Button
            InkWell(
                onTap:()=> pushTo(AppRouter.fatigueManagementChecklist),
                child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SmallText(
                          text: 'Complete ${AppString.fatigueManagementChecklist} >',
                          textColor: AppColor.primaryColor,
                          textAlign: TextAlign.end),
                    ))),
            const SizedBox(height: TextSize.textFieldGap),

            ///Additional Fees
            const BodyText(text: AppString.additionalFee,fontWeight: FontWeight.bold),
            const Divider(),
            const AdditionalFeeCheckboxWidget(),
            const SizedBox(height: TextSize.textFieldGap),

            ///Note
            TextFormFieldWidget(
              controller: note,
              labelText: AppString.note,
              hintText: AppString.note,
              minLine: 3,
              maxLine: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: TextSize.textFieldGap),
          ],
        ))
      ]);
}
