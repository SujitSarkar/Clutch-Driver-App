import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/text_widget.dart';
import '../provider/drawer_menu_provider.dart';

class PreStartCheckboxWidget extends StatelessWidget {
  const PreStartCheckboxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DrawerMenuProvider drawerMenuProvider = Provider.of(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: drawerMenuProvider.preStartCheckBoxItem.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          dense: true,
          title: BodyText(
              text: drawerMenuProvider.preStartCheckBoxItem[index].name!),
          value: drawerMenuProvider.preStartCheckBoxItem[index].value ?? false,
          onChanged: (bool? value) {
            drawerMenuProvider.changePreStartItemCheckboxValue(
              index,
              value!,
              drawerMenuProvider.preStartCheckBoxItem[index],
            );
          },
        );
      },
    );
  }
}
