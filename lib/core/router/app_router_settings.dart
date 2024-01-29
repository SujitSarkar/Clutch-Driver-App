import 'package:clutch_driver_app/src/features/home/screen/company_list_screen.dart';
import 'package:clutch_driver_app/src/features/home/screen/load_attachment_screen.dart';
import 'package:clutch_driver_app/src/features/home/screen/load_details_screen.dart';
import 'package:clutch_driver_app/src/features/profile/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../src/features/authentication/screen/reset_password_screen.dart';
import '../../src/features/authentication/screen/signin_screen.dart';
import '../../src/features/home/screen/load_list_screen.dart';
import '../../src/features/splash/splash_screen.dart';
import '../widgets/no_internet_screen.dart';
import 'app_router.dart';

class GeneratedRoute {
  static PageRouteBuilder onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouter.initializer:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const SplashScreen());

      case AppRouter.signIn:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const SignInScreen());

      case AppRouter.resetPassword:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
            const ResetPasswordScreen());

      case AppRouter.noInternet:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
            const NoInternetScreen());

      case AppRouter.companyList:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const CompanyListScreen());

      case AppRouter.loadList:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const LoadListScreen());

      case AppRouter.loadDetails:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const LoadDetailsScreen());

      case AppRouter.loadAttachment:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const LoadAttachmentScreen());

      case AppRouter.profile:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const ProfileScreen());

      default:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const SplashScreen());
    }
  }

  static Widget fadeTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget slideTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    const begin = Offset(1, 0);
    const end = Offset.zero;
    const curve = Curves.ease;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
