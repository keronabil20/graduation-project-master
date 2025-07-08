// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `ID`
  String get id {
    return Intl.message('ID', name: 'id', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Menu`
  String get menu {
    return Intl.message('Menu', name: 'menu', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `We're here to help you discover the best restaurants around you.`
  String get first_instruction {
    return Intl.message(
      'We\'re here to help you discover the best restaurants around you.',
      name: 'first_instruction',
      desc: '',
      args: [],
    );
  }

  /// `People will try beyond you `
  String get second_instruction {
    return Intl.message(
      'People will try beyond you ',
      name: 'second_instruction',
      desc: '',
      args: [],
    );
  }

  /// `Rate now with Revo`
  String get third_instruction {
    return Intl.message(
      'Rate now with Revo',
      name: 'third_instruction',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logout {
    return Intl.message('Log Out', name: 'logout', desc: '', args: []);
  }

  /// `user type`
  String get user_type {
    return Intl.message('user type', name: 'user_type', desc: '', args: []);
  }

  /// `First`
  String get first {
    return Intl.message('First', name: 'first', desc: '', args: []);
  }

  /// `Second`
  String get second {
    return Intl.message('Second', name: 'second', desc: '', args: []);
  }

  /// `Third`
  String get third {
    return Intl.message('Third', name: 'third', desc: '', args: []);
  }

  /// `Fourth`
  String get fourth {
    return Intl.message('Fourth', name: 'fourth', desc: '', args: []);
  }

  /// `Map`
  String get map {
    return Intl.message('Map', name: 'map', desc: '', args: []);
  }

  /// `Person`
  String get person {
    return Intl.message('Person', name: 'person', desc: '', args: []);
  }

  /// `Likes`
  String get likes {
    return Intl.message('Likes', name: 'likes', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get google {
    return Intl.message('Google', name: 'google', desc: '', args: []);
  }

  /// `Sign-Up Successful!`
  String get sign_Up_Successful {
    return Intl.message(
      'Sign-Up Successful!',
      name: 'sign_Up_Successful',
      desc: '',
      args: [],
    );
  }

  /// `Sign-Up Failed!`
  String get sign_Up_Failed {
    return Intl.message(
      'Sign-Up Failed!',
      name: 'sign_Up_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant`
  String get restaurant {
    return Intl.message('Restaurant', name: 'restaurant', desc: '', args: []);
  }

  /// `Account Type`
  String get accountType {
    return Intl.message(
      'Account Type',
      name: 'accountType',
      desc: '',
      args: [],
    );
  }

  /// ` User`
  String get regularUser {
    return Intl.message(' User', name: 'regularUser', desc: '', args: []);
  }

  /// `Owner`
  String get restaurantOwner {
    return Intl.message('Owner', name: 'restaurantOwner', desc: '', args: []);
  }

  /// `Full Name`
  String get fullname {
    return Intl.message('Full Name', name: 'fullname', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant Information`
  String get restaurantInfo {
    return Intl.message(
      'Restaurant Information',
      name: 'restaurantInfo',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant Name`
  String get restaurantName {
    return Intl.message(
      'Restaurant Name',
      name: 'restaurantName',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant Address`
  String get restaurantAddress {
    return Intl.message(
      'Restaurant Address',
      name: 'restaurantAddress',
      desc: '',
      args: [],
    );
  }

  /// `Note: Restaurant owner accounts require admin verification before you can create restaurant listings.`
  String get verificationNote {
    return Intl.message(
      'Note: Restaurant owner accounts require admin verification before you can create restaurant listings.',
      name: 'verificationNote',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Please enter your name`
  String get nameValidation {
    return Intl.message(
      'Please enter your name',
      name: 'nameValidation',
      desc: '',
      args: [],
    );
  }

  /// `Name too long (max 100 characters)`
  String get nameTooLong {
    return Intl.message(
      'Name too long (max 100 characters)',
      name: 'nameTooLong',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get emailValidation {
    return Intl.message(
      'Please enter your email',
      name: 'emailValidation',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email too long`
  String get emailTooLong {
    return Intl.message(
      'Email too long',
      name: 'emailTooLong',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get passwordValidation {
    return Intl.message(
      'Please enter a password',
      name: 'passwordValidation',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain:\n- 8+ characters\n- Uppercase letter\n- Lowercase letter\n- Number\n- Special character`
  String get passwordRequirements {
    return Intl.message(
      'Password must contain:\n- 8+ characters\n- Uppercase letter\n- Lowercase letter\n- Number\n- Special character',
      name: 'passwordRequirements',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get confirmPasswordValidation {
    return Intl.message(
      'Please confirm your password',
      name: 'confirmPasswordValidation',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordMismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Please enter restaurant name`
  String get restaurantNameValidation {
    return Intl.message(
      'Please enter restaurant name',
      name: 'restaurantNameValidation',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant name too long (max 100 characters)`
  String get restaurantNameTooLong {
    return Intl.message(
      'Restaurant name too long (max 100 characters)',
      name: 'restaurantNameTooLong',
      desc: '',
      args: [],
    );
  }

  /// `Please enter restaurant address`
  String get restaurantAddressValidation {
    return Intl.message(
      'Please enter restaurant address',
      name: 'restaurantAddressValidation',
      desc: '',
      args: [],
    );
  }

  /// `Address too long (max 200 characters)`
  String get restaurantAddressTooLong {
    return Intl.message(
      'Address too long (max 200 characters)',
      name: 'restaurantAddressTooLong',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all restaurant information`
  String get fillRestaurantInfo {
    return Intl.message(
      'Please fill all restaurant information',
      name: 'fillRestaurantInfo',
      desc: '',
      args: [],
    );
  }

  /// `Verification Pending`
  String get verificationPendingTitle {
    return Intl.message(
      'Verification Pending',
      name: 'verificationPendingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your restaurant owner account is under review. You will receive an email notification once approved.`
  String get verificationPendingDesc {
    return Intl.message(
      'Your restaurant owner account is under review. You will receive an email notification once approved.',
      name: 'verificationPendingDesc',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up Failed`
  String get signUpFailed {
    return Intl.message(
      'Sign Up Failed',
      name: 'signUpFailed',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again.`
  String get errorOccurred {
    return Intl.message(
      'An error occurred. Please try again.',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `You need to be logged in to view favorites`
  String get viewfavorites {
    return Intl.message(
      'You need to be logged in to view favorites',
      name: 'viewfavorites',
      desc: '',
      args: [],
    );
  }

  /// `My Favorite Restaurants`
  String get favrestaurants {
    return Intl.message(
      'My Favorite Restaurants',
      name: 'favrestaurants',
      desc: '',
      args: [],
    );
  }

  /// `No favorite restaurants yet`
  String get nofavorites {
    return Intl.message(
      'No favorite restaurants yet',
      name: 'nofavorites',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message('View', name: 'view', desc: '', args: []);
  }

  /// `You will go back to the main screen if you click the logout button.`
  String get logoutMessage {
    return Intl.message(
      'You will go back to the main screen if you click the logout button.',
      name: 'logoutMessage',
      desc: '',
      args: [],
    );
  }

  /// `Want to logout now?`
  String get wantToLogoutNow {
    return Intl.message(
      'Want to logout now?',
      name: 'wantToLogoutNow',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `No user data found`
  String get noUserDataFound {
    return Intl.message(
      'No user data found',
      name: 'noUserDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Switch to Light Mode`
  String get switchToLight {
    return Intl.message(
      'Switch to Light Mode',
      name: 'switchToLight',
      desc: '',
      args: [],
    );
  }

  /// `Switch to Dark Mode`
  String get switchToDark {
    return Intl.message(
      'Switch to Dark Mode',
      name: 'switchToDark',
      desc: '',
      args: [],
    );
  }

  /// `Change to arabic`
  String get language {
    return Intl.message(
      'Change to arabic',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Switch to Dark Mode`
  String get stdark {
    return Intl.message(
      'Switch to Dark Mode',
      name: 'stdark',
      desc: '',
      args: [],
    );
  }

  /// `Switch to Light Mode`
  String get stlight {
    return Intl.message(
      'Switch to Light Mode',
      name: 'stlight',
      desc: '',
      args: [],
    );
  }

  /// `Revo`
  String get appTitle {
    return Intl.message('Revo', name: 'appTitle', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Premium Dining`
  String get premiumDining {
    return Intl.message(
      'Premium Dining',
      name: 'premiumDining',
      desc: '',
      args: [],
    );
  }

  /// `Exclusive Offers`
  String get exclusiveOffers {
    return Intl.message(
      'Exclusive Offers',
      name: 'exclusiveOffers',
      desc: '',
      args: [],
    );
  }

  /// `Premium Experience`
  String get premiumExperience {
    return Intl.message(
      'Premium Experience',
      name: 'premiumExperience',
      desc: '',
      args: [],
    );
  }

  /// `Book your table now`
  String get bookYourTable {
    return Intl.message(
      'Book your table now',
      name: 'bookYourTable',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Forget Password?`
  String get forgotPassword {
    return Intl.message(
      'Forget Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Our Menu`
  String get ourMenu {
    return Intl.message('Our Menu', name: 'ourMenu', desc: '', args: []);
  }

  /// `View All`
  String get viewAll {
    return Intl.message('View All', name: 'viewAll', desc: '', args: []);
  }

  /// `Discover our exquisite selection`
  String get discoverSelection {
    return Intl.message(
      'Discover our exquisite selection',
      name: 'discoverSelection',
      desc: '',
      args: [],
    );
  }

  /// `EGP`
  String get currency {
    return Intl.message('EGP', name: 'currency', desc: '', args: []);
  }

  /// `Error loading restaurant data`
  String get errorLoadingRestaurant {
    return Intl.message(
      'Error loading restaurant data',
      name: 'errorLoadingRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `No description available`
  String get noDescription {
    return Intl.message(
      'No description available',
      name: 'noDescription',
      desc: '',
      args: [],
    );
  }

  /// `Search for restaurants`
  String get searchForRestaurants {
    return Intl.message(
      'Search for restaurants',
      name: 'searchForRestaurants',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResultsFound {
    return Intl.message(
      'No results found',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
