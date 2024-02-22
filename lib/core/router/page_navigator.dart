import 'package:flutter/Material.dart';
import '../utils/app_navigator_key.dart';

void pushTo(String targetRoute, {dynamic arguments}) =>
    Navigator.pushNamed(AppNavigatorKey.key.currentState!.context, targetRoute,
        arguments: arguments);

void popAndPushTo(String targetRoute, {dynamic arguments}) =>
    Navigator.popAndPushNamed(AppNavigatorKey.key.currentState!.context,
        targetRoute,
        arguments: arguments);

void pushAndRemoveUntil(String targetRoute) =>
    Navigator.pushNamedAndRemoveUntil(
        AppNavigatorKey.key.currentState!.context, targetRoute, (route) => false);

void popUntilOf(String targetRoute) => Navigator.popUntil(
    AppNavigatorKey.key.currentState!.context,
    (route) => route.settings.name == targetRoute);

void popScreen() => Navigator.pop(AppNavigatorKey.key.currentState!.context);
