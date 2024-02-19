class ApiEndpoint {
  ///Base URL
  static const String baseUrl = 'https://app.clutchit.com.au';
  static const String imageUrlPath = '$baseUrl/storage/settings';

  ///Auth
  static const String login = '/index.php/api/applogin';
  static const String changePassword = '/index.php/api/chnage-password';

  static const String loadList = '/index.php/api/driver_app/load-list';
  static const String singleLoad = '/index.php/api/driver_app/load-single';
  static const String assetList = '/index.php/api/driver_app/asset-list';
}
