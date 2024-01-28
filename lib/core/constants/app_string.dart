class AppString {
  static const String appName = 'Clutch Driver App';
  static const String fontName = 'inter';

  static const String appExitMessage = 'Do you want to exit?';

  ///Button String
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String start = 'Start';
  static const String complete = 'Complete';
  static const String upload = 'Upload';

  ///Auth
  static const String welcomeMessage = 'Welcome to $appName';
  static const String username = 'Username';
  static const String password = 'Password';
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String resetPassword = 'Reset Password';
  static const String signInMessage = 'Please sign-in to your account and start the\nadventure';
  static const String noInternetConnection = 'No internet connection';

  ///Drawer
  static const String upcomingLoads = 'Upcoming Loads';
  static const String completedLoads = 'Completed Loads';
  static const String dailyLogbook = 'Daily Logbook';

  ///Home
  static const String selectCompany = 'Select Company';
  static const String applyDateRange = 'Apply Date Range';
  static const String contact = 'Contact';
  static const String load = 'Load';
  static const String pickup = 'Pickup';
  static const String destination = 'Destination';
  static const String commodity = 'Commodity';
  static const String quantity = 'QTY';

  static const String note = 'Note';
  static const String pickupTareWeight = 'Pickup Tare Weight';
  static const String pickupGrossWeight = 'Pickup Gross Weight';
  static const String deliveryGrossWeight = 'Delivery Gross Weight';
  static const String deliveryTareWeight = 'Delivery Tare Weight';
  static const String calculatedNett = 'Calculated Nett';

  static const String uploadAttachment = 'Upload Attachment';
  static const String openCamera = 'Open Camera';
  static const String linkedDocument = 'Linked Document';

  static const String selectCompanyMgs = 'These are the trucks on which you have been assigned loads.'
      ' Please select the Truck to view the loads. The trucks are listed in order based on which load '
      'is scheduled to be completed first.';
  static List<int> timeSlotInDays = [1,7,14];

  ///Profile
  static const String personalDetails = 'Personal Details';
  static const String name = 'Name';
  static const String emailAddress = 'Email Address';
  static const String organization = 'Organization';
  static const String license = 'License';
  static const String vIC = 'VIC';
  static const String address = 'Address';
  static const String reservoir = 'Reservoir';
  static const String uploadPhoto = 'Upload Photo';
}
