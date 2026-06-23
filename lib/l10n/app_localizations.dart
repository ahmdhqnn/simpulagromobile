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
  /// **'Status Parameter Sensor'**
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

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTitle;

  /// No description provided for @settingsAccountSection.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get settingsAccountSection;

  /// No description provided for @settingsAboutSection.
  ///
  /// In id, this message translates to:
  /// **'Tentang'**
  String get settingsAboutSection;

  /// No description provided for @settingsChangePassword.
  ///
  /// In id, this message translates to:
  /// **'Ganti Password'**
  String get settingsChangePassword;

  /// No description provided for @settingsChangePasswordSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Perbarui password akun Anda'**
  String get settingsChangePasswordSubtitle;

  /// No description provided for @changePasswordTitle.
  ///
  /// In id, this message translates to:
  /// **'Ganti Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordCurrentLabel.
  ///
  /// In id, this message translates to:
  /// **'Password Lama'**
  String get changePasswordCurrentLabel;

  /// No description provided for @changePasswordCurrentHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan password lama'**
  String get changePasswordCurrentHint;

  /// No description provided for @changePasswordCurrentRequired.
  ///
  /// In id, this message translates to:
  /// **'Password lama wajib diisi'**
  String get changePasswordCurrentRequired;

  /// No description provided for @changePasswordNewLabel.
  ///
  /// In id, this message translates to:
  /// **'Password Baru'**
  String get changePasswordNewLabel;

  /// No description provided for @changePasswordNewHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan password baru'**
  String get changePasswordNewHint;

  /// No description provided for @changePasswordNewRequired.
  ///
  /// In id, this message translates to:
  /// **'Password baru wajib diisi'**
  String get changePasswordNewRequired;

  /// No description provided for @changePasswordConfirmLabel.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Password Baru'**
  String get changePasswordConfirmLabel;

  /// No description provided for @changePasswordConfirmHint.
  ///
  /// In id, this message translates to:
  /// **'Ulangi password baru'**
  String get changePasswordConfirmHint;

  /// No description provided for @changePasswordConfirmRequired.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi password wajib diisi'**
  String get changePasswordConfirmRequired;

  /// No description provided for @changePasswordConfirmMismatch.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi password tidak sama'**
  String get changePasswordConfirmMismatch;

  /// No description provided for @changePasswordSubmit.
  ///
  /// In id, this message translates to:
  /// **'Simpan Password Baru'**
  String get changePasswordSubmit;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In id, this message translates to:
  /// **'Password berhasil diubah'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengubah password. Silakan coba lagi.'**
  String get changePasswordFailed;

  /// No description provided for @changePasswordErrorConfirmMismatch.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi password tidak cocok.'**
  String get changePasswordErrorConfirmMismatch;

  /// No description provided for @changePasswordErrorUnauthorized.
  ///
  /// In id, this message translates to:
  /// **'Password lama salah atau sesi sudah berakhir.'**
  String get changePasswordErrorUnauthorized;

  /// No description provided for @changePasswordErrorUserNotFound.
  ///
  /// In id, this message translates to:
  /// **'Pengguna tidak ditemukan.'**
  String get changePasswordErrorUserNotFound;

  /// No description provided for @siteInviteTitle.
  ///
  /// In id, this message translates to:
  /// **'Undang Member Site'**
  String get siteInviteTitle;

  /// No description provided for @siteInviteSiteIdLabel.
  ///
  /// In id, this message translates to:
  /// **'Site ID: {siteId}'**
  String siteInviteSiteIdLabel(String siteId);

  /// No description provided for @siteInviteUserIdLabel.
  ///
  /// In id, this message translates to:
  /// **'User ID'**
  String get siteInviteUserIdLabel;

  /// No description provided for @siteInviteUserIdHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: USR_001'**
  String get siteInviteUserIdHint;

  /// No description provided for @siteInviteUserIdRequired.
  ///
  /// In id, this message translates to:
  /// **'User ID wajib diisi'**
  String get siteInviteUserIdRequired;

  /// No description provided for @siteInviteSubmit.
  ///
  /// In id, this message translates to:
  /// **'Kirim Undangan'**
  String get siteInviteSubmit;

  /// No description provided for @siteInviteSuccess.
  ///
  /// In id, this message translates to:
  /// **'Undangan member berhasil dikirim'**
  String get siteInviteSuccess;

  /// No description provided for @siteInviteErrorBadRequest.
  ///
  /// In id, this message translates to:
  /// **'Data undangan tidak valid.'**
  String get siteInviteErrorBadRequest;

  /// No description provided for @siteInviteErrorForbidden.
  ///
  /// In id, this message translates to:
  /// **'Hanya admin/site leader yang dapat mengundang member.'**
  String get siteInviteErrorForbidden;

  /// No description provided for @siteInviteErrorConflict.
  ///
  /// In id, this message translates to:
  /// **'User sudah menjadi member site ini.'**
  String get siteInviteErrorConflict;

  /// No description provided for @siteInviteErrorNoSiteSelected.
  ///
  /// In id, this message translates to:
  /// **'Site belum dipilih.'**
  String get siteInviteErrorNoSiteSelected;

  /// No description provided for @siteInviteErrorUnknown.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengirim undangan member.'**
  String get siteInviteErrorUnknown;

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
  /// **'Belum ada data parameter sensor'**
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

  /// No description provided for @plantOverviewTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Tanaman'**
  String get plantOverviewTitle;

  /// No description provided for @plantEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada penanaman'**
  String get plantEmptyTitle;

  /// No description provided for @plantEmptyMessage.
  ///
  /// In id, this message translates to:
  /// **'Mulai tambahkan tanaman pertama untuk memantau lokasi ini.'**
  String get plantEmptyMessage;

  /// No description provided for @plantAddFirst.
  ///
  /// In id, this message translates to:
  /// **'Tambah penanaman pertama'**
  String get plantAddFirst;

  /// No description provided for @plantAddTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Penanaman Pertama'**
  String get plantAddTitle;

  /// No description provided for @plantEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Penanaman'**
  String get plantEditTitle;

  /// No description provided for @plantNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Tanaman'**
  String get plantNameLabel;

  /// No description provided for @plantNameHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Padi Cigentur'**
  String get plantNameHint;

  /// No description provided for @plantNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama tanaman wajib diisi'**
  String get plantNameRequired;

  /// No description provided for @plantVarietasIdLabel.
  ///
  /// In id, this message translates to:
  /// **'ID Varietas'**
  String get plantVarietasIdLabel;

  /// No description provided for @plantVarietasIdHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: VARIETAS001'**
  String get plantVarietasIdHint;

  /// No description provided for @plantVarietasIdRequired.
  ///
  /// In id, this message translates to:
  /// **'ID varietas wajib diisi'**
  String get plantVarietasIdRequired;

  /// No description provided for @plantVarietasUseManual.
  ///
  /// In id, this message translates to:
  /// **'Input manual'**
  String get plantVarietasUseManual;

  /// No description provided for @plantVarietasUseList.
  ///
  /// In id, this message translates to:
  /// **'Pilih dari daftar'**
  String get plantVarietasUseList;

  /// No description provided for @plantVarietasEmptyFallback.
  ///
  /// In id, this message translates to:
  /// **'Daftar varietas kosong. Silakan isi ID varietas manual.'**
  String get plantVarietasEmptyFallback;

  /// No description provided for @plantVarietasLoadFailedFallback.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat varietas. Gunakan input ID manual.'**
  String get plantVarietasLoadFailedFallback;

  /// No description provided for @plantTypeLabel.
  ///
  /// In id, this message translates to:
  /// **'Jenis Tanaman'**
  String get plantTypeLabel;

  /// No description provided for @plantTypeHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: PADI, JAGUNG, dll.'**
  String get plantTypeHint;

  /// No description provided for @plantTypeRequired.
  ///
  /// In id, this message translates to:
  /// **'Pilih jenis tanaman terlebih dahulu'**
  String get plantTypeRequired;

  /// No description provided for @plantDateLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Tanam'**
  String get plantDateLabel;

  /// No description provided for @plantActiveConflict.
  ///
  /// In id, this message translates to:
  /// **'Lokasi ini masih memiliki tanaman aktif \"{name}\". Panen terlebih dahulu sebelum menambah yang baru.'**
  String plantActiveConflict(String name);

  /// No description provided for @plantCreateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Tanaman berhasil ditambahkan'**
  String get plantCreateSuccess;

  /// No description provided for @plantUpdateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Tanaman berhasil diperbarui'**
  String get plantUpdateSuccess;

  /// No description provided for @plantCreateFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menambahkan tanaman. Silakan coba lagi.'**
  String get plantCreateFailed;

  /// No description provided for @plantUpdateFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memperbarui tanaman. Silakan coba lagi.'**
  String get plantUpdateFailed;

  /// No description provided for @plantListEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada tanaman'**
  String get plantListEmpty;

  /// No description provided for @plantListEmptyHint.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan tanaman pertama Anda'**
  String get plantListEmptyHint;

  /// No description provided for @plantLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data'**
  String get plantLoadFailed;

  /// No description provided for @plantHarvestDialogTitle.
  ///
  /// In id, this message translates to:
  /// **'Panen tanaman?'**
  String get plantHarvestDialogTitle;

  /// No description provided for @plantHarvestDialogMessage.
  ///
  /// In id, this message translates to:
  /// **'\"{name}\" akan ditandai sudah dipanen. Aksi ini tidak dapat dibatalkan.'**
  String plantHarvestDialogMessage(String name);

  /// No description provided for @plantHarvestConfirm.
  ///
  /// In id, this message translates to:
  /// **'Ya, panen'**
  String get plantHarvestConfirm;

  /// No description provided for @plantHarvestSuccess.
  ///
  /// In id, this message translates to:
  /// **'\"{name}\" berhasil ditandai sudah panen'**
  String plantHarvestSuccess(String name);

  /// No description provided for @plantHarvestFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memanen tanaman'**
  String get plantHarvestFailed;

  /// No description provided for @plantDeleteDialogMessage.
  ///
  /// In id, this message translates to:
  /// **'\"{name}\" akan dihapus permanen. Aksi ini tidak dapat dibatalkan.'**
  String plantDeleteDialogMessage(String name);

  /// No description provided for @plantDeleteSuccess.
  ///
  /// In id, this message translates to:
  /// **'\"{name}\" berhasil dihapus'**
  String plantDeleteSuccess(String name);

  /// No description provided for @plantDeleteFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menghapus tanaman'**
  String get plantDeleteFailed;

  /// No description provided for @plantInvalidSite.
  ///
  /// In id, this message translates to:
  /// **'Site tidak valid'**
  String get plantInvalidSite;

  /// No description provided for @plantActionEdit.
  ///
  /// In id, this message translates to:
  /// **'Edit tanaman'**
  String get plantActionEdit;

  /// No description provided for @plantActionHarvest.
  ///
  /// In id, this message translates to:
  /// **'Panen tanaman'**
  String get plantActionHarvest;

  /// No description provided for @plantActionDelete.
  ///
  /// In id, this message translates to:
  /// **'Hapus tanaman'**
  String get plantActionDelete;

  /// No description provided for @plantGrowthTitle.
  ///
  /// In id, this message translates to:
  /// **'Pertumbuhan'**
  String get plantGrowthTitle;

  /// No description provided for @plantInfoTitle.
  ///
  /// In id, this message translates to:
  /// **'Informasi Tanaman'**
  String get plantInfoTitle;

  /// No description provided for @plantHstLabel.
  ///
  /// In id, this message translates to:
  /// **'HST'**
  String get plantHstLabel;

  /// No description provided for @plantHstSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hari Setelah Tanam'**
  String get plantHstSubtitle;

  /// No description provided for @plantPhaseLabel.
  ///
  /// In id, this message translates to:
  /// **'Fase'**
  String get plantPhaseLabel;

  /// No description provided for @plantPhaseSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Fase Pertumbuhan'**
  String get plantPhaseSubtitle;

  /// No description provided for @plantSpeciesLabel.
  ///
  /// In id, this message translates to:
  /// **'Spesies'**
  String get plantSpeciesLabel;

  /// No description provided for @plantPlantDateLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Tanam'**
  String get plantPlantDateLabel;

  /// No description provided for @plantHarvestDateLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Panen'**
  String get plantHarvestDateLabel;

  /// No description provided for @plantTargetHarvestLabel.
  ///
  /// In id, this message translates to:
  /// **'Target Panen'**
  String get plantTargetHarvestLabel;

  /// No description provided for @plantViewPhases.
  ///
  /// In id, this message translates to:
  /// **'Lihat Fase Pertumbuhan'**
  String get plantViewPhases;

  /// No description provided for @plantGddTracking.
  ///
  /// In id, this message translates to:
  /// **'Pelacakan GDD'**
  String get plantGddTracking;

  /// No description provided for @plantMarkHarvested.
  ///
  /// In id, this message translates to:
  /// **'Tandai Sudah Panen'**
  String get plantMarkHarvested;

  /// No description provided for @phaseGrowthTitle.
  ///
  /// In id, this message translates to:
  /// **'Fase Pertumbuhan'**
  String get phaseGrowthTitle;

  /// No description provided for @phaseOverallProgressTitle.
  ///
  /// In id, this message translates to:
  /// **'Progress Keseluruhan'**
  String get phaseOverallProgressTitle;

  /// No description provided for @phaseOverallProgressSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Progress fase keseluruhan'**
  String get phaseOverallProgressSubtitle;

  /// No description provided for @phaseStatusCompleted.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get phaseStatusCompleted;

  /// No description provided for @phaseStatusActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get phaseStatusActive;

  /// No description provided for @phaseStatusUpcoming.
  ///
  /// In id, this message translates to:
  /// **'Mendatang'**
  String get phaseStatusUpcoming;

  /// No description provided for @phaseEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data fase'**
  String get phaseEmptyTitle;

  /// No description provided for @phaseEmptyMessage.
  ///
  /// In id, this message translates to:
  /// **'Data fase pertumbuhan akan muncul setelah tanaman aktif terdaftar di site ini.'**
  String get phaseEmptyMessage;

  /// No description provided for @phaseReload.
  ///
  /// In id, this message translates to:
  /// **'Muat Ulang'**
  String get phaseReload;

  /// No description provided for @phaseHstLabel.
  ///
  /// In id, this message translates to:
  /// **'HST'**
  String get phaseHstLabel;

  /// No description provided for @phaseDurationLabel.
  ///
  /// In id, this message translates to:
  /// **'Durasi'**
  String get phaseDurationLabel;

  /// No description provided for @phaseDaysValue.
  ///
  /// In id, this message translates to:
  /// **'{count} hari'**
  String phaseDaysValue(String count);

  /// No description provided for @phaseProgressDone.
  ///
  /// In id, this message translates to:
  /// **'{percent}% selesai'**
  String phaseProgressDone(String percent);

  /// No description provided for @phaseDetailProgressTitle.
  ///
  /// In id, this message translates to:
  /// **'Progress Fase'**
  String get phaseDetailProgressTitle;

  /// No description provided for @phaseDetailProgressSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pelacakan progress fase'**
  String get phaseDetailProgressSubtitle;

  /// No description provided for @phaseCurrentHstLabel.
  ///
  /// In id, this message translates to:
  /// **'HST Saat Ini'**
  String get phaseCurrentHstLabel;

  /// No description provided for @phaseRemainingDaysLabel.
  ///
  /// In id, this message translates to:
  /// **'Sisa Hari'**
  String get phaseRemainingDaysLabel;

  /// No description provided for @phaseTargetHstLabel.
  ///
  /// In id, this message translates to:
  /// **'Target HST'**
  String get phaseTargetHstLabel;

  /// No description provided for @phaseHstRangeTitle.
  ///
  /// In id, this message translates to:
  /// **'Rentang HST'**
  String get phaseHstRangeTitle;

  /// No description provided for @phaseHstRangeSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hari Setelah Tanam'**
  String get phaseHstRangeSubtitle;

  /// No description provided for @phaseTimelineStartLabel.
  ///
  /// In id, this message translates to:
  /// **'Mulai'**
  String get phaseTimelineStartLabel;

  /// No description provided for @phaseTimelineEndLabel.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get phaseTimelineEndLabel;

  /// No description provided for @phaseTimelineStartSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Awal fase'**
  String get phaseTimelineStartSubtitle;

  /// No description provided for @phaseTimelineCompleted.
  ///
  /// In id, this message translates to:
  /// **'Sudah selesai'**
  String get phaseTimelineCompleted;

  /// No description provided for @phaseTimelineNotStarted.
  ///
  /// In id, this message translates to:
  /// **'Belum dimulai'**
  String get phaseTimelineNotStarted;

  /// No description provided for @phaseDaysRemaining.
  ///
  /// In id, this message translates to:
  /// **'~{count} hari lagi'**
  String phaseDaysRemaining(String count);

  /// No description provided for @plantDetailHarvestTitle.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Panen'**
  String get plantDetailHarvestTitle;

  /// No description provided for @plantDetailHarvestMessage.
  ///
  /// In id, this message translates to:
  /// **'Tandai \"{name}\" sudah dipanen?'**
  String plantDetailHarvestMessage(String name);

  /// No description provided for @plantDetailHarvestConfirm.
  ///
  /// In id, this message translates to:
  /// **'Ya, Sudah Panen'**
  String get plantDetailHarvestConfirm;

  /// No description provided for @plantDetailCancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get plantDetailCancel;

  /// No description provided for @plantErrorTitle.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan'**
  String get plantErrorTitle;

  /// No description provided for @plantDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Tanaman'**
  String get plantDetailTitle;

  /// No description provided for @plantHstUnit.
  ///
  /// In id, this message translates to:
  /// **'Hari'**
  String get plantHstUnit;

  /// No description provided for @plantStatusLabel.
  ///
  /// In id, this message translates to:
  /// **'Status'**
  String get plantStatusLabel;

  /// No description provided for @monitoringTitle.
  ///
  /// In id, this message translates to:
  /// **'Monitoring'**
  String get monitoringTitle;

  /// No description provided for @monitoringTabRealtime.
  ///
  /// In id, this message translates to:
  /// **'Realtime'**
  String get monitoringTabRealtime;

  /// No description provided for @monitoringTabRawReads.
  ///
  /// In id, this message translates to:
  /// **'Raw Reads'**
  String get monitoringTabRawReads;

  /// No description provided for @monitoringTabDailyRecap.
  ///
  /// In id, this message translates to:
  /// **'Rekap Harian'**
  String get monitoringTabDailyRecap;

  /// No description provided for @monitoringTabMonthlyRecap.
  ///
  /// In id, this message translates to:
  /// **'Rekap Bulan'**
  String get monitoringTabMonthlyRecap;

  /// No description provided for @monitoringTabMaps.
  ///
  /// In id, this message translates to:
  /// **'Peta'**
  String get monitoringTabMaps;

  /// No description provided for @monitoringTabAnalytics.
  ///
  /// In id, this message translates to:
  /// **'Analisis'**
  String get monitoringTabAnalytics;

  /// No description provided for @monitoringTabAdmin.
  ///
  /// In id, this message translates to:
  /// **'Admin'**
  String get monitoringTabAdmin;

  /// No description provided for @monitoringSyncWaiting.
  ///
  /// In id, this message translates to:
  /// **'Menunggu sinkronisasi'**
  String get monitoringSyncWaiting;

  /// No description provided for @monitoringSyncAt.
  ///
  /// In id, this message translates to:
  /// **'Sinkron {time}'**
  String monitoringSyncAt(String time);

  /// No description provided for @monitoringSyncStale.
  ///
  /// In id, this message translates to:
  /// **'data perlu disegarkan'**
  String get monitoringSyncStale;

  /// No description provided for @monitoringAutoRefreshEvery.
  ///
  /// In id, this message translates to:
  /// **'Auto-refresh {seconds} detik'**
  String monitoringAutoRefreshEvery(int seconds);

  /// No description provided for @monitoringAutoRefreshOff.
  ///
  /// In id, this message translates to:
  /// **'Auto-refresh nonaktif'**
  String get monitoringAutoRefreshOff;

  /// No description provided for @monitoringNoActivePlantTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada tanaman aktif'**
  String get monitoringNoActivePlantTitle;

  /// No description provided for @monitoringNoActivePlantMessage.
  ///
  /// In id, this message translates to:
  /// **'Data sensor tetap diperbarui. Tambahkan tanaman agar rekomendasi monitoring terhubung ke siklus tanam.'**
  String get monitoringNoActivePlantMessage;

  /// No description provided for @monitoringAddPlant.
  ///
  /// In id, this message translates to:
  /// **'Tambah Tanaman'**
  String get monitoringAddPlant;

  /// No description provided for @monitoringViewPlantList.
  ///
  /// In id, this message translates to:
  /// **'Lihat daftar tanaman'**
  String get monitoringViewPlantList;

  /// No description provided for @monitoringLatestStatusTitle.
  ///
  /// In id, this message translates to:
  /// **'Status Parameter Terkini'**
  String get monitoringLatestStatusTitle;

  /// No description provided for @monitoringTodayChartSection.
  ///
  /// In id, this message translates to:
  /// **'Grafik Hari Ini'**
  String get monitoringTodayChartSection;

  /// No description provided for @monitoringSensorDetailSection.
  ///
  /// In id, this message translates to:
  /// **'Detail Status Parameter Sensor'**
  String get monitoringSensorDetailSection;

  /// No description provided for @monitoringEmptySensor.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data parameter sensor'**
  String get monitoringEmptySensor;

  /// No description provided for @monitoringEmptyTodayChart.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data grafik hari ini'**
  String get monitoringEmptyTodayChart;

  /// No description provided for @monitoringHistoryChartSection.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Grafik'**
  String get monitoringHistoryChartSection;

  /// No description provided for @monitoringEmptyHistory.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data riwayat'**
  String get monitoringEmptyHistory;

  /// No description provided for @monitoringSelectSensor.
  ///
  /// In id, this message translates to:
  /// **'Pilih parameter sensor'**
  String get monitoringSelectSensor;

  /// No description provided for @monitoringHistoryDataSection.
  ///
  /// In id, this message translates to:
  /// **'Data Riwayat'**
  String get monitoringHistoryDataSection;

  /// No description provided for @monitoringChartNoSensorData.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data untuk sensor ini'**
  String get monitoringChartNoSensorData;

  /// No description provided for @monitoringChartDailyAggregation.
  ///
  /// In id, this message translates to:
  /// **'Agregasi Harian'**
  String get monitoringChartDailyAggregation;

  /// No description provided for @monitoringChartNoDailyAggregation.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data agregasi harian'**
  String get monitoringChartNoDailyAggregation;

  /// No description provided for @monitoringChartLast7DaysAggregation.
  ///
  /// In id, this message translates to:
  /// **'Agregasi 7 Hari Terakhir'**
  String get monitoringChartLast7DaysAggregation;

  /// No description provided for @monitoringMonthlyRecapSection.
  ///
  /// In id, this message translates to:
  /// **'Rekap Bulanan'**
  String get monitoringMonthlyRecapSection;

  /// No description provided for @monitoringDailyTodaySection.
  ///
  /// In id, this message translates to:
  /// **'Rekap Hari Ini'**
  String get monitoringDailyTodaySection;

  /// No description provided for @monitoringDailyByDateSection.
  ///
  /// In id, this message translates to:
  /// **'Rekap Per Tanggal'**
  String get monitoringDailyByDateSection;

  /// No description provided for @monitoringDailyNoRecap.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada data rekap'**
  String get monitoringDailyNoRecap;

  /// No description provided for @monitoringSelectSiteFirst.
  ///
  /// In id, this message translates to:
  /// **'Pilih site terlebih dahulu'**
  String get monitoringSelectSiteFirst;

  /// No description provided for @monitoringFilterToday.
  ///
  /// In id, this message translates to:
  /// **'Hari Ini'**
  String get monitoringFilterToday;

  /// No description provided for @monitoringFilterSingleDate.
  ///
  /// In id, this message translates to:
  /// **'Per Tanggal'**
  String get monitoringFilterSingleDate;

  /// No description provided for @monitoringFilterSevenDay.
  ///
  /// In id, this message translates to:
  /// **'7 Hari'**
  String get monitoringFilterSevenDay;

  /// No description provided for @monitoringFilterDateRange.
  ///
  /// In id, this message translates to:
  /// **'Rentang Tanggal'**
  String get monitoringFilterDateRange;

  /// No description provided for @monitoringFilterPlantingDate.
  ///
  /// In id, this message translates to:
  /// **'Masa Tanam'**
  String get monitoringFilterPlantingDate;

  /// No description provided for @commonDateLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get commonDateLabel;

  /// No description provided for @commonFromLabel.
  ///
  /// In id, this message translates to:
  /// **'Dari'**
  String get commonFromLabel;

  /// No description provided for @commonToLabel.
  ///
  /// In id, this message translates to:
  /// **'Sampai'**
  String get commonToLabel;

  /// No description provided for @monitoringTodayCardTitle.
  ///
  /// In id, this message translates to:
  /// **'Data Sensor Hari Ini'**
  String get monitoringTodayCardTitle;

  /// No description provided for @monitoringTodayCardSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pemantauan harian sensor realtime'**
  String get monitoringTodayCardSubtitle;

  /// No description provided for @monitoringChartNoDataForSensor.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data untuk sensor ini'**
  String get monitoringChartNoDataForSensor;

  /// No description provided for @commonMin.
  ///
  /// In id, this message translates to:
  /// **'Min'**
  String get commonMin;

  /// No description provided for @commonMax.
  ///
  /// In id, this message translates to:
  /// **'Max'**
  String get commonMax;

  /// No description provided for @commonAverage.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata'**
  String get commonAverage;

  /// No description provided for @monitoringHistoryCardSubtitle.
  ///
  /// In id, this message translates to:
  /// **'{count} data - riwayat sensor'**
  String monitoringHistoryCardSubtitle(int count);

  /// No description provided for @monitoringInvalidSensorData.
  ///
  /// In id, this message translates to:
  /// **'Data sensor tidak valid'**
  String get monitoringInvalidSensorData;

  /// No description provided for @monitoringDailyAnalyticsTitle.
  ///
  /// In id, this message translates to:
  /// **'Analisis Sensor Harian'**
  String get monitoringDailyAnalyticsTitle;

  /// No description provided for @monitoringDailyAnalyticsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Statistik Sensor Hari Ini'**
  String get monitoringDailyAnalyticsSubtitle;

  /// No description provided for @monitoringDailyEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data harian'**
  String get monitoringDailyEmpty;

  /// No description provided for @monitoringDailyUnavailableToday.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada data sensor yang tersedia untuk hari ini'**
  String get monitoringDailyUnavailableToday;

  /// No description provided for @monitoringMonthlyCardEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data rekap bulanan'**
  String get monitoringMonthlyCardEmpty;

  /// No description provided for @monitoringMonthlyCardNoSensorData.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada data untuk sensor ini'**
  String get monitoringMonthlyCardNoSensorData;

  /// No description provided for @monitoringMonthlyCardTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekap Bulanan'**
  String get monitoringMonthlyCardTitle;

  /// No description provided for @monitoringMonthlyCardSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata per bulan'**
  String get monitoringMonthlyCardSubtitle;

  /// No description provided for @monitoringMonthlyLegendAverage.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata {sensor}'**
  String monitoringMonthlyLegendAverage(String sensor);

  /// No description provided for @commonYes.
  ///
  /// In id, this message translates to:
  /// **'Ya'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In id, this message translates to:
  /// **'Tidak'**
  String get commonNo;

  /// No description provided for @commonCancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In id, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonBack.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get commonBack;

  /// No description provided for @commonRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get commonRetry;

  /// No description provided for @commonRefresh.
  ///
  /// In id, this message translates to:
  /// **'Muat Ulang'**
  String get commonRefresh;

  /// No description provided for @commonLoading.
  ///
  /// In id, this message translates to:
  /// **'Memuat...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan'**
  String get commonError;

  /// No description provided for @commonLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data'**
  String get commonLoadFailed;

  /// No description provided for @commonNoData.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada data'**
  String get commonNoData;

  /// No description provided for @commonNoDataYet.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data'**
  String get commonNoDataYet;

  /// No description provided for @commonActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get commonActive;

  /// No description provided for @commonInactive.
  ///
  /// In id, this message translates to:
  /// **'Tidak Aktif'**
  String get commonInactive;

  /// No description provided for @commonUnknown.
  ///
  /// In id, this message translates to:
  /// **'Tidak diketahui'**
  String get commonUnknown;

  /// No description provided for @commonStatus.
  ///
  /// In id, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @commonPriority.
  ///
  /// In id, this message translates to:
  /// **'Prioritas'**
  String get commonPriority;

  /// No description provided for @commonTotal.
  ///
  /// In id, this message translates to:
  /// **'Total'**
  String get commonTotal;

  /// No description provided for @commonPending.
  ///
  /// In id, this message translates to:
  /// **'Menunggu'**
  String get commonPending;

  /// No description provided for @commonInProgress.
  ///
  /// In id, this message translates to:
  /// **'Dikerjakan'**
  String get commonInProgress;

  /// No description provided for @commonCompleted.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get commonCompleted;

  /// No description provided for @commonFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal'**
  String get commonFailed;

  /// No description provided for @commonLow.
  ///
  /// In id, this message translates to:
  /// **'Rendah'**
  String get commonLow;

  /// No description provided for @commonMedium.
  ///
  /// In id, this message translates to:
  /// **'Sedang'**
  String get commonMedium;

  /// No description provided for @commonHigh.
  ///
  /// In id, this message translates to:
  /// **'Tinggi'**
  String get commonHigh;

  /// No description provided for @commonCritical.
  ///
  /// In id, this message translates to:
  /// **'Kritis'**
  String get commonCritical;

  /// No description provided for @commonApplied.
  ///
  /// In id, this message translates to:
  /// **'Diterapkan'**
  String get commonApplied;

  /// No description provided for @commonDismissed.
  ///
  /// In id, this message translates to:
  /// **'Diabaikan'**
  String get commonDismissed;

  /// No description provided for @commonExpired.
  ///
  /// In id, this message translates to:
  /// **'Kedaluwarsa'**
  String get commonExpired;

  /// No description provided for @commonAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get commonAll;

  /// No description provided for @commonOther.
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get commonOther;

  /// No description provided for @commonGeneral.
  ///
  /// In id, this message translates to:
  /// **'Umum'**
  String get commonGeneral;

  /// No description provided for @commonHighPriority.
  ///
  /// In id, this message translates to:
  /// **'Prioritas Tinggi'**
  String get commonHighPriority;

  /// No description provided for @commonActionRequired.
  ///
  /// In id, this message translates to:
  /// **'Perlu Tindakan'**
  String get commonActionRequired;

  /// No description provided for @commonInformation.
  ///
  /// In id, this message translates to:
  /// **'Informasi'**
  String get commonInformation;

  /// No description provided for @commonLocation.
  ///
  /// In id, this message translates to:
  /// **'Lokasi'**
  String get commonLocation;

  /// No description provided for @commonName.
  ///
  /// In id, this message translates to:
  /// **'Nama'**
  String get commonName;

  /// No description provided for @commonAddress.
  ///
  /// In id, this message translates to:
  /// **'Alamat'**
  String get commonAddress;

  /// No description provided for @commonCoordinates.
  ///
  /// In id, this message translates to:
  /// **'Koordinat'**
  String get commonCoordinates;

  /// No description provided for @commonAltitude.
  ///
  /// In id, this message translates to:
  /// **'Ketinggian'**
  String get commonAltitude;

  /// No description provided for @commonCreatedAt.
  ///
  /// In id, this message translates to:
  /// **'Dibuat'**
  String get commonCreatedAt;

  /// No description provided for @commonUpdatedAt.
  ///
  /// In id, this message translates to:
  /// **'Terakhir Diperbarui'**
  String get commonUpdatedAt;

  /// No description provided for @commonCompletedAt.
  ///
  /// In id, this message translates to:
  /// **'Selesai Pada'**
  String get commonCompletedAt;

  /// No description provided for @commonDescription.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi'**
  String get commonDescription;

  /// No description provided for @commonDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get commonDate;

  /// No description provided for @commonUnit.
  ///
  /// In id, this message translates to:
  /// **'Satuan'**
  String get commonUnit;

  /// No description provided for @commonSearch.
  ///
  /// In id, this message translates to:
  /// **'Cari'**
  String get commonSearch;

  /// No description provided for @commonActions.
  ///
  /// In id, this message translates to:
  /// **'Aksi'**
  String get commonActions;

  /// No description provided for @commonClose.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get commonClose;

  /// No description provided for @commonPreview.
  ///
  /// In id, this message translates to:
  /// **'Preview'**
  String get commonPreview;

  /// No description provided for @commonNone.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada'**
  String get commonNone;

  /// No description provided for @commonInvalid.
  ///
  /// In id, this message translates to:
  /// **'Tidak valid'**
  String get commonInvalid;

  /// No description provided for @commonRequired.
  ///
  /// In id, this message translates to:
  /// **'Wajib diisi'**
  String get commonRequired;

  /// No description provided for @siteTitle.
  ///
  /// In id, this message translates to:
  /// **'Site'**
  String get siteTitle;

  /// No description provided for @siteSelectFirst.
  ///
  /// In id, this message translates to:
  /// **'Pilih site terlebih dahulu'**
  String get siteSelectFirst;

  /// No description provided for @siteSelect.
  ///
  /// In id, this message translates to:
  /// **'Pilih Site'**
  String get siteSelect;

  /// No description provided for @taskTypePlanting.
  ///
  /// In id, this message translates to:
  /// **'Penanaman'**
  String get taskTypePlanting;

  /// No description provided for @taskTypeFertilizing.
  ///
  /// In id, this message translates to:
  /// **'Pemupukan'**
  String get taskTypeFertilizing;

  /// No description provided for @taskTypeHarvesting.
  ///
  /// In id, this message translates to:
  /// **'Panen'**
  String get taskTypeHarvesting;

  /// No description provided for @taskTypeWatering.
  ///
  /// In id, this message translates to:
  /// **'Penyiraman'**
  String get taskTypeWatering;

  /// No description provided for @taskTypePestControl.
  ///
  /// In id, this message translates to:
  /// **'Pengendalian Hama'**
  String get taskTypePestControl;

  /// No description provided for @taskTypeMonitoring.
  ///
  /// In id, this message translates to:
  /// **'Monitoring'**
  String get taskTypeMonitoring;

  /// No description provided for @taskTypeMaintenance.
  ///
  /// In id, this message translates to:
  /// **'Perawatan'**
  String get taskTypeMaintenance;

  /// No description provided for @cropRice.
  ///
  /// In id, this message translates to:
  /// **'Padi'**
  String get cropRice;

  /// No description provided for @cropCorn.
  ///
  /// In id, this message translates to:
  /// **'Jagung'**
  String get cropCorn;

  /// No description provided for @cropSoybean.
  ///
  /// In id, this message translates to:
  /// **'Kedelai'**
  String get cropSoybean;

  /// No description provided for @recommendationTypeNpk.
  ///
  /// In id, this message translates to:
  /// **'Pemupukan NPK'**
  String get recommendationTypeNpk;

  /// No description provided for @recommendationTypePh.
  ///
  /// In id, this message translates to:
  /// **'Penyesuaian pH'**
  String get recommendationTypePh;

  /// No description provided for @recommendationAllStatuses.
  ///
  /// In id, this message translates to:
  /// **'Semua Status'**
  String get recommendationAllStatuses;

  /// No description provided for @taskAddTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Task'**
  String get taskAddTitle;

  /// No description provided for @taskEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Task'**
  String get taskEditTitle;

  /// No description provided for @taskNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Task'**
  String get taskNameLabel;

  /// No description provided for @taskNameHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nama task'**
  String get taskNameHint;

  /// No description provided for @taskNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama task harus diisi'**
  String get taskNameRequired;

  /// No description provided for @taskDescriptionHint.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan deskripsi task'**
  String get taskDescriptionHint;

  /// No description provided for @taskTypeLabel.
  ///
  /// In id, this message translates to:
  /// **'Jenis Task'**
  String get taskTypeLabel;

  /// No description provided for @taskEmptyAll.
  ///
  /// In id, this message translates to:
  /// **'Belum ada task'**
  String get taskEmptyAll;

  /// No description provided for @taskEmptyPending.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada task yang menunggu'**
  String get taskEmptyPending;

  /// No description provided for @taskEmptyProgress.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada task yang sedang dikerjakan'**
  String get taskEmptyProgress;

  /// No description provided for @taskEmptyCompleted.
  ///
  /// In id, this message translates to:
  /// **'Belum ada task yang selesai'**
  String get taskEmptyCompleted;

  /// No description provided for @taskEmptyFailed.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada task yang gagal'**
  String get taskEmptyFailed;

  /// No description provided for @taskSiteRequiredForEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Site belum dipilih'**
  String get taskSiteRequiredForEditTitle;

  /// No description provided for @taskSiteRequiredForEditMessage.
  ///
  /// In id, this message translates to:
  /// **'Pilih site terlebih dahulu sebelum mengedit task.'**
  String get taskSiteRequiredForEditMessage;

  /// No description provided for @taskLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat task'**
  String get taskLoadFailed;

  /// No description provided for @taskNoSite.
  ///
  /// In id, this message translates to:
  /// **'Belum ada site'**
  String get taskNoSite;

  /// No description provided for @taskSiteIdMissing.
  ///
  /// In id, this message translates to:
  /// **'Site ID tidak ditemukan'**
  String get taskSiteIdMissing;

  /// No description provided for @taskUpdateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Task berhasil diupdate'**
  String get taskUpdateSuccess;

  /// No description provided for @taskCreateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Task berhasil ditambahkan'**
  String get taskCreateSuccess;

  /// No description provided for @taskDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Task'**
  String get taskDeleteTitle;

  /// No description provided for @taskDeleteSuccess.
  ///
  /// In id, this message translates to:
  /// **'Task berhasil dihapus'**
  String get taskDeleteSuccess;

  /// No description provided for @taskMarkComplete.
  ///
  /// In id, this message translates to:
  /// **'Tandai Selesai'**
  String get taskMarkComplete;

  /// No description provided for @taskStartWork.
  ///
  /// In id, this message translates to:
  /// **'Mulai Kerjakan'**
  String get taskStartWork;

  /// No description provided for @taskInfoTitle.
  ///
  /// In id, this message translates to:
  /// **'Informasi Task'**
  String get taskInfoTitle;

  /// No description provided for @taskTimeDetailsTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Waktu'**
  String get taskTimeDetailsTitle;

  /// No description provided for @taskTimelineTitle.
  ///
  /// In id, this message translates to:
  /// **'Timeline'**
  String get taskTimelineTitle;

  /// No description provided for @taskCreatedTimeline.
  ///
  /// In id, this message translates to:
  /// **'Task Dibuat'**
  String get taskCreatedTimeline;

  /// No description provided for @taskProgressTimeline.
  ///
  /// In id, this message translates to:
  /// **'Task Sedang Dikerjakan'**
  String get taskProgressTimeline;

  /// No description provided for @taskFailedTimeline.
  ///
  /// In id, this message translates to:
  /// **'Task Gagal'**
  String get taskFailedTimeline;

  /// No description provided for @taskCompletedTimeline.
  ///
  /// In id, this message translates to:
  /// **'Task Selesai'**
  String get taskCompletedTimeline;

  /// No description provided for @taskDeleteMessage.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin menghapus task \"{name}\"?'**
  String taskDeleteMessage(String name);

  /// No description provided for @taskDeleteFailure.
  ///
  /// In id, this message translates to:
  /// **'Gagal menghapus task: {message}'**
  String taskDeleteFailure(String message);

  /// No description provided for @taskUpdateStatusFailure.
  ///
  /// In id, this message translates to:
  /// **'Gagal memperbarui status: {message}'**
  String taskUpdateStatusFailure(String message);

  /// No description provided for @taskStatusUpdated.
  ///
  /// In id, this message translates to:
  /// **'Status diperbarui ke \"{status}\"'**
  String taskStatusUpdated(String status);

  /// No description provided for @taskLoadSiteFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat site: {message}'**
  String taskLoadSiteFailed(String message);

  /// No description provided for @taskUpdateFailure.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengupdate task: {message}'**
  String taskUpdateFailure(String message);

  /// No description provided for @taskCreateFailure.
  ///
  /// In id, this message translates to:
  /// **'Gagal menambah task: {message}'**
  String taskCreateFailure(String message);

  /// No description provided for @commonDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus {itemName}?'**
  String commonDeleteTitle(String itemName);

  /// No description provided for @commonDeleteIrreversible.
  ///
  /// In id, this message translates to:
  /// **'Data yang dihapus tidak dapat dikembalikan.'**
  String get commonDeleteIrreversible;

  /// No description provided for @commonErrorTitle.
  ///
  /// In id, this message translates to:
  /// **'Terjadi Kesalahan'**
  String get commonErrorTitle;

  /// No description provided for @sensorDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Sensor'**
  String get sensorDetailTitle;

  /// No description provided for @sensorTypeLabel.
  ///
  /// In id, this message translates to:
  /// **'Tipe Sensor'**
  String get sensorTypeLabel;

  /// No description provided for @sensorLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat sensor'**
  String get sensorLoadFailed;

  /// No description provided for @recommendationConfidenceLabel.
  ///
  /// In id, this message translates to:
  /// **'Tingkat Keyakinan'**
  String get recommendationConfidenceLabel;

  /// No description provided for @recommendationAppliedBy.
  ///
  /// In id, this message translates to:
  /// **'Diterapkan oleh'**
  String get recommendationAppliedBy;

  /// No description provided for @monitoringCurrentGrowthPhase.
  ///
  /// In id, this message translates to:
  /// **'Fase Pertumbuhan Saat Ini'**
  String get monitoringCurrentGrowthPhase;

  /// No description provided for @recommendationConfidenceUnknown.
  ///
  /// In id, this message translates to:
  /// **'Tidak diketahui'**
  String get recommendationConfidenceUnknown;

  /// No description provided for @recommendationConfidenceVeryHigh.
  ///
  /// In id, this message translates to:
  /// **'Sangat Tinggi'**
  String get recommendationConfidenceVeryHigh;

  /// No description provided for @plantStatusHarvested.
  ///
  /// In id, this message translates to:
  /// **'Sudah Panen'**
  String get plantStatusHarvested;

  /// No description provided for @plantStatusGrowing.
  ///
  /// In id, this message translates to:
  /// **'Sedang Tumbuh'**
  String get plantStatusGrowing;

  /// No description provided for @dashboardTodayDailyRecap.
  ///
  /// In id, this message translates to:
  /// **'Rekap Harian Hari Ini'**
  String get dashboardTodayDailyRecap;

  /// No description provided for @dashboardLatestRecommendations.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Terbaru'**
  String get dashboardLatestRecommendations;

  /// No description provided for @dashboardLatestActivity.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas Terbaru'**
  String get dashboardLatestActivity;

  /// No description provided for @dashboardActivityLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat aktivitas'**
  String get dashboardActivityLoadFailed;

  /// No description provided for @dashboardLatestNotes.
  ///
  /// In id, this message translates to:
  /// **'Catatan Terbaru'**
  String get dashboardLatestNotes;

  /// No description provided for @dashboardNoDailyRecapToday.
  ///
  /// In id, this message translates to:
  /// **'Belum ada rekap harian hari ini'**
  String get dashboardNoDailyRecapToday;

  /// No description provided for @notesEmptyForSite.
  ///
  /// In id, this message translates to:
  /// **'Belum ada catatan untuk site ini'**
  String get notesEmptyForSite;

  /// No description provided for @forumTitle.
  ///
  /// In id, this message translates to:
  /// **'Forum'**
  String get forumTitle;

  /// No description provided for @authWelcome.
  ///
  /// In id, this message translates to:
  /// **'Welcome to SimpulAgro'**
  String get authWelcome;

  /// No description provided for @authSkip.
  ///
  /// In id, this message translates to:
  /// **'Lewati'**
  String get authSkip;

  /// No description provided for @authNext.
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get authNext;

  /// No description provided for @authGetStarted.
  ///
  /// In id, this message translates to:
  /// **'Mulai'**
  String get authGetStarted;

  /// No description provided for @onboardingMonitorTitle.
  ///
  /// In id, this message translates to:
  /// **'Pantau Lahan\nLebih Akurat'**
  String get onboardingMonitorTitle;

  /// No description provided for @onboardingMonitorDesc.
  ///
  /// In id, this message translates to:
  /// **'Pantau kondisi tanaman dan kesehatan tanah secara real-time langsung dari smartphone Anda, di mana saja dan kapan saja.'**
  String get onboardingMonitorDesc;

  /// No description provided for @onboardingDataTitle.
  ///
  /// In id, this message translates to:
  /// **'Keputusan Berbasis\nData'**
  String get onboardingDataTitle;

  /// No description provided for @onboardingDataDesc.
  ///
  /// In id, this message translates to:
  /// **'Dapatkan wawasan akurat mengenai kelembapan, suhu, dan nutrisi tanah untuk menentukan langkah perawatan yang paling tepat.'**
  String get onboardingDataDesc;

  /// No description provided for @onboardingRiskTitle.
  ///
  /// In id, this message translates to:
  /// **'Minimalkan Risiko\nGagal Panen'**
  String get onboardingRiskTitle;

  /// No description provided for @onboardingRiskDesc.
  ///
  /// In id, this message translates to:
  /// **'Terima notifikasi dini jika terjadi anomali pada lahan sehingga Anda bisa bertindak lebih cepat sebelum masalah berkembang.'**
  String get onboardingRiskDesc;

  /// No description provided for @loginHeroTitle.
  ///
  /// In id, this message translates to:
  /// **'Masa Depan\nBertani, Hari Ini.'**
  String get loginHeroTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Silakan masuk ke akun Anda'**
  String get loginSubtitle;

  /// No description provided for @loginUsernameHint.
  ///
  /// In id, this message translates to:
  /// **'Username Anda'**
  String get loginUsernameHint;

  /// No description provided for @loginPasswordHint.
  ///
  /// In id, this message translates to:
  /// **'Password Anda'**
  String get loginPasswordHint;

  /// No description provided for @loginUsernameRequired.
  ///
  /// In id, this message translates to:
  /// **'Username tidak boleh kosong'**
  String get loginUsernameRequired;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In id, this message translates to:
  /// **'Password tidak boleh kosong'**
  String get loginPasswordRequired;

  /// No description provided for @loginForgotPassword.
  ///
  /// In id, this message translates to:
  /// **'Lupa Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSignIn.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get loginSignIn;

  /// No description provided for @loginFailedTitle.
  ///
  /// In id, this message translates to:
  /// **'Gagal Login'**
  String get loginFailedTitle;

  /// No description provided for @loginFailedMessage.
  ///
  /// In id, this message translates to:
  /// **'Username atau password salah'**
  String get loginFailedMessage;

  /// No description provided for @authSessionExpired.
  ///
  /// In id, this message translates to:
  /// **'Sesi Anda telah berakhir. Silakan login kembali.'**
  String get authSessionExpired;

  /// No description provided for @siteListTitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Lokasi'**
  String get siteListTitle;

  /// No description provided for @siteDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Lokasi'**
  String get siteDetailTitle;

  /// No description provided for @siteAddTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Lokasi'**
  String get siteAddTitle;

  /// No description provided for @siteEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Lokasi'**
  String get siteEditTitle;

  /// No description provided for @siteEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada lokasi'**
  String get siteEmptyTitle;

  /// No description provided for @siteEmptyMessage.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan lokasi pertanian Anda'**
  String get siteEmptyMessage;

  /// No description provided for @siteIdLabel.
  ///
  /// In id, this message translates to:
  /// **'ID Lokasi'**
  String get siteIdLabel;

  /// No description provided for @siteIdRequired.
  ///
  /// In id, this message translates to:
  /// **'ID lokasi tidak boleh kosong'**
  String get siteIdRequired;

  /// No description provided for @siteNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Lokasi'**
  String get siteNameLabel;

  /// No description provided for @siteNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama lokasi tidak boleh kosong'**
  String get siteNameRequired;

  /// No description provided for @siteNameMinLength.
  ///
  /// In id, this message translates to:
  /// **'Nama minimal 3 karakter'**
  String get siteNameMinLength;

  /// No description provided for @siteAddressHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Jl. Raya Pertanian No. 123'**
  String get siteAddressHint;

  /// No description provided for @siteIdHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: SITE001'**
  String get siteIdHint;

  /// No description provided for @siteNameHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Sawah Utara'**
  String get siteNameHint;

  /// No description provided for @siteAltitudeLabel.
  ///
  /// In id, this message translates to:
  /// **'Ketinggian (meter)'**
  String get siteAltitudeLabel;

  /// No description provided for @siteAltitudeHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: 150'**
  String get siteAltitudeHint;

  /// No description provided for @siteGpsCoordinates.
  ///
  /// In id, this message translates to:
  /// **'Koordinat GPS'**
  String get siteGpsCoordinates;

  /// No description provided for @siteStatusLabel.
  ///
  /// In id, this message translates to:
  /// **'Status Lokasi'**
  String get siteStatusLabel;

  /// No description provided for @siteUpdateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Lokasi berhasil diperbarui'**
  String get siteUpdateSuccess;

  /// No description provided for @siteCreateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Lokasi berhasil ditambahkan'**
  String get siteCreateSuccess;

  /// No description provided for @siteLoadDataFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data: {message}'**
  String siteLoadDataFailed(String message);

  /// No description provided for @siteDataTitle.
  ///
  /// In id, this message translates to:
  /// **'Data Site'**
  String get siteDataTitle;

  /// No description provided for @siteOverviewTab.
  ///
  /// In id, this message translates to:
  /// **'Overview'**
  String get siteOverviewTab;

  /// No description provided for @siteNotesTab.
  ///
  /// In id, this message translates to:
  /// **'Catatan'**
  String get siteNotesTab;

  /// No description provided for @siteLocationInfo.
  ///
  /// In id, this message translates to:
  /// **'Informasi Lokasi'**
  String get siteLocationInfo;

  /// No description provided for @siteAdditionalInfo.
  ///
  /// In id, this message translates to:
  /// **'Informasi Tambahan'**
  String get siteAdditionalInfo;

  /// No description provided for @siteInviteTooltip.
  ///
  /// In id, this message translates to:
  /// **'Undang Member'**
  String get siteInviteTooltip;

  /// No description provided for @commonSaveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan Perubahan'**
  String get commonSaveChanges;

  /// No description provided for @recommendationTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi'**
  String get recommendationTitle;

  /// No description provided for @recommendationHubTitle.
  ///
  /// In id, this message translates to:
  /// **'Pusat Rekomendasi'**
  String get recommendationHubTitle;

  /// No description provided for @recommendationSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari judul, deskripsi, tanaman, aksi, atau fase'**
  String get recommendationSearchHint;

  /// No description provided for @recommendationEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada rekomendasi'**
  String get recommendationEmptyTitle;

  /// No description provided for @recommendationEmptyAll.
  ///
  /// In id, this message translates to:
  /// **'Belum ada rekomendasi aktif untuk aksi hari ini, tanaman ML, atau fase aktif.'**
  String get recommendationEmptyAll;

  /// No description provided for @recommendationReload.
  ///
  /// In id, this message translates to:
  /// **'Muat Ulang'**
  String get recommendationReload;

  /// No description provided for @recommendationLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat rekomendasi'**
  String get recommendationLoadFailed;

  /// No description provided for @recommendationEmptyDataTitle.
  ///
  /// In id, this message translates to:
  /// **'Data rekomendasi kosong'**
  String get recommendationEmptyDataTitle;

  /// No description provided for @recommendationEmptyForSite.
  ///
  /// In id, this message translates to:
  /// **'Belum ada rekomendasi yang tersedia untuk konteks ini.'**
  String get recommendationEmptyForSite;

  /// No description provided for @recommendationFilterCategory.
  ///
  /// In id, this message translates to:
  /// **'Filter Kategori'**
  String get recommendationFilterCategory;

  /// No description provided for @recommendationFilterStatus.
  ///
  /// In id, this message translates to:
  /// **'Filter Status'**
  String get recommendationFilterStatus;

  /// No description provided for @recommendationPriorityStat.
  ///
  /// In id, this message translates to:
  /// **'Prioritas'**
  String get recommendationPriorityStat;

  /// No description provided for @recommendationDismiss.
  ///
  /// In id, this message translates to:
  /// **'Abaikan'**
  String get recommendationDismiss;

  /// No description provided for @recommendationApply.
  ///
  /// In id, this message translates to:
  /// **'Terapkan'**
  String get recommendationApply;

  /// No description provided for @recommendationEmptyFiltered.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada rekomendasi untuk filter \"{filter}\".'**
  String recommendationEmptyFiltered(String filter);

  /// No description provided for @recommendationEmptyScoped.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada data untuk filter {scope} dengan status {status}.'**
  String recommendationEmptyScoped(String scope, String status);

  /// No description provided for @recommendationAccuracy.
  ///
  /// In id, this message translates to:
  /// **'Akurasi: {level}'**
  String recommendationAccuracy(String level);

  /// No description provided for @recommendationStepsTitle.
  ///
  /// In id, this message translates to:
  /// **'Langkah-langkah'**
  String get recommendationStepsTitle;

  /// No description provided for @recommendationParametersTitle.
  ///
  /// In id, this message translates to:
  /// **'Parameter'**
  String get recommendationParametersTitle;

  /// No description provided for @recommendationSelectPhaseFirst.
  ///
  /// In id, this message translates to:
  /// **'Pilih fase terlebih dahulu'**
  String get recommendationSelectPhaseFirst;

  /// No description provided for @recommendationLabSaved.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi tersimpan'**
  String get recommendationLabSaved;

  /// No description provided for @recommendationLabTestTitle.
  ///
  /// In id, this message translates to:
  /// **'[TEST] Rekomendasi dummy - admin only'**
  String get recommendationLabTestTitle;

  /// No description provided for @recommendationPlantInputTitle.
  ///
  /// In id, this message translates to:
  /// **'Input nilai sensor untuk rekomendasi tanaman'**
  String get recommendationPlantInputTitle;

  /// No description provided for @recommendationNpkStatusLabel.
  ///
  /// In id, this message translates to:
  /// **'Status NPK'**
  String get recommendationNpkStatusLabel;

  /// No description provided for @recommendationNpkDoseLabel.
  ///
  /// In id, this message translates to:
  /// **'Dosis NPK'**
  String get recommendationNpkDoseLabel;

  /// No description provided for @recommendationPhStatusLabel.
  ///
  /// In id, this message translates to:
  /// **'Status pH'**
  String get recommendationPhStatusLabel;

  /// No description provided for @recommendationPhDoseLabel.
  ///
  /// In id, this message translates to:
  /// **'Dosis pH'**
  String get recommendationPhDoseLabel;

  /// No description provided for @recommendationNoAdditionalDose.
  ///
  /// In id, this message translates to:
  /// **'Tidak perlu tambahan'**
  String get recommendationNoAdditionalDose;

  /// No description provided for @recommendationBackendDataUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Belum tersedia dari backend'**
  String get recommendationBackendDataUnavailable;

  /// No description provided for @recommendationLabAdminTestTitle.
  ///
  /// In id, this message translates to:
  /// **'[TEST] Rekomendasi dummy - admin only'**
  String get recommendationLabAdminTestTitle;

  /// No description provided for @recommendationSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal: {error}'**
  String recommendationSaveFailed(Object error);

  /// No description provided for @recommendationAllTab.
  ///
  /// In id, this message translates to:
  /// **'Semua Rekomendasi'**
  String get recommendationAllTab;

  /// No description provided for @recommendationHistoryTab.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get recommendationHistoryTab;

  /// No description provided for @recommendationByPhaseTab.
  ///
  /// In id, this message translates to:
  /// **'Per Fase'**
  String get recommendationByPhaseTab;

  /// No description provided for @recommendationSelectPhase.
  ///
  /// In id, this message translates to:
  /// **'Pilih Fase'**
  String get recommendationSelectPhase;

  /// No description provided for @recommendationNoData.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada data'**
  String get recommendationNoData;

  /// No description provided for @recommendationSensorInputTitle.
  ///
  /// In id, this message translates to:
  /// **'Input nilai sensor untuk rekomendasi tanaman'**
  String get recommendationSensorInputTitle;

  /// No description provided for @commonOk.
  ///
  /// In id, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsEnableNotifications.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan Notifikasi'**
  String get settingsEnableNotifications;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Terima notifikasi untuk alert dan update'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsDataSyncSection.
  ///
  /// In id, this message translates to:
  /// **'Data & Sinkronisasi'**
  String get settingsDataSyncSection;

  /// No description provided for @settingsAutoRefresh.
  ///
  /// In id, this message translates to:
  /// **'Auto Refresh'**
  String get settingsAutoRefresh;

  /// No description provided for @settingsAutoRefreshSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Perbarui data layar aktif sesuai interval'**
  String get settingsAutoRefreshSubtitle;

  /// No description provided for @settingsRefreshInterval.
  ///
  /// In id, this message translates to:
  /// **'Interval Refresh'**
  String get settingsRefreshInterval;

  /// No description provided for @settingsRefreshIntervalSeconds.
  ///
  /// In id, this message translates to:
  /// **'{seconds} detik'**
  String settingsRefreshIntervalSeconds(int seconds);

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In id, this message translates to:
  /// **'Tampilan'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsLanguage.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In id, this message translates to:
  /// **'Tema'**
  String get settingsTheme;

  /// No description provided for @settingsThemeUnavailableSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Belum tersedia di versi ini'**
  String get settingsThemeUnavailableSubtitle;

  /// No description provided for @settingsThemeUnavailableMessage.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan tema belum tersedia di versi aplikasi ini.'**
  String get settingsThemeUnavailableMessage;

  /// No description provided for @settingsTemperatureUnit.
  ///
  /// In id, this message translates to:
  /// **'Satuan Suhu'**
  String get settingsTemperatureUnit;

  /// No description provided for @settingsAppVersion.
  ///
  /// In id, this message translates to:
  /// **'Versi Aplikasi'**
  String get settingsAppVersion;

  /// No description provided for @settingsHelpSupport.
  ///
  /// In id, this message translates to:
  /// **'Bantuan & Dukungan'**
  String get settingsHelpSupport;

  /// No description provided for @settingsHelpSupportSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kontak bantuan teknis'**
  String get settingsHelpSupportSubtitle;

  /// No description provided for @settingsHelpSupportMessage.
  ///
  /// In id, this message translates to:
  /// **'Untuk bantuan teknis, hubungi tim support melalui email atau WhatsApp yang tertera di aplikasi.'**
  String get settingsHelpSupportMessage;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In id, this message translates to:
  /// **'Kebijakan Privasi'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsPrivacyPolicySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Keamanan dan penggunaan data'**
  String get settingsPrivacyPolicySubtitle;

  /// No description provided for @settingsPrivacyPolicyMessage.
  ///
  /// In id, this message translates to:
  /// **'Data Anda disimpan secara aman dan tidak dibagikan kepada pihak ketiga tanpa persetujuan Anda.'**
  String get settingsPrivacyPolicyMessage;

  /// No description provided for @settingsSelectLanguage.
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa'**
  String get settingsSelectLanguage;

  /// No description provided for @settingsSelectTheme.
  ///
  /// In id, this message translates to:
  /// **'Pilih Tema'**
  String get settingsSelectTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In id, this message translates to:
  /// **'Ikuti Sistem'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLanguageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get settingsLanguageIndonesian;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsTemperatureCelsius.
  ///
  /// In id, this message translates to:
  /// **'Celsius (C)'**
  String get settingsTemperatureCelsius;

  /// No description provided for @settingsTemperatureFahrenheit.
  ///
  /// In id, this message translates to:
  /// **'Fahrenheit (F)'**
  String get settingsTemperatureFahrenheit;

  /// No description provided for @profileEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get profileEditTitle;

  /// No description provided for @profilePhotoUploadComingSoon.
  ///
  /// In id, this message translates to:
  /// **'Fitur upload foto akan segera hadir'**
  String get profilePhotoUploadComingSoon;

  /// No description provided for @profileFullNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get profileFullNameLabel;

  /// No description provided for @profileNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama tidak boleh kosong'**
  String get profileNameRequired;

  /// No description provided for @profileNameMinLength.
  ///
  /// In id, this message translates to:
  /// **'Nama minimal 3 karakter'**
  String get profileNameMinLength;

  /// No description provided for @profileEmailRequired.
  ///
  /// In id, this message translates to:
  /// **'Email tidak boleh kosong'**
  String get profileEmailRequired;

  /// No description provided for @profileEmailInvalid.
  ///
  /// In id, this message translates to:
  /// **'Email tidak valid'**
  String get profileEmailInvalid;

  /// No description provided for @profilePhoneNumberLabel.
  ///
  /// In id, this message translates to:
  /// **'Nomor Telepon'**
  String get profilePhoneNumberLabel;

  /// No description provided for @profilePhoneRequired.
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon tidak boleh kosong'**
  String get profilePhoneRequired;

  /// No description provided for @profilePhoneInvalid.
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon tidak valid'**
  String get profilePhoneInvalid;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Profil berhasil diperbarui'**
  String get profileUpdateSuccess;

  /// No description provided for @profileAccountInfoTitle.
  ///
  /// In id, this message translates to:
  /// **'Informasi Akun'**
  String get profileAccountInfoTitle;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In id, this message translates to:
  /// **'Telepon'**
  String get profilePhoneLabel;

  /// No description provided for @profileAdminSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kelola data dan akses sistem'**
  String get profileAdminSubtitle;

  /// No description provided for @profileForumManagement.
  ///
  /// In id, this message translates to:
  /// **'Manajemen Forum'**
  String get profileForumManagement;

  /// No description provided for @profileForumManagementSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kelola postingan dan komentar'**
  String get profileForumManagementSubtitle;

  /// No description provided for @profileMyPosts.
  ///
  /// In id, this message translates to:
  /// **'Postingan Saya'**
  String get profileMyPosts;

  /// No description provided for @profileMyPostsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Lihat dan kelola postingan'**
  String get profileMyPostsSubtitle;

  /// No description provided for @profileLikedPosts.
  ///
  /// In id, this message translates to:
  /// **'Postingan Disukai'**
  String get profileLikedPosts;

  /// No description provided for @profileLikedPostsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Postingan yang Anda sukai'**
  String get profileLikedPostsSubtitle;

  /// No description provided for @profileMyComments.
  ///
  /// In id, this message translates to:
  /// **'Komentar Saya'**
  String get profileMyComments;

  /// No description provided for @profileMyCommentsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Lihat semua komentar'**
  String get profileMyCommentsSubtitle;

  /// No description provided for @profilePermissionsSection.
  ///
  /// In id, this message translates to:
  /// **'Hak Akses'**
  String get profilePermissionsSection;

  /// No description provided for @profileSignout.
  ///
  /// In id, this message translates to:
  /// **'Signout'**
  String get profileSignout;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Keluar'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutMessage.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin keluar dari aplikasi?'**
  String get profileLogoutMessage;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get profileLogoutConfirm;

  /// No description provided for @commonLatitude.
  ///
  /// In id, this message translates to:
  /// **'Latitude'**
  String get commonLatitude;

  /// No description provided for @commonLongitude.
  ///
  /// In id, this message translates to:
  /// **'Longitude'**
  String get commonLongitude;

  /// No description provided for @commonPort.
  ///
  /// In id, this message translates to:
  /// **'Port'**
  String get commonPort;

  /// No description provided for @commonIpAddress.
  ///
  /// In id, this message translates to:
  /// **'IP Address'**
  String get commonIpAddress;

  /// No description provided for @commonSaved.
  ///
  /// In id, this message translates to:
  /// **'Tersimpan'**
  String get commonSaved;

  /// No description provided for @siteNoSitesAvailable.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada site tersedia'**
  String get siteNoSitesAvailable;

  /// No description provided for @notesNew.
  ///
  /// In id, this message translates to:
  /// **'Catatan Baru'**
  String get notesNew;

  /// No description provided for @notesContentHint.
  ///
  /// In id, this message translates to:
  /// **'Isi catatan...'**
  String get notesContentHint;

  /// No description provided for @notesSaved.
  ///
  /// In id, this message translates to:
  /// **'Catatan tersimpan'**
  String get notesSaved;

  /// No description provided for @notesSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan catatan'**
  String get notesSaveFailed;

  /// No description provided for @sensorAddTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Sensor'**
  String get sensorAddTitle;

  /// No description provided for @sensorEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada sensor'**
  String get sensorEmptyTitle;

  /// No description provided for @sensorEmptyMessage.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan sensor untuk mulai memantau kondisi lahan.'**
  String get sensorEmptyMessage;

  /// No description provided for @sensorUnitValue.
  ///
  /// In id, this message translates to:
  /// **'Satuan: {unit}'**
  String sensorUnitValue(String unit);

  /// No description provided for @deviceIoTTitle.
  ///
  /// In id, this message translates to:
  /// **'Perangkat IoT'**
  String get deviceIoTTitle;

  /// No description provided for @deviceAddTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Perangkat'**
  String get deviceAddTitle;

  /// No description provided for @deviceEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Perangkat'**
  String get deviceEditTitle;

  /// No description provided for @deviceDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Perangkat'**
  String get deviceDetailTitle;

  /// No description provided for @deviceEmptyMessage.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada perangkat ditemukan'**
  String get deviceEmptyMessage;

  /// No description provided for @deviceIdLabel.
  ///
  /// In id, this message translates to:
  /// **'ID Perangkat'**
  String get deviceIdLabel;

  /// No description provided for @deviceIdRequired.
  ///
  /// In id, this message translates to:
  /// **'ID Perangkat wajib diisi'**
  String get deviceIdRequired;

  /// No description provided for @deviceNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Perangkat'**
  String get deviceNameLabel;

  /// No description provided for @deviceNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama Perangkat wajib diisi'**
  String get deviceNameRequired;

  /// No description provided for @deviceNumberIdLabel.
  ///
  /// In id, this message translates to:
  /// **'Nomor ID'**
  String get deviceNumberIdLabel;

  /// No description provided for @deviceInformationTitle.
  ///
  /// In id, this message translates to:
  /// **'Informasi Perangkat'**
  String get deviceInformationTitle;

  /// No description provided for @deviceStatusActive.
  ///
  /// In id, this message translates to:
  /// **'Status Aktif'**
  String get deviceStatusActive;

  /// No description provided for @deviceCreateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Perangkat berhasil ditambahkan'**
  String get deviceCreateSuccess;

  /// No description provided for @deviceUpdateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Perangkat berhasil diperbarui'**
  String get deviceUpdateSuccess;

  /// No description provided for @monitoringMapsNoDeviceLocations.
  ///
  /// In id, this message translates to:
  /// **'Belum ada lokasi device untuk ditampilkan'**
  String get monitoringMapsNoDeviceLocations;

  /// No description provided for @monitoringDeviceSensorList.
  ///
  /// In id, this message translates to:
  /// **'Daftar Device & Sensor'**
  String get monitoringDeviceSensorList;

  /// No description provided for @monitoringNoDevicesAvailable.
  ///
  /// In id, this message translates to:
  /// **'Belum ada device tersedia'**
  String get monitoringNoDevicesAvailable;

  /// No description provided for @monitoringAnalyticsOverview.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Analitik'**
  String get monitoringAnalyticsOverview;

  /// No description provided for @monitoringPlantStatisticsSection.
  ///
  /// In id, this message translates to:
  /// **'Statistik Tanaman'**
  String get monitoringPlantStatisticsSection;

  /// No description provided for @monitoringPlantRecommendationSection.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Tanaman'**
  String get monitoringPlantRecommendationSection;

  /// No description provided for @monitoringDeviceSensorOverviewSection.
  ///
  /// In id, this message translates to:
  /// **'Perangkat & Ringkasan Sensor'**
  String get monitoringDeviceSensorOverviewSection;

  /// No description provided for @monitoringMonthlySensorRecap.
  ///
  /// In id, this message translates to:
  /// **'Rekap Bulanan Sensor'**
  String get monitoringMonthlySensorRecap;

  /// No description provided for @monitoringRawParameterUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Parameter sensor tidak tersedia pada data raw'**
  String get monitoringRawParameterUnavailable;

  /// No description provided for @monitoringAdminOnlyMessage.
  ///
  /// In id, this message translates to:
  /// **'Tab admin hanya untuk pengguna dengan role admin.'**
  String get monitoringAdminOnlyMessage;

  /// No description provided for @monitoringReadCorrectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Koreksi Sensor Read'**
  String get monitoringReadCorrectionTitle;

  /// No description provided for @monitoringReadCorrectionDescription.
  ///
  /// In id, this message translates to:
  /// **'Perbarui nilai atau status read pada site aktif'**
  String get monitoringReadCorrectionDescription;

  /// No description provided for @monitoringSaving.
  ///
  /// In id, this message translates to:
  /// **'Menyimpan...'**
  String get monitoringSaving;

  /// No description provided for @monitoringSaveCorrection.
  ///
  /// In id, this message translates to:
  /// **'Simpan Koreksi'**
  String get monitoringSaveCorrection;

  /// No description provided for @monitoringGenerateDailyRecapTitle.
  ///
  /// In id, this message translates to:
  /// **'Generate Rekap Harian'**
  String get monitoringGenerateDailyRecapTitle;

  /// No description provided for @monitoringGenerateDailyRecapDescription.
  ///
  /// In id, this message translates to:
  /// **'Proses ulang agregasi sensor untuk tanggal dipilih'**
  String get monitoringGenerateDailyRecapDescription;

  /// No description provided for @monitoringProcessing.
  ///
  /// In id, this message translates to:
  /// **'Memproses...'**
  String get monitoringProcessing;

  /// No description provided for @monitoringGenerateRecap.
  ///
  /// In id, this message translates to:
  /// **'Generate Rekap'**
  String get monitoringGenerateRecap;

  /// No description provided for @monitoringReadIdLabel.
  ///
  /// In id, this message translates to:
  /// **'ID Bacaan'**
  String get monitoringReadIdLabel;

  /// No description provided for @monitoringReadValueLabel.
  ///
  /// In id, this message translates to:
  /// **'Nilai Bacaan (opsional)'**
  String get monitoringReadValueLabel;

  /// No description provided for @monitoringReadStsLabel.
  ///
  /// In id, this message translates to:
  /// **'Status Bacaan (opsional)'**
  String get monitoringReadStsLabel;

  /// No description provided for @monitoringReadIdRequired.
  ///
  /// In id, this message translates to:
  /// **'read_id wajib diisi'**
  String get monitoringReadIdRequired;

  /// No description provided for @monitoringReadValueMustBeNumber.
  ///
  /// In id, this message translates to:
  /// **'read_value harus berupa angka'**
  String get monitoringReadValueMustBeNumber;

  /// No description provided for @monitoringReadValueOrStatusRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi read_value atau read_sts'**
  String get monitoringReadValueOrStatusRequired;

  /// No description provided for @monitoringReadUpdated.
  ///
  /// In id, this message translates to:
  /// **'Read diperbarui'**
  String get monitoringReadUpdated;

  /// No description provided for @monitoringReadUpdateFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memperbarui read'**
  String get monitoringReadUpdateFailed;

  /// No description provided for @monitoringDailyRecapTriggered.
  ///
  /// In id, this message translates to:
  /// **'Rekap diproses untuk {day}'**
  String monitoringDailyRecapTriggered(String day);

  /// No description provided for @monitoringDailyRecapTriggerFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal trigger rekap'**
  String get monitoringDailyRecapTriggerFailed;

  /// No description provided for @monitoringRefreshActiveTab.
  ///
  /// In id, this message translates to:
  /// **'Refresh tab aktif'**
  String get monitoringRefreshActiveTab;

  /// No description provided for @monitoringNoDeviceStats.
  ///
  /// In id, this message translates to:
  /// **'Belum ada statistik device'**
  String get monitoringNoDeviceStats;

  /// No description provided for @monitoringTotalDevice.
  ///
  /// In id, this message translates to:
  /// **'Total device'**
  String get monitoringTotalDevice;

  /// No description provided for @monitoringTotalSensor.
  ///
  /// In id, this message translates to:
  /// **'Total sensor'**
  String get monitoringTotalSensor;

  /// No description provided for @monitoringShowLess.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan Lebih Sedikit'**
  String get monitoringShowLess;

  /// No description provided for @monitoringShowAllCount.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan Semua ({count})'**
  String monitoringShowAllCount(int count);

  /// No description provided for @monitoringPlantRecommendationEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada rekomendasi tanaman ML untuk rata-rata sensor 7 hari terakhir'**
  String get monitoringPlantRecommendationEmpty;

  /// No description provided for @monitoringRecommendationActionCount.
  ///
  /// In id, this message translates to:
  /// **'{count} aksi'**
  String monitoringRecommendationActionCount(int count);

  /// No description provided for @monitoringRecommendationMoreCount.
  ///
  /// In id, this message translates to:
  /// **'+{count} rekomendasi lainnya'**
  String monitoringRecommendationMoreCount(int count);

  /// No description provided for @monitoringRecommendationSiteTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Tanaman ML'**
  String get monitoringRecommendationSiteTitle;

  /// No description provided for @monitoringRecommendationCachedSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Fresh dari endpoint ML tanaman'**
  String get monitoringRecommendationCachedSubtitle;

  /// No description provided for @monitoringRecommendationActiveSiteSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Berdasarkan rata-rata sensor 7 hari'**
  String get monitoringRecommendationActiveSiteSubtitle;

  /// No description provided for @monitoringNpkAdjustment.
  ///
  /// In id, this message translates to:
  /// **'Penyesuaian NPK'**
  String get monitoringNpkAdjustment;

  /// No description provided for @monitoringSoilPhAdjustment.
  ///
  /// In id, this message translates to:
  /// **'Penyesuaian pH Tanah'**
  String get monitoringSoilPhAdjustment;

  /// No description provided for @monitoringSoilPhLabel.
  ///
  /// In id, this message translates to:
  /// **'pH Tanah'**
  String get monitoringSoilPhLabel;

  /// No description provided for @monitoringNoActiveAlarmTitle.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada alarm aktif'**
  String get monitoringNoActiveAlarmTitle;

  /// No description provided for @monitoringNoActiveAlarmDescription.
  ///
  /// In id, this message translates to:
  /// **'Semua sensor berjalan normal'**
  String get monitoringNoActiveAlarmDescription;

  /// No description provided for @monitoringAlarmSummaryTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Alarm'**
  String get monitoringAlarmSummaryTitle;

  /// No description provided for @monitoringAlarmSummaryDescription.
  ///
  /// In id, this message translates to:
  /// **'{total} total alarm tercatat'**
  String monitoringAlarmSummaryDescription(int total);

  /// No description provided for @monitoringLatestAlarm.
  ///
  /// In id, this message translates to:
  /// **'Alarm Terbaru'**
  String get monitoringLatestAlarm;

  /// No description provided for @monitoringAlarmLast24Hours.
  ///
  /// In id, this message translates to:
  /// **'Alarm 24 Jam'**
  String get monitoringAlarmLast24Hours;

  /// No description provided for @monitoringTotalAlarm.
  ///
  /// In id, this message translates to:
  /// **'Total Alarm'**
  String get monitoringTotalAlarm;

  /// No description provided for @monitoringAlarmDetected.
  ///
  /// In id, this message translates to:
  /// **'Alarm terdeteksi'**
  String get monitoringAlarmDetected;

  /// No description provided for @forumMyPosts.
  ///
  /// In id, this message translates to:
  /// **'Postingan Saya'**
  String get forumMyPosts;

  /// No description provided for @forumLikedPosts.
  ///
  /// In id, this message translates to:
  /// **'Postingan Disukai'**
  String get forumLikedPosts;

  /// No description provided for @forumMyComments.
  ///
  /// In id, this message translates to:
  /// **'Komentar Saya'**
  String get forumMyComments;

  /// No description provided for @forumLiked.
  ///
  /// In id, this message translates to:
  /// **'Disukai'**
  String get forumLiked;

  /// No description provided for @forumNoPostsTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada postingan'**
  String get forumNoPostsTitle;

  /// No description provided for @forumNoPostsMessage.
  ///
  /// In id, this message translates to:
  /// **'Jadilah yang pertama membuat postingan di forum komunitas'**
  String get forumNoPostsMessage;

  /// No description provided for @forumCreatePost.
  ///
  /// In id, this message translates to:
  /// **'Buat Postingan'**
  String get forumCreatePost;

  /// No description provided for @forumLoadPostsFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat postingan'**
  String get forumLoadPostsFailed;

  /// No description provided for @forumManagePosts.
  ///
  /// In id, this message translates to:
  /// **'Kelola Postingan'**
  String get forumManagePosts;

  /// No description provided for @forumEditPost.
  ///
  /// In id, this message translates to:
  /// **'Edit Postingan'**
  String get forumEditPost;

  /// No description provided for @forumDeletePost.
  ///
  /// In id, this message translates to:
  /// **'Hapus Postingan'**
  String get forumDeletePost;

  /// No description provided for @forumDeletePostConfirm.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin menghapus postingan ini?'**
  String get forumDeletePostConfirm;

  /// No description provided for @forumDeletePostPermanent.
  ///
  /// In id, this message translates to:
  /// **'Postingan ini akan dihapus permanen.'**
  String get forumDeletePostPermanent;

  /// No description provided for @forumPostDeleted.
  ///
  /// In id, this message translates to:
  /// **'Postingan berhasil dihapus'**
  String get forumPostDeleted;

  /// No description provided for @forumSharePostTitle.
  ///
  /// In id, this message translates to:
  /// **'Bagikan Postingan'**
  String get forumSharePostTitle;

  /// No description provided for @forumSharePostMessage.
  ///
  /// In id, this message translates to:
  /// **'Bagikan postingan ini ke teman atau komunitas Anda.'**
  String get forumSharePostMessage;

  /// No description provided for @forumPostShared.
  ///
  /// In id, this message translates to:
  /// **'Postingan berhasil dibagikan'**
  String get forumPostShared;

  /// No description provided for @forumFirstPostMessage.
  ///
  /// In id, this message translates to:
  /// **'Buat postingan pertama Anda untuk berbagi dengan komunitas.'**
  String get forumFirstPostMessage;

  /// No description provided for @forumPostCount.
  ///
  /// In id, this message translates to:
  /// **'{count} postingan'**
  String forumPostCount(int count);

  /// No description provided for @forumMyPostsSummary.
  ///
  /// In id, this message translates to:
  /// **'Postingan yang Anda buat di forum komunitas.'**
  String get forumMyPostsSummary;

  /// No description provided for @forumLikedPostsEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada postingan disukai'**
  String get forumLikedPostsEmptyTitle;

  /// No description provided for @forumLikedPostsEmptyMessage.
  ///
  /// In id, this message translates to:
  /// **'Postingan yang Anda sukai akan tersimpan di sini.'**
  String get forumLikedPostsEmptyMessage;

  /// No description provided for @forumLikedPostCount.
  ///
  /// In id, this message translates to:
  /// **'{count} postingan disukai'**
  String forumLikedPostCount(int count);

  /// No description provided for @forumLikedPostsSummary.
  ///
  /// In id, this message translates to:
  /// **'Daftar postingan yang pernah Anda sukai.'**
  String get forumLikedPostsSummary;

  /// No description provided for @forumNoCommentsTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada komentar'**
  String get forumNoCommentsTitle;

  /// No description provided for @forumNoCommentsMessage.
  ///
  /// In id, this message translates to:
  /// **'Komentar Anda pada postingan akan muncul di sini.'**
  String get forumNoCommentsMessage;

  /// No description provided for @forumCommentCount.
  ///
  /// In id, this message translates to:
  /// **'{count} komentar'**
  String forumCommentCount(int count);

  /// No description provided for @forumMyCommentsSummary.
  ///
  /// In id, this message translates to:
  /// **'Komentar yang Anda tulis di postingan forum.'**
  String get forumMyCommentsSummary;

  /// No description provided for @forumLoadCommentsFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat komentar'**
  String get forumLoadCommentsFailed;

  /// No description provided for @forumNoTitle.
  ///
  /// In id, this message translates to:
  /// **'Tanpa Judul'**
  String get forumNoTitle;

  /// No description provided for @forumOpenPostHint.
  ///
  /// In id, this message translates to:
  /// **'Ketuk untuk membuka postingan'**
  String get forumOpenPostHint;

  /// No description provided for @forumCommentActions.
  ///
  /// In id, this message translates to:
  /// **'Aksi komentar'**
  String get forumCommentActions;

  /// No description provided for @forumEdited.
  ///
  /// In id, this message translates to:
  /// **'Diedit'**
  String get forumEdited;

  /// No description provided for @forumManageComments.
  ///
  /// In id, this message translates to:
  /// **'Kelola Komentar'**
  String get forumManageComments;

  /// No description provided for @forumEditComment.
  ///
  /// In id, this message translates to:
  /// **'Edit Komentar'**
  String get forumEditComment;

  /// No description provided for @forumDeleteComment.
  ///
  /// In id, this message translates to:
  /// **'Hapus Komentar'**
  String get forumDeleteComment;

  /// No description provided for @forumWriteComment.
  ///
  /// In id, this message translates to:
  /// **'Tulis komentar'**
  String get forumWriteComment;

  /// No description provided for @forumCommentUpdated.
  ///
  /// In id, this message translates to:
  /// **'Komentar diperbarui'**
  String get forumCommentUpdated;

  /// No description provided for @forumDeleteCommentPermanent.
  ///
  /// In id, this message translates to:
  /// **'Komentar ini akan dihapus permanen.'**
  String get forumDeleteCommentPermanent;

  /// No description provided for @forumCommentDeleted.
  ///
  /// In id, this message translates to:
  /// **'Komentar dihapus'**
  String get forumCommentDeleted;

  /// No description provided for @forumLikesCount.
  ///
  /// In id, this message translates to:
  /// **'{count} suka'**
  String forumLikesCount(int count);

  /// No description provided for @forumCommentsCount.
  ///
  /// In id, this message translates to:
  /// **'{count} komentar'**
  String forumCommentsCount(int count);

  /// No description provided for @forumSharesCount.
  ///
  /// In id, this message translates to:
  /// **'{count} bagikan'**
  String forumSharesCount(int count);

  /// No description provided for @forumLike.
  ///
  /// In id, this message translates to:
  /// **'Suka'**
  String get forumLike;

  /// No description provided for @forumComment.
  ///
  /// In id, this message translates to:
  /// **'Komentar'**
  String get forumComment;

  /// No description provided for @forumShare.
  ///
  /// In id, this message translates to:
  /// **'Bagikan'**
  String get forumShare;

  /// No description provided for @forumDislike.
  ///
  /// In id, this message translates to:
  /// **'Dislike'**
  String get forumDislike;

  /// No description provided for @forumNoReactions.
  ///
  /// In id, this message translates to:
  /// **'Belum ada reaksi'**
  String get forumNoReactions;

  /// No description provided for @forumAddPost.
  ///
  /// In id, this message translates to:
  /// **'Tambah Postingan'**
  String get forumAddPost;

  /// No description provided for @forumSelectImage.
  ///
  /// In id, this message translates to:
  /// **'Pilih Gambar'**
  String get forumSelectImage;

  /// No description provided for @forumPickFromGallery.
  ///
  /// In id, this message translates to:
  /// **'Pilih dari Galeri'**
  String get forumPickFromGallery;

  /// No description provided for @forumTakePhoto.
  ///
  /// In id, this message translates to:
  /// **'Ambil Foto'**
  String get forumTakePhoto;

  /// No description provided for @forumDeleteImage.
  ///
  /// In id, this message translates to:
  /// **'Hapus Gambar'**
  String get forumDeleteImage;

  /// No description provided for @forumPickImageFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memilih gambar: {message}'**
  String forumPickImageFailed(String message);

  /// No description provided for @forumSiteRequiredMain.
  ///
  /// In id, this message translates to:
  /// **'Pilih site terlebih dahulu di halaman utama'**
  String get forumSiteRequiredMain;

  /// No description provided for @forumSiteNotSelectedTitle.
  ///
  /// In id, this message translates to:
  /// **'Site belum dipilih'**
  String get forumSiteNotSelectedTitle;

  /// No description provided for @forumLoadDataFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data: {message}'**
  String forumLoadDataFailed(String message);

  /// No description provided for @forumPostTitleLabel.
  ///
  /// In id, this message translates to:
  /// **'Judul'**
  String get forumPostTitleLabel;

  /// No description provided for @forumPostTitleHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan judul postingan'**
  String get forumPostTitleHint;

  /// No description provided for @forumPostTitleRequired.
  ///
  /// In id, this message translates to:
  /// **'Judul tidak boleh kosong'**
  String get forumPostTitleRequired;

  /// No description provided for @forumPostTitleMinLength.
  ///
  /// In id, this message translates to:
  /// **'Judul minimal 3 karakter'**
  String get forumPostTitleMinLength;

  /// No description provided for @forumPostContentLabel.
  ///
  /// In id, this message translates to:
  /// **'Isi Postingan'**
  String get forumPostContentLabel;

  /// No description provided for @forumPostContentHint.
  ///
  /// In id, this message translates to:
  /// **'Tulis informasi yang ingin Anda bagikan'**
  String get forumPostContentHint;

  /// No description provided for @forumPostContentRequired.
  ///
  /// In id, this message translates to:
  /// **'Konten tidak boleh kosong'**
  String get forumPostContentRequired;

  /// No description provided for @forumPostContentMinLength.
  ///
  /// In id, this message translates to:
  /// **'Konten minimal 10 karakter'**
  String get forumPostContentMinLength;

  /// No description provided for @forumMediaLabel.
  ///
  /// In id, this message translates to:
  /// **'Media'**
  String get forumMediaLabel;

  /// No description provided for @forumPostGuideline.
  ///
  /// In id, this message translates to:
  /// **'Pastikan isi postingan tetap jelas, relevan, dan sesuai pedoman komunitas.'**
  String get forumPostGuideline;

  /// No description provided for @forumAddImage.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan gambar'**
  String get forumAddImage;

  /// No description provided for @forumImageOptionalHint.
  ///
  /// In id, this message translates to:
  /// **'Opsional. Postingan tanpa gambar tetap dapat dipublikasikan.'**
  String get forumImageOptionalHint;

  /// No description provided for @forumChoose.
  ///
  /// In id, this message translates to:
  /// **'Pilih'**
  String get forumChoose;

  /// No description provided for @forumNewImageReady.
  ///
  /// In id, this message translates to:
  /// **'Gambar baru siap diunggah'**
  String get forumNewImageReady;

  /// No description provided for @forumActivePostImage.
  ///
  /// In id, this message translates to:
  /// **'Gambar postingan aktif'**
  String get forumActivePostImage;

  /// No description provided for @forumChange.
  ///
  /// In id, this message translates to:
  /// **'Ganti'**
  String get forumChange;

  /// No description provided for @forumPostCreated.
  ///
  /// In id, this message translates to:
  /// **'Postingan berhasil ditambahkan'**
  String get forumPostCreated;

  /// No description provided for @forumPostUpdated.
  ///
  /// In id, this message translates to:
  /// **'Postingan berhasil diperbarui'**
  String get forumPostUpdated;

  /// No description provided for @forumSelectActiveSiteBeforePosting.
  ///
  /// In id, this message translates to:
  /// **'Pilih site aktif di dashboard sebelum membuat postingan forum.'**
  String get forumSelectActiveSiteBeforePosting;

  /// No description provided for @forumSendCommentFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengirim komentar: {message}'**
  String forumSendCommentFailed(String message);

  /// No description provided for @forumFirstCommentMessage.
  ///
  /// In id, this message translates to:
  /// **'Jadilah yang pertama berkomentar'**
  String get forumFirstCommentMessage;

  /// No description provided for @forumReactions.
  ///
  /// In id, this message translates to:
  /// **'Reaksi'**
  String get forumReactions;

  /// No description provided for @forumDeleteCommentConfirm.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin menghapus komentar ini?'**
  String get forumDeleteCommentConfirm;

  /// No description provided for @adminAccessDeniedTitle.
  ///
  /// In id, this message translates to:
  /// **'Akses Ditolak'**
  String get adminAccessDeniedTitle;

  /// No description provided for @adminFeatureOnlyMessage.
  ///
  /// In id, this message translates to:
  /// **'Fitur admin hanya dapat diakses oleh Admin.'**
  String get adminFeatureOnlyMessage;

  /// No description provided for @adminNoPagePermissionMessage.
  ///
  /// In id, this message translates to:
  /// **'Anda tidak memiliki izin untuk mengakses halaman ini.'**
  String get adminNoPagePermissionMessage;

  /// No description provided for @adminUsersTitle.
  ///
  /// In id, this message translates to:
  /// **'Users'**
  String get adminUsersTitle;

  /// No description provided for @adminRoleTitle.
  ///
  /// In id, this message translates to:
  /// **'Role'**
  String get adminRoleTitle;

  /// No description provided for @adminUnitTitle.
  ///
  /// In id, this message translates to:
  /// **'Unit'**
  String get adminUnitTitle;

  /// No description provided for @adminDeviceSensorTitle.
  ///
  /// In id, this message translates to:
  /// **'Device Sensor'**
  String get adminDeviceSensorTitle;

  /// No description provided for @adminPermissionTitle.
  ///
  /// In id, this message translates to:
  /// **'Permission'**
  String get adminPermissionTitle;

  /// No description provided for @adminNoPermissionsAvailable.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada permission tersedia'**
  String get adminNoPermissionsAvailable;

  /// No description provided for @adminLoadPermissionsFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat permissions: {message}'**
  String adminLoadPermissionsFailed(String message);

  /// No description provided for @adminNoThresholdData.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data threshold'**
  String get adminNoThresholdData;

  /// No description provided for @adminNoUsers.
  ///
  /// In id, this message translates to:
  /// **'Belum ada user'**
  String get adminNoUsers;

  /// No description provided for @adminNoUsersMessage.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan user untuk mengakses sistem'**
  String get adminNoUsersMessage;

  /// No description provided for @adminNoUnits.
  ///
  /// In id, this message translates to:
  /// **'Belum ada unit'**
  String get adminNoUnits;

  /// No description provided for @adminNoUnitsMessage.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan unit satuan untuk sensor'**
  String get adminNoUnitsMessage;

  /// No description provided for @adminNoDevices.
  ///
  /// In id, this message translates to:
  /// **'Belum ada device'**
  String get adminNoDevices;

  /// No description provided for @adminNoDevicesMessage.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan device untuk memulai monitoring'**
  String get adminNoDevicesMessage;

  /// No description provided for @adminNoSensors.
  ///
  /// In id, this message translates to:
  /// **'Belum ada sensor'**
  String get adminNoSensors;

  /// No description provided for @adminNoSensorsMessage.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan sensor untuk memulai monitoring'**
  String get adminNoSensorsMessage;

  /// No description provided for @adminNoRoles.
  ///
  /// In id, this message translates to:
  /// **'Belum ada role'**
  String get adminNoRoles;

  /// No description provided for @adminNoRolesMessage.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan role untuk mengatur hak akses'**
  String get adminNoRolesMessage;

  /// No description provided for @adminNoPermissions.
  ///
  /// In id, this message translates to:
  /// **'Belum ada permission'**
  String get adminNoPermissions;

  /// No description provided for @adminNoPermissionsMessage.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada permission yang terdaftar'**
  String get adminNoPermissionsMessage;

  /// No description provided for @adminNoPlants.
  ///
  /// In id, this message translates to:
  /// **'Belum ada tanaman'**
  String get adminNoPlants;

  /// No description provided for @adminNoPlantsMessage.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan tanaman untuk memulai monitoring'**
  String get adminNoPlantsMessage;

  /// No description provided for @adminNoMappings.
  ///
  /// In id, this message translates to:
  /// **'Belum ada mapping'**
  String get adminNoMappings;

  /// No description provided for @adminNoMappingsMessage.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan mapping device-sensor untuk monitoring'**
  String get adminNoMappingsMessage;

  /// No description provided for @adminPlantActionsTooltip.
  ///
  /// In id, this message translates to:
  /// **'Aksi tanaman'**
  String get adminPlantActionsTooltip;

  /// No description provided for @adminEditMapping.
  ///
  /// In id, this message translates to:
  /// **'Edit Mapping'**
  String get adminEditMapping;

  /// No description provided for @adminHarvestPlantTitle.
  ///
  /// In id, this message translates to:
  /// **'Panen Tanaman?'**
  String get adminHarvestPlantTitle;

  /// No description provided for @adminDeleteSuccess.
  ///
  /// In id, this message translates to:
  /// **'{item} berhasil dihapus'**
  String adminDeleteSuccess(String item);

  /// No description provided for @adminDeleteFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menghapus {item}'**
  String adminDeleteFailed(String item);

  /// No description provided for @adminRoleDeleteWarning.
  ///
  /// In id, this message translates to:
  /// **'Semua user dengan role ini akan kehilangan akses.'**
  String get adminRoleDeleteWarning;

  /// No description provided for @adminUnitReadonlyMessage.
  ///
  /// In id, this message translates to:
  /// **'Data Unit bersifat read-only. Perubahan dan penghapusan unit tidak didukung oleh sistem backend saat ini.'**
  String get adminUnitReadonlyMessage;

  /// No description provided for @adminTotalPermissions.
  ///
  /// In id, this message translates to:
  /// **'{count} Total Permission'**
  String adminTotalPermissions(int count);

  /// No description provided for @adminResourceGroupCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Grup Resource'**
  String adminResourceGroupCount(int count);

  /// No description provided for @adminPermissionCount.
  ///
  /// In id, this message translates to:
  /// **'{count} permission'**
  String adminPermissionCount(int count);

  /// No description provided for @adminPermissionBadge.
  ///
  /// In id, this message translates to:
  /// **'{count} Permission'**
  String adminPermissionBadge(int count);

  /// No description provided for @adminMappingTab.
  ///
  /// In id, this message translates to:
  /// **'Mapping'**
  String get adminMappingTab;

  /// No description provided for @adminThresholdValuesTab.
  ///
  /// In id, this message translates to:
  /// **'Nilai Ambang'**
  String get adminThresholdValuesTab;

  /// No description provided for @commonViewDetail.
  ///
  /// In id, this message translates to:
  /// **'Lihat Detail'**
  String get commonViewDetail;

  /// No description provided for @commonOffline.
  ///
  /// In id, this message translates to:
  /// **'Offline'**
  String get commonOffline;

  /// No description provided for @commonDays.
  ///
  /// In id, this message translates to:
  /// **'{count} hari'**
  String commonDays(int count);

  /// No description provided for @commonMinCharacters.
  ///
  /// In id, this message translates to:
  /// **'Minimal {count} karakter'**
  String commonMinCharacters(int count);

  /// No description provided for @recommendationSiteTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Aksi'**
  String get recommendationSiteTitle;

  /// No description provided for @recommendationSiteSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Aksi hari ini dari kondisi sensor lahan'**
  String get recommendationSiteSubtitle;

  /// No description provided for @recommendationSiteDescription.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi tindakan langsung untuk hari ini berdasarkan kondisi terkini lahan Anda.'**
  String get recommendationSiteDescription;

  /// No description provided for @recommendationPlantTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Tanaman'**
  String get recommendationPlantTitle;

  /// No description provided for @recommendationPlantSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Analisis rata-rata sensor 7 hari'**
  String get recommendationPlantSubtitle;

  /// No description provided for @recommendationPlantDescription.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi jenis tanaman yang paling cocok berdasarkan riwayat kondisi tanah seminggu terakhir.'**
  String get recommendationPlantDescription;

  /// No description provided for @recommendationPlantLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat rekomendasi tanaman'**
  String get recommendationPlantLoadFailed;

  /// No description provided for @recommendationPhaseTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Fase Aktif'**
  String get recommendationPhaseTitle;

  /// No description provided for @recommendationPhaseDescription.
  ///
  /// In id, this message translates to:
  /// **'Panduan perawatan tanaman yang disesuaikan dengan usia dan fase pertumbuhan saat ini.'**
  String get recommendationPhaseDescription;

  /// No description provided for @recommendationPhaseLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat rekomendasi fase'**
  String get recommendationPhaseLoadFailed;

  /// No description provided for @recommendationActivePhaseLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat fase aktif'**
  String get recommendationActivePhaseLoadFailed;

  /// No description provided for @recommendationPhaseNoActive.
  ///
  /// In id, this message translates to:
  /// **'Belum ada fase aktif'**
  String get recommendationPhaseNoActive;

  /// No description provided for @recommendationPhaseUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Fase aktif belum tersedia'**
  String get recommendationPhaseUnavailable;

  /// No description provided for @recommendationPhaseAvailableForActivePlant.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi fase tersedia untuk tanaman aktif.'**
  String get recommendationPhaseAvailableForActivePlant;

  /// No description provided for @recommendationPhaseNoneForPlant.
  ///
  /// In id, this message translates to:
  /// **'Belum ada fase aktif untuk tanaman ini.'**
  String get recommendationPhaseNoneForPlant;

  /// No description provided for @recommendationPhaseLabel.
  ///
  /// In id, this message translates to:
  /// **'Fase: {phase}'**
  String recommendationPhaseLabel(String phase);

  /// No description provided for @recommendationActionScopeLabel.
  ///
  /// In id, this message translates to:
  /// **'Aksi'**
  String get recommendationActionScopeLabel;

  /// No description provided for @recommendationPlantMlScopeLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanaman ML'**
  String get recommendationPlantMlScopeLabel;

  /// No description provided for @recommendationActivePhaseScopeLabel.
  ///
  /// In id, this message translates to:
  /// **'Fase Aktif'**
  String get recommendationActivePhaseScopeLabel;

  /// No description provided for @recommendationSourceLabel.
  ///
  /// In id, this message translates to:
  /// **'Sumber data'**
  String get recommendationSourceLabel;

  /// No description provided for @recommendationDataRuleLabel.
  ///
  /// In id, this message translates to:
  /// **'Aturan tampil'**
  String get recommendationDataRuleLabel;

  /// No description provided for @recommendationActionSourceTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Aksi'**
  String get recommendationActionSourceTitle;

  /// No description provided for @recommendationActionSourceDescription.
  ///
  /// In id, this message translates to:
  /// **'Saran tindakan langsung berdasarkan kondisi terkini lahan Anda hari ini.'**
  String get recommendationActionSourceDescription;

  /// No description provided for @recommendationPlantSourceTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Tanaman'**
  String get recommendationPlantSourceTitle;

  /// No description provided for @recommendationPlantSourceDescription.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi jenis tanaman yang paling cocok berdasarkan riwayat kondisi tanah seminggu terakhir.'**
  String get recommendationPlantSourceDescription;

  /// No description provided for @recommendationPhaseSourceTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Fase Aktif'**
  String get recommendationPhaseSourceTitle;

  /// No description provided for @recommendationPhaseSourceDescription.
  ///
  /// In id, this message translates to:
  /// **'Panduan perawatan tanaman yang disesuaikan dengan usia dan fase pertumbuhan saat ini.'**
  String get recommendationPhaseSourceDescription;

  /// No description provided for @recommendationGeneratedTodayLabel.
  ///
  /// In id, this message translates to:
  /// **'Hari ini'**
  String get recommendationGeneratedTodayLabel;

  /// No description provided for @recommendationFreshMlLabel.
  ///
  /// In id, this message translates to:
  /// **'Analisis 7 hari'**
  String get recommendationFreshMlLabel;

  /// No description provided for @recommendationSeededDatabaseLabel.
  ///
  /// In id, this message translates to:
  /// **'Fase tanaman'**
  String get recommendationSeededDatabaseLabel;

  /// No description provided for @recommendationEmptyAction.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada rekomendasi aksi untuk hari ini.'**
  String get recommendationEmptyAction;

  /// No description provided for @recommendationEmptyPlant.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada rekomendasi tanaman ML untuk rata-rata sensor 7 hari terakhir.'**
  String get recommendationEmptyPlant;

  /// No description provided for @recommendationEmptyPhase.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada rekomendasi fase karena belum ada fase penanaman aktif.'**
  String get recommendationEmptyPhase;

  /// No description provided for @recommendationHstLabel.
  ///
  /// In id, this message translates to:
  /// **'HST {hst}'**
  String recommendationHstLabel(int hst);

  /// No description provided for @monitoringDailySummaryTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Harian'**
  String get monitoringDailySummaryTitle;

  /// No description provided for @monitoringDailyAggregationEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data agregasi untuk rentang ini'**
  String get monitoringDailyAggregationEmpty;

  /// No description provided for @monitoringLast30Days.
  ///
  /// In id, this message translates to:
  /// **'30 hari terakhir'**
  String get monitoringLast30Days;

  /// No description provided for @monitoringCustomRange.
  ///
  /// In id, this message translates to:
  /// **'Rentang custom'**
  String get monitoringCustomRange;

  /// No description provided for @monitoringSensorCount.
  ///
  /// In id, this message translates to:
  /// **'{count} sensor'**
  String monitoringSensorCount(int count);

  /// No description provided for @monitoringRegisteredSensorCount.
  ///
  /// In id, this message translates to:
  /// **'{count} sensor terdaftar'**
  String monitoringRegisteredSensorCount(int count);

  /// No description provided for @monitoringDataPointCount.
  ///
  /// In id, this message translates to:
  /// **'{count} titik data'**
  String monitoringDataPointCount(int count);

  /// No description provided for @monitoringActionRequiredDescription.
  ///
  /// In id, this message translates to:
  /// **'Belum ada parameter sensor yang dapat dievaluasi. Periksa konfigurasi dan data sensor terbaru.'**
  String get monitoringActionRequiredDescription;

  /// No description provided for @monitoringEnvironmentSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Skor kondisi parameter lingkungan pada site aktif'**
  String get monitoringEnvironmentSubtitle;

  /// No description provided for @monitoringNoSensorsConfiguredStatus.
  ///
  /// In id, this message translates to:
  /// **'Belum ada parameter sensor yang dapat dievaluasi. Periksa konfigurasi dan data terbaru.'**
  String get monitoringNoSensorsConfiguredStatus;

  /// No description provided for @monitoringSensorsStableStatus.
  ///
  /// In id, this message translates to:
  /// **'{total} parameter dipantau, kondisi lingkungan stabil.'**
  String monitoringSensorsStableStatus(int total);

  /// No description provided for @monitoringSensorsAttentionStatus.
  ///
  /// In id, this message translates to:
  /// **'{total} parameter dipantau, beberapa parameter perlu perhatian.'**
  String monitoringSensorsAttentionStatus(int total);

  /// No description provided for @monitoringHealthNeedsSetup.
  ///
  /// In id, this message translates to:
  /// **'Perlu Konfigurasi'**
  String get monitoringHealthNeedsSetup;

  /// No description provided for @monitoringHealthExcellent.
  ///
  /// In id, this message translates to:
  /// **'Sangat Baik'**
  String get monitoringHealthExcellent;

  /// No description provided for @monitoringHealthExcellentDesc.
  ///
  /// In id, this message translates to:
  /// **'Kondisi lingkungan optimal untuk pertumbuhan tanaman'**
  String get monitoringHealthExcellentDesc;

  /// No description provided for @monitoringHealthGood.
  ///
  /// In id, this message translates to:
  /// **'Baik'**
  String get monitoringHealthGood;

  /// No description provided for @monitoringHealthGoodDesc.
  ///
  /// In id, this message translates to:
  /// **'Kondisi lingkungan mendukung pertumbuhan tanaman'**
  String get monitoringHealthGoodDesc;

  /// No description provided for @monitoringHealthFair.
  ///
  /// In id, this message translates to:
  /// **'Cukup'**
  String get monitoringHealthFair;

  /// No description provided for @monitoringHealthFairDesc.
  ///
  /// In id, this message translates to:
  /// **'Beberapa parameter perlu perhatian'**
  String get monitoringHealthFairDesc;

  /// No description provided for @monitoringHealthNeedsAttention.
  ///
  /// In id, this message translates to:
  /// **'Perlu Perhatian'**
  String get monitoringHealthNeedsAttention;

  /// No description provided for @monitoringHealthNeedsAttentionDesc.
  ///
  /// In id, this message translates to:
  /// **'Kondisi lingkungan memerlukan perbaikan segera'**
  String get monitoringHealthNeedsAttentionDesc;

  /// No description provided for @monitoringSensorsMonitoredCount.
  ///
  /// In id, this message translates to:
  /// **'{count} parameter dipantau'**
  String monitoringSensorsMonitoredCount(int count);

  /// No description provided for @agroParameterScoreTitle.
  ///
  /// In id, this message translates to:
  /// **'Skor Parameter'**
  String get agroParameterScoreTitle;

  /// No description provided for @agroRecVentilationLowerHumidity.
  ///
  /// In id, this message translates to:
  /// **'Tingkatkan ventilasi untuk menurunkan kelembaban'**
  String get agroRecVentilationLowerHumidity;

  /// No description provided for @agroRecIncreaseIrrigationHumidity.
  ///
  /// In id, this message translates to:
  /// **'Tingkatkan penyiraman dan kelembaban udara'**
  String get agroRecIncreaseIrrigationHumidity;

  /// No description provided for @agroRecIncreaseWateringFrequency.
  ///
  /// In id, this message translates to:
  /// **'Tingkatkan frekuensi penyiraman'**
  String get agroRecIncreaseWateringFrequency;

  /// No description provided for @agroRecHighEtcCheckSoil.
  ///
  /// In id, this message translates to:
  /// **'ETC tinggi, periksa kelembaban tanah dan irigasi'**
  String get agroRecHighEtcCheckSoil;

  /// No description provided for @agroRecIntenseMonitoring.
  ///
  /// In id, this message translates to:
  /// **'Lakukan monitoring lebih intensif'**
  String get agroRecIntenseMonitoring;

  /// No description provided for @agroRecConsultAgronomist.
  ///
  /// In id, this message translates to:
  /// **'Konsultasikan dengan ahli agronomi'**
  String get agroRecConsultAgronomist;

  /// No description provided for @monitoringSensorByTypeTitle.
  ///
  /// In id, this message translates to:
  /// **'Sensor Berdasarkan Jenis'**
  String get monitoringSensorByTypeTitle;

  /// No description provided for @monitoringNoRegisteredSensors.
  ///
  /// In id, this message translates to:
  /// **'Belum ada sensor terdaftar'**
  String get monitoringNoRegisteredSensors;

  /// No description provided for @monitoringNoSensorData.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data sensor'**
  String get monitoringNoSensorData;

  /// No description provided for @monitoringDistributionByTypeTitle.
  ///
  /// In id, this message translates to:
  /// **'Distribusi Berdasarkan Jenis'**
  String get monitoringDistributionByTypeTitle;

  /// No description provided for @monitoringPlantCompositionSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Komposisi tanaman site aktif'**
  String get monitoringPlantCompositionSubtitle;

  /// No description provided for @monitoringAverageGrowthPhase.
  ///
  /// In id, this message translates to:
  /// **'Fase Pertumbuhan Rata-rata'**
  String get monitoringAverageGrowthPhase;

  /// No description provided for @agroSelectSiteMessage.
  ///
  /// In id, this message translates to:
  /// **'Pilih site terlebih dahulu untuk melihat data agro (VPD, GDD, ETc).'**
  String get agroSelectSiteMessage;

  /// No description provided for @agroActionRecommendationTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Tindakan'**
  String get agroActionRecommendationTitle;

  /// No description provided for @agroPlantingPhaseTitle.
  ///
  /// In id, this message translates to:
  /// **'Fase Tanam'**
  String get agroPlantingPhaseTitle;

  /// No description provided for @agroInformationTitle.
  ///
  /// In id, this message translates to:
  /// **'Informasi'**
  String get agroInformationTitle;

  /// No description provided for @agroAboutTitle.
  ///
  /// In id, this message translates to:
  /// **'Tentang Agro Indicator'**
  String get agroAboutTitle;

  /// No description provided for @agroVdpDescription.
  ///
  /// In id, this message translates to:
  /// **'Mengukur defisit tekanan uap air. Nilai optimal: 0.4-1.2 kPa. VPD rendah (<0.4) meningkatkan risiko penyakit, VPD tinggi (>1.6) menyebabkan stres air.'**
  String get agroVdpDescription;

  /// No description provided for @agroGddDescription.
  ///
  /// In id, this message translates to:
  /// **'Akumulasi suhu yang diperlukan tanaman untuk tumbuh. Digunakan untuk memprediksi fase pertumbuhan dan waktu panen.'**
  String get agroGddDescription;

  /// No description provided for @agroEtcDescription.
  ///
  /// In id, this message translates to:
  /// **'Kebutuhan air tanaman berdasarkan evaporasi dan transpirasi. Membantu menentukan jadwal dan volume penyiraman yang optimal.'**
  String get agroEtcDescription;

  /// No description provided for @agroVdpTitle.
  ///
  /// In id, this message translates to:
  /// **'Vapor Pressure Deficit'**
  String get agroVdpTitle;

  /// No description provided for @agroGddTitle.
  ///
  /// In id, this message translates to:
  /// **'Growing Degree Days'**
  String get agroGddTitle;

  /// No description provided for @agroEtcTitle.
  ///
  /// In id, this message translates to:
  /// **'Evapotranspiration'**
  String get agroEtcTitle;

  /// No description provided for @agroSmartRecommendation.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Cerdas'**
  String get agroSmartRecommendation;

  /// No description provided for @agroNoCriticalRecommendations.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada rekomendasi kritis saat ini'**
  String get agroNoCriticalRecommendations;

  /// No description provided for @agroRecommendationSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tindakan berdasarkan AI & Data'**
  String get agroRecommendationSubtitle;

  /// No description provided for @agroWateringRecommendation.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Penyiraman'**
  String get agroWateringRecommendation;

  /// No description provided for @agroWaterRequirement.
  ///
  /// In id, this message translates to:
  /// **'Kebutuhan Air Tanaman'**
  String get agroWaterRequirement;

  /// No description provided for @agroEtcTrend7Days.
  ///
  /// In id, this message translates to:
  /// **'Tren ETC (7 Hari)'**
  String get agroEtcTrend7Days;

  /// No description provided for @agroDailyClimateDetail.
  ///
  /// In id, this message translates to:
  /// **'Detail Iklim Harian'**
  String get agroDailyClimateDetail;

  /// No description provided for @agroTableDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get agroTableDate;

  /// No description provided for @agroTableTemp.
  ///
  /// In id, this message translates to:
  /// **'Suhu (Min-Maks)'**
  String get agroTableTemp;

  /// No description provided for @agroTableRh.
  ///
  /// In id, this message translates to:
  /// **'Kelembaban (Min-Maks)'**
  String get agroTableRh;

  /// No description provided for @agroEtcDataUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Data ETC tidak tersedia'**
  String get agroEtcDataUnavailable;

  /// No description provided for @agroUnitMmPerDay.
  ///
  /// In id, this message translates to:
  /// **'mm/hari'**
  String get agroUnitMmPerDay;

  /// No description provided for @agroUnitCoefficient.
  ///
  /// In id, this message translates to:
  /// **'koefisien'**
  String get agroUnitCoefficient;

  /// No description provided for @agroWaterNeedsLabel.
  ///
  /// In id, this message translates to:
  /// **'Kebutuhan'**
  String get agroWaterNeedsLabel;

  /// No description provided for @agroRecWaterNeedsLow.
  ///
  /// In id, this message translates to:
  /// **'Kebutuhan air rendah. Penyiraman minimal atau tidak diperlukan.'**
  String get agroRecWaterNeedsLow;

  /// No description provided for @agroRecWaterNeedsMedium.
  ///
  /// In id, this message translates to:
  /// **'Kebutuhan air sedang. Lakukan penyiraman rutin sesuai jadwal.'**
  String get agroRecWaterNeedsMedium;

  /// No description provided for @agroRecWaterNeedsHigh.
  ///
  /// In id, this message translates to:
  /// **'Kebutuhan air tinggi. Tingkatkan frekuensi penyiraman.'**
  String get agroRecWaterNeedsHigh;

  /// No description provided for @agroRecWaterNeedsVeryHigh.
  ///
  /// In id, this message translates to:
  /// **'Kebutuhan air sangat tinggi! Penyiraman intensif diperlukan.'**
  String get agroRecWaterNeedsVeryHigh;

  /// No description provided for @agroStatusEtc.
  ///
  /// In id, this message translates to:
  /// **'Status ETC'**
  String get agroStatusEtc;

  /// No description provided for @agroRecEtcLow.
  ///
  /// In id, this message translates to:
  /// **'ETC rendah. Kebutuhan evapotranspirasi tanaman sedang ringan.'**
  String get agroRecEtcLow;

  /// No description provided for @agroRecEtcMedium.
  ///
  /// In id, this message translates to:
  /// **'ETC berada pada rentang sedang. Pantau kelembaban dan jadwal irigasi.'**
  String get agroRecEtcMedium;

  /// No description provided for @agroRecEtcHigh.
  ///
  /// In id, this message translates to:
  /// **'ETC tinggi. Periksa kelembaban tanah dan kesiapan irigasi.'**
  String get agroRecEtcHigh;

  /// No description provided for @adminLoadingTitle.
  ///
  /// In id, this message translates to:
  /// **'Memuat...'**
  String get adminLoadingTitle;

  /// No description provided for @adminEditUserTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit User'**
  String get adminEditUserTitle;

  /// No description provided for @adminAddUserTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah User'**
  String get adminAddUserTitle;

  /// No description provided for @adminEditUnitTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Unit'**
  String get adminEditUnitTitle;

  /// No description provided for @adminAddUnitTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Unit'**
  String get adminAddUnitTitle;

  /// No description provided for @adminEditDeviceTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Device'**
  String get adminEditDeviceTitle;

  /// No description provided for @adminAddDeviceTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Device'**
  String get adminAddDeviceTitle;

  /// No description provided for @adminEditSensorTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Sensor'**
  String get adminEditSensorTitle;

  /// No description provided for @adminAddSensorTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Sensor'**
  String get adminAddSensorTitle;

  /// No description provided for @adminEditPlantTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Tanaman'**
  String get adminEditPlantTitle;

  /// No description provided for @adminAddPlantTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Tanaman'**
  String get adminAddPlantTitle;

  /// No description provided for @adminEditRoleTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Role'**
  String get adminEditRoleTitle;

  /// No description provided for @adminAddRoleTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Role'**
  String get adminAddRoleTitle;

  /// No description provided for @adminEditDeviceSensorTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Device Sensor'**
  String get adminEditDeviceSensorTitle;

  /// No description provided for @adminAddDeviceSensorTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Device Sensor'**
  String get adminAddDeviceSensorTitle;

  /// No description provided for @adminSavingChanges.
  ///
  /// In id, this message translates to:
  /// **'Menyimpan perubahan...'**
  String get adminSavingChanges;

  /// No description provided for @adminCreatingUser.
  ///
  /// In id, this message translates to:
  /// **'Membuat user...'**
  String get adminCreatingUser;

  /// No description provided for @adminCreatingUnit.
  ///
  /// In id, this message translates to:
  /// **'Membuat unit...'**
  String get adminCreatingUnit;

  /// No description provided for @adminCreatingDevice.
  ///
  /// In id, this message translates to:
  /// **'Membuat device...'**
  String get adminCreatingDevice;

  /// No description provided for @adminCreatingSensor.
  ///
  /// In id, this message translates to:
  /// **'Membuat sensor...'**
  String get adminCreatingSensor;

  /// No description provided for @adminCreatingPlant.
  ///
  /// In id, this message translates to:
  /// **'Membuat tanaman...'**
  String get adminCreatingPlant;

  /// No description provided for @adminCreatingRole.
  ///
  /// In id, this message translates to:
  /// **'Membuat role...'**
  String get adminCreatingRole;

  /// No description provided for @adminCreatingMapping.
  ///
  /// In id, this message translates to:
  /// **'Membuat mapping...'**
  String get adminCreatingMapping;

  /// No description provided for @adminAccountInfoSection.
  ///
  /// In id, this message translates to:
  /// **'Informasi Akun'**
  String get adminAccountInfoSection;

  /// No description provided for @adminSecuritySection.
  ///
  /// In id, this message translates to:
  /// **'Keamanan'**
  String get adminSecuritySection;

  /// No description provided for @adminRoleStatusSection.
  ///
  /// In id, this message translates to:
  /// **'Role & Status'**
  String get adminRoleStatusSection;

  /// No description provided for @adminBasicInfoSection.
  ///
  /// In id, this message translates to:
  /// **'Informasi Dasar'**
  String get adminBasicInfoSection;

  /// No description provided for @adminUnitInfoSection.
  ///
  /// In id, this message translates to:
  /// **'Informasi Unit'**
  String get adminUnitInfoSection;

  /// No description provided for @adminPlantInfoSection.
  ///
  /// In id, this message translates to:
  /// **'Informasi Tanaman'**
  String get adminPlantInfoSection;

  /// No description provided for @adminPlantingDateSection.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Tanam'**
  String get adminPlantingDateSection;

  /// No description provided for @adminRoleInfoSection.
  ///
  /// In id, this message translates to:
  /// **'Informasi Role'**
  String get adminRoleInfoSection;

  /// No description provided for @adminRolePermissionSection.
  ///
  /// In id, this message translates to:
  /// **'Permission Role'**
  String get adminRolePermissionSection;

  /// No description provided for @adminConnectionSection.
  ///
  /// In id, this message translates to:
  /// **'Koneksi'**
  String get adminConnectionSection;

  /// No description provided for @adminConnectionSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Opsional - IP address dan port device'**
  String get adminConnectionSubtitle;

  /// No description provided for @adminCoordinatesSection.
  ///
  /// In id, this message translates to:
  /// **'Koordinat'**
  String get adminCoordinatesSection;

  /// No description provided for @adminDeviceCoordinateSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Opsional - untuk pemetaan lokasi device'**
  String get adminDeviceCoordinateSubtitle;

  /// No description provided for @adminSensorCoordinateSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Opsional - untuk pemetaan lokasi sensor'**
  String get adminSensorCoordinateSubtitle;

  /// No description provided for @adminConfigurationSection.
  ///
  /// In id, this message translates to:
  /// **'Konfigurasi'**
  String get adminConfigurationSection;

  /// No description provided for @adminStatusSection.
  ///
  /// In id, this message translates to:
  /// **'Status'**
  String get adminStatusSection;

  /// No description provided for @adminMappingInfoSection.
  ///
  /// In id, this message translates to:
  /// **'Informasi Mapping'**
  String get adminMappingInfoSection;

  /// No description provided for @adminThresholdSection.
  ///
  /// In id, this message translates to:
  /// **'Threshold'**
  String get adminThresholdSection;

  /// No description provided for @adminThresholdSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Konfigurasi batas nilai sensor'**
  String get adminThresholdSubtitle;

  /// No description provided for @adminUserIdLabel.
  ///
  /// In id, this message translates to:
  /// **'User ID'**
  String get adminUserIdLabel;

  /// No description provided for @adminUserIdHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: USER001'**
  String get adminUserIdHint;

  /// No description provided for @adminUserIdRequired.
  ///
  /// In id, this message translates to:
  /// **'User ID wajib diisi'**
  String get adminUserIdRequired;

  /// No description provided for @adminFullNameHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: John Doe'**
  String get adminFullNameHint;

  /// No description provided for @adminEmailHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: user@example.com'**
  String get adminEmailHint;

  /// No description provided for @adminPhoneHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: 081234567890'**
  String get adminPhoneHint;

  /// No description provided for @adminRoleLabel.
  ///
  /// In id, this message translates to:
  /// **'Role'**
  String get adminRoleLabel;

  /// No description provided for @adminSelectRoleHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih role'**
  String get adminSelectRoleHint;

  /// No description provided for @adminRoleRequired.
  ///
  /// In id, this message translates to:
  /// **'Role wajib dipilih'**
  String get adminRoleRequired;

  /// No description provided for @adminSelectStatusHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih status'**
  String get adminSelectStatusHint;

  /// No description provided for @adminPasswordLabel.
  ///
  /// In id, this message translates to:
  /// **'Password'**
  String get adminPasswordLabel;

  /// No description provided for @adminPasswordHint.
  ///
  /// In id, this message translates to:
  /// **'Minimal 6 karakter'**
  String get adminPasswordHint;

  /// No description provided for @adminPasswordRequired.
  ///
  /// In id, this message translates to:
  /// **'Password wajib diisi'**
  String get adminPasswordRequired;

  /// No description provided for @adminPasswordMinLength.
  ///
  /// In id, this message translates to:
  /// **'Password minimal 6 karakter'**
  String get adminPasswordMinLength;

  /// No description provided for @adminUnitIdLabel.
  ///
  /// In id, this message translates to:
  /// **'Unit ID'**
  String get adminUnitIdLabel;

  /// No description provided for @adminUnitIdHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: TEMP_C'**
  String get adminUnitIdHint;

  /// No description provided for @adminUnitIdRequired.
  ///
  /// In id, this message translates to:
  /// **'Unit ID wajib diisi'**
  String get adminUnitIdRequired;

  /// No description provided for @adminUnitNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Unit'**
  String get adminUnitNameLabel;

  /// No description provided for @adminUnitNameHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Celsius'**
  String get adminUnitNameHint;

  /// No description provided for @adminUnitNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama unit wajib diisi'**
  String get adminUnitNameRequired;

  /// No description provided for @adminUnitSymbolLabel.
  ///
  /// In id, this message translates to:
  /// **'Simbol'**
  String get adminUnitSymbolLabel;

  /// No description provided for @adminUnitSymbolHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: C'**
  String get adminUnitSymbolHint;

  /// No description provided for @adminUnitSymbolRequired.
  ///
  /// In id, this message translates to:
  /// **'Simbol wajib diisi'**
  String get adminUnitSymbolRequired;

  /// No description provided for @adminUnitDescriptionHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Satuan suhu dalam derajat Celsius'**
  String get adminUnitDescriptionHint;

  /// No description provided for @adminSensorIdLabel.
  ///
  /// In id, this message translates to:
  /// **'Sensor ID'**
  String get adminSensorIdLabel;

  /// No description provided for @adminSensorIdHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: soil_nitro'**
  String get adminSensorIdHint;

  /// No description provided for @adminSensorIdRequired.
  ///
  /// In id, this message translates to:
  /// **'Sensor ID wajib diisi'**
  String get adminSensorIdRequired;

  /// No description provided for @adminSensorNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Sensor'**
  String get adminSensorNameLabel;

  /// No description provided for @adminSensorNameHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Nitrogen Sensor'**
  String get adminSensorNameHint;

  /// No description provided for @adminSensorNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama sensor wajib diisi'**
  String get adminSensorNameRequired;

  /// No description provided for @adminSensorAddressLabel.
  ///
  /// In id, this message translates to:
  /// **'Alamat Sensor'**
  String get adminSensorAddressLabel;

  /// No description provided for @adminSensorAddressHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: 0x10'**
  String get adminSensorAddressHint;

  /// No description provided for @adminSensorLocationHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Soil Layer 1'**
  String get adminSensorLocationHint;

  /// No description provided for @adminSelectDeviceOptional.
  ///
  /// In id, this message translates to:
  /// **'Pilih device (opsional)'**
  String get adminSelectDeviceOptional;

  /// No description provided for @adminNoDevice.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada device'**
  String get adminNoDevice;

  /// No description provided for @adminLoadDeviceFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat device'**
  String get adminLoadDeviceFailed;

  /// No description provided for @adminDeviceRequired.
  ///
  /// In id, this message translates to:
  /// **'Device wajib dipilih'**
  String get adminDeviceRequired;

  /// No description provided for @adminDeviceIdHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: DEV001'**
  String get adminDeviceIdHint;

  /// No description provided for @adminDeviceNameHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Main Gateway'**
  String get adminDeviceNameHint;

  /// No description provided for @adminDeviceLocationHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Greenhouse A'**
  String get adminDeviceLocationHint;

  /// No description provided for @adminIpInvalid.
  ///
  /// In id, this message translates to:
  /// **'IP tidak valid'**
  String get adminIpInvalid;

  /// No description provided for @adminPlantIdLabel.
  ///
  /// In id, this message translates to:
  /// **'Plant ID'**
  String get adminPlantIdLabel;

  /// No description provided for @adminServerIdHint.
  ///
  /// In id, this message translates to:
  /// **'ID dari server'**
  String get adminServerIdHint;

  /// No description provided for @adminPlantNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Tanaman'**
  String get adminPlantNameLabel;

  /// No description provided for @adminPlantNameHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Padi Sawah Blok A'**
  String get adminPlantNameHint;

  /// No description provided for @adminPlantNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama tanaman wajib diisi'**
  String get adminPlantNameRequired;

  /// No description provided for @adminCropTypeLabel.
  ///
  /// In id, this message translates to:
  /// **'Jenis Tanaman'**
  String get adminCropTypeLabel;

  /// No description provided for @adminSelectCropTypeHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih jenis tanaman'**
  String get adminSelectCropTypeHint;

  /// No description provided for @adminCropTypeRequired.
  ///
  /// In id, this message translates to:
  /// **'Jenis tanaman wajib dipilih'**
  String get adminCropTypeRequired;

  /// No description provided for @adminVarietasIdLabel.
  ///
  /// In id, this message translates to:
  /// **'Varietas ID'**
  String get adminVarietasIdLabel;

  /// No description provided for @adminVarietasIdHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: VAR_001'**
  String get adminVarietasIdHint;

  /// No description provided for @adminVarietasIdRequired.
  ///
  /// In id, this message translates to:
  /// **'Varietas ID wajib diisi'**
  String get adminVarietasIdRequired;

  /// No description provided for @adminChooseVarietasFromList.
  ///
  /// In id, this message translates to:
  /// **'Pilih dari daftar varietas'**
  String get adminChooseVarietasFromList;

  /// No description provided for @adminVarietasLabel.
  ///
  /// In id, this message translates to:
  /// **'Varietas'**
  String get adminVarietasLabel;

  /// No description provided for @adminSelectVarietasHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih varietas dari backend'**
  String get adminSelectVarietasHint;

  /// No description provided for @adminVarietasRequired.
  ///
  /// In id, this message translates to:
  /// **'Varietas wajib dipilih'**
  String get adminVarietasRequired;

  /// No description provided for @adminVarietasLoadFailedManual.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat varietas. Gunakan input manual.'**
  String get adminVarietasLoadFailedManual;

  /// No description provided for @adminManualIdInput.
  ///
  /// In id, this message translates to:
  /// **'Input ID manual'**
  String get adminManualIdInput;

  /// No description provided for @adminSelectPlantingDate.
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal tanam'**
  String get adminSelectPlantingDate;

  /// No description provided for @adminPlantingDateRequired.
  ///
  /// In id, this message translates to:
  /// **'Tanggal tanam wajib dipilih'**
  String get adminPlantingDateRequired;

  /// No description provided for @adminRoleIdLabel.
  ///
  /// In id, this message translates to:
  /// **'Role ID'**
  String get adminRoleIdLabel;

  /// No description provided for @adminRoleIdHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: ROLE001'**
  String get adminRoleIdHint;

  /// No description provided for @adminRoleIdRequired.
  ///
  /// In id, this message translates to:
  /// **'Role ID wajib diisi'**
  String get adminRoleIdRequired;

  /// No description provided for @adminRoleNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Role'**
  String get adminRoleNameLabel;

  /// No description provided for @adminRoleNameHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Admin, Operator, Viewer'**
  String get adminRoleNameHint;

  /// No description provided for @adminRoleNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama role wajib diisi'**
  String get adminRoleNameRequired;

  /// No description provided for @adminRoleDescriptionHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Role untuk administrator sistem'**
  String get adminRoleDescriptionHint;

  /// No description provided for @adminDsIdLabel.
  ///
  /// In id, this message translates to:
  /// **'DS ID'**
  String get adminDsIdLabel;

  /// No description provided for @adminDsIdHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: DS001'**
  String get adminDsIdHint;

  /// No description provided for @adminDsIdRequired.
  ///
  /// In id, this message translates to:
  /// **'DS ID wajib diisi'**
  String get adminDsIdRequired;

  /// No description provided for @adminMappingNameHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Nitrogen Sensor DEV001'**
  String get adminMappingNameHint;

  /// No description provided for @adminNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama wajib diisi'**
  String get adminNameRequired;

  /// No description provided for @adminSelectDeviceHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih device'**
  String get adminSelectDeviceHint;

  /// No description provided for @adminSelectSensorOptional.
  ///
  /// In id, this message translates to:
  /// **'Pilih sensor (opsional)'**
  String get adminSelectSensorOptional;

  /// No description provided for @adminSelectUnitOptional.
  ///
  /// In id, this message translates to:
  /// **'Pilih unit (opsional)'**
  String get adminSelectUnitOptional;

  /// No description provided for @adminLoadSensorFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat sensor'**
  String get adminLoadSensorFailed;

  /// No description provided for @adminLoadUnitFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat unit'**
  String get adminLoadUnitFailed;

  /// No description provided for @adminNoSelection.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada'**
  String get adminNoSelection;

  /// No description provided for @adminAddressLabel.
  ///
  /// In id, this message translates to:
  /// **'Alamat'**
  String get adminAddressLabel;

  /// No description provided for @adminSequenceLabel.
  ///
  /// In id, this message translates to:
  /// **'Urutan (Seq)'**
  String get adminSequenceLabel;

  /// No description provided for @adminSequenceHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: 1'**
  String get adminSequenceHint;

  /// No description provided for @adminNormalValueLabel.
  ///
  /// In id, this message translates to:
  /// **'Nilai Normal'**
  String get adminNormalValueLabel;

  /// No description provided for @adminExampleDecimalHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: 25.0'**
  String get adminExampleDecimalHint;

  /// No description provided for @adminMinNormalLabel.
  ///
  /// In id, this message translates to:
  /// **'Min Normal'**
  String get adminMinNormalLabel;

  /// No description provided for @adminMaxNormalLabel.
  ///
  /// In id, this message translates to:
  /// **'Max Normal'**
  String get adminMaxNormalLabel;

  /// No description provided for @adminMinAbsoluteLabel.
  ///
  /// In id, this message translates to:
  /// **'Min Absolut'**
  String get adminMinAbsoluteLabel;

  /// No description provided for @adminMaxAbsoluteLabel.
  ///
  /// In id, this message translates to:
  /// **'Max Absolut'**
  String get adminMaxAbsoluteLabel;

  /// No description provided for @adminMinWarningLabel.
  ///
  /// In id, this message translates to:
  /// **'Min Warning'**
  String get adminMinWarningLabel;

  /// No description provided for @adminMaxWarningLabel.
  ///
  /// In id, this message translates to:
  /// **'Max Warning'**
  String get adminMaxWarningLabel;

  /// No description provided for @adminStatusUserLabel.
  ///
  /// In id, this message translates to:
  /// **'Status User'**
  String get adminStatusUserLabel;

  /// No description provided for @adminStatusUnitLabel.
  ///
  /// In id, this message translates to:
  /// **'Status Unit'**
  String get adminStatusUnitLabel;

  /// No description provided for @adminStatusDeviceLabel.
  ///
  /// In id, this message translates to:
  /// **'Status Device'**
  String get adminStatusDeviceLabel;

  /// No description provided for @adminStatusSensorLabel.
  ///
  /// In id, this message translates to:
  /// **'Status Sensor'**
  String get adminStatusSensorLabel;

  /// No description provided for @adminStatusPlantLabel.
  ///
  /// In id, this message translates to:
  /// **'Status Tanaman'**
  String get adminStatusPlantLabel;

  /// No description provided for @adminStatusRoleLabel.
  ///
  /// In id, this message translates to:
  /// **'Status Role'**
  String get adminStatusRoleLabel;

  /// No description provided for @adminStatusMappingLabel.
  ///
  /// In id, this message translates to:
  /// **'Status Mapping'**
  String get adminStatusMappingLabel;

  /// No description provided for @adminUpdateSuccess.
  ///
  /// In id, this message translates to:
  /// **'{item} berhasil diperbarui'**
  String adminUpdateSuccess(String item);

  /// No description provided for @adminCreateSuccess.
  ///
  /// In id, this message translates to:
  /// **'{item} berhasil ditambahkan'**
  String adminCreateSuccess(String item);

  /// No description provided for @adminSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan {item}'**
  String adminSaveFailed(String item);

  /// No description provided for @adminMinNormalGreaterThanMaxNormal.
  ///
  /// In id, this message translates to:
  /// **'Min Normal tidak boleh lebih besar dari Max Normal'**
  String get adminMinNormalGreaterThanMaxNormal;

  /// No description provided for @adminMinAbsoluteGreaterThanMaxAbsolute.
  ///
  /// In id, this message translates to:
  /// **'Min Absolut tidak boleh lebih besar dari Max Absolut'**
  String get adminMinAbsoluteGreaterThanMaxAbsolute;

  /// No description provided for @adminMinWarningGreaterThanMaxWarning.
  ///
  /// In id, this message translates to:
  /// **'Min Warning tidak boleh lebih besar dari Max Warning'**
  String get adminMinWarningGreaterThanMaxWarning;

  /// No description provided for @adminMinAbsoluteGreaterThanMinNormal.
  ///
  /// In id, this message translates to:
  /// **'Min Absolut tidak boleh lebih besar dari Min Normal'**
  String get adminMinAbsoluteGreaterThanMinNormal;

  /// No description provided for @adminMinAbsoluteGreaterThanMinWarning.
  ///
  /// In id, this message translates to:
  /// **'Min Absolut tidak boleh lebih besar dari Min Warning'**
  String get adminMinAbsoluteGreaterThanMinWarning;

  /// No description provided for @adminMaxAbsoluteLessThanMaxNormal.
  ///
  /// In id, this message translates to:
  /// **'Max Absolut tidak boleh lebih kecil dari Max Normal'**
  String get adminMaxAbsoluteLessThanMaxNormal;

  /// No description provided for @adminMaxAbsoluteLessThanMaxWarning.
  ///
  /// In id, this message translates to:
  /// **'Max Absolut tidak boleh lebih kecil dari Max Warning'**
  String get adminMaxAbsoluteLessThanMaxWarning;

  /// No description provided for @adminMinWarningGreaterThanMinNormal.
  ///
  /// In id, this message translates to:
  /// **'Min Warning tidak boleh lebih besar dari Min Normal'**
  String get adminMinWarningGreaterThanMinNormal;

  /// No description provided for @adminMaxWarningLessThanMaxNormal.
  ///
  /// In id, this message translates to:
  /// **'Max Warning tidak boleh lebih kecil dari Max Normal'**
  String get adminMaxWarningLessThanMaxNormal;

  /// No description provided for @adminFullNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get adminFullNameLabel;

  /// No description provided for @adminEmailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get adminEmailLabel;

  /// No description provided for @adminPhoneLabel.
  ///
  /// In id, this message translates to:
  /// **'No. Telepon'**
  String get adminPhoneLabel;

  /// No description provided for @adminEmailInvalid.
  ///
  /// In id, this message translates to:
  /// **'Format email tidak valid'**
  String get adminEmailInvalid;

  /// No description provided for @adminPhoneInvalid.
  ///
  /// In id, this message translates to:
  /// **'No. telepon tidak valid'**
  String get adminPhoneInvalid;

  /// No description provided for @roleAdmin.
  ///
  /// In id, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleUser.
  ///
  /// In id, this message translates to:
  /// **'User'**
  String get roleUser;

  /// No description provided for @roleViewer.
  ///
  /// In id, this message translates to:
  /// **'Viewer'**
  String get roleViewer;

  /// No description provided for @adminIdPrefix.
  ///
  /// In id, this message translates to:
  /// **'ID: {id}'**
  String adminIdPrefix(String id);

  /// No description provided for @adminDevicePrefix.
  ///
  /// In id, this message translates to:
  /// **'Device: {id}'**
  String adminDevicePrefix(String id);

  /// No description provided for @adminSensorPrefix.
  ///
  /// In id, this message translates to:
  /// **'Sensor: {id}'**
  String adminSensorPrefix(String id);

  /// No description provided for @adminDeviceLabel.
  ///
  /// In id, this message translates to:
  /// **'Device'**
  String get adminDeviceLabel;

  /// No description provided for @adminSensorLabel.
  ///
  /// In id, this message translates to:
  /// **'Sensor'**
  String get adminSensorLabel;

  /// No description provided for @adminUnitLabel.
  ///
  /// In id, this message translates to:
  /// **'Unit'**
  String get adminUnitLabel;

  /// No description provided for @adminDeviceIdLabel.
  ///
  /// In id, this message translates to:
  /// **'Device ID'**
  String get adminDeviceIdLabel;

  /// No description provided for @adminDeviceIdRequired.
  ///
  /// In id, this message translates to:
  /// **'Device ID wajib diisi'**
  String get adminDeviceIdRequired;

  /// No description provided for @adminDeviceNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Device'**
  String get adminDeviceNameLabel;

  /// No description provided for @adminDeviceNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama device wajib diisi'**
  String get adminDeviceNameRequired;

  /// No description provided for @adminIpAddressLabel.
  ///
  /// In id, this message translates to:
  /// **'IP Address'**
  String get adminIpAddressLabel;

  /// No description provided for @adminPortLabel.
  ///
  /// In id, this message translates to:
  /// **'Port'**
  String get adminPortLabel;

  /// No description provided for @adminAltitudeLabel.
  ///
  /// In id, this message translates to:
  /// **'Altitude (meter)'**
  String get adminAltitudeLabel;

  /// No description provided for @recommendationHstRangeLabel.
  ///
  /// In id, this message translates to:
  /// **'HST {min}-{max}'**
  String recommendationHstRangeLabel(int min, int max);

  /// No description provided for @adminDsDevSubtitle.
  ///
  /// In id, this message translates to:
  /// **'DS ID: {dsId} · Device ID: {devId}'**
  String adminDsDevSubtitle(String dsId, String devId);

  /// No description provided for @adminSensIdBadge.
  ///
  /// In id, this message translates to:
  /// **'sens_id: {id}'**
  String adminSensIdBadge(String id);

  /// No description provided for @adminUnitBadge.
  ///
  /// In id, this message translates to:
  /// **'unit: {id}'**
  String adminUnitBadge(String id);

  /// No description provided for @sensorTypeAirTemperature.
  ///
  /// In id, this message translates to:
  /// **'Suhu Udara'**
  String get sensorTypeAirTemperature;

  /// No description provided for @sensorTypeAirHumidity.
  ///
  /// In id, this message translates to:
  /// **'Kelembaban Udara'**
  String get sensorTypeAirHumidity;

  /// No description provided for @sensorTypeSoilMoisture.
  ///
  /// In id, this message translates to:
  /// **'Kelembaban Tanah'**
  String get sensorTypeSoilMoisture;

  /// No description provided for @sensorTypeSoilPh.
  ///
  /// In id, this message translates to:
  /// **'pH Tanah'**
  String get sensorTypeSoilPh;

  /// No description provided for @sensorTypeSoilNitrogen.
  ///
  /// In id, this message translates to:
  /// **'Nitrogen Tanah'**
  String get sensorTypeSoilNitrogen;

  /// No description provided for @sensorTypeSoilPhosphorus.
  ///
  /// In id, this message translates to:
  /// **'Fosfor Tanah'**
  String get sensorTypeSoilPhosphorus;

  /// No description provided for @sensorTypeSoilPotassium.
  ///
  /// In id, this message translates to:
  /// **'Kalium Tanah'**
  String get sensorTypeSoilPotassium;

  /// No description provided for @sensorTypeLightIntensity.
  ///
  /// In id, this message translates to:
  /// **'Intensitas Cahaya'**
  String get sensorTypeLightIntensity;

  /// No description provided for @sensorTypeAtmosphericPressure.
  ///
  /// In id, this message translates to:
  /// **'Tekanan Udara'**
  String get sensorTypeAtmosphericPressure;

  /// No description provided for @sensorTypeWindSpeed.
  ///
  /// In id, this message translates to:
  /// **'Kecepatan Angin'**
  String get sensorTypeWindSpeed;

  /// No description provided for @agroVdpDeficitTitle.
  ///
  /// In id, this message translates to:
  /// **'Defisit Tekanan Uap'**
  String get agroVdpDeficitTitle;

  /// No description provided for @agroVdpValueLabel.
  ///
  /// In id, this message translates to:
  /// **'Nilai VPD'**
  String get agroVdpValueLabel;

  /// No description provided for @agroVdpRangeLabel.
  ///
  /// In id, this message translates to:
  /// **'Rentang VPD'**
  String get agroVdpRangeLabel;

  /// No description provided for @agroVdpDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail VPD'**
  String get agroVdpDetailTitle;

  /// No description provided for @agroVdpUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Data VPD tidak tersedia'**
  String get agroVdpUnavailable;

  /// No description provided for @agroVdpStatusLow.
  ///
  /// In id, this message translates to:
  /// **'Terlalu Rendah'**
  String get agroVdpStatusLow;

  /// No description provided for @agroVdpStatusOptimal.
  ///
  /// In id, this message translates to:
  /// **'Optimal'**
  String get agroVdpStatusOptimal;

  /// No description provided for @agroVdpStatusWarning.
  ///
  /// In id, this message translates to:
  /// **'Waspada'**
  String get agroVdpStatusWarning;

  /// No description provided for @agroVdpStatusHigh.
  ///
  /// In id, this message translates to:
  /// **'Terlalu Tinggi'**
  String get agroVdpStatusHigh;

  /// No description provided for @agroVdpDescLow.
  ///
  /// In id, this message translates to:
  /// **'Kelembaban relatif tinggi. Tingkatkan ventilasi agar risiko penyakit turun.'**
  String get agroVdpDescLow;

  /// No description provided for @agroVdpDescOptimal.
  ///
  /// In id, this message translates to:
  /// **'Kondisi defisit tekanan uap berada pada rentang ideal.'**
  String get agroVdpDescOptimal;

  /// No description provided for @agroVdpDescWarning.
  ///
  /// In id, this message translates to:
  /// **'Tanaman mulai berisiko kehilangan air lebih cepat. Pantau irigasi dan kelembaban.'**
  String get agroVdpDescWarning;

  /// No description provided for @agroVdpDescHigh.
  ///
  /// In id, this message translates to:
  /// **'Defisit tekanan uap tinggi. Tingkatkan penyiraman dan jaga kelembaban area tanam.'**
  String get agroVdpDescHigh;

  /// No description provided for @agroGddSuhuAccumLabel.
  ///
  /// In id, this message translates to:
  /// **'Akumulasi Suhu Pertumbuhan'**
  String get agroGddSuhuAccumLabel;

  /// No description provided for @agroGddTotalLabel.
  ///
  /// In id, this message translates to:
  /// **'Total GDD'**
  String get agroGddTotalLabel;

  /// No description provided for @agroGddAccumLabel.
  ///
  /// In id, this message translates to:
  /// **'Akumulasi'**
  String get agroGddAccumLabel;

  /// No description provided for @agroGddDailyChartTitle.
  ///
  /// In id, this message translates to:
  /// **'GDD Harian (7 Hari Terakhir)'**
  String get agroGddDailyChartTitle;

  /// No description provided for @agroGddDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail GDD Harian'**
  String get agroGddDetailTitle;

  /// No description provided for @agroGddUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Data GDD tidak tersedia'**
  String get agroGddUnavailable;

  /// No description provided for @plantGrowthPhaseTitle.
  ///
  /// In id, this message translates to:
  /// **'Fase Pertumbuhan'**
  String get plantGrowthPhaseTitle;

  /// No description provided for @plantActivePhaseDesc.
  ///
  /// In id, this message translates to:
  /// **'Fase aktif tanaman saat ini'**
  String get plantActivePhaseDesc;

  /// No description provided for @plantTimeProgressLabel.
  ///
  /// In id, this message translates to:
  /// **'Progress Waktu'**
  String get plantTimeProgressLabel;

  /// No description provided for @plantGrowthPhaseUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Data fase pertumbuhan belum tersedia'**
  String get plantGrowthPhaseUnavailable;

  /// No description provided for @commonNotAvailableYet.
  ///
  /// In id, this message translates to:
  /// **'Belum ada'**
  String get commonNotAvailableYet;

  /// No description provided for @agroGddTrackingNoData.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data GDD'**
  String get agroGddTrackingNoData;

  /// No description provided for @agroGddTrackingNoDataDesc.
  ///
  /// In id, this message translates to:
  /// **'Data GDD akan ditarik dari API Agro setelah tanaman aktif terdaftar di site ini.'**
  String get agroGddTrackingNoDataDesc;

  /// No description provided for @agroGddTrackingSummaryTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan GDD'**
  String get agroGddTrackingSummaryTitle;

  /// No description provided for @agroGddTrackingTotalReal.
  ///
  /// In id, this message translates to:
  /// **'Total GDD (Riil)'**
  String get agroGddTrackingTotalReal;

  /// No description provided for @agroGddTrackingFieldProgress.
  ///
  /// In id, this message translates to:
  /// **'Progress Lahan'**
  String get agroGddTrackingFieldProgress;

  /// No description provided for @agroGddTrackingDurationTitle.
  ///
  /// In id, this message translates to:
  /// **'Durasi HST per Fase'**
  String get agroGddTrackingDurationTitle;

  /// No description provided for @agroGddTrackingDurationSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Durasi Hari Setelah Tanam per fase pertumbuhan'**
  String get agroGddTrackingDurationSubtitle;

  /// No description provided for @agroGddTrackingDurationDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Durasi per Fase'**
  String get agroGddTrackingDurationDetailTitle;

  /// No description provided for @agroGddTrackingDurationDetailSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Detail rincian durasi setiap fase pertumbuhan'**
  String get agroGddTrackingDurationDetailSubtitle;

  /// No description provided for @agroGddTrackingTablePhase.
  ///
  /// In id, this message translates to:
  /// **'Fase'**
  String get agroGddTrackingTablePhase;

  /// No description provided for @agroGddTrackingTableCurrentHst.
  ///
  /// In id, this message translates to:
  /// **'HST Kini'**
  String get agroGddTrackingTableCurrentHst;

  /// No description provided for @agroGddTrackingTableDuration.
  ///
  /// In id, this message translates to:
  /// **'Durasi'**
  String get agroGddTrackingTableDuration;

  /// No description provided for @profilePermissionsLoadError.
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat memuat hak akses'**
  String get profilePermissionsLoadError;

  /// No description provided for @profilePermissionsNoAccess.
  ///
  /// In id, this message translates to:
  /// **'Tidak Ada Akses'**
  String get profilePermissionsNoAccess;

  /// No description provided for @profilePermissionsNoAccessDesc.
  ///
  /// In id, this message translates to:
  /// **'Belum ada hak akses tersedia'**
  String get profilePermissionsNoAccessDesc;

  /// No description provided for @profilePermissionsSystemAccess.
  ///
  /// In id, this message translates to:
  /// **'Hak Akses Sistem'**
  String get profilePermissionsSystemAccess;

  /// No description provided for @permissionActionRead.
  ///
  /// In id, this message translates to:
  /// **'Lihat'**
  String get permissionActionRead;

  /// No description provided for @permissionActionCreate.
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get permissionActionCreate;

  /// No description provided for @permissionActionUpdate.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get permissionActionUpdate;

  /// No description provided for @permissionActionDelete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get permissionActionDelete;

  /// No description provided for @permissionActionManage.
  ///
  /// In id, this message translates to:
  /// **'Kelola'**
  String get permissionActionManage;

  /// No description provided for @sensorEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Sensor'**
  String get sensorEditTitle;

  /// No description provided for @sensorNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Sensor'**
  String get sensorNameLabel;

  /// No description provided for @sensorNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama sensor wajib diisi'**
  String get sensorNameRequired;

  /// No description provided for @sensorTypeRequired.
  ///
  /// In id, this message translates to:
  /// **'Tipe sensor wajib dipilih'**
  String get sensorTypeRequired;

  /// No description provided for @sensorUnitRequired.
  ///
  /// In id, this message translates to:
  /// **'Satuan wajib diisi'**
  String get sensorUnitRequired;

  /// No description provided for @sensorUnitHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: °C, %, pH'**
  String get sensorUnitHint;

  /// No description provided for @sensorDescLabel.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi (Opsional)'**
  String get sensorDescLabel;

  /// No description provided for @sensorDescHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan deskripsi sensor'**
  String get sensorDescHint;

  /// No description provided for @sensorStatusActiveLabel.
  ///
  /// In id, this message translates to:
  /// **'Status Aktif'**
  String get sensorStatusActiveLabel;

  /// No description provided for @sensorStatusActiveDesc.
  ///
  /// In id, this message translates to:
  /// **'Sensor aktif'**
  String get sensorStatusActiveDesc;

  /// No description provided for @sensorStatusInactiveDesc.
  ///
  /// In id, this message translates to:
  /// **'Sensor tidak aktif'**
  String get sensorStatusInactiveDesc;

  /// No description provided for @sensorUpdatedSuccess.
  ///
  /// In id, this message translates to:
  /// **'Sensor berhasil diperbarui'**
  String get sensorUpdatedSuccess;

  /// No description provided for @sensorCreatedSuccess.
  ///
  /// In id, this message translates to:
  /// **'Sensor berhasil ditambahkan'**
  String get sensorCreatedSuccess;

  /// No description provided for @commonOptimal.
  ///
  /// In id, this message translates to:
  /// **'Optimal'**
  String get commonOptimal;

  /// No description provided for @commonWarning.
  ///
  /// In id, this message translates to:
  /// **'Waspada'**
  String get commonWarning;

  /// No description provided for @commonNitrogen.
  ///
  /// In id, this message translates to:
  /// **'Nitrogen'**
  String get commonNitrogen;

  /// No description provided for @commonPhosphorus.
  ///
  /// In id, this message translates to:
  /// **'Fosfor'**
  String get commonPhosphorus;

  /// No description provided for @commonPotassium.
  ///
  /// In id, this message translates to:
  /// **'Kalium'**
  String get commonPotassium;

  /// No description provided for @monitoringActionRequiredTitle.
  ///
  /// In id, this message translates to:
  /// **'Tindakan Diperlukan'**
  String get monitoringActionRequiredTitle;

  /// No description provided for @monitoringNoSensorConfiguredDesc.
  ///
  /// In id, this message translates to:
  /// **'Belum ada parameter sensor yang dapat dievaluasi. Periksa konfigurasi dan data sensor terbaru.'**
  String get monitoringNoSensorConfiguredDesc;

  /// No description provided for @monitoringPlantCompositionTitle.
  ///
  /// In id, this message translates to:
  /// **'Distribusi Berdasarkan Jenis'**
  String get monitoringPlantCompositionTitle;

  /// No description provided for @monitoringChartTypeLabel.
  ///
  /// In id, this message translates to:
  /// **'Tipe Grafik'**
  String get monitoringChartTypeLabel;

  /// No description provided for @monitoringChartTypeLine.
  ///
  /// In id, this message translates to:
  /// **'Garis'**
  String get monitoringChartTypeLine;

  /// No description provided for @monitoringChartTypeBar.
  ///
  /// In id, this message translates to:
  /// **'Batang'**
  String get monitoringChartTypeBar;

  /// No description provided for @monitoringChartTypeArea.
  ///
  /// In id, this message translates to:
  /// **'Area'**
  String get monitoringChartTypeArea;

  /// No description provided for @monitoringDailyNoAggregationDesc.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data agregasi untuk rentang ini'**
  String get monitoringDailyNoAggregationDesc;

  /// No description provided for @monitoringRangeToday.
  ///
  /// In id, this message translates to:
  /// **'Hari ini'**
  String get monitoringRangeToday;

  /// No description provided for @monitoringRangeLast7Days.
  ///
  /// In id, this message translates to:
  /// **'7 hari terakhir'**
  String get monitoringRangeLast7Days;

  /// No description provided for @monitoringRangeLast30Days.
  ///
  /// In id, this message translates to:
  /// **'30 hari terakhir'**
  String get monitoringRangeLast30Days;

  /// No description provided for @monitoringRangeCustom.
  ///
  /// In id, this message translates to:
  /// **'Rentang custom'**
  String get monitoringRangeCustom;

  /// No description provided for @monitoringDataPointsCount.
  ///
  /// In id, this message translates to:
  /// **'{count} titik data'**
  String monitoringDataPointsCount(int count);

  /// No description provided for @monitoringFilterThirtyDay.
  ///
  /// In id, this message translates to:
  /// **'30 Hari'**
  String get monitoringFilterThirtyDay;

  /// No description provided for @monitoringFilterCustom.
  ///
  /// In id, this message translates to:
  /// **'Kustom'**
  String get monitoringFilterCustom;

  /// No description provided for @monitoringRangeLabel.
  ///
  /// In id, this message translates to:
  /// **'Rentang'**
  String get monitoringRangeLabel;

  /// No description provided for @monitoringActiveAlarmsCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Alarm Aktif'**
  String monitoringActiveAlarmsCount(int count);

  /// No description provided for @monitoringDetectedInLast24Hours.
  ///
  /// In id, this message translates to:
  /// **'Terdeteksi dalam 24 jam terakhir'**
  String get monitoringDetectedInLast24Hours;

  /// No description provided for @monitoringOtherAlarmsCount.
  ///
  /// In id, this message translates to:
  /// **'+ {count} alarm lainnya'**
  String monitoringOtherAlarmsCount(int count);

  /// No description provided for @monitoringCloseLog.
  ///
  /// In id, this message translates to:
  /// **'Tutup Log'**
  String get monitoringCloseLog;

  /// No description provided for @monitoringShowAllLogsCount.
  ///
  /// In id, this message translates to:
  /// **'Lihat Semua Log ({count})'**
  String monitoringShowAllLogsCount(int count);

  /// No description provided for @monitoringChartDescLine.
  ///
  /// In id, this message translates to:
  /// **'Tren sensor berdasarkan waktu'**
  String get monitoringChartDescLine;

  /// No description provided for @monitoringChartDescBar.
  ///
  /// In id, this message translates to:
  /// **'Perbandingan nilai sensor per waktu'**
  String get monitoringChartDescBar;

  /// No description provided for @monitoringChartDescArea.
  ///
  /// In id, this message translates to:
  /// **'Perubahan sensor dengan area tren'**
  String get monitoringChartDescArea;

  /// No description provided for @agroIndicatorLabel.
  ///
  /// In id, this message translates to:
  /// **'Agro Indikator'**
  String get agroIndicatorLabel;

  /// No description provided for @environmentalHealthScore.
  ///
  /// In id, this message translates to:
  /// **'Skor Kesehatan Lingkungan'**
  String get environmentalHealthScore;

  /// No description provided for @gddCDaysUnit.
  ///
  /// In id, this message translates to:
  /// **'C-hari'**
  String get gddCDaysUnit;

  /// No description provided for @etcLitrePerSqmUnit.
  ///
  /// In id, this message translates to:
  /// **'L/m²'**
  String get etcLitrePerSqmUnit;

  /// No description provided for @commonFair.
  ///
  /// In id, this message translates to:
  /// **'Cukup'**
  String get commonFair;

  /// No description provided for @commonPoor.
  ///
  /// In id, this message translates to:
  /// **'Kurang'**
  String get commonPoor;

  /// No description provided for @dashboardWelcomeUser.
  ///
  /// In id, this message translates to:
  /// **'Halo, {userName}'**
  String dashboardWelcomeUser(String userName);

  /// No description provided for @dashboardSelectSitePrompt.
  ///
  /// In id, this message translates to:
  /// **'Pilih site untuk memuat data monitoring dan rekomendasi'**
  String get dashboardSelectSitePrompt;

  /// No description provided for @dashboardNoSensorReadings.
  ///
  /// In id, this message translates to:
  /// **'Belum ada bacaan sensor'**
  String get dashboardNoSensorReadings;

  /// No description provided for @dashboardActiveSensorsCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Parameter Dipantau'**
  String dashboardActiveSensorsCount(num count);

  /// No description provided for @dashboardRecentActivities.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas Terbaru'**
  String get dashboardRecentActivities;

  /// No description provided for @dashboardNoActivities.
  ///
  /// In id, this message translates to:
  /// **'Belum ada aktivitas'**
  String get dashboardNoActivities;

  /// No description provided for @dashboardTaskSummaryTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Task'**
  String get dashboardTaskSummaryTitle;

  /// No description provided for @dashboardCompletionRateLabel.
  ///
  /// In id, this message translates to:
  /// **'Tingkat Penyelesaian'**
  String get dashboardCompletionRateLabel;

  /// No description provided for @dashboardShowOtherSensors.
  ///
  /// In id, this message translates to:
  /// **'Lihat {count} parameter lainnya'**
  String dashboardShowOtherSensors(num count);

  /// No description provided for @dashboardAverageLabel.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata'**
  String get dashboardAverageLabel;

  /// No description provided for @commonViewAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat Semua'**
  String get commonViewAll;

  /// No description provided for @commonHide.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan'**
  String get commonHide;

  /// No description provided for @timeJustNow.
  ///
  /// In id, this message translates to:
  /// **'Baru saja'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In id, this message translates to:
  /// **'{count} menit yang lalu'**
  String timeMinutesAgo(num count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In id, this message translates to:
  /// **'{count} jam yang lalu'**
  String timeHoursAgo(num count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In id, this message translates to:
  /// **'{count} hari yang lalu'**
  String timeDaysAgo(num count);

  /// No description provided for @recommendationReasonLabel.
  ///
  /// In id, this message translates to:
  /// **'Alasan'**
  String get recommendationReasonLabel;

  /// No description provided for @profilePermissionsCount.
  ///
  /// In id, this message translates to:
  /// **'{count} izin'**
  String profilePermissionsCount(int count);

  /// No description provided for @errorNetwork.
  ///
  /// In id, this message translates to:
  /// **'Koneksi tidak stabil. Periksa internet Anda lalu coba lagi.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In id, this message translates to:
  /// **'Server belum bisa memuat data saat ini. Silakan coba lagi.'**
  String get errorServer;

  /// No description provided for @errorSessionExpired.
  ///
  /// In id, this message translates to:
  /// **'Sesi Anda berakhir. Silakan login kembali.'**
  String get errorSessionExpired;

  /// No description provided for @errorDataNotFound.
  ///
  /// In id, this message translates to:
  /// **'Data tidak ditemukan untuk site ini.'**
  String get errorDataNotFound;

  /// No description provided for @errorLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kendala saat memuat data. Silakan coba lagi.'**
  String get errorLoadFailed;
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
