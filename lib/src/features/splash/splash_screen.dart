import 'dart:async';
import 'package:clutch_driver_app/core/utils/app_navigator_key.dart';
import 'package:clutch_driver_app/src/features/home/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extension/string_extension.dart';
import '../../../core/constants/local_storage_key.dart';
import '../../../core/constants/text_size.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/page_route.dart';
import '../../../core/utils/local_storage.dart';
import '../../../core/widgets/text_widget.dart';
import '../../../shared/api/api_service.dart';
import '../authentication/model/login_response_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LoginResponseModel? loginResponseModel;

  @override
  void initState() {
    onInit();
    super.initState();
  }

  Future<void> getLocalData() async {
    final loginResponseFromLocal = await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null ) {
      loginResponseModel = loginResponseModelFromJson(loginResponseFromLocal);
      ApiService.instance.addAccessToken(loginResponseModel?.token);
    }
  }

  Future<void> onInit() async {
    final HomeProvider homeProvider = Provider.of(AppNavigatorKey.key.currentState!.context,listen: false);
    await getLocalData();
    if(loginResponseModel !=null && loginResponseModel!.token.isValid){
      await homeProvider.initialize().then((value){
        pushAndRemoveUntil(targetRoute: AppRouter.pendingLoad);
      });
    }else{
      await Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        pushAndRemoveUntil(targetRoute: AppRouter.signIn);
      });
    }
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
                    child: Image.asset('assets/images/logo.png',height: 180,width: 180)),
                const SizedBox(height: TextSize.pagePadding),
                const LargeTitleText(text:'Driver App',
                    textAlign: TextAlign.center,
                ),
              ],
            )));
  }
}
