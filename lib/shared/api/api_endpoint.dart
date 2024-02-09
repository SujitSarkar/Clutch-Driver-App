class ApiEndpoint {
  ///Base URL
  static const String baseUrl = 'https://app.clutchit.com.au';
  static const String imageUrlPath = '$baseUrl/storage/settings';

  ///Auth
  static const String signIn = '/index.php/api/login';
  static const String logout = '/index.php/api/logout';

  ///Home
  static const String assetList = '/index.php/api/driver_app/asset_list';
}
