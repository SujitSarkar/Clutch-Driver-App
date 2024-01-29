import 'package:clutch_driver_app/core/constants/app_string.dart';
import 'package:clutch_driver_app/core/widgets/text_widget.dart';
import 'package:clutch_driver_app/src/features/drawer/provider/drawer_menu_provider.dart';
import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';

class AdditionalFeeCheckboxWidget extends StatelessWidget {
  const AdditionalFeeCheckboxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DrawerMenuProvider drawerMenuProvider = Provider.of(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppString.additionalFeeCheckBoxList.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          dense: true,
          title: BodyText(text: AppString.additionalFeeCheckBoxList[index]),
          value: drawerMenuProvider.additionalFeeCheckedList[index],
          onChanged: (value) {
            drawerMenuProvider.changeAdditionalFeeCheckedList(index, value!);
          },
        );
      },
    );
  }
}