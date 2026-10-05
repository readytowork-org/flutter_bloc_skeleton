import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 's_en.dart';
import 's_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/s.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @authHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get authHome;

  /// No description provided for @authName.
  ///
  /// In en, this message translates to:
  /// **'Enter a Full Name'**
  String get authName;

  /// No description provided for @authEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter a Email Address'**
  String get authEmailAddress;

  /// No description provided for @authPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get authPhone;

  /// No description provided for @authFurigana.
  ///
  /// In en, this message translates to:
  /// **'Enter a Furigana'**
  String get authFurigana;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a Password'**
  String get authPassword;

  /// No description provided for @authTest.
  ///
  /// In en, this message translates to:
  /// **'test'**
  String get authTest;

  /// No description provided for @homeProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get homeProduct;

  /// No description provided for @homeProductName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get homeProductName;

  /// No description provided for @homeEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get homeEmailAddress;

  /// No description provided for @homePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get homePhone;

  /// No description provided for @homeFurigana.
  ///
  /// In en, this message translates to:
  /// **'Furigana'**
  String get homeFurigana;

  /// No description provided for @productProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productProduct;

  /// No description provided for @productProductName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productProductName;

  /// No description provided for @productEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get productEmailAddress;

  /// No description provided for @productPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get productPhone;

  /// No description provided for @productFurigana.
  ///
  /// In en, this message translates to:
  /// **'Furigana'**
  String get productFurigana;

  /// No description provided for @cartProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get cartProduct;

  /// No description provided for @cartProductName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get cartProductName;

  /// No description provided for @cartEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get cartEmailAddress;

  /// No description provided for @cartPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get cartPhone;

  /// No description provided for @cartFurigana.
  ///
  /// In en, this message translates to:
  /// **'Furigana'**
  String get cartFurigana;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'ja':
      return SJa();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
