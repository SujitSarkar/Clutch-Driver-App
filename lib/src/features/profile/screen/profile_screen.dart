import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../src/features/home/provider/home_provider.dart';
import '../../../../core/widgets/basic_dropdown.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/utils/app_media_service.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../../core/widgets/text_widget.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? selectedAttachmentFile;

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController organization = TextEditingController();
  final TextEditingController license = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController streetNumber = TextEditingController();
  final TextEditingController suburb = TextEditingController();
  final TextEditingController postcode = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      onInit();
    });
    super.initState();
  }

  Future<void> onInit() async {
    final ProfileProvider profileProvider = Provider.of(context, listen: false);
    await profileProvider.initialize();

    firstName.text = profileProvider.loginModel!.data!.firstName ?? '';
    lastName.text = profileProvider.loginModel!.data!.lastName ?? '';
    emailAddress.text = profileProvider.loginModel!.data!.email ?? '';
    phone.text = profileProvider.loginModel!.data!.phone ?? '';
    license.text = profileProvider.loginModel!.data!.meta!.licenseNumber ?? '';
    street.text =
        profileProvider.loginModel!.data!.address!.streetAddress ?? '';
    streetNumber.text =
        profileProvider.loginModel!.data!.address!.streetNumber ?? '';
    suburb.text = profileProvider.loginModel!.data!.address!.suburb ?? '';
    postcode.text = profileProvider.loginModel!.data!.address!.postcode ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title:
              const TitleText(text: AppString.account, textColor: Colors.white),
          titleSpacing: 8,
        ),
        body: profileProvider.initialLoading
            ? const LoadingWidget(color: AppColor.primaryColor)
            : _bodyUI(profileProvider, size));
  }

  Widget _bodyUI(ProfileProvider profileProvider, Size size) => Column(
        children: [
          ///Save & Cancel Button
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
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
                    onPressed: () async {
                      await saveButtonOnTap(profileProvider);
                      selectedAttachmentFile = null;
                    },
                    child: profileProvider.functionLoading
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
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: selectedAttachmentFile != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                child: Image.file(
                                  selectedAttachmentFile!,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ))
                            : profileProvider
                                        .loginModel?.data?.meta?.profileImage !=
                                    null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100)),
                                    child: CachedNetworkImage(
                                      imageUrl: profileProvider.loginModel!
                                          .data!.meta!.profileImage!,
                                      placeholder: (context, url) =>
                                          const LoadingWidget(
                                              color: AppColor.primaryColor),
                                      errorWidget: (context, url, value) =>
                                          const Icon(Icons.error,
                                              color: Colors.grey, size: 40),
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ))
                                : const Icon(Icons.person,
                                    color: AppColor.primaryColor, size: 100),
                      ),
                      TextButton(
                          onPressed: () async {
                            await AppMediaService()
                                .getImageFromGallery()
                                .then((File? value) {
                              if (value != null) {
                                selectedAttachmentFile = value;
                                setState(() {});
                              }
                            });
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
                const SizedBox(height: TextSize.textGap),

                ///First Name
                TextFormFieldWidget(
                  controller: firstName,
                  labelText: AppString.firstName,
                  hintText: AppString.firstName,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: TextSize.textGap),

                ///Last Name
                TextFormFieldWidget(
                  controller: lastName,
                  labelText: AppString.lastName,
                  hintText: AppString.lastName,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: TextSize.textGap),

                ///Email Address
                TextFormFieldWidget(
                  controller: emailAddress,
                  labelText: AppString.emailAddress,
                  hintText: AppString.emailAddress,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: TextSize.textGap),

                ///Organization
                const BodyText(
                    text: AppString.organization, fontWeight: FontWeight.bold),
                const SizedBox(height: TextSize.textGap),
                TextFormFieldWidget(
                  controller: organization,
                  labelText: AppString.organization,
                  hintText: AppString.organization,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: TextSize.textGap),

                ///License
                const BodyText(
                    text: AppString.license, fontWeight: FontWeight.bold),
                const SizedBox(height: TextSize.textGap),
                TextFormFieldWidget(
                  controller: license,
                  labelText: AppString.license,
                  hintText: AppString.license,
                ),
                const SizedBox(height: TextSize.textGap),

                ///Address
                const BodyText(
                    text: AppString.address, fontWeight: FontWeight.bold),
                const SizedBox(height: TextSize.textGap),

                TextFormFieldWidget(
                  controller: postcode,
                  labelText: AppString.postCode,
                  hintText: AppString.postCode,
                  textInputType: TextInputType.number,
                  maxLength: 4,
                ),
                const SizedBox(height: TextSize.textGap),

                TextFormFieldWidget(
                  controller: street,
                  labelText: AppString.street,
                  hintText: AppString.street,
                  textInputType: TextInputType.streetAddress,
                ),
                const SizedBox(height: TextSize.textGap),

                TextFormFieldWidget(
                  controller: streetNumber,
                  labelText: AppString.streetNumber,
                  hintText: AppString.streetNumber,
                  textCapitalization: TextCapitalization.words,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: TextSize.textGap),

                TextFormFieldWidget(
                  controller: suburb,
                  labelText: AppString.suburb,
                  hintText: AppString.suburb,
                ),
                const SizedBox(height: TextSize.textGap),

                profileProvider.stateCountryLoading
                    ? const LoadingWidget(color: AppColor.primaryColor)
                    : Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                  flex: 2,
                                  child: BodyText(text: '${AppString.state}:')),
                              Expanded(
                                flex: 3,
                                child: BasicDropdown(
                                    buttonHeight: 40,
                                    dropdownWidth: size.width * .5,
                                    items: profileProvider.stateList,
                                    selectedValue:
                                        profileProvider.selectedState,
                                    hintText: 'Select state',
                                    onChanged: (value) =>
                                        profileProvider.changeState(value)),
                              )
                            ],
                          ),
                          const SizedBox(height: TextSize.textGap),
                          Row(
                            children: [
                              const Expanded(
                                  flex: 2,
                                  child:
                                      BodyText(text: '${AppString.country}:')),
                              Expanded(
                                flex: 3,
                                child: BasicDropdown(
                                    buttonHeight: 40,
                                    dropdownWidth: size.width * .5,
                                    items: profileProvider.countryList,
                                    selectedValue:
                                        profileProvider.selectedCountry,
                                    hintText: 'Select country',
                                    onChanged: (value) =>
                                        profileProvider.changeCountry(value)),
                              )
                            ],
                          ),
                          const SizedBox(height: TextSize.textGap),
                        ],
                      ),
                const SizedBox(height: TextSize.textGap),

                if (HomeProvider.instance.loginModel?.data?.linkdCompanyName !=
                    null)
                  TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: BodyText(
                                      text:
                                          '${AppString.unlinkFrom} ${profileProvider.loginModel?.data?.linkdCompanyName ?? 'N/A'}?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const ButtonText(
                                          text: 'No',
                                          textColor: AppColor.enableColor,
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          profileProvider.unlinkDriver();
                                          Navigator.pop(context);
                                        },
                                        child: const ButtonText(
                                          text: 'Yes',
                                          textColor: AppColor.errorColor,
                                        ))
                                  ],
                                ));
                      },
                      child: profileProvider.unlinkLoading
                          ? const LoadingWidget(color: AppColor.primaryColor)
                          : ButtonText(
                              text:
                                  '${AppString.unlinkFrom} ${profileProvider.loginModel?.data?.linkdCompanyName ?? 'N/A'}',
                              textColor: AppColor.primaryColor,
                            ))
              ],
            ),
          )
        ],
      );

  Future<void> saveButtonOnTap(ProfileProvider profileProvider) async {
    final address = {
      "street_name": street.text.trim(),
      "street_number": streetNumber.text.trim(),
      "suburb": suburb.text.trim(),
      "state": profileProvider.selectedState,
      "postcode": postcode.text.trim(),
      "country": profileProvider.selectedCountry
    };
    final requestBody = {
      'id': profileProvider.loginModel?.data?.id,
      'first_name': firstName.text.trim(),
      'last_name': lastName.text.trim(),
      'email': emailAddress.text.trim(),
      'phone': phone.text.trim(),
      'address': jsonEncode(address),
      'license_number': license.text.trim(),
    };
    await profileProvider.updateProfile(
        requestBody: requestBody,
        file: selectedAttachmentFile,
        fileFieldName: 'profile_image');
  }
}
