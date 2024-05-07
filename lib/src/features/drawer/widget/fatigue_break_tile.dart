import 'dart:io';

import '../../../../src/features/drawer/provider/drawer_menu_provider.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../src/features/drawer/model/fatigue_management_break_model.dart';
import '../../../../core/widgets/text_widget.dart';

class FatigueBreakTile extends StatelessWidget {
  const FatigueBreakTile({super.key, required this.model});

  final BreakModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: BodyText(text: '${model.breakStartTime}'),
        ),
        Expanded(
          flex: 1,
          child: BodyText(text: '${model.breakEndTime}'),
        ),
        Expanded(
          flex: 2,
          child: BodyText(text: model.breakDetails ?? ''),
        ),
        InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) =>
                      StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: const TitleText(text: 'Delete this break?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const ButtonText(
                                  text: 'No',
                                  textColor: AppColor.enableColor,
                                )),
                            TextButton(
                                onPressed: () {
                                  setState(() {});
                                  DrawerMenuProvider.instance
                                      .deleteFatigueBreak(id: '${model.id}');
                                },
                                child:
                                    DrawerMenuProvider.instance.functionLoading
                                        ? SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Platform.isIOS
                                                ? const CupertinoActivityIndicator()
                                                : const CircularProgressIndicator(),
                                          )
                                        : const ButtonText(
                                            text: 'Yes',
                                            textColor: AppColor.errorColor,
                                          ))
                          ],
                        );
                      }));
            },
            child: const Icon(Icons.delete_outline, color: Colors.redAccent))
      ],
    );
  }
}
