import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/loading_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../src/features/drawer/provider/drawer_menu_provider.dart';
import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../../shared/date_time_picker.dart';

class AddBreakDialogWidget extends StatelessWidget {
  AddBreakDialogWidget({super.key});
  final TextEditingController startTime = TextEditingController();
  final TextEditingController endTime = TextEditingController();
  final TextEditingController breakDetails = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final DrawerMenuProvider drawerMenuProvider = Provider.of(context);
    return AlertDialog(
      insetPadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      scrollable: true,
      title: const Text(AppString.addBreak),
      content: Column(
        children: [
          ///Start time
          TextFormFieldWidget(
            controller: startTime,
            labelText: AppString.startTime,
            hintText: AppString.startTime,
            readOnly: true,
            onTap: () async {
              TimeOfDay? timeOfDay = await pickTime(context);
              if (timeOfDay != null) {
                startTime.text = formatTimeOfDay(timeOfDay);
              }
            },
          ),
          const SizedBox(height: TextSize.textGap),

          ///End time
          TextFormFieldWidget(
            controller: endTime,
            labelText: AppString.endTime,
            hintText: AppString.endTime,
            readOnly: true,
            onTap: () async {
              TimeOfDay? timeOfDay = await pickTime(context);
              if (timeOfDay != null) {
                endTime.text = formatTimeOfDay(timeOfDay);
              }
            },
          ),
          const SizedBox(height: TextSize.textGap),

          ///Break Details
          TextFormFieldWidget(
            controller: breakDetails,
            labelText: 'Break Details',
            hintText: 'Break Details',
            minLine: 1,
            maxLine: 5,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: TextSize.textFieldGap),

          Row(
            children: [
              Expanded(
                  child: SolidButton(
                    backgroundColor: Colors.grey,
                      onTap: () => popScreen(),
                      child: const ButtonText(text: AppString.cancel))),
              const SizedBox(width: 12),
              Expanded(
                  child: SolidButton(
                      onTap: () async{
                        if(startTime.text.isNotEmpty && endTime.text.isNotEmpty){
                          await drawerMenuProvider.saveFatigueBreak(
                              startTime: startTime.text.trim(),
                              endTime: endTime.text.trim(),
                              breakDetails: breakDetails.text.trim());
                        }else{
                          showToast('Select break start and end time',position: ToastGravity.TOP);
                        }
                      },
                      child: drawerMenuProvider.functionLoading
                          ? const LoadingWidget()
                          : const ButtonText(text: AppString.save))),
            ],
          )
        ],
      ),
    );
  }
}
