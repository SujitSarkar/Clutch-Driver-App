import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../../core/widgets/text_widget.dart';
import '../provider/drawer_menu_provider.dart';
import '../widget/pre_start_checkbox_widget.dart';

class PreStartChecklistScreen extends StatefulWidget {
  const PreStartChecklistScreen({super.key});

  @override
  State<PreStartChecklistScreen> createState() => _PreStartChecklistScreenState();
}

class _PreStartChecklistScreenState extends State<PreStartChecklistScreen> {
  final TextEditingController endTime = TextEditingController();
  final TextEditingController endingOdometerReading = TextEditingController();
  final TextEditingController note = TextEditingController();

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
                onTap: () => Navigator.pushNamed(context, AppRouter.profile),
                child: const CircleAvatar(
                    child: Icon(Icons.person, color: AppColor.primaryColor)),
              ),
            )
          ],
        ),
        body: _bodyUI(drawerMenuProvider, size));
  }

  Widget _bodyUI(DrawerMenuProvider homeProvider, Size size) =>
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
                  onPressed: () {},
                  child: const BodyText(
                    text: AppString.save,
                    textColor: AppColor.primaryColor,
                  )),
            ],
          ),
        ),

        Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: TextSize.pagePadding,vertical: TextSize.pagePadding),
              children: [
                ///End time
                TextFormFieldWidget(
                  controller: endTime,
                  labelText: AppString.endTime,
                  hintText: 'Enter ${AppString.endTime}',
                ),
                const SizedBox(height: TextSize.textGap),

                ///Ending Odometer Reading
                TextFormFieldWidget(
                  controller: endingOdometerReading,
                  labelText: AppString.endingOdometerReading,
                  hintText: 'Enter ${AppString.endingOdometerReading}',
                ),
                const SizedBox(height: TextSize.textFieldGap),

                ///Pre-start check
                const BodyText(text: AppString.preStartChecklist,fontWeight: FontWeight.bold),
                const Divider(),
                const PreStartCheckboxWidget(),
                const SizedBox(height: TextSize.textFieldGap),

                ///Note
                TextFormFieldWidget(
                  controller: note,
                  labelText: AppString.note,
                  hintText: 'Enter ${AppString.note}',
                  minLine: 3,
                  maxLine: 5,
                ),
                const SizedBox(height: TextSize.textFieldGap),
              ],
            ))
      ]);
}
