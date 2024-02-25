class ApiEndpoint {
  ///Base URL
  static const String baseUrl = 'https://app.clutchit.com.au';

  ///Auth
  static const String login = '/index.php/api/applogin';
  static const String changePassword = '/index.php/api/chnage-password';

  ///Home
  static const String loadList = '/index.php/api/driver_app/load-list';
  static const String singleLoad = '/index.php/api/driver_app/load-single';
  static const String getLoadWeight = '/index.php/api/driver_app/get-load-weight';
  static const String loadWeightCreateEdit = '/index.php/api/driver_app/load-weight-create-edit';
  static const String loadWeightAttachment = '/index.php/api/driver_app/load-weight-attachment';

  ///Profile
  static const String updateProfile = '/index.php/api/app-update-profile';
  static const String stateList = '/index.php/api/state-list';
  static const String countryList = '/index.php/api/country-list';
  static const String getUserInfo = '/index.php/api/app-user-info';

  ///Drawer
  static const String assetList = '/index.php/api/driver_app/asset-list';
  static const String getPreStartChecklist = '/index.php/api/driver_logbook/get-pre-start-checklist';
  static const String savePreStartChecklist = '/index.php/api/driver_logbook/pre-start-checklist';
  static const String saveDailyLogbook = '/index.php/api/driver_logbook/logbook-save';
  static const String getDailySummary = '/index.php/api/driver_logbook/get-daily-summary';
  static const String getFatigueBreaks = '/index.php/api/driver_logbook/fatigue-break-get';
  static const String saveFatigueBreak = '/index.php/api/driver_logbook/fatigue-break-save';
  static const String saveFatigueManagement = '/index.php/api/driver_logbook/fatigue-management-save';
}
