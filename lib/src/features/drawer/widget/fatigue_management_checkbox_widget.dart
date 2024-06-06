import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/text_widget.dart';
import '../provider/drawer_menu_provider.dart';

class FatigueManagementCheckboxWidget extends StatelessWidget {
  const FatigueManagementCheckboxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DrawerMenuProvider drawerMenuProvider = Provider.of(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: drawerMenuProvider.fatigueManagementCheckBoxItem.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          dense: true,
          title: BodyText(
              text: drawerMenuProvider
                  .fatigueManagementCheckBoxItem[index].name!),
          value: drawerMenuProvider.fatigueManagementCheckBoxItem[index].value,
          onChanged: (value) {
            drawerMenuProvider.changeFatigueManagementCheckboxItemValue(
              index,
              value!,
              drawerMenuProvider.fatigueManagementCheckBoxItem[index],
            );
          },
        );
      },
    );
  }
}
