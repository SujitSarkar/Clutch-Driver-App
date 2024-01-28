import 'package:clutch_driver_app/core/widgets/text_widget.dart';
import 'package:clutch_driver_app/src/features/home/provider/home_provider.dart';
import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';

class CompanyTile extends StatelessWidget {
  const CompanyTile({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of(context);
    return Row(
      children: [
        const Expanded(flex: 1, child: SmallText(text: 'XYW589')),
        const Expanded(flex: 2, child: SmallText(text: 'A-Double Combination')),
        Radio(
            value: index,
            groupValue: homeProvider.selectedCompanyIndex,
            onChanged: (value) {
              homeProvider.changeCompanyRadioValue(value!);
            })
      ],
    );
  }
}
