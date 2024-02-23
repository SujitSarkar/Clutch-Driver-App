import '../../../../src/features/drawer/widget/add_break_dialog.dart';
import '../../../../src/features/drawer/widget/fatigue_break_tile.dart';
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
import '../provider/drawer_menu_provider.dart';
import '../widget/fatigue_management_checkbox_widget.dart';

class FatigueManagementCheckListScreen extends StatefulWidget {
  const FatigueManagementCheckListScreen({super.key});

  @override
  State<FatigueManagementCheckListScreen> createState() =>
      _FatigueManagementCheckListScreenState();
}

class _FatigueManagementCheckListScreenState
    extends State<FatigueManagementCheckListScreen> {
  final TextEditingController note = TextEditingController();

  @override
  void initState() {
    final DrawerMenuProvider drawerMenuProvider = Provider.of(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ///Set data to textField
      note.text = drawerMenuProvider.preStartDataModel!.data!.fatigueNotes ?? '';
      await drawerMenuProvider.getFatigueBreaks();
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
              text: AppString.fatigueManagementChecklist,
              textColor: Colors.white),
          titleSpacing: 8,
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
        body: _bodyUI(drawerMenuProvider, size));
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
                    await drawerMenuProvider.saveFatigueManagement(notes: note.text.trim());
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
                  items: drawerMenuProvider.truckList,
                  selectedValue: drawerMenuProvider.selectedTruck,
                  hintText: 'Select Slot',
                  buttonHeight: 35,
                  onChanged: (value) {
                    drawerMenuProvider.changeTruck(value);
                  }),
              const SizedBox(height: TextSize.textFieldGap),

              ///Fatigue Management Checklist
              const BodyText(
                  text: AppString.fatigueManagementChecklist,
                  fontWeight: FontWeight.bold),
              const Divider(),
              const FatigueManagementCheckboxWidget(),
              const SizedBox(height: TextSize.textFieldGap),

              ///Break Times & Add Break Button
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: BodyText(
                        text: AppString.breakTimes,
                        fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      minimumSize: const Size(130, 28),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => AddBreakDialogWidget());
                    },
                    child: const ButtonText(
                      text: AppString.addBreak,
                    ),
                  ),
                ],
              ),
              const Divider(),

              //Header
              drawerMenuProvider.fatigueManagementLoading
                  ? const LoadingWidget(color: AppColor.primaryColor)
                  :drawerMenuProvider.fatigueManagementBreakModel!=null && drawerMenuProvider.fatigueManagementBreakModel!.data!
                          .breakes!.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SmallText(
                                      text: AppString.startTime,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SmallText(
                                      text: AppString.endTime,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SmallText(
                                      text: AppString.destination,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(thickness: 0.5),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: drawerMenuProvider
                                  .fatigueManagementBreakModel!
                                  .data!
                                  .breakes!
                                  .length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: TextSize.textGap),
                              itemBuilder: (context, index) => FatigueBreakTile(
                                  model: drawerMenuProvider
                                      .fatigueManagementBreakModel!
                                      .data!
                                      .breakes![index]),
                            ),
                            const Divider(height: TextSize.textFieldGap),
                          ],
                        )
                      : const SizedBox.shrink(),

              ///Total hours driven
              Row(
                children: [
                  const Expanded(
                      child: BodyText(text: "${AppString.totalHoursDriven}:")),
                  BodyText(
                      text:
                          '${drawerMenuProvider.fatigueManagementBreakModel?.data?.totaltime}')
                ],
              ),
              const SizedBox(
                  height: TextSize.textFieldGap + TextSize.textFieldGap),

              ///Note
              TextFormFieldWidget(
                  controller: note,
                  labelText: AppString.note,
                  hintText: 'Enter ${AppString.note}',
                  textCapitalization: TextCapitalization.sentences,
                  minLine: 3,
                  maxLine: 5),
            ],
          ))
      ]);
}
