import 'package:flutter/material.dart';

class LanguageHelper {
  // Singleton instance
  static final LanguageHelper _instance = LanguageHelper._internal();
  factory LanguageHelper() => _instance;
  LanguageHelper._internal();

  // Language codes
  static const String englishCode = 'en';
  static const String bengaliCode = 'bn';

  String _currentLanguage = englishCode;
  String get currentLanguage => _currentLanguage;
  Locale get currentLocale => Locale(_currentLanguage);

  // Notifier for state management
  final List<VoidCallback> _listeners = [];

  // Translation maps
  final Map<String, Map<String, String>> _translations = {
    englishCode: {
      // Homepage
      'app_title': 'Bangladesh GIS Platform',
      'our_objective': 'Our Objective',
      'our_mission': 'Our Mission',
      'our_vision': 'Our Vision',
      'our_core_values': 'Our Core Values',
      'objective_desc':
          'To establish a comprehensive national GIS platform that enables evidence-based decision making, promotes data-driven governance, and fosters innovation in spatial data management across all sectors of Bangladesh.',
      'mission_desc':
          'To develop, maintain and promote the use of a standardized national geographic information infrastructure that facilitates data sharing, interoperability, and supports sustainable development goals across all government agencies and public institutions.',
      'vision_desc':
          'To become a world-class spatial data infrastructure that empowers citizens, businesses and government with timely, accurate and accessible geographic information for a prosperous and digitally transformed Bangladesh.',

      // Core Values
      'innovation': 'Innovation',
      'innovation_desc':
          'Embracing cutting-edge technology to solve complex spatial challenges',
      'collaboration': 'Collaboration',
      'collaboration_desc':
          'Working together with stakeholders across all sectors',
      'excellence': 'Excellence',
      'excellence_desc':
          'Maintaining the highest standards in data quality and service delivery',
      'accessibility': 'Accessibility',
      'accessibility_desc':
          'Ensuring geographic information is available to all citizens',

      // Drawer items
      'home': 'Home',
      'organizations': 'Organizations',
      'committees': 'Committees',
      'executive_committee': 'Executive Committee',
      'technical_committee': 'Technical Committee',
      'tools': 'Tools',
      'integrated_geoportal': 'Integrated Geoportal',
      'metadata': 'Metadata',
      'data_dissemination': 'Data Dissemination',
      'others': 'Others',
      'focal_persons': 'Focal Persons',
      'gallery': 'Gallery',
      'sign_in': 'Sign In',
      'help_support': 'Help & Support',
      'about': 'About',
      'welcome_user': 'Welcome User',

      // About Page
      'about_page_title': 'About BBS',
      'about_bbs': 'Bangladesh Bureau of Statistics',
      'ministry_of_planning': 'Ministry of Planning',
      'introduction': 'Introduction',
      'about_introduction_desc':
          'The Bangladesh Bureau of Statistics (BBS) is the official statistical organization of the Government of Bangladesh. Established in 1974, BBS serves as the central agency for collecting, processing, analyzing, and disseminating statistical data for national planning and policy formulation.',
      'vision': 'Vision',
      'about_vision_desc':
          'To become a world-class national statistical organization that provides reliable, timely, and user-friendly statistical information for evidence-based decision making and sustainable development.',
      'mission': 'Mission',
      'about_mission_desc':
          'To produce and disseminate high-quality official statistics through professional independence, transparency, and innovation to support national development goals and improve public service delivery.',
      'major_milestones': 'Major Milestones',
      'milestone_1974':
          '1974: Establishment of BBS as a government statistics organization',
      'milestone_1975': '1975: First Population Census conducted by BBS',
      'milestone_1983':
          '1983: Introduction of Statistical Information Management System',
      'milestone_1995': '1995: Launch of first BBS website',
      'milestone_2005':
          '2005: Implementation of National Strategy for Development of Statistics',
      'milestone_2011': '2011: Digitalization of census operations',
      'milestone_2022':
          '2022: Introduction of real-time data analytics platform',
      'milestone_2023': '2023: Establishment of National Data Center',
      'milestone_2024': '2024: Launch of mobile data collection application',

      // Help & Support Page
      'help_support_page_title': 'Help & Support',
      'how_can_we_help': 'How can we help you?',
      'help_support_subtitle':
          'Get assistance, find answers, or contact our support team',
      'send_us_message': 'Send us a Message',
      'category': 'Category',
      'your_name': 'Full Name',
      'your_email': 'Email Address',
      'subject': 'Subject',
      'your_message': 'Message',
      'contact_form_subtitle':
          'Fill out the form below and we\'ll get back to you as soon as possible',
      'contact_information': 'Contact Information',
      'head_office': 'Head Office',
      'head_office_address':
          'Statistics and Informatics Division,\nE-27/A, Agargaon,\nSher-e-Bangla Nagar, Dhaka-1207',
      'phone_numbers': 'Phone Numbers',
      'phone_numbers_list':
          'General: +880-2-9112889\nSupport: +880-2-8181300\nFax: +880-2-9112754',
      'email': 'Email',
      'email_list':
          'General: info@bbs.gov.bd\nSupport: support@bbs.gov.bd\nTechnical: tech@bbs.gov.bd',
      'website': 'Website',
      'website_list': 'www.bbs.gov.bd\nportal.bbs.gov.bd',
      'office_hours': 'Office Hours',
      'office_hours_list':
          'Sunday - Thursday: 9:00 AM - 5:00 PM\nFriday & Saturday: Closed\nSupport Available: 24/7 via email',

      // Committee Pages
      'executive_committee_page': 'Executive Committee',
      'technical_committee_page': 'Technical Committee',
      'executive_committee_members': 'Executive Committee Members',
      'technical_committee_members': 'Technical Committee Members',
      'loading_committee_members': 'Loading committee members...',
      'failed_to_load_members': 'Failed to load committee members',
      'try_again': 'Try Again',
      'no_committee_members': 'No committee members found',
      'no_search_results': 'No results found',
      'pagination_info': 'Showing {start} - {end} of {total} members',
      'organization': 'Organization',
      'close': 'Close',

      // Common
      'search': 'Search',
      'clear': 'Clear',
      'next': 'Next',
      'previous': 'Previous',
      'submit': 'Submit',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'view': 'View',
      'download': 'Download',
      'upload': 'Upload',
      'refresh': 'Refresh',
      'settings': 'Settings',
      'logout': 'Logout',

      //Focal Persons
      'loading_focal_persons': 'Loading focal persons...',
      'failed_to_load_focal_persons': 'Failed to load focal persons',
      'no_focal_persons': 'No focal persons found',
      'contact_info_not_available': 'Contact information not available',
      'loading_organizations': 'Loading organizations...',
      'failed_to_load_organizations': 'Failed to load organizations',
      'no_organizations': 'No organizations found',
      'search_organizations': 'Search organizations...',
      'total_organizations': 'Total Organizations',
      'short_name': 'Short Name',
      'phone': 'Phone',
      'search_hint': 'Search by name, designation, or organization...',

      // Gallery
      'gallery_items': 'Gallery',
      'loading_gallery_items': 'Loading gallery items...',
      'failed_to_load_gallery': 'Failed to load gallery',
      'no_gallery_items': 'No gallery items found',
      'search_gallery': 'Search gallery items...',
      'view_details': 'View Details',
      'description': 'Description',
      'gallery_pagination_info': 'Showing {start} - {end} of {total} images',

      // Metadata Page
      'loading_metadata': 'Loading metadata...',
      'failed_to_load_metadata': 'Failed to load metadata',
      'no_metadata_found': 'No metadata found',
      'clear_filters': 'Clear Filters',
      'search_metadata_hint': 'Search by title, abstract, type, or language...',
      'dataset_type': 'Dataset Type',
      'all_types': 'All Types',
      'not_available': 'Not available',

      // Integrated Geoportal
      'integrated_geoportal_page': 'Integrated Geoportal',
      'toggle_language': 'Toggle Language',
    },
    bengaliCode: {
      // Homepage
      'app_title': 'বাংলাদেশ জিআইএস প্ল্যাটফর্ম',
      'our_objective': 'আমাদের উদ্দেশ্য',
      'our_mission': 'আমাদের লক্ষ্য',
      'our_vision': 'আমাদের দর্শন',
      'our_core_values': 'আমাদের মূলনীতি',
      'objective_desc':
          'একটি দূরদর্শী জাতীয় জিআইএস প্ল্যাটফর্ম প্রতিষ্ঠা করা যা প্রমাণভিত্তিক সিদ্ধান্ত গ্রহণ সক্ষম করে, তথ্য-চালিত শাসনকে উন্নীত করে এবং বাংলাদেশের সমস্ত খণ্ডে স্থানিক তথ্য ব্যবস্থাপনায় উদ্ভাবনকে উৎসাহিত করে।',
      'mission_desc':
          'একটি মানসম্পন্ন জাতীয় ভৌগলিক তথ্য অবকাঠামো তৈরি, রক্ষণাবেক্ষণ এবং প্রচার করা যা সমস্ত সরকারি সংস্থা এবং সরকারি প্রতিষ্ঠানের মধ্যে তথ্য আদান-প্রদান, আন্তঃকার্যকারিতা এবং টেকসই উন্নয়ন লক্ষ্যগুলিকে সমর্থন করে।',
      'vision_desc':
          'একটি বিশ্বস্তরের স্থানিক তথ্য অবকাঠামো হয়ে ওঠা যা সময়োপযোগী, নির্ভুল এবং অর্জিত ভৌগলিক তথ্যের মাধ্যমে নাগরিক, ব্যবসা এবং সরকারকে ক্ষমতায়ন করে একটি সমৃদ্ধ ডিজিটাল বাংলাদেশে রূপান্তরিত করে।',

      // Core Values
      'innovation': 'উদ্ভাবন',
      'innovation_desc':
          'জটিল স্থানিক চ্যালেঞ্জ মোকাবেলায় অত্যাধুনিক প্রযুক্তি গ্রহণ',
      'collaboration': 'সহযোগিতা',
      'collaboration_desc': 'সমস্ত খণ্ডের অংশীদারদের সাথে একসাথে কাজ করা',
      'excellence': 'উৎকর্ষতা',
      'excellence_desc':
          'তথ্যের গুণগত মান এবং পরিষেবা সরবরাহে সর্বোচ্চ মান বজায় রাখা',
      'accessibility': 'প্রাপ্যতা',
      'accessibility_desc': 'সকল নাগরিকের জন্য ভৌগলিক তথ্য সহজলভ্য করা',

      // Drawer items
      'home': 'হোম',
      'organizations': 'সংস্থাসমূহ',
      'committees': 'কমিটি',
      'executive_committee': 'কার্যনির্বাহী কমিটি',
      'technical_committee': 'কারিগরি কমিটি',
      'tools': 'সরঞ্জামসমূহ',
      'integrated_geoportal': 'সমন্বিত জিওপোর্টাল',
      'metadata': 'মেটাডেটা',
      'data_dissemination': 'তথ্য প্রচার',
      'others': 'অন্যান্য',
      'focal_persons': 'কেন্দ্রীয় ব্যক্তিবর্গ',
      'gallery': 'গ্যালারি',
      'sign_in': 'সাইন ইন',
      'help_support': 'সাহায্য ও সমর্থন',
      'about': 'আমাদের সম্পর্কে',
      'welcome_user': 'স্বাগতম ব্যবহারকারী',

      // About Page
      'about_page_title': 'বিবিএস সম্পর্কে',
      'about_bbs': 'বাংলাদেশ পরিসংখ্যান ব্যুরো',
      'ministry_of_planning': 'পরিকল্পনা মন্ত্রণালয়',
      'introduction': 'ভূমিকা',
      'about_introduction_desc':
          'বাংলাদেশ পরিসংখ্যান ব্যুরো (বিবিএস) বাংলাদেশ সরকারের সরকারি পরিসংখ্যান সংস্থা। ১৯৭৪ সালে প্রতিষ্ঠিত, বিবিএস জাতীয় পরিকল্পনা এবং নীতি প্রণয়নের জন্য পরিসংখ্যানগত তথ্য সংগ্রহ, প্রক্রিয়াকরণ, বিশ্লেষণ এবং প্রচারের কেন্দ্রীয় সংস্থা হিসাবে কাজ করে।',
      'vision': 'দর্শন',
      'about_vision_desc':
          'একটি বিশ্ব-স্তরের জাতীয় পরিসংখ্যান সংস্থা হয়ে উঠতে যা নির্ভরযোগ্য, সময়োপযোগী এবং ব্যবহারকারী-বান্ধব পরিসংখ্যানগত তথ্য সরবরাহ করে প্রমাণ-ভিত্তিক সিদ্ধান্ত গ্রহণ এবং টেকসই উন্নয়নের জন্য।',
      'mission': 'লক্ষ্য',
      'about_mission_desc':
          'পেশাদার স্বাধীনতা, স্বচ্ছতা এবং উদ্ভাবনের মাধ্যমে উচ্চ-মানের সরকারি পরিসংখ্যান উৎপাদন ও প্রচার করা যাতে জাতীয় উন্নয়ন লক্ষ্যগুলি সমর্থন করা হয় এবং সরকারি পরিষেবা বিতরণ উন্নত করা হয়।',
      'major_milestones': 'প্রধান মাইলফলক',
      'milestone_1974':
          '১৯৭৪: সরকারি পরিসংখ্যান সংস্থা হিসাবে বাংলাদেশ পরিসংখ্যান ব্যুরো (বিবিএস) প্রতিষ্ঠা',
      'milestone_1975': '১৯৭৫: বিবিএস দ্বারা প্রথম জনসংখ্যা আদমশুমারি পরিচালনা',
      'milestone_1983': '১৯৮৩: পরিসংখ্যানগত তথ্য ব্যবস্থাপনা পদ্ধতি চালু',
      'milestone_1995': '১৯৯৫: প্রথম বিবিএস ওয়েবসাইট চালু',
      'milestone_2005': '২০০৫: পরিসংখ্যান উন্নয়নের জাতীয় কৌশল বাস্তবায়ন',
      'milestone_2011': '২০১১: আদমশুমারি কার্যক্রম ডিজিটালাইজেশন',
      'milestone_2022': '২০২২: রিয়েল-টাইম ডেটা বিশ্লেষণ প্ল্যাটফর্ম চালু',
      'milestone_2023': '২০২৩: জাতীয় ডেটা সেন্টার প্রতিষ্ঠা',
      'milestone_2024': '২০২৪: মোবাইল ডেটা সংগ্রহ অ্যাপ্লিকেশন চালু',

      // Help & Support Page
      'help_support_page_title': 'সাহায্য ও সমর্থন',
      'how_can_we_help': 'আমরা আপনাকে কীভাবে সাহায্য করতে পারি?',
      'help_support_subtitle':
          'সাহায্য পান, উত্তর খুঁজুন বা আমাদের সমর্থন দলের সাথে যোগাযোগ করুন',
      'send_us_message': 'আমাদের একটি বার্তা পাঠান',
      'contact_form_subtitle':
          'নিচের ফর্মটি পূরণ করুন এবং আমরা যত তাড়াতাড়ি সম্ভব আপনার কাছে ফিরে আসব',
      'category': 'ক্যাটাগরি',
      'your_name': 'পূর্ণ নাম',
      'your_email': 'ইমেইল',
      'subject': 'বিষয়',
      'your_message': 'বার্তা',
      'contact_information': 'যোগাযোগের তথ্য',
      'head_office': 'হেড অফিস',
      'head_office_address':
          'পরিসংখ্যান ও তথ্যবিজ্ঞান বিভাগ,\nই-২৭/এ, আগারগাঁও,\nশের-ই-বাংলা নগর, ঢাকা-১২০৭',
      'phone_numbers': 'ফোন নম্বর',
      'phone_numbers_list':
          'সাধারণ: +৮৮০-২-৯১১২৮৮৯\nসাপোর্ট: +৮৮০-২-৮১৮১৩০০\nফ্যাক্স: +৮৮০-২-৯১১২৭৫৪',
      'email': 'ইমেইল',
      'email_list':
          'সাধারণ: info@bbs.gov.bd\nসাপোর্ট: support@bbs.gov.bd\nকারিগরি: tech@bbs.gov.bd',
      'website': 'ওয়েবসাইট',
      'website_list': 'www.bbs.gov.bd\nportal.bbs.gov.bd',
      'office_hours': 'অফিসের সময়সূচি',
      'office_hours_list':
          'রবিবার - বৃহস্পতিবার: সকাল ৯:০০ - বিকাল ৫:০০\nশুক্রবার ও শনিবার: বন্ধ\nসমর্থন উপলব্ধ: ইমেইলের মাধ্যমে ২৪/৭ ',

      // Committee Pages
      'executive_committee_page': 'কার্যনির্বাহী কমিটি',
      'technical_committee_page': 'কারিগরি কমিটি',
      'executive_committee_members': 'কার্যনির্বাহী কমিটি সদস্য',
      'technical_committee_members': 'কারিগরি কমিটি সদস্য',
      'loading_committee_members': 'কমিটি সদস্য লোড হচ্ছে...',
      'failed_to_load_members': 'কমিটি সদস্য লোড করতে ব্যর্থ হয়েছে',
      'try_again': 'পুনরায় চেষ্টা করুন',
      'no_committee_members': 'কোন কমিটি সদস্য পাওয়া যায়নি',
      'no_search_results': 'কোন ফলাফল পাওয়া যায়নি',
      'pagination_info':
          'সর্বমোট {total} টি ফলাফলের {start} - {end} টি পর্যন্ত ফলাফল দেখানো হচ্ছে',
      'organization': 'সংস্থা',
      'close': 'বন্ধ করুন',

      // Common
      'search': 'খুঁজুন',
      'clear': 'পরিষ্কার করুন',
      'next': 'পরবর্তী',
      'previous': 'পূর্ববর্তী',
      'submit': 'জমা দিন',
      'cancel': 'বাতিল করুন',
      'save': 'সংরক্ষণ করুন',
      'delete': 'মুছে ফেলুন',
      'edit': 'সম্পাদনা করুন',
      'view': 'দেখুন',
      'download': 'ডাউনলোড করুন',
      'upload': 'আপলোড করুন',
      'refresh': 'রিফ্রেশ করুন',
      'settings': 'সেটিংস',
      'logout': 'লগআউট',

      //Focal Persons
      'loading_focal_persons': 'কেন্দ্রীয় ব্যক্তি লোড হচ্ছে...',
      'failed_to_load_focal_persons':
          'কেন্দ্রীয় ব্যক্তি লোড করতে ব্যর্থ হয়েছে',
      'no_focal_persons': 'কোন কেন্দ্রীয় ব্যক্তি পাওয়া যায়নি',
      'contact_info_not_available': 'যোগাযোগের তথ্য পাওয়া যায়নি',
      'loading_organizations': 'সংস্থা লোড হচ্ছে...',
      'failed_to_load_organizations': 'সংস্থা লোড করতে ব্যর্থ হয়েছে',
      'no_organizations': 'কোন সংস্থা পাওয়া যায়নি',
      'search_organizations': 'সংস্থা খুঁজুন...',
      'total_organizations': 'মোট সংস্থা',
      'short_name': 'সংক্ষিপ্ত নাম',
      'phone': 'ফোন',
      'search_hint': 'নাম, পদবী বা সংস্থা অনুসন্ধান করুন...',

      // Gallery
      'gallery_items': 'গ্যালারি',
      'loading_gallery_items': 'গ্যালারী আইটেম লোড হচ্ছে...',
      'failed_to_load_gallery': 'গ্যালারী লোড করতে ব্যর্থ হয়েছে',
      'no_gallery_items': 'কোন গ্যালারী আইটেম পাওয়া যায়নি',
      'search_gallery': 'গ্যালারী আইটেম অনুসন্ধান করুন...',
      'view_details': 'বিস্তারিত দেখুন',
      'description': 'বর্ণনা',
      'gallery_pagination_info':
          'সর্বমোট {total} টি ফলাফলের {start} - {end} টি পর্যন্ত ফলাফল দেখানো হচ্ছে',

      // Metadata Page
      'loading_metadata': 'মেটাডেটা লোড হচ্ছে...',
      'failed_to_load_metadata': 'মেটাডেটা লোড করতে ব্যর্থ হয়েছে',
      'no_metadata_found': 'কোন মেটাডেটা পাওয়া যায়নি',
      'clear_filters': 'ফিল্টার পরিষ্কার করুন',
      'search_metadata_hint':
          'শিরোনাম, সারাংশ, প্রকার বা ভাষা অনুসন্ধান করুন...',
      'dataset_type': 'ডেটাসেট প্রকার',
      'all_types': 'সমস্ত প্রকার',
      'not_available': 'পাওয়া যায়নি',

      // Integrated Geoportal
      'integrated_geoportal_page': 'ইন্টিগ্রেটেড জিওপোর্টাল',
      'toggle_language': 'ভাষা পরিবর্তন করুন',
    },
  };

