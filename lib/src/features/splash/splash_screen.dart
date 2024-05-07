import 'dart:async';
import '../../../src/features/authentication/provider/authentication_provider.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/local_storage_key.dart';
import '../../../core/constants/text_size.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/page_navigator.dart';
import '../../../core/utils/local_storage.dart';
import '../../../core/widgets/text_widget.dart';
import '../drawer/provider/drawer_menu_provider.dart';
import '../home/provider/home_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    onInit();
    super.initState();
  }

  Future<void> onInit() async {
    await AuthenticationProvider.instance.initialize();
    await getData(LocalStorageKey.loginResponseKey)
        .then((loginResponseFromLocal) async {
      if (loginResponseFromLocal != null) {
        await HomeProvider.instance.initialize();
        await DrawerMenuProvider.instance.initialize();
        pushAndRemoveUntil(AppRouter.pendingLoad);
      } else {
        await Future.delayed(const Duration(milliseconds: 1000)).then((value) {
          pushAndRemoveUntil(AppRouter.signIn);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child:
                Image.asset('assets/images/logo.png', height: 160, width: 160)),
        const SizedBox(height: TextSize.pagePadding),
        const LargeTitleText(
          text: 'Driver App',
          textAlign: TextAlign.center,
        ),
      ],
    )));
  }
}
