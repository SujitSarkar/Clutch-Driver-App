import 'package:clutch_driver_app/src/features/authentication/provider/authentication_provider.dart';
import 'package:clutch_driver_app/src/features/drawer/provider/drawer_menu_provider.dart';
import 'package:clutch_driver_app/src/features/home/provider/home_provider.dart';
import 'package:clutch_driver_app/src/features/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_string.dart';
import 'core/constants/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/router/app_router_settings.dart';
import 'core/utils/app_navigator_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  AppTheme.statusBarDesign;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthenticationProvider>(
              create: (_) => AuthenticationProvider()),
          ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
          ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
          ChangeNotifierProvider<DrawerMenuProvider>(create: (_) => DrawerMenuProvider()),
        ],
        child: MaterialApp(
          navigatorKey: AppNavigatorKey.key,
          title: AppString.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          initialRoute: AppRouter.initializer,
          onGenerateRoute: (RouteSettings settings) =>
              GeneratedRoute.onGenerateRoute(settings),
        ));
  }
}