  // Language methods
  void toggleLanguage() {
    _currentLanguage = _currentLanguage == englishCode
        ? bengaliCode
        : englishCode;
    _notifyListeners();
  }

  void setLanguage(String language) {
    if (_translations.containsKey(language) && _currentLanguage != language) {
      _currentLanguage = language;
      _notifyListeners();
    }
  }

  bool get isEnglish => _currentLanguage == englishCode;
  bool get isBengali => _currentLanguage == bengaliCode;

  // Get supported languages
  List<String> get supportedLanguages => _translations.keys.toList();
  List<MapEntry<String, String>> get supportedLanguageNames => [
    MapEntry(englishCode, 'English'),
    MapEntry(bengaliCode, 'বাংলা'),
  ];

  // Translation methods
  String translate(String key, {Map<String, dynamic>? params}) {
    final translation =
        _translations[_currentLanguage]?[key] ??
        _translations[englishCode]?[key] ??
        key;

    if (params != null && params.isNotEmpty) {
      return _replaceParams(translation, params);
    }

    return translation;
  }

  String _replaceParams(String text, Map<String, dynamic> params) {
    String result = text;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }

  // Listener management
  void addListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void clearListeners() {
    _listeners.clear();
  }

  void _notifyListeners() {
    final listeners = List<VoidCallback>.from(_listeners);
    for (final listener in listeners) {
      listener();
    }
  }

  Future<void> loadTranslations(
    Map<String, Map<String, String>> newTranslations,
  ) async {
    _translations.addAll(newTranslations);
  }

  void addTranslation(String languageCode, String key, String value) {
    if (_translations.containsKey(languageCode)) {
      _translations[languageCode]![key] = value;
    } else {
      _translations[languageCode] = {key: value};
    }
  }

  void clearTranslations() {
    _translations.clear();
    _translations[englishCode] = {};
    _translations[bengaliCode] = {};
  }
}
