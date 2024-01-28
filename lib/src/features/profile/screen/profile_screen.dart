import 'package:clutch_driver_app/src/features/profile/provider/profile_provider.dart';
import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../../core/widgets/text_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(),
        drawer: const Drawer(child: AppDrawer()),
        body: _bodyUI(profileProvider, size, context));
  }

  Widget _bodyUI(
          ProfileProvider profileProvider, Size size, BuildContext context) =>
      Column(
        children: [
          ///Save & Cancel Button
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const BodyText(
                      text: AppString.cancel,
                      textColor: AppColor.primaryColor,
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
              padding:
                  const EdgeInsets.symmetric(horizontal: TextSize.pagePadding),
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: profileProvider.selectedAttachmentFile != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                child: Image.file(
                                  profileProvider.selectedAttachmentFile!,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ))
                            : const Icon(Icons.person,
                                color: AppColor.primaryColor, size: 100),
                      ),
                      TextButton(
                          onPressed: () async {
                            await profileProvider.getImageFromCamera();
                          },
                          child: const ButtonText(
                              text: AppString.uploadPhoto,
                              textColor: AppColor.primaryColor))
                    ],
                  ),
                ),
                const SizedBox(height: TextSize.pagePadding),

                ///Personal Details
                const BodyText(
                    text: AppString.personalDetails,
                    fontWeight: FontWeight.bold),
                const Divider(height: 8, thickness: 0.8),
                const SizedBox(height: TextSize.textGap),

                ///Name
                TextFormFieldWidget(
                  controller: profileProvider.name,
                  labelText: AppString.name,
                  hintText: 'Enter ${AppString.name}',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: TextSize.textGap),

                ///Email Address
                TextFormFieldWidget(
                  controller: profileProvider.emailAddress,
                  labelText: AppString.emailAddress,
                  hintText: 'Enter ${AppString.emailAddress}',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: TextSize.textGap),

                ///Organization
                TextFormFieldWidget(
                  controller: profileProvider.organization,
                  labelText: AppString.organization,
                  hintText: 'Enter ${AppString.organization}',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: TextSize.textGap),

                ///License
                TextFormFieldWidget(
                  controller: profileProvider.license,
                  labelText: AppString.license,
                  hintText: 'Enter ${AppString.license}',
                ),
                const SizedBox(height: TextSize.textGap),

                ///VIC
                TextFormFieldWidget(
                  controller: profileProvider.vic,
                  labelText: AppString.vIC,
                  hintText: 'Enter ${AppString.vIC}',
                ),
                const SizedBox(height: TextSize.textGap),

                ///Address
                TextFormFieldWidget(
                  controller: profileProvider.address,
                  labelText: AppString.address,
                  hintText: 'Enter ${AppString.address}',
                  textCapitalization: TextCapitalization.words,
                  textInputType: TextInputType.streetAddress,
                ),
                const SizedBox(height: TextSize.textGap),

                ///Reservoir
                TextFormFieldWidget(
                  controller: profileProvider.reservoir,
                  labelText: AppString.reservoir,
                  hintText: 'Enter ${AppString.reservoir}',
                ),
                const SizedBox(height: TextSize.textGap),
              ],
            ),
          )
        ],
      );
}
