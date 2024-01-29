class AppString {
  static const String appName = 'Driver App';
  static const String fontName = 'inter';

  ///Button String
  static const String appExitMessage = 'Do you want to exit?';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String start = 'Start';
  static const String complete = 'Complete';
  static const String upload = 'Upload';
  static const String reset = 'Reset';
  static const String addBreak = 'Add Break';

  ///Auth
  static const String welcomeMessage = 'Welcome to $appName';
  static const String username = 'Username';
  static const String password = 'Password';
  static const String phone = 'Phone';
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String resetPassword = 'Reset Password';
  static const String signInMessage =
      'Please sign-in to your account and start the\nadventure';
  static const String noInternetConnection = 'No internet connection';
  static const String resetPassTitle = 'Reset your password';
  static const String resetPassSubTitle =
      'enter the email or phone number you use to log into clutch and we’ll send you a link to get back into your account';

  ///Drawer
  static const String pendingLoads = 'Pending Loads';
  static const String upcomingLoads = 'Upcoming Loads';
  static const String completedLoads = 'Completed Loads';
  static const String dailyLogbook = 'Daily Logbook';

  static const String preStartChecklist = 'Pre-Start Checklist';
  static const String fatigueManagementChecklist = 'Fatigue Management Checklist';

  static const String breakTimes = 'Break Times';
  static const String time = 'Time';
  static const String description = 'Description';
  static const String regularBreaksTaken = 'Regular Breaks Taken';
  static const String totalHoursDriven = 'Total Hours Driven';

  ///Daily Logbook
  static const String endTime = 'End Time';
  static const String endingOdometerReading = 'Ending Odometer Reading';
  static const String totalLoadComplete = 'Total loads completed';
  static const String totalTonnageDone = 'Total tonnage done';
  static const String totalKmDriven = 'Total Kilometers driven';
  static const String additionalFee = 'Additional Fees';

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

  static const String selectCompanyMgs =
      'These are the trucks on which you have been assigned loads.'
      ' Please select the Truck to view the loads. The trucks are listed in order based on which load '
      'is scheduled to be completed first.';

  static List<int> timeSlotInDays = [1, 7, 14];
  static List<String> loadTypeList = ['Pending', 'Upcoming', 'Complete'];
  static List<String> additionalFeeCheckBoxList = [
    'Overnight Delivery',
    'Vehicle Maintenance',
    'Truck Wash'
  ];
  static List<String> preStartCheckboxList = [
    'Gauges Working',
    'Radio Working',
    'First-Aid Kit',
    'Fire Extinguisher',
    'Tire Pressure Check',
    'Trailer lights Check',
    'Brake lights Check',
    'Tail-light Check',
    'Headlight Check'
  ];

  ///Profile
  static const String account = 'Account';
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
