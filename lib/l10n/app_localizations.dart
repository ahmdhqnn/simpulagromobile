import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('id'),
  ];

  /// The title of the application
  ///
  /// In id, this message translates to:
  /// **'SimpulAgro'**
  String get appTitle;

  /// No description provided for @greetingMorning.
  ///
  /// In id, this message translates to:
  /// **'Selamat Pagi,'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In id, this message translates to:
  /// **'Selamat Siang,'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In id, this message translates to:
  /// **'Selamat Sore,'**
  String get greetingEvening;

  /// No description provided for @greetingNight.
  ///
  /// In id, this message translates to:
  /// **'Selamat Malam,'**
  String get greetingNight;

  /// No description provided for @weatherLoading.
  ///
  /// In id, this message translates to:
  /// **'Memuat cuaca...'**
  String get weatherLoading;

  /// No description provided for @weatherError.
  ///
  /// In id, this message translates to:
  /// **'Gagal'**
  String get weatherError;

  /// No description provided for @dashboardTitle.
  ///
  /// In id, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @recentActivityTitle.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas Terkini'**
  String get recentActivityTitle;

  /// No description provided for @recentActivityEmpty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada aktivitas hari ini.'**
  String get recentActivityEmpty;

  /// No description provided for @sensorSectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Status Sensor'**
  String get sensorSectionTitle;

  /// No description provided for @activeSensors.
  ///
  /// In id, this message translates to:
  /// **'{count} Aktif'**
  String activeSensors(int count);

  /// No description provided for @plantSectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Tanaman'**
  String get plantSectionTitle;

  /// No description provided for @activePlants.
  ///
  /// In id, this message translates to:
  /// **'{count} Fase Aktif'**
  String activePlants(int count);

  /// No description provided for @viewAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat Semua'**
  String get viewAll;

  /// No description provided for @errorLoadData.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data'**
  String get errorLoadData;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get retry;

  /// No description provided for @healthSectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Kesehatan Lingkungan'**
  String get healthSectionTitle;

  /// No description provided for @summarySectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan'**
  String get summarySectionTitle;

  /// No description provided for @deviceTitle.
  ///
  /// In id, this message translates to:
  /// **'Device'**
  String get deviceTitle;

  /// No description provided for @sensorTitle.
  ///
  /// In id, this message translates to:
  /// **'Sensor'**
  String get sensorTitle;

  /// No description provided for @plantTitle.
  ///
  /// In id, this message translates to:
  /// **'Tanaman'**
  String get plantTitle;

  /// No description provided for @errorLoadSite.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat site'**
  String get errorLoadSite;

  /// No description provided for @errorLoadHealth.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data kesehatan'**
  String get errorLoadHealth;

  /// No description provided for @emptySite.
  ///
  /// In id, this message translates to:
  /// **'Pilih site terlebih dahulu'**
  String get emptySite;

  /// No description provided for @emptySensor.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data sensor'**
  String get emptySensor;

  /// No description provided for @taskTitle.
  ///
  /// In id, this message translates to:
  /// **'Task'**
  String get taskTitle;

  /// No description provided for @taskSummarySectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Task'**
  String get taskSummarySectionTitle;

  /// No description provided for @quickActionSectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Aksi Cepat'**
  String get quickActionSectionTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
