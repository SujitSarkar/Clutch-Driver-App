import 'package:clutch_driver_app/core/utils/app_navigator_key.dart';
import 'package:flutter/Material.dart';

void pushTo({required String targetRoute}) =>
    Navigator.pushNamed(AppNavigatorKey.key.currentState!.context, targetRoute);

void pushAndRemoveUntil({required String targetRoute}) => Navigator.pushNamedAndRemoveUntil(
    AppNavigatorKey.key.currentState!.context, targetRoute, (route) => false);

void popUntilOf({required String targetRoute}) => Navigator.popUntil(
    AppNavigatorKey.key.currentState!.context,
        (route) => route.settings.name == targetRoute);

void popScreen() => Navigator.pop(AppNavigatorKey.key.currentState!.context);