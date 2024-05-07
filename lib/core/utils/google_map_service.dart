import 'package:flutter/Material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMapsWithLatLong(
    {required double originLat,
    required double originLong,
    required double destLat,
    required double destLong}) async {
  final String googleMapsUrl =
      'https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLong&destination=$destLat,$destLong';

  debugPrint('googleMapsUrl: $googleMapsUrl');
  try {
    await launchUrl(Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication);
  } catch (error) {
    debugPrint('Error launching Google Maps: $error');
  }
}

Future<void> openGoogleMapsWithAddress(String address) async {
  final String encodedAddress = Uri.encodeComponent(address);
  final String googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
  debugPrint('googleMapsUrl: $googleMapsUrl');
  try {
    await launchUrl(Uri.parse(googleMapsUrl));
  } catch (error) {
    debugPrint('Error launching Google Maps: $error');
  }
}
