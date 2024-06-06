import '../../../../core/widgets/country_code_dropdown.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../core/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/widgets/text_widget.dart';
import '../provider/authentication_provider.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitleText(
            text: AppString.resetPassword, textColor: Colors.white),
        titleSpacing: 8,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: TextSize.pagePadding),
            child: InkWell(
              onTap: () => pushTo(AppRouter.profile),
              child: const CircleAvatar(
                  child: Icon(Icons.person, color: AppColor.primaryColor)),
            ),
          )
        ],
      ),
      backgroundColor: AppColor.cardColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TextSize.pagePadding),
          child: Form(
            key: authProvider.phoneFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SmallText(
                    text:
                        "Enter phone number that is associated with your account. We send an OTP code for verification.",
                    textColor: AppColor.secondaryTextColor,
                    textAlign: TextAlign.center),
                const SizedBox(height: TextSize.pagePadding * 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: CountryCodeDropdown(
                          items: authProvider.countryCodeList,
                          selectedValue: authProvider.selectedCountryCode,
                          hintText: 'Enter Otp',
                          onChanged: (value) {
                            authProvider.changeCountryCode(value);
                          },
                        )),
                    const SizedBox(width: 8),
                    Expanded(
                        flex: 2,
                        child: TextFormFieldWidget(
                          controller: authProvider.phoneController,
                          hintText: 'Phone number',
                          labelText: 'Phone number',
                          textInputType: TextInputType.number,
                          required: true,
                        ))
                  ],
                ),
                const SizedBox(height: TextSize.textFieldGap),
                SolidButton(
                    onTap: () {
                      authProvider.getOtpButtonOnTap();
                    },
                    child: authProvider.loading
                        ? const LoadingWidget(
                            color: Colors.white,
                          )
                        : const ButtonText(
                            text: 'Get OTP',
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
