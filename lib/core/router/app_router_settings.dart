import '../../src/features/home/screen/file_preview_screen.dart';
import 'package:flutter/material.dart';
import '../../src/features/authentication/screen/change_password_screen.dart';
import '../../src/features/drawer/screen/daily_logbook_screen.dart';
import '../../src/features/drawer/screen/fatigue_management_checklist_screen.dart';
import '../../src/features/drawer/screen/prestart_checklist_screen.dart';
import '../../src/features/home/screen/completed_load_screen.dart';
import '../../src/features/home/screen/load_attachment_screen.dart';
import '../../src/features/home/screen/load_details_screen.dart';
import '../../src/features/home/screen/pending_load_list_screen.dart';
import '../../src/features/home/screen/upcomimg_load_screen.dart';
import '../../src/features/authentication/screen/signin_screen.dart';
import '../../src/features/profile/screen/profile_screen.dart';
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

      case AppRouter.changePassword:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
            const ChangePasswordScreen());

      case AppRouter.noInternet:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
            const NoInternetScreen());

      // case AppRouter.companyList:
      //   return PageRouteBuilder(
      //       settings: settings,
      //       transitionsBuilder: fadeTransition,
      //       pageBuilder: (_, animation, secondaryAnimation) =>
      //           const CompanyListScreen());

      case AppRouter.pendingLoad:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const PendingLoadListScreen());

      case AppRouter.upcomingLoad:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const UpcomingLoadScreen());

      case AppRouter.completeLoad:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const CompleteLoadScreen());

      case AppRouter.loadDetails:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const LoadDetailsScreen());

      case AppRouter.loadAttachment:
        final String arguments = settings.arguments as String;
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                LoadAttachmentScreen(loadWeightType: arguments));

      case AppRouter.filePreview:
        final String arguments = settings.arguments as String;
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                FilePreviewScreen(fileUrl: arguments));

      case AppRouter.dailyLogbook:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const DailyLogbookScreen());

      case AppRouter.preStartChecklist:
        final PreStartChecklistScreen arguments = settings.arguments as PreStartChecklistScreen;
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                PreStartChecklistScreen(fromPage: arguments.fromPage));

      case AppRouter.fatigueManagementChecklist:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const FatigueManagementCheckListScreen());

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

  ///Fade Page Transition
  static Widget fadeTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }

  ///Slide Page Transition
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
