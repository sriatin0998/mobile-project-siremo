// lib/core/constants/app_constants.dart

class AppConstants {
  // App Info
  static const String appName = 'Siremo';
  static const String appTagline = 'Sewa Mobil Mudah & Cepat';

  // Colors
  static const String primaryColor = '#F9A825';

  // Routes
  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String detailRoute = '/detail';
  static const String bookingRoute = '/booking';
  static const String historyRoute = '/history';
  static const String profileRoute = '/profile';
  static const String paymentMethodsRoute = '/payment-methods';
  static const String securityRoute = '/security';
  static const String settingRoute = '/settings';
  static const String helpCenterRoute = '/help-center';
  static const String termsRoute = '/terms-conditions';
  static const String privacyRoute = '/privacy-policy';

  // Car Categories
  static const List<String> carCategories = [
    'semua',
    'City car',
    'MPV',
    'Minibus',
    'SUV',
  ];

  // Firestore Collections
  static const String carsCollection = 'cars';
  static const String bookingsCollection = 'bookings';
  static const String usersCollection = 'users';

  // Shared Prefs Keys
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String isLoggedInKey = 'is_logged_in';
}
