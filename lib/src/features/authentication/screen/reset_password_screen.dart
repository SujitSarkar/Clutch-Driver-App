import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../../core/widgets/text_widget.dart';
import '../provider/authentication_provider.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider = Provider.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.cardColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: TextSize.pagePadding),
            child: Form(
              key: authProvider.resetPasswordFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                      child: LargeTitleText(
                          text: AppString.resetPassTitle,
                          textAlign: TextAlign.center,
                          textColor: AppColor.primaryColor)),
                  const SizedBox(height: TextSize.pagePadding),

                  const SmallText(
                      text: AppString.resetPassSubTitle,
                      textColor: AppColor.secondaryTextColor,
                      textAlign: TextAlign.center),
                  const SizedBox(height: TextSize.pagePadding),

                  TextFormFieldWidget(
                    controller: authProvider.emailController,
                    labelText: AppString.emailAddress,
                    hintText: 'Enter your ${AppString.emailAddress.toLowerCase()}',
                    required: true,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: TextSize.textFieldGap),

                  TextFormFieldWidget(
                    controller: authProvider.phoneController,
                    labelText: AppString.phone,
                    hintText: 'Enter your ${AppString.phone.toLowerCase()}',
                    required: true,
                    textInputType: TextInputType.phone,
                  ),
                  const SizedBox(height: TextSize.textFieldGap),

                  ///Reset Button
                  SolidButton(
                      onTap: () async {
                        await authProvider.resetPasswordButtonOnTap();
                      },
                      child: authProvider.loading
                          ? const LoadingWidget(color: Colors.white)
                          : const ButtonText(text: AppString.reset)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
