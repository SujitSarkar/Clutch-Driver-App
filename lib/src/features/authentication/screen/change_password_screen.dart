import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../home/provider/home_provider.dart';
import '../provider/authentication_provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider = Provider.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const TitleText(
              text: AppString.changePassword, textColor: Colors.white),
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
            padding:
                const EdgeInsets.symmetric(horizontal: TextSize.pagePadding),
            child: Form(
              key: authProvider.changePasswordFormKey,
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
                    controller: authProvider.passwordController,
                    labelText: AppString.password,
                    hintText: AppString.password.toLowerCase(),
                    required: true,
                    obscure: true,
                  ),
                  const SizedBox(height: TextSize.textFieldGap),

                  TextFormFieldWidget(
                    controller: authProvider.confirmPasswordController,
                    labelText: AppString.confirmPassword,
                    hintText:
                        AppString.confirmPassword.toLowerCase(),
                    required: true,
                    obscure: true,
                  ),
                  const SizedBox(height: TextSize.textFieldGap),

                  ///Reset Button
                  SolidButton(
                      onTap: () async {
                        final int? userId = HomeProvider.instance.loginModel?.data?.id;
                        await authProvider.changePasswordButtonOnTap(userId: userId!);
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
