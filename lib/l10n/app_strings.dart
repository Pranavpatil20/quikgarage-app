import 'package:flutter/widgets.dart';

import '../core/providers/locale_provider.dart';

/// App-wide strings for English, Hindi, and Marathi.
class AppStrings {
  AppStrings(this.appLanguage);

  final AppLanguage appLanguage;

  static AppStrings of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<AppStringsScope>();
    assert(inherited != null, 'AppStrings not found in context');
    return inherited!.strings;
  }

  bool get isEn => appLanguage == AppLanguage.english;
  bool get isHi => appLanguage == AppLanguage.hindi;

  String get appName => 'QuikGarage';

  String get garageProfile => _t('Garage Profile', 'गैराज प्रोफ़ाइल', 'गॅरेज प्रोफाइल');
  String get appSettings => _t('App Settings', 'ऐप सेटिंग्स', 'अॅप सेटिंग्ज');
  String get account => _t('Account', 'खाता', 'खाते');
  String get language => _t('Language', 'भाषा', 'भाषा');
  String get languageSubtitle => _t(
        'English, Hindi, Marathi',
        'अंग्रेज़ी, हिंदी, मराठी',
        'इंग्रजी, हिंदी, मराठी',
      );
  String get appearance => _t('Appearance', 'दिखावट', 'दिसणे');
  String get appearanceSubtitle =>
      _t('Dark / Light Mode', 'डार्क / लाइट मोड', 'डार्क / लाइट मोड');
  String get editProfile => _t('Edit Profile', 'प्रोफ़ाइल संपादित करें', 'प्रोफाइल संपादित करा');
  String get supportFeedback =>
      _t('Support & Feedback', 'सहायता और प्रतिक्रिया', 'सहाय्य आणि अभिप्राय');
  String get support => _t('Support', 'सहायता', 'सहाय्य');
  String get supportHint => _t(
        'Reach us anytime for help or feedback.',
        'मदद या प्रतिक्रिया के लिए कभी भी संपर्क करें।',
        'मदत किंवा अभिप्रायासाठी कधीही संपर्क करा.',
      );
  String get supportEmailLabel => _t('Email', 'ईमेल', 'ईमेल');
  String get supportCallLabel => _t('Call', 'कॉल', 'कॉल');
  String get logout => _t('Logout', 'लॉग आउट', 'लॉग आउट');
  String get signOut => _t('Sign Out', 'साइन आउट', 'साइन आउट');

  String get dashboard => _t('Dashboard', 'डैशबोर्ड', 'डॅशबोर्ड');
  String get home => _t('Home', 'होम', 'होम');
  String get bookings => _t('Bookings', 'बुकिंग', 'बुकिंग');
  String get customers => _t('Customers', 'ग्राहक', 'ग्राहक');
  String get billing => _t('Billing', 'बिलिंग', 'बिलिंग');
  String get settings => _t('Settings', 'सेटिंग्स', 'सेटिंग्ज');
  String get alerts => _t('Alerts', 'अलर्ट', 'अलर्ट');
  String get profile => _t('Profile', 'प्रोफ़ाइल', 'प्रोफाइल');

  String get createYourGarage =>
      _t('Create Your Garage', 'अपना गैराज बनाएं', 'तुमचे गॅरेज तयार करा');
  String get createGarageHint => _t(
        'Customers can only book after you create a garage.',
        'ग्राहक तभी बुक कर सकते हैं जब आप गैराज बना लें।',
        'तुम्ही गॅरेज तयार केल्यानंतरच ग्राहक बुक करू शकतात.',
      );
  String get garageName => _t('Garage Name', 'गैराज का नाम', 'गॅरेजचे नाव');
  String get address => _t('Address', 'पता', 'पत्ता');
  String get openingTime => _t('Opening Time', 'खुलने का समय', 'उघडण्याची वेळ');
  String get closingTime => _t('Closing Time', 'बंद होने का समय', 'बंद होण्याची वेळ');
  String get createGarage => _t('Create Garage', 'गैराज बनाएं', 'गॅरेज तयार करा');
  String get saveGarage => _t('Save Garage', 'गैराज सहेजें', 'गॅरेज जतन करा');
  String get saveProfile => _t('Save Profile', 'प्रोफ़ाइल सहेजें', 'प्रोफाइल जतन करा');
  String get yourName => _t('Your Name', 'आपका नाम', 'तुमचे नाव');
  String get name => _t('Name', 'नाम', 'नाव');
  String get phone => _t('Phone', 'फ़ोन', 'फोन');
  String get darkMode => _t('Dark Mode', 'डार्क मोड', 'डार्क मोड');
  String get myVehicles => _t('My Vehicles', 'मेरे वाहन', 'माझी वाहने');
  String get noVehiclesYet =>
      _t('No vehicles added yet.', 'अभी कोई वाहन नहीं जोड़ा गया।', 'अद्याप कोणतीही वाहने जोडलेली नाहीत.');
  String get primary => _t('Primary', 'प्राथमिक', 'प्राथमिक');

  String get generalServiceAmount =>
      _t('General Service Amount', 'जनरल सर्विस राशि', 'जनरल सर्व्हिस रक्कम');
  String get generalServiceHint => _t(
        'Used as default when creating invoices',
        'इनवॉइस बनाते समय डिफ़ॉल्ट राशि के रूप में उपयोग',
        'इनव्हॉइस तयार करताना डीफॉल्ट रक्कम म्हणून वापर',
      );
  String get avgService => _t('avg. service', 'औसत सर्विस', 'सरासरी सर्व्हिस');
  String get editGarage => _t('Edit Garage', 'गैराज संपादित करें', 'गॅरेज संपादित करा');
  String get save => _t('Save', 'सहेजें', 'जतन करा');
  String get cancel => _t('Cancel', 'रद्द करें', 'रद्द करा');
  String get selectLanguage => _t('Select Language', 'भाषा चुनें', 'भाषा निवडा');
  String get garageUpdated => _t('Garage updated', 'गैराज अपडेट हो गया', 'गॅरेज अपडेट झाले');
  String get garageCreated =>
      _t('Garage created successfully', 'गैराज सफलतापूर्वक बना', 'गॅरेज यशस्वीरीत्या तयार झाले');
  String get profileUpdated =>
      _t('Profile updated', 'प्रोफ़ाइल अपडेट हो गई', 'प्रोफाइल अपडेट झाली');
  String get enterName => _t('Enter your name', 'अपना नाम दर्ज करें', 'तुमचे नाव प्रविष्ट करा');
  String get enterGarageDetails => _t(
        'Enter garage name and address',
        'गैराज का नाम और पता दर्ज करें',
        'गॅरेजचे नाव आणि पत्ता प्रविष्ट करा',
      );
  String get enterValidAmount => _t(
        'Enter a valid service amount',
        'मान्य सर्विस राशि दर्ज करें',
        'वैध सर्व्हिस रक्कम प्रविष्ट करा',
      );
  String get supportMessage => _t(
        'For support, email info@digiaarambh.com or call +91 8605864047 / +91 7020681301.',
        'सहायता के लिए info@digiaarambh.com पर ईमेल करें या +91 8605864047 / +91 7020681301 पर कॉल करें।',
        'सहाय्यासाठी info@digiaarambh.com वर ईमेल करा किंवा +91 8605864047 / +91 7020681301 वर कॉल करा.',
      );
  String get noGarageYet => _t(
        'No garage yet',
        'अभी कोई गैराज नहीं',
        'अद्याप कोणतेही गॅरेज नाही',
      );
  String get setUpGarageCta => _t(
        'Create garage to start receiving bookings',
        'बुकिंग प्राप्त करने के लिए गैराज बनाएं',
        'बुकिंग मिळवण्यासाठी गॅरेज तयार करा',
      );
  String get versionLabel => _t('Version', 'संस्करण', 'आवृत्ती');

  String get billingInvoices =>
      _t('Billing & Invoices', 'बिलिंग और इनवॉइस', 'बिलिंग आणि इनव्हॉइस');
  String get bookingManagement =>
      _t('Booking Management', 'बुकिंग प्रबंधन', 'बुकिंग व्यवस्थापन');
  String get customerManagement =>
      _t('Customer Management', 'ग्राहक प्रबंधन', 'ग्राहक व्यवस्थापन');
  String get myBookings => _t('My Bookings', 'मेरी बुकिंग', 'माझ्या बुकिंग');
  String get notifications => _t('Notifications', 'सूचनाएँ', 'सूचना');
  String get bookService => _t('Book Service', 'सर्विस बुक करें', 'सर्व्हिस बुक करा');
  String get addBooking => _t('Add Booking', 'बुकिंग जोड़ें', 'बुकिंग जोडा');
  String get chooseRole =>
      _t('Choose Your Role', 'अपनी भूमिका चुनें', 'तुमची भूमिका निवडा');

  String get login => _t('Sign In', 'साइन इन', 'साइन इन');
  String get signUp => _t('Sign Up', 'साइन अप', 'साइन अप');
  String get password => _t('Password', 'पासवर्ड', 'पासवर्ड');

  // Dashboard
  String get manageServicesToday => _t(
        'Manage your services today',
        'आज अपनी सेवाएँ प्रबंधित करें',
        'आज तुमच्या सेवा व्यवस्थापित करा',
      );
  String get todayBookings =>
      _t('Today Bookings', 'आज की बुकिंग', 'आजच्या बुकिंग');
  String get pendingBookings =>
      _t('Pending Bookings', 'लंबित बुकिंग', 'प्रलंबित बुकिंग');
  String get upcomingBookings =>
      _t('Upcoming Bookings', 'आगामी बुकिंग', 'आगामी बुकिंग');
  String get todaysRevenue =>
      _t("Today's Revenue", 'आज की आय', 'आजचे उत्पन्न');
  String get weeklyRevenue =>
      _t('Weekly Revenue', 'साप्ताहिक आय', 'साप्ताहिक उत्पन्न');
  String get quickActions =>
      _t('Quick Actions', 'त्वरित क्रियाएँ', 'द्रुत क्रिया');
  String get viewBookings =>
      _t('View Bookings', 'बुकिंग देखें', 'बुकिंग पहा');
  String get recentBookings =>
      _t('Recent Bookings', 'हाल की बुकिंग', 'अलीकडील बुकिंग');
  String get viewAll => _t('View All', 'सभी देखें', 'सर्व पहा');
  String get orSetupInSettings => _t(
        'Or set up in Settings',
        'या सेटिंग्स में सेट करें',
        'किंवा सेटिंग्जमध्ये सेट करा',
      );
  String get createGarageSoCustomersCanBook => _t(
        'Create your garage so customers can book services.',
        'ग्राहक सेवा बुक कर सकें, इसके लिए अपना गैराज बनाएं।',
        'ग्राहक सेवा बुक करू शकतील यासाठी तुमचे गॅरेज तयार करा.',
      );

  // Booking filter tabs
  String get tabToday => _t('Today', 'आज', 'आज');
  String get tabUpcoming => _t('Upcoming', 'आगामी', 'आगामी');
  String get tabCompleted => _t('Completed', 'पूर्ण', 'पूर्ण');
  String get tabCancelled => _t('Cancelled', 'रद्द', 'रद्द');
  String get tabActive => _t('Active', 'सक्रिय', 'सक्रिय');
  String get tabAll => _t('All', 'सभी', 'सर्व');
  String get tabPending => _t('Pending', 'लंबित', 'प्रलंबित');
  String get tabPaid => _t('Paid', 'भुगतान', 'भरले');

  String get noBookingsFound =>
      _t('No bookings found', 'कोई बुकिंग नहीं मिली', 'कोणतीही बुकिंग सापडली नाही');
  String get noCustomersYet =>
      _t('No customers yet', 'अभी कोई ग्राहक नहीं', 'अद्याप कोणतेही ग्राहक नाहीत');
  String get tapToViewHistory => _t(
        'Tap to view service history',
        'सेवा इतिहास देखने के लिए टैप करें',
        'सेवा इतिहास पाहण्यासाठी टॅप करा',
      );
  String get serviceHistory =>
      _t('Service History', 'सेवा इतिहास', 'सेवा इतिहास');
  String get noServiceHistoryYet => _t(
        'No service history yet',
        'अभी कोई सेवा इतिहास नहीं',
        'अद्याप कोणताही सेवा इतिहास नाही',
      );
  String get customerLabel => _t('Customer', 'ग्राहक', 'ग्राहक');
  String get vehicleLabel => _t('Vehicle', 'वाहन', 'वाहन');

  String get confirm => _t('Confirm', 'पुष्टि करें', 'पुष्टी करा');
  String get complete => _t('Complete', 'पूर्ण करें', 'पूर्ण करा');
  String get markConfirmed =>
      _t('Mark Confirmed', 'पुष्टि करें', 'पुष्टी करा');
  String get markInProgress =>
      _t('Mark In Progress', 'प्रगति में चिह्नित करें', 'प्रगतीत चिन्हांकित करा');
  String get markCompleted =>
      _t('Mark Completed', 'पूर्ण चिह्नित करें', 'पूर्ण चिन्हांकित करा');
  String get statusUpdated =>
      _t('Status updated', 'स्थिति अपडेट हुई', 'स्थिती अपडेट झाली');
  String get noFurtherStatusChanges => _t(
        'No further status changes for this booking',
        'इस बुकिंग के लिए और स्थिति परिवर्तन नहीं',
        'या बुकिंगसाठी आणखी स्थिती बदल नाहीत',
      );
  String get cancelBookingConfirm => _t(
        'Are you sure you want to cancel this booking?',
        'क्या आप वाकई इस बुकिंग को रद्द करना चाहते हैं?',
        'तुम्हाला खरोखर ही बुकिंग रद्द करायची आहे का?',
      );
  String get yes => _t('Yes', 'हाँ', 'होय');
  String get no => _t('No', 'नहीं', 'नाही');

  String get noPaidInvoicesYet =>
      _t('No paid invoices yet', 'अभी कोई भुगतान इनवॉइस नहीं', 'अद्याप कोणतेही भरलेले इनव्हॉइस नाहीत');
  String get noPendingInvoices =>
      _t('No pending invoices', 'कोई लंबित इनवॉइस नहीं', 'कोणतेही प्रलंबित इनव्हॉइस नाहीत');
  String get noInvoicesYet => _t(
        'No invoices yet\nComplete a booking to create one',
        'अभी कोई इनवॉइस नहीं\nबनाने के लिए बुकिंग पूर्ण करें',
        'अद्याप कोणतेही इनव्हॉइस नाहीत\nतयार करण्यासाठी बुकिंग पूर्ण करा',
      );
  String get editAmount => _t('Edit amount', 'राशि संपादित करें', 'रक्कम संपादित करा');
  String get updateServicePartsCost => _t(
        'Update service / parts cost',
        'सेवा / पार्ट्स लागत अपडेट करें',
        'सेवा / पार्ट्स खर्च अपडेट करा',
      );
  String get markAsPaid => _t('Mark as Paid', 'भुगतान चिह्नित करें', 'भरले म्हणून चिन्हांकित करा');
  String get markAsPartial =>
      _t('Mark as Partial', 'आंशिक चिह्नित करें', 'अंशतः चिन्हांकित करा');
  String get moveBackToPending =>
      _t('Move back to Pending', 'लंबित पर वापस लाएँ', 'प्रलंबितवर परत आणा');
  String get markPaid => _t('Mark Paid', 'भुगतान करें', 'भरले करा');
  String get sendWhatsApp => _t('WhatsApp', 'व्हाट्सऐप', 'व्हॉट्सअॅप');
  String get sendWhatsAppDetails => _t(
        'Send details on WhatsApp',
        'विवरण व्हाट्सऐप पर भेजें',
        'तपशील व्हॉट्सअॅपवर पाठवा',
      );
  String get whatsappNoCustomerPhone => _t(
        'Customer phone number is missing',
        'ग्राहक फ़ोन नंबर नहीं है',
        'ग्राहक फोन नंबर नाही',
      );
  String get whatsappOpenFailed => _t(
        'Could not open WhatsApp',
        'व्हाट्सऐप नहीं खुल सका',
        'व्हॉट्सअॅप उघडता आले नाही',
      );
  String get sendInvoicePdf => _t(
        'Send invoice PDF',
        'इनवॉइस PDF भेजें',
        'इनव्हॉइस PDF पाठवा',
      );
  String get invoicePdfFailed => _t(
        'Could not create invoice PDF',
        'इनवॉइस PDF नहीं बन सका',
        'इनव्हॉइस PDF तयार करता आले नाही',
      );
  String get whatsappPickToSendPdf => _t(
        'Choose WhatsApp to send the invoice PDF',
        'इनवॉइस PDF भेजने के लिए व्हाट्सऐप चुनें',
        'इनव्हॉइस PDF पाठवण्यासाठी व्हॉट्सअॅप निवडा',
      );
  String get manage => _t('Manage', 'प्रबंधित करें', 'व्यवस्थापित करा');
  String get yesPaid => _t('Yes, Paid', 'हाँ, भुगतान', 'होय, भरले');
  String get serviceCost => _t('Service', 'सेवा', 'सेवा');
  String get partsCost => _t('Parts', 'पार्ट्स', 'पार्ट्स');
  String get total => _t('Total', 'कुल', 'एकूण');
  String get invoiceAmountUpdated =>
      _t('Invoice amount updated', 'इनवॉइस राशि अपडेट हुई', 'इनव्हॉइस रक्कम अपडेट झाली');

  String greeting(String name) {
    final hour = DateTime.now().hour;
    final label = hour < 12
        ? _t('Good Morning', 'सुप्रभात', 'शुभ सकाळ')
        : hour < 17
            ? _t('Good Afternoon', 'नमस्कार', 'शुभ दुपार')
            : _t('Good Evening', 'शुभ संध्या', 'शुभ संध्याकाळ');
    final fallback = _t('Owner', 'मालिक', 'मालक');
    return '$label, ${name.isEmpty ? fallback : name}';
  }

  // Customer home / booking
  String customerHi(String name) {
    final fallback = _t('there', 'मित्र', 'मित्र');
    final hi = _t('Hi', 'नमस्ते', 'नमस्कार');
    return '$hi ${name.isEmpty ? fallback : name}';
  }

  String get readyForCheckup =>
      _t('Ready for a check-up?', 'चेक-अप के लिए तैयार?', 'चेक-अपसाठी तयार आहात?');
  String get bookPremiumService => _t(
        'Book a premium service and keep your vehicle running like new.',
        'प्रीमियम सर्विस बुक करें और अपने वाहन को नया जैसा रखें।',
        'प्रीमियम सर्व्हिस बुक करा आणि तुमचे वाहन नव्यासारखे ठेवा.',
      );
  String get serviceStatus =>
      _t('Service Status', 'सेवा स्थिति', 'सेवा स्थिती');
  String get liveTrack => _t('LIVE TRACK', 'लाइव ट्रैक', 'लाइव्ह ट्रॅक');
  String get stepInGarage => _t('In Garage', 'गैराज में', 'गॅरेजमध्ये');
  String get stepStarted => _t('Started', 'शुरू', 'सुरू');
  String get stepWashing => _t('Washing', 'धुलाई', 'धुणे');
  String get stepReady => _t('Ready', 'तैयार', 'तयार');

  String get selectVehicle =>
      _t('Select Vehicle', 'वाहन चुनें', 'वाहन निवडा');
  String get selectGarage =>
      _t('Select Garage', 'गैराज चुनें', 'गॅरेज निवडा');
  String get serviceTypeLabel =>
      _t('Service Type', 'सेवा प्रकार', 'सेवा प्रकार');
  String get selectDate => _t('Select Date', 'तारीख चुनें', 'तारीख निवडा');
  String get timeSlots => _t('Time Slots', 'समय स्लॉट', 'वेळ स्लॉट');
  String get addNew => _t('Add New', 'नया जोड़ें', 'नवीन जोडा');
  String get addVehicle => _t('Add Vehicle', 'वाहन जोड़ें', 'वाहन जोडा');
  String get vehicleNumber =>
      _t('Vehicle Number', 'वाहन नंबर', 'वाहन क्रमांक');
  String get makeModel => _t('Make / Model', 'मेक / मॉडल', 'मेक / मॉडेल');
  String get additionalNotes =>
      _t('Additional Notes', 'अतिरिक्त नोट्स', 'अतिरिक्त नोट्स');
  String get notesHint => _t(
        'Describe any issues...',
        'कोई समस्या बताएँ...',
        'काही समस्या असल्यास लिहा...',
      );
  String get confirmBooking =>
      _t('Confirm Booking', 'बुकिंग पुष्टि करें', 'बुकिंग पुष्टी करा');
  String get bookingConfirmed =>
      _t('Booking confirmed!', 'बुकिंग पुष्टि हो गई!', 'बुकिंग पुष्टी झाली!');
  String get pleaseSelectVehicle =>
      _t('Please select a vehicle', 'कृपया वाहन चुनें', 'कृपया वाहन निवडा');
  String get pleaseSelectGarage => _t(
        'Please select a garage (or ask an owner to create one)',
        'कृपया गैराज चुनें (या मालिक से गैराज बनाने को कहें)',
        'कृपया गॅरेज निवडा (किंवा मालकाला गॅरेज तयार करायला सांगा)',
      );
  String get pleaseSelectTimeSlot =>
      _t('Please select a time slot', 'कृपया समय स्लॉट चुनें', 'कृपया वेळ स्लॉट निवडा');
  String get noVehiclesYetAdd => _t(
        'No vehicles yet. Tap Add New to add one.',
        'अभी कोई वाहन नहीं। जोड़ने के लिए नया जोड़ें टैप करें।',
        'अद्याप कोणतीही वाहने नाहीत. जोडण्यासाठी नवीन जोडा टॅप करा.',
      );
  String get noGaragesAvailable => _t(
        'No garages available yet. An owner must create a garage first.',
        'अभी कोई गैराज उपलब्ध नहीं। पहले मालिक को गैराज बनाना होगा।',
        'अद्याप कोणतेही गॅरेज उपलब्ध नाहीत. आधी मालकाने गॅरेज तयार करणे आवश्यक आहे.',
      );
  String get selectGarageForSlots => _t(
        'Select a garage to see available time slots.',
        'उपलब्ध समय स्लॉट देखने के लिए गैराज चुनें।',
        'उपलब्ध वेळ स्लॉट पाहण्यासाठी गॅरेज निवडा.',
      );
  String get noSlotsForDate =>
      _t('No slots for this date.', 'इस तारीख के लिए कोई स्लॉट नहीं।', 'या तारीखसाठी कोणतेही स्लॉट नाहीत.');
  String get markAllRead =>
      _t('Mark all read', 'सभी पढ़ा चिह्नित करें', 'सर्व वाचले चिन्हांकित करा');
  String get noNotifications =>
      _t('No notifications', 'कोई सूचना नहीं', 'कोणत्याही सूचना नाहीत');
  String get vehicleAdded =>
      _t('Vehicle added', 'वाहन जोड़ा गया', 'वाहन जोडले');

  String serviceType(String key) {
    const en = {
      'general_service': 'General Service',
      'oil_change': 'Oil Change',
      'ac_service': 'AC Service',
      'brake_service': 'Brake Service',
      'wash': 'Car Wash',
      'repair': 'Repair',
      'inspection': 'Inspection',
      'other': 'Other',
    };
    const hi = {
      'general_service': 'जनरल सर्विस',
      'oil_change': 'ऑयल चेंज',
      'ac_service': 'एसी सर्विस',
      'brake_service': 'ब्रेक सर्विस',
      'wash': 'कार वॉश',
      'repair': 'मरम्मत',
      'inspection': 'निरीक्षण',
      'other': 'अन्य',
    };
    const mr = {
      'general_service': 'जनरल सर्व्हिस',
      'oil_change': 'ऑइल चेंज',
      'ac_service': 'एसी सर्व्हिस',
      'brake_service': 'ब्रेक सर्व्हिस',
      'wash': 'कार वॉश',
      'repair': 'दुरुस्ती',
      'inspection': 'तपासणी',
      'other': 'इतर',
    };
    final map = isEn ? en : (isHi ? hi : mr);
    return map[key] ?? key;
  }

  String bookingStatus(String key) {
    const en = {
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'in_progress': 'In Progress',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
    };
    const hi = {
      'pending': 'लंबित',
      'confirmed': 'पुष्टि',
      'in_progress': 'प्रगति में',
      'completed': 'पूर्ण',
      'cancelled': 'रद्द',
    };
    const mr = {
      'pending': 'प्रलंबित',
      'confirmed': 'पुष्टी',
      'in_progress': 'प्रगतीत',
      'completed': 'पूर्ण',
      'cancelled': 'रद्द',
    };
    final map = isEn ? en : (isHi ? hi : mr);
    return map[key] ?? key;
  }

  String paymentStatus(String key) {
    const en = {
      'pending': 'Pending',
      'paid': 'Paid',
      'partial': 'Partial',
      'refunded': 'Refunded',
    };
    const hi = {
      'pending': 'लंबित',
      'paid': 'भुगतान',
      'partial': 'आंशिक',
      'refunded': 'वापसी',
    };
    const mr = {
      'pending': 'प्रलंबित',
      'paid': 'भरले',
      'partial': 'अंशतः',
      'refunded': 'परत',
    };
    final map = isEn ? en : (isHi ? hi : mr);
    return map[key] ?? key;
  }

  String avgServiceCost(String amount) => '₹$amount $avgService';

  String _t(String en, String hi, String mr) {
    switch (appLanguage) {
      case AppLanguage.hindi:
        return hi;
      case AppLanguage.marathi:
        return mr;
      case AppLanguage.english:
        return en;
    }
  }
}

class AppStringsScope extends InheritedWidget {
  const AppStringsScope({
    super.key,
    required this.strings,
    required super.child,
  });

  final AppStrings strings;

  @override
  bool updateShouldNotify(AppStringsScope oldWidget) =>
      strings.appLanguage != oldWidget.strings.appLanguage;
}
