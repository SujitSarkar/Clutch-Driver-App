import 'package:clutch_driver_app/core/constants/text_size.dart';
import 'package:clutch_driver_app/core/router/app_router.dart';
import 'package:clutch_driver_app/core/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../provider/authentication_provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
              key: authProvider.signInFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                      child: LargeTitleText(
                          text: AppString.welcomeMessage,
                          textAlign: TextAlign.center,
                          textColor: AppColor.primaryColor)),
                  const SizedBox(height: TextSize.pagePadding),

                  const SmallText(
                      text: AppString.signInMessage,
                      textColor: AppColor.secondaryTextColor,
                      textAlign: TextAlign.center),
                  const SizedBox(height: TextSize.pagePadding),

                  TextFormFieldWidget(
                    controller: authProvider.email,
                    labelText: AppString.emailAddress,
                    hintText: 'Enter your ${AppString.emailAddress.toLowerCase()}',
                    required: true,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: TextSize.textFieldGap),

                  TextFormFieldWidget(
                    controller: authProvider.passwordController,
                    obscure: true,
                    labelText: AppString.password,
                    hintText: 'Enter your ${AppString.password.toLowerCase()}',
                    required: true,
                  ),
                  const SizedBox(height: TextSize.textFieldGap),

                  ///Login Button
                  SolidButton(
                      onTap: () async => await authProvider.signInButtonOnTap(),
                      child: authProvider.loading
                          ? const LoadingWidget(color: Colors.white)
                          : const ButtonText(text: AppString.login)),
                  const SizedBox(height: TextSize.textFieldGap),

                  TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRouter.resetPassword),
                      child: const ButtonText(
                          text: AppString.resetPassword,
                          textColor: AppColor.primaryColor))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
