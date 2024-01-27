import 'package:clutch_driver_app/src/features/authentication/view/reset_password_screen.dart';
import 'package:flutter/material.dart';
import '../../src/features/authentication/view/signin_screen.dart';
import '../../src/features/home/screen/home_screen.dart';
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

      case AppRouter.home:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const HomeScreen());

      case AppRouter.noInternet:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
            const NoInternetScreen());

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
