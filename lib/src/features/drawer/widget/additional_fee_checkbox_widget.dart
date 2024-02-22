import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/text_widget.dart';
import '../provider/drawer_menu_provider.dart';

class AdditionalFeeCheckboxWidget extends StatelessWidget {
  const AdditionalFeeCheckboxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DrawerMenuProvider drawerMenuProvider = Provider.of(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: drawerMenuProvider.additionalFeeCheckBoxItem.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          dense: true,
          title: BodyText(text: drawerMenuProvider.additionalFeeCheckBoxItem[index].name!),
          value: drawerMenuProvider.additionalFeeCheckBoxItem[index].value ??
              false,
          onChanged: (bool? value) {
            drawerMenuProvider.changeAdditionalFeeItemCheckboxValue(
              index,
              value!,
              drawerMenuProvider.additionalFeeCheckBoxItem[index],
            );
          },
        );
      },
    );
  }
}