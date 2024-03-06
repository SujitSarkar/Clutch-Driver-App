import 'package:flutter/Material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMapsWithLatLong(double latitude, double longitude) async {
  final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  debugPrint('googleMapsUrl: $googleMapsUrl');
  try {
    await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
  } catch (error) {
    debugPrint('Error launching Google Maps: $error');
  }
}

Future<void> openGoogleMapsWithAddress(String address) async {
  final String encodedAddress = Uri.encodeComponent(address);
  final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
  debugPrint('googleMapsUrl: $googleMapsUrl');
  try {
    await launchUrl(Uri.parse(googleMapsUrl));
  } catch (error) {
    debugPrint('Error launching Google Maps: $error');
  }
}
