import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../core/widgets/truck_dropdown_button.dart';
import '../../../../shared/date_time_picker.dart';
import '../provider/drawer_menu_provider.dart';
import '../widget/pre_start_checkbox_widget.dart';

class PreStartChecklistScreen extends StatefulWidget {
  const PreStartChecklistScreen({super.key, required this.fromPage});
  final String fromPage;

  @override
  State<PreStartChecklistScreen> createState() => _PreStartChecklistScreenState();
}

class _PreStartChecklistScreenState extends State<PreStartChecklistScreen> {
  final TextEditingController startTime = TextEditingController();
  final TextEditingController startingOdometerReading = TextEditingController();
  final TextEditingController note = TextEditingController();
  ///You have to fillup this form first

  @override
  void initState() {
    final DrawerMenuProvider drawerMenuProvider = Provider.of(context,listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async{
      await drawerMenuProvider.getPreStartChecks(fromPage: widget.fromPage);
      ///Set data to textField
      startingOdometerReading.text = drawerMenuProvider.preStartDataModel?.data?.startOdoReading??'';
      startTime.text = drawerMenuProvider.preStartDataModel?.data?.logStartTime??'';
      note.text = drawerMenuProvider.preStartDataModel?.data?.preStartNotes??'';
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
              text: AppString.preStartChecklist, textColor: Colors.white),
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
            : _bodyUI(drawerMenuProvider, size));
  }

  Widget _bodyUI(DrawerMenuProvider drawerMenuProvider, Size size) =>
      Column(children: [
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
                  onPressed: () async{
                    await drawerMenuProvider.savePreStartCheckList(
                        startTime: startTime.text.trim(),
                        odoMeterReading: startingOdometerReading.text.trim(),
                        notes: note.text.trim(),
                      fromPage: widget.fromPage
                    );
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
                const SizedBox(height: TextSize.textFieldGap),

                ///Starting Odometer Reading
                TextFormFieldWidget(
                  controller: startingOdometerReading,
                  labelText: AppString.startingOdometerReading,
                  hintText: AppString.startingOdometerReading,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: TextSize.textFieldGap),

                ///End time
                TextFormFieldWidget(
                  controller: startTime,
                  labelText: AppString.startTime,
                  hintText: AppString.startTime,
                  readOnly: true,
                  onTap: ()async{
                    TimeOfDay? timeOfDay = await pickTime(context);
                    if(timeOfDay!=null){
                      startTime.text = formatTimeOfDay(timeOfDay);
                    }
                  },
                ),
                const SizedBox(height: TextSize.textGap),

                ///Pre-start check
                const BodyText(text: AppString.preStartChecklist,fontWeight: FontWeight.bold),
                const Divider(),
                const PreStartCheckboxWidget(),
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
