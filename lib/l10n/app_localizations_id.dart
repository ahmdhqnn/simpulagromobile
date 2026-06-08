// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'SimpulAgro';

  @override
  String get greetingMorning => 'Selamat Pagi,';

  @override
  String get greetingAfternoon => 'Selamat Siang,';

  @override
  String get greetingEvening => 'Selamat Sore,';

  @override
  String get greetingNight => 'Selamat Malam,';

  @override
  String get weatherLoading => 'Memuat cuaca...';

  @override
  String get weatherError => 'Gagal';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get recentActivityTitle => 'Aktivitas Terkini';

  @override
  String get recentActivityEmpty => 'Tidak ada aktivitas hari ini.';

  @override
  String get sensorSectionTitle => 'Status Sensor';

  @override
  String activeSensors(int count) {
    return '$count Aktif';
  }

  @override
  String get plantSectionTitle => 'Tanaman';

  @override
  String activePlants(int count) {
    return '$count Fase Aktif';
  }

  @override
  String get viewAll => 'Lihat Semua';

  @override
  String get errorLoadData => 'Gagal memuat data';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsAccountSection => 'Akun';

  @override
  String get settingsAboutSection => 'Tentang';

  @override
  String get settingsChangePassword => 'Ganti Password';

  @override
  String get settingsChangePasswordSubtitle => 'Perbarui password akun Anda';

  @override
  String get changePasswordTitle => 'Ganti Password';

  @override
  String get changePasswordCurrentLabel => 'Password Lama';

  @override
  String get changePasswordCurrentHint => 'Masukkan password lama';

  @override
  String get changePasswordCurrentRequired => 'Password lama wajib diisi';

  @override
  String get changePasswordNewLabel => 'Password Baru';

  @override
  String get changePasswordNewHint => 'Masukkan password baru';

  @override
  String get changePasswordNewRequired => 'Password baru wajib diisi';

  @override
  String get changePasswordConfirmLabel => 'Konfirmasi Password Baru';

  @override
  String get changePasswordConfirmHint => 'Ulangi password baru';

  @override
  String get changePasswordConfirmRequired => 'Konfirmasi password wajib diisi';

  @override
  String get changePasswordConfirmMismatch => 'Konfirmasi password tidak sama';

  @override
  String get changePasswordSubmit => 'Simpan Password Baru';

  @override
  String get changePasswordSuccess => 'Password berhasil diubah';

  @override
  String get changePasswordFailed =>
      'Gagal mengubah password. Silakan coba lagi.';

  @override
  String get changePasswordErrorConfirmMismatch =>
      'Konfirmasi password tidak cocok.';

  @override
  String get changePasswordErrorUnauthorized =>
      'Password lama salah atau sesi sudah berakhir.';

  @override
  String get changePasswordErrorUserNotFound => 'Pengguna tidak ditemukan.';

  @override
  String get siteInviteTitle => 'Undang Member Site';

  @override
  String siteInviteSiteIdLabel(String siteId) {
    return 'Site ID: $siteId';
  }

  @override
  String get siteInviteUserIdLabel => 'User ID';

  @override
  String get siteInviteUserIdHint => 'Contoh: USR_001';

  @override
  String get siteInviteUserIdRequired => 'User ID wajib diisi';

  @override
  String get siteInviteSubmit => 'Kirim Undangan';

  @override
  String get siteInviteSuccess => 'Undangan member berhasil dikirim';

  @override
  String get siteInviteErrorBadRequest => 'Data undangan tidak valid.';

  @override
  String get siteInviteErrorForbidden =>
      'Hanya admin/site leader yang dapat mengundang member.';

  @override
  String get siteInviteErrorConflict => 'User sudah menjadi member site ini.';

  @override
  String get siteInviteErrorNoSiteSelected => 'Site belum dipilih.';

  @override
  String get siteInviteErrorUnknown => 'Gagal mengirim undangan member.';

  @override
  String get healthSectionTitle => 'Kesehatan Lingkungan';

  @override
  String get summarySectionTitle => 'Ringkasan';

  @override
  String get deviceTitle => 'Device';

  @override
  String get sensorTitle => 'Sensor';

  @override
  String get plantTitle => 'Tanaman';

  @override
  String get errorLoadSite => 'Gagal memuat site';

  @override
  String get errorLoadHealth => 'Gagal memuat data kesehatan';

  @override
  String get emptySite => 'Pilih site terlebih dahulu';

  @override
  String get emptySensor => 'Belum ada data sensor';

  @override
  String get taskTitle => 'Task';

  @override
  String get taskSummarySectionTitle => 'Ringkasan Task';

  @override
  String get quickActionSectionTitle => 'Aksi Cepat';

  @override
  String get plantOverviewTitle => 'Ringkasan Tanaman';

  @override
  String get plantEmptyTitle => 'Belum ada penanaman';

  @override
  String get plantEmptyMessage =>
      'Mulai tambahkan tanaman pertama untuk memantau lokasi ini.';

  @override
  String get plantAddFirst => 'Tambah penanaman pertama';

  @override
  String get plantAddTitle => 'Tambah Penanaman Pertama';

  @override
  String get plantEditTitle => 'Edit Penanaman';

  @override
  String get plantNameLabel => 'Nama Tanaman';

  @override
  String get plantNameHint => 'Contoh: Padi Cigentur';

  @override
  String get plantNameRequired => 'Nama tanaman wajib diisi';

  @override
  String get plantVarietasIdLabel => 'ID Varietas';

  @override
  String get plantVarietasIdHint => 'Contoh: VARIETAS001';

  @override
  String get plantVarietasIdRequired => 'ID varietas wajib diisi';

  @override
  String get plantVarietasUseManual => 'Input manual';

  @override
  String get plantVarietasUseList => 'Pilih dari daftar';

  @override
  String get plantVarietasEmptyFallback =>
      'Daftar varietas kosong. Silakan isi ID varietas manual.';

  @override
  String get plantVarietasLoadFailedFallback =>
      'Gagal memuat varietas. Gunakan input ID manual.';

  @override
  String get plantTypeLabel => 'Jenis Tanaman';

  @override
  String get plantTypeHint => 'Contoh: PADI, JAGUNG, dll.';

  @override
  String get plantTypeRequired => 'Pilih jenis tanaman terlebih dahulu';

  @override
  String get plantDateLabel => 'Tanggal Tanam';

  @override
  String plantActiveConflict(String name) {
    return 'Lokasi ini masih memiliki tanaman aktif \"$name\". Panen terlebih dahulu sebelum menambah yang baru.';
  }

  @override
  String get plantCreateSuccess => 'Tanaman berhasil ditambahkan';

  @override
  String get plantUpdateSuccess => 'Tanaman berhasil diperbarui';

  @override
  String get plantCreateFailed =>
      'Gagal menambahkan tanaman. Silakan coba lagi.';

  @override
  String get plantUpdateFailed =>
      'Gagal memperbarui tanaman. Silakan coba lagi.';

  @override
  String get plantListEmpty => 'Belum ada tanaman';

  @override
  String get plantListEmptyHint => 'Tambahkan tanaman pertama Anda';

  @override
  String get plantLoadFailed => 'Gagal memuat data';

  @override
  String get plantHarvestDialogTitle => 'Panen tanaman?';

  @override
  String plantHarvestDialogMessage(String name) {
    return '\"$name\" akan ditandai sudah dipanen. Aksi ini tidak dapat dibatalkan.';
  }

  @override
  String get plantHarvestConfirm => 'Ya, panen';

  @override
  String plantHarvestSuccess(String name) {
    return '\"$name\" berhasil ditandai sudah panen';
  }

  @override
  String get plantHarvestFailed => 'Gagal memanen tanaman';

  @override
  String plantDeleteDialogMessage(String name) {
    return '\"$name\" akan dihapus permanen. Aksi ini tidak dapat dibatalkan.';
  }

  @override
  String plantDeleteSuccess(String name) {
    return '\"$name\" berhasil dihapus';
  }

  @override
  String get plantDeleteFailed => 'Gagal menghapus tanaman';

  @override
  String get plantInvalidSite => 'Site tidak valid';

  @override
  String get plantActionEdit => 'Edit tanaman';

  @override
  String get plantActionHarvest => 'Panen tanaman';

  @override
  String get plantActionDelete => 'Hapus tanaman';

  @override
  String get plantGrowthTitle => 'Pertumbuhan';

  @override
  String get plantInfoTitle => 'Informasi Tanaman';

  @override
  String get plantHstLabel => 'HST';

  @override
  String get plantHstSubtitle => 'Hari Setelah Tanam';

  @override
  String get plantPhaseLabel => 'Fase';

  @override
  String get plantPhaseSubtitle => 'Fase Pertumbuhan';

  @override
  String get plantSpeciesLabel => 'Spesies';

  @override
  String get plantPlantDateLabel => 'Tanggal Tanam';

  @override
  String get plantHarvestDateLabel => 'Tanggal Panen';

  @override
  String get plantTargetHarvestLabel => 'Target Panen';

  @override
  String get plantViewPhases => 'Lihat Fase Pertumbuhan';

  @override
  String get plantGddTracking => 'Pelacakan GDD';

  @override
  String get plantMarkHarvested => 'Tandai Sudah Panen';

  @override
  String get phaseGrowthTitle => 'Fase Pertumbuhan';

  @override
  String get phaseOverallProgressTitle => 'Progress Keseluruhan';

  @override
  String get phaseOverallProgressSubtitle => 'Progress fase keseluruhan';

  @override
  String get phaseStatusCompleted => 'Selesai';

  @override
  String get phaseStatusActive => 'Aktif';

  @override
  String get phaseStatusUpcoming => 'Mendatang';

  @override
  String get phaseEmptyTitle => 'Belum ada data fase';

  @override
  String get phaseEmptyMessage =>
      'Data fase pertumbuhan akan muncul setelah tanaman aktif terdaftar di site ini.';

  @override
  String get phaseReload => 'Muat Ulang';

  @override
  String get phaseHstLabel => 'HST';

  @override
  String get phaseDurationLabel => 'Durasi';

  @override
  String phaseDaysValue(String count) {
    return '$count hari';
  }

  @override
  String phaseProgressDone(String percent) {
    return '$percent% selesai';
  }

  @override
  String get phaseDetailProgressTitle => 'Progress Fase';

  @override
  String get phaseDetailProgressSubtitle => 'Pelacakan progress fase';

  @override
  String get phaseCurrentHstLabel => 'HST Saat Ini';

  @override
  String get phaseRemainingDaysLabel => 'Sisa Hari';

  @override
  String get phaseTargetHstLabel => 'Target HST';

  @override
  String get phaseHstRangeTitle => 'Rentang HST';

  @override
  String get phaseHstRangeSubtitle => 'Hari Setelah Tanam';

  @override
  String get phaseTimelineStartLabel => 'Mulai';

  @override
  String get phaseTimelineEndLabel => 'Selesai';

  @override
  String get phaseTimelineStartSubtitle => 'Awal fase';

  @override
  String get phaseTimelineCompleted => 'Sudah selesai';

  @override
  String get phaseTimelineNotStarted => 'Belum dimulai';

  @override
  String phaseDaysRemaining(String count) {
    return '~$count hari lagi';
  }

  @override
  String get plantDetailHarvestTitle => 'Konfirmasi Panen';

  @override
  String plantDetailHarvestMessage(String name) {
    return 'Tandai \"$name\" sudah dipanen?';
  }

  @override
  String get plantDetailHarvestConfirm => 'Ya, Sudah Panen';

  @override
  String get plantDetailCancel => 'Batal';

  @override
  String get plantErrorTitle => 'Terjadi kesalahan';

  @override
  String get plantDetailTitle => 'Detail Tanaman';

  @override
  String get plantHstUnit => 'Hari';

  @override
  String get plantStatusLabel => 'Status';

  @override
  String get monitoringTitle => 'Monitoring';

  @override
  String get monitoringTabRealtime => 'Realtime';

  @override
  String get monitoringTabRawReads => 'Raw Reads';

  @override
  String get monitoringTabDailyRecap => 'Rekap Harian';

  @override
  String get monitoringTabMonthlyRecap => 'Rekap Bulan';

  @override
  String get monitoringTabMaps => 'Maps';

  @override
  String get monitoringTabAnalytics => 'Analytics';

  @override
  String get monitoringTabAdmin => 'Admin';

  @override
  String get monitoringSyncWaiting => 'Menunggu sinkronisasi';

  @override
  String monitoringSyncAt(String time) {
    return 'Sinkron $time';
  }

  @override
  String get monitoringSyncStale => 'data perlu disegarkan';

  @override
  String monitoringAutoRefreshEvery(int seconds) {
    return 'Auto-refresh $seconds detik';
  }

  @override
  String get monitoringAutoRefreshOff => 'Auto-refresh nonaktif';

  @override
  String get monitoringNoActivePlantTitle => 'Belum ada tanaman aktif';

  @override
  String get monitoringNoActivePlantMessage =>
      'Data sensor tetap diperbarui. Tambahkan tanaman agar rekomendasi monitoring terhubung ke siklus tanam.';

  @override
  String get monitoringAddPlant => 'Tambah Tanaman';

  @override
  String get monitoringViewPlantList => 'Lihat daftar tanaman';

  @override
  String get monitoringLatestStatusTitle => 'Status Sensor Terkini';

  @override
  String get monitoringTodayChartSection => 'Grafik Hari Ini';

  @override
  String get monitoringSensorDetailSection => 'Detail Status Sensor';

  @override
  String get monitoringEmptySensor => 'Belum ada data sensor';

  @override
  String get monitoringEmptyTodayChart => 'Belum ada data grafik hari ini';

  @override
  String get monitoringHistoryChartSection => 'Grafik History';

  @override
  String get monitoringEmptyHistory => 'Belum ada data riwayat';

  @override
  String get monitoringSelectSensor => 'Pilih parameter sensor';

  @override
  String get monitoringHistoryDataSection => 'Data Riwayat';

  @override
  String get monitoringChartNoSensorData => 'Belum ada data untuk sensor ini';

  @override
  String get monitoringChartDailyAggregation => 'Agregasi Harian';

  @override
  String get monitoringChartNoDailyAggregation =>
      'Belum ada data agregasi harian';

  @override
  String get monitoringChartLast7DaysAggregation => 'Agregasi 7 Hari Terakhir';

  @override
  String get monitoringMonthlyRecapSection => 'Rekap Bulanan';

  @override
  String get monitoringDailyTodaySection => 'Rekap Hari Ini';

  @override
  String get monitoringDailyByDateSection => 'Rekap Per Tanggal';

  @override
  String get monitoringDailyNoRecap => 'Tidak ada data rekap';

  @override
  String get monitoringSelectSiteFirst => 'Pilih site terlebih dahulu';

  @override
  String get monitoringFilterToday => 'Hari Ini';

  @override
  String get monitoringFilterSingleDate => 'Per Tanggal';

  @override
  String get monitoringFilterSevenDay => '7 Hari';

  @override
  String get monitoringFilterDateRange => 'Rentang Tanggal';

  @override
  String get monitoringFilterPlantingDate => 'Masa Tanam';

  @override
  String get commonDateLabel => 'Tanggal';

  @override
  String get commonFromLabel => 'Dari';

  @override
  String get commonToLabel => 'Sampai';

  @override
  String get monitoringTodayCardTitle => 'Data Sensor Hari Ini';

  @override
  String get monitoringTodayCardSubtitle => 'Pemantauan harian sensor realtime';

  @override
  String get monitoringChartNoDataForSensor =>
      'Belum ada data untuk sensor ini';

  @override
  String get commonMin => 'Min';

  @override
  String get commonMax => 'Max';

  @override
  String get commonAverage => 'Rata-rata';

  @override
  String monitoringHistoryCardSubtitle(int count) {
    return '$count data - riwayat sensor';
  }

  @override
  String get monitoringInvalidSensorData => 'Data sensor tidak valid';

  @override
  String get monitoringDailyAnalyticsTitle => 'Analisis Sensor Harian';

  @override
  String get monitoringDailyAnalyticsSubtitle => 'Statistik Sensor Hari Ini';

  @override
  String get monitoringDailyEmpty => 'Belum ada data harian';

  @override
  String get monitoringDailyUnavailableToday =>
      'Tidak ada data sensor yang tersedia untuk hari ini';

  @override
  String get monitoringMonthlyCardEmpty => 'Belum ada data rekap bulanan';

  @override
  String get monitoringMonthlyCardNoSensorData =>
      'Tidak ada data untuk sensor ini';

  @override
  String get monitoringMonthlyCardTitle => 'Rekap Bulanan';

  @override
  String get monitoringMonthlyCardSubtitle => 'Rata-rata per bulan';

  @override
  String monitoringMonthlyLegendAverage(String sensor) {
    return 'Rata-rata $sensor';
  }
}
