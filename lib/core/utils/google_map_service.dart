import 'package:flutter/Material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMaps(double latitude, double longitude) async {
  final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  try {
    await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
  } catch (error) {
    debugPrint('Error launching Google Maps: $error');
  }
}
