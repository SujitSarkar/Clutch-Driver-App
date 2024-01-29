import 'dart:async';
import 'package:clutch_driver_app/core/constants/text_size.dart';
import 'package:clutch_driver_app/core/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';

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
    await Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRouter.companyList, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Hero(
              tag: 'splashToSignIn',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ 
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.asset('assets/images/logo.png',height: 180,width: 180)),
                  const SizedBox(height: TextSize.pagePadding),
                  const LargeTitleText(text:'Driver App',
                      textAlign: TextAlign.center,
                  ),
                ],
              ),
            )));
  }
}
