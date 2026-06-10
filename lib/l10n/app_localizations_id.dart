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
  String get monitoringTabMaps => 'Peta';

  @override
  String get monitoringTabAnalytics => 'Analisis';

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
  String get monitoringHistoryChartSection => 'Riwayat Grafik';

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

  @override
  String get commonYes => 'Ya';

  @override
  String get commonNo => 'Tidak';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonSave => 'Simpan';

  @override
  String get commonDelete => 'Hapus';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonBack => 'Kembali';

  @override
  String get commonRetry => 'Coba Lagi';

  @override
  String get commonRefresh => 'Muat Ulang';

  @override
  String get commonLoading => 'Memuat...';

  @override
  String get commonError => 'Terjadi kesalahan';

  @override
  String get commonLoadFailed => 'Gagal memuat data';

  @override
  String get commonNoData => 'Tidak ada data';

  @override
  String get commonNoDataYet => 'Belum ada data';

  @override
  String get commonActive => 'Aktif';

  @override
  String get commonInactive => 'Tidak Aktif';

  @override
  String get commonUnknown => 'Tidak diketahui';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonPriority => 'Prioritas';

  @override
  String get commonTotal => 'Total';

  @override
  String get commonPending => 'Menunggu';

  @override
  String get commonInProgress => 'Dikerjakan';

  @override
  String get commonCompleted => 'Selesai';

  @override
  String get commonFailed => 'Gagal';

  @override
  String get commonLow => 'Rendah';

  @override
  String get commonMedium => 'Sedang';

  @override
  String get commonHigh => 'Tinggi';

  @override
  String get commonCritical => 'Kritis';

  @override
  String get commonApplied => 'Diterapkan';

  @override
  String get commonDismissed => 'Diabaikan';

  @override
  String get commonExpired => 'Kedaluwarsa';

  @override
  String get commonAll => 'Semua';

  @override
  String get commonOther => 'Lainnya';

  @override
  String get commonGeneral => 'Umum';

  @override
  String get commonHighPriority => 'Prioritas Tinggi';

  @override
  String get commonActionRequired => 'Perlu Tindakan';

  @override
  String get commonInformation => 'Informasi';

  @override
  String get commonLocation => 'Lokasi';

  @override
  String get commonName => 'Nama';

  @override
  String get commonAddress => 'Alamat';

  @override
  String get commonCoordinates => 'Koordinat';

  @override
  String get commonAltitude => 'Ketinggian';

  @override
  String get commonCreatedAt => 'Dibuat';

  @override
  String get commonUpdatedAt => 'Terakhir Diperbarui';

  @override
  String get commonCompletedAt => 'Selesai Pada';

  @override
  String get commonDescription => 'Deskripsi';

  @override
  String get commonDate => 'Tanggal';

  @override
  String get commonUnit => 'Satuan';

  @override
  String get commonSearch => 'Cari';

  @override
  String get commonActions => 'Aksi';

  @override
  String get commonClose => 'Tutup';

  @override
  String get commonPreview => 'Preview';

  @override
  String get commonNone => 'Tidak ada';

  @override
  String get commonInvalid => 'Tidak valid';

  @override
  String get commonRequired => 'Wajib diisi';

  @override
  String get siteTitle => 'Site';

  @override
  String get siteSelectFirst => 'Pilih site terlebih dahulu';

  @override
  String get siteSelect => 'Pilih Site';

  @override
  String get taskTypePlanting => 'Penanaman';

  @override
  String get taskTypeFertilizing => 'Pemupukan';

  @override
  String get taskTypeHarvesting => 'Panen';

  @override
  String get taskTypeWatering => 'Penyiraman';

  @override
  String get taskTypePestControl => 'Pengendalian Hama';

  @override
  String get taskTypeMonitoring => 'Monitoring';

  @override
  String get taskTypeMaintenance => 'Perawatan';

  @override
  String get cropRice => 'Padi';

  @override
  String get cropCorn => 'Jagung';

  @override
  String get cropSoybean => 'Kedelai';

  @override
  String get recommendationTypeNpk => 'Pemupukan NPK';

  @override
  String get recommendationTypePh => 'Penyesuaian pH';

  @override
  String get recommendationAllStatuses => 'Semua Status';

  @override
  String get taskAddTitle => 'Tambah Task';

  @override
  String get taskEditTitle => 'Edit Task';

  @override
  String get taskNameLabel => 'Nama Task';

  @override
  String get taskNameHint => 'Masukkan nama task';

  @override
  String get taskNameRequired => 'Nama task harus diisi';

  @override
  String get taskDescriptionHint => 'Tambahkan deskripsi task';

  @override
  String get taskTypeLabel => 'Jenis Task';

  @override
  String get taskEmptyAll => 'Belum ada task';

  @override
  String get taskEmptyPending => 'Tidak ada task yang menunggu';

  @override
  String get taskEmptyProgress => 'Tidak ada task yang sedang dikerjakan';

  @override
  String get taskEmptyCompleted => 'Belum ada task yang selesai';

  @override
  String get taskEmptyFailed => 'Tidak ada task yang gagal';

  @override
  String get taskSiteRequiredForEditTitle => 'Site belum dipilih';

  @override
  String get taskSiteRequiredForEditMessage =>
      'Pilih site terlebih dahulu sebelum mengedit task.';

  @override
  String get taskLoadFailed => 'Gagal memuat task';

  @override
  String get taskNoSite => 'Belum ada site';

  @override
  String get taskSiteIdMissing => 'Site ID tidak ditemukan';

  @override
  String get taskUpdateSuccess => 'Task berhasil diupdate';

  @override
  String get taskCreateSuccess => 'Task berhasil ditambahkan';

  @override
  String get taskDeleteTitle => 'Hapus Task';

  @override
  String get taskDeleteSuccess => 'Task berhasil dihapus';

  @override
  String get taskMarkComplete => 'Tandai Selesai';

  @override
  String get taskStartWork => 'Mulai Kerjakan';

  @override
  String get taskInfoTitle => 'Informasi Task';

  @override
  String get taskTimeDetailsTitle => 'Detail Waktu';

  @override
  String get taskTimelineTitle => 'Timeline';

  @override
  String get taskCreatedTimeline => 'Task Dibuat';

  @override
  String get taskProgressTimeline => 'Task Sedang Dikerjakan';

  @override
  String get taskFailedTimeline => 'Task Gagal';

  @override
  String get taskCompletedTimeline => 'Task Selesai';

  @override
  String taskDeleteMessage(String name) {
    return 'Apakah Anda yakin ingin menghapus task \"$name\"?';
  }

  @override
  String taskDeleteFailure(String message) {
    return 'Gagal menghapus task: $message';
  }

  @override
  String taskUpdateStatusFailure(String message) {
    return 'Gagal memperbarui status: $message';
  }

  @override
  String taskStatusUpdated(String status) {
    return 'Status diperbarui ke \"$status\"';
  }

  @override
  String taskLoadSiteFailed(String message) {
    return 'Gagal memuat site: $message';
  }

  @override
  String taskUpdateFailure(String message) {
    return 'Gagal mengupdate task: $message';
  }

  @override
  String taskCreateFailure(String message) {
    return 'Gagal menambah task: $message';
  }

  @override
  String commonDeleteTitle(String itemName) {
    return 'Hapus $itemName?';
  }

  @override
  String get commonDeleteIrreversible =>
      'Data yang dihapus tidak dapat dikembalikan.';

  @override
  String get commonErrorTitle => 'Terjadi Kesalahan';

  @override
  String get sensorDetailTitle => 'Detail Sensor';

  @override
  String get sensorTypeLabel => 'Tipe Sensor';

  @override
  String get sensorLoadFailed => 'Gagal memuat sensor';

  @override
  String get recommendationConfidenceLabel => 'Tingkat Keyakinan';

  @override
  String get recommendationAppliedBy => 'Diterapkan oleh';

  @override
  String get monitoringCurrentGrowthPhase => 'Fase Pertumbuhan Saat Ini';

  @override
  String get recommendationConfidenceUnknown => 'Tidak diketahui';

  @override
  String get recommendationConfidenceVeryHigh => 'Sangat Tinggi';

  @override
  String get plantStatusHarvested => 'Sudah Panen';

  @override
  String get plantStatusGrowing => 'Sedang Tumbuh';

  @override
  String get dashboardTodayDailyRecap => 'Rekap Harian Hari Ini';

  @override
  String get dashboardLatestRecommendations => 'Rekomendasi Terbaru';

  @override
  String get dashboardLatestActivity => 'Aktivitas Terbaru';

  @override
  String get dashboardActivityLoadFailed => 'Gagal memuat aktivitas';

  @override
  String get dashboardLatestNotes => 'Catatan Terbaru';

  @override
  String get dashboardNoDailyRecapToday => 'Belum ada rekap harian hari ini';

  @override
  String get notesEmptyForSite => 'Belum ada catatan untuk site ini';

  @override
  String get forumTitle => 'Forum';

  @override
  String get authWelcome => 'Welcome to SimpulAgro';

  @override
  String get authSkip => 'Lewati';

  @override
  String get authNext => 'Lanjut';

  @override
  String get authGetStarted => 'Mulai';

  @override
  String get onboardingMonitorTitle => 'Pantau Lahan\nLebih Akurat';

  @override
  String get onboardingMonitorDesc =>
      'Pantau kondisi tanaman dan kesehatan tanah secara real-time langsung dari smartphone Anda, di mana saja dan kapan saja.';

  @override
  String get onboardingDataTitle => 'Keputusan Berbasis\nData';

  @override
  String get onboardingDataDesc =>
      'Dapatkan wawasan akurat mengenai kelembapan, suhu, dan nutrisi tanah untuk menentukan langkah perawatan yang paling tepat.';

  @override
  String get onboardingRiskTitle => 'Minimalkan Risiko\nGagal Panen';

  @override
  String get onboardingRiskDesc =>
      'Terima notifikasi dini jika terjadi anomali pada lahan sehingga Anda bisa bertindak lebih cepat sebelum masalah berkembang.';

  @override
  String get loginHeroTitle => 'Masa Depan\nBertani, Hari Ini.';

  @override
  String get loginSubtitle => 'Silakan masuk ke akun Anda';

  @override
  String get loginUsernameHint => 'Username Anda';

  @override
  String get loginPasswordHint => 'Password Anda';

  @override
  String get loginUsernameRequired => 'Username tidak boleh kosong';

  @override
  String get loginPasswordRequired => 'Password tidak boleh kosong';

  @override
  String get loginForgotPassword => 'Lupa Password?';

  @override
  String get loginSignIn => 'Masuk';

  @override
  String get loginFailedTitle => 'Gagal Login';

  @override
  String get loginFailedMessage => 'Username atau password salah';

  @override
  String get authSessionExpired =>
      'Sesi Anda telah berakhir. Silakan login kembali.';

  @override
  String get siteListTitle => 'Pilih Lokasi';

  @override
  String get siteDetailTitle => 'Detail Lokasi';

  @override
  String get siteAddTitle => 'Tambah Lokasi';

  @override
  String get siteEditTitle => 'Edit Lokasi';

  @override
  String get siteEmptyTitle => 'Belum ada lokasi';

  @override
  String get siteEmptyMessage => 'Tambahkan lokasi pertanian Anda';

  @override
  String get siteIdLabel => 'ID Lokasi';

  @override
  String get siteIdRequired => 'ID lokasi tidak boleh kosong';

  @override
  String get siteNameLabel => 'Nama Lokasi';

  @override
  String get siteNameRequired => 'Nama lokasi tidak boleh kosong';

  @override
  String get siteNameMinLength => 'Nama minimal 3 karakter';

  @override
  String get siteAddressHint => 'Contoh: Jl. Raya Pertanian No. 123';

  @override
  String get siteIdHint => 'Contoh: SITE001';

  @override
  String get siteNameHint => 'Contoh: Sawah Utara';

  @override
  String get siteAltitudeLabel => 'Ketinggian (meter)';

  @override
  String get siteAltitudeHint => 'Contoh: 150';

  @override
  String get siteGpsCoordinates => 'Koordinat GPS';

  @override
  String get siteStatusLabel => 'Status Lokasi';

  @override
  String get siteUpdateSuccess => 'Lokasi berhasil diperbarui';

  @override
  String get siteCreateSuccess => 'Lokasi berhasil ditambahkan';

  @override
  String siteLoadDataFailed(String message) {
    return 'Gagal memuat data: $message';
  }

  @override
  String get siteDataTitle => 'Data Site';

  @override
  String get siteOverviewTab => 'Overview';

  @override
  String get siteNotesTab => 'Catatan';

  @override
  String get siteLocationInfo => 'Informasi Lokasi';

  @override
  String get siteAdditionalInfo => 'Informasi Tambahan';

  @override
  String get siteInviteTooltip => 'Undang Member';

  @override
  String get commonSaveChanges => 'Simpan Perubahan';

  @override
  String get recommendationTitle => 'Rekomendasi';

  @override
  String get recommendationHubTitle => 'Pusat Rekomendasi';

  @override
  String get recommendationSearchHint =>
      'Cari judul, deskripsi, tanaman atau site';

  @override
  String get recommendationEmptyTitle => 'Tidak ada rekomendasi';

  @override
  String get recommendationEmptyAll =>
      'Belum ada rekomendasi tersedia.\nPastikan sensor sudah aktif dan mengirim data.';

  @override
  String get recommendationReload => 'Muat Ulang';

  @override
  String get recommendationLoadFailed => 'Gagal memuat rekomendasi';

  @override
  String get recommendationEmptyDataTitle => 'Data rekomendasi kosong';

  @override
  String get recommendationEmptyForSite =>
      'Belum ada rekomendasi yang tersedia untuk site ini.';

  @override
  String get recommendationFilterCategory => 'Filter Kategori';

  @override
  String get recommendationFilterStatus => 'Filter Status';

  @override
  String get recommendationPriorityStat => 'Prioritas';

  @override
  String get recommendationDismiss => 'Abaikan';

  @override
  String get recommendationApply => 'Terapkan';

  @override
  String recommendationEmptyFiltered(String filter) {
    return 'Tidak ada rekomendasi untuk filter \"$filter\".';
  }

  @override
  String recommendationEmptyScoped(String scope, String status) {
    return 'Tidak ada data untuk filter $scope dengan status $status.';
  }

  @override
  String recommendationAccuracy(String level) {
    return 'Akurasi: $level';
  }

  @override
  String get recommendationStepsTitle => 'Langkah-langkah';

  @override
  String get recommendationParametersTitle => 'Parameter';

  @override
  String get recommendationSelectPhaseFirst => 'Pilih fase terlebih dahulu';

  @override
  String get recommendationLabSaved => 'Rekomendasi tersimpan';

  @override
  String get recommendationLabTestTitle =>
      '[TEST] Rekomendasi dummy - admin only';

  @override
  String get recommendationPlantInputTitle =>
      'Input nilai sensor untuk rekomendasi tanaman';

  @override
  String get recommendationNpkStatusLabel => 'Status NPK';

  @override
  String get recommendationNpkDoseLabel => 'Dosis NPK';

  @override
  String get recommendationPhStatusLabel => 'Status pH';

  @override
  String get recommendationPhDoseLabel => 'Dosis pH';

  @override
  String get recommendationNoAdditionalDose => 'Tidak perlu tambahan';

  @override
  String get recommendationBackendDataUnavailable =>
      'Belum tersedia dari backend';

  @override
  String get recommendationLabAdminTestTitle =>
      '[TEST] Rekomendasi dummy - admin only';

  @override
  String recommendationSaveFailed(Object error) {
    return 'Gagal: $error';
  }

  @override
  String get recommendationAllTab => 'Semua Rekomendasi';

  @override
  String get recommendationHistoryTab => 'Riwayat';

  @override
  String get recommendationByPhaseTab => 'Per Fase';

  @override
  String get recommendationSelectPhase => 'Pilih Fase';

  @override
  String get recommendationNoData => 'Tidak ada data';

  @override
  String get recommendationSensorInputTitle =>
      'Input nilai sensor untuk rekomendasi tanaman';

  @override
  String get commonOk => 'OK';

  @override
  String get settingsNotificationsSection => 'Notifikasi';

  @override
  String get settingsEnableNotifications => 'Aktifkan Notifikasi';

  @override
  String get settingsNotificationsSubtitle =>
      'Terima notifikasi untuk alert dan update';

  @override
  String get settingsDataSyncSection => 'Data & Sinkronisasi';

  @override
  String get settingsAutoRefresh => 'Auto Refresh';

  @override
  String get settingsAutoRefreshSubtitle => 'Perbarui data secara otomatis';

  @override
  String get settingsRefreshInterval => 'Interval Refresh';

  @override
  String settingsRefreshIntervalSeconds(int seconds) {
    return '$seconds detik';
  }

  @override
  String get settingsAppearanceSection => 'Tampilan';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsTemperatureUnit => 'Satuan Suhu';

  @override
  String get settingsAppVersion => 'Versi Aplikasi';

  @override
  String get settingsHelpSupport => 'Bantuan & Dukungan';

  @override
  String get settingsHelpSupportSubtitle => 'Kontak bantuan teknis';

  @override
  String get settingsHelpSupportMessage =>
      'Untuk bantuan teknis, hubungi tim support melalui email atau WhatsApp yang tertera di aplikasi.';

  @override
  String get settingsPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get settingsPrivacyPolicySubtitle => 'Keamanan dan penggunaan data';

  @override
  String get settingsPrivacyPolicyMessage =>
      'Data Anda disimpan secara aman dan tidak dibagikan kepada pihak ketiga tanpa persetujuan Anda.';

  @override
  String get settingsSelectLanguage => 'Pilih Bahasa';

  @override
  String get settingsSelectTheme => 'Pilih Tema';

  @override
  String get settingsThemeLight => 'Terang';

  @override
  String get settingsThemeDark => 'Gelap';

  @override
  String get settingsThemeSystem => 'Ikuti Sistem';

  @override
  String get settingsLanguageIndonesian => 'Indonesia';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsTemperatureCelsius => 'Celsius (C)';

  @override
  String get settingsTemperatureFahrenheit => 'Fahrenheit (F)';

  @override
  String get profileEditTitle => 'Edit Profil';

  @override
  String get profilePhotoUploadComingSoon =>
      'Fitur upload foto akan segera hadir';

  @override
  String get profileFullNameLabel => 'Nama Lengkap';

  @override
  String get profileNameRequired => 'Nama tidak boleh kosong';

  @override
  String get profileNameMinLength => 'Nama minimal 3 karakter';

  @override
  String get profileEmailRequired => 'Email tidak boleh kosong';

  @override
  String get profileEmailInvalid => 'Email tidak valid';

  @override
  String get profilePhoneNumberLabel => 'Nomor Telepon';

  @override
  String get profilePhoneRequired => 'Nomor telepon tidak boleh kosong';

  @override
  String get profilePhoneInvalid => 'Nomor telepon tidak valid';

  @override
  String get profileUpdateSuccess => 'Profil berhasil diperbarui';

  @override
  String get profileAccountInfoTitle => 'Informasi Akun';

  @override
  String get profilePhoneLabel => 'Telepon';

  @override
  String get profileAdminSubtitle => 'Kelola data dan akses sistem';

  @override
  String get profileForumManagement => 'Manajemen Forum';

  @override
  String get profileForumManagementSubtitle => 'Kelola postingan dan komentar';

  @override
  String get profileMyPosts => 'Postingan Saya';

  @override
  String get profileMyPostsSubtitle => 'Lihat dan kelola postingan';

  @override
  String get profileLikedPosts => 'Postingan Disukai';

  @override
  String get profileLikedPostsSubtitle => 'Postingan yang Anda sukai';

  @override
  String get profileMyComments => 'Komentar Saya';

  @override
  String get profileMyCommentsSubtitle => 'Lihat semua komentar';

  @override
  String get profilePermissionsSection => 'Hak Akses';

  @override
  String get profileSignout => 'Signout';

  @override
  String get profileLogoutTitle => 'Konfirmasi Keluar';

  @override
  String get profileLogoutMessage =>
      'Apakah Anda yakin ingin keluar dari aplikasi?';

  @override
  String get profileLogoutConfirm => 'Keluar';

  @override
  String get commonLatitude => 'Latitude';

  @override
  String get commonLongitude => 'Longitude';

  @override
  String get commonPort => 'Port';

  @override
  String get commonIpAddress => 'IP Address';

  @override
  String get commonSaved => 'Tersimpan';

  @override
  String get siteNoSitesAvailable => 'Tidak ada site tersedia';

  @override
  String get notesNew => 'Catatan Baru';

  @override
  String get notesContentHint => 'Isi catatan...';

  @override
  String get notesSaved => 'Catatan tersimpan';

  @override
  String get notesSaveFailed => 'Gagal menyimpan catatan';

  @override
  String get sensorAddTitle => 'Tambah Sensor';

  @override
  String get sensorEmptyTitle => 'Belum ada sensor';

  @override
  String get sensorEmptyMessage =>
      'Tambahkan sensor untuk mulai memantau kondisi lahan.';

  @override
  String sensorUnitValue(String unit) {
    return 'Satuan: $unit';
  }

  @override
  String get deviceIoTTitle => 'Perangkat IoT';

  @override
  String get deviceAddTitle => 'Tambah Perangkat';

  @override
  String get deviceEditTitle => 'Edit Perangkat';

  @override
  String get deviceDetailTitle => 'Detail Perangkat';

  @override
  String get deviceEmptyMessage => 'Tidak ada perangkat ditemukan';

  @override
  String get deviceIdLabel => 'ID Perangkat';

  @override
  String get deviceIdRequired => 'ID Perangkat wajib diisi';

  @override
  String get deviceNameLabel => 'Nama Perangkat';

  @override
  String get deviceNameRequired => 'Nama Perangkat wajib diisi';

  @override
  String get deviceNumberIdLabel => 'Nomor ID';

  @override
  String get deviceInformationTitle => 'Informasi Perangkat';

  @override
  String get deviceStatusActive => 'Status Aktif';

  @override
  String get deviceCreateSuccess => 'Perangkat berhasil ditambahkan';

  @override
  String get deviceUpdateSuccess => 'Perangkat berhasil diperbarui';

  @override
  String get monitoringMapsNoDeviceLocations =>
      'Belum ada lokasi device untuk ditampilkan';

  @override
  String get monitoringDeviceSensorList => 'Daftar Device & Sensor';

  @override
  String get monitoringNoDevicesAvailable => 'Belum ada device tersedia';

  @override
  String get monitoringAnalyticsOverview => 'Ringkasan Analitik';

  @override
  String get monitoringPlantStatisticsSection => 'Statistik Tanaman';

  @override
  String get monitoringPlantRecommendationSection => 'Rekomendasi Tanaman';

  @override
  String get monitoringDeviceSensorOverviewSection =>
      'Perangkat & Ringkasan Sensor';

  @override
  String get monitoringMonthlySensorRecap => 'Rekap Bulanan Sensor';

  @override
  String get monitoringRawParameterUnavailable =>
      'Parameter sensor tidak tersedia pada data raw';

  @override
  String get monitoringAdminOnlyMessage =>
      'Tab admin hanya untuk pengguna dengan role admin.';

  @override
  String get monitoringReadCorrectionTitle => 'Koreksi Sensor Read';

  @override
  String get monitoringReadCorrectionDescription =>
      'Perbarui nilai atau status read pada site aktif';

  @override
  String get monitoringSaving => 'Menyimpan...';

  @override
  String get monitoringSaveCorrection => 'Simpan Koreksi';

  @override
  String get monitoringGenerateDailyRecapTitle => 'Generate Rekap Harian';

  @override
  String get monitoringGenerateDailyRecapDescription =>
      'Proses ulang agregasi sensor untuk tanggal dipilih';

  @override
  String get monitoringProcessing => 'Memproses...';

  @override
  String get monitoringGenerateRecap => 'Generate Rekap';

  @override
  String get monitoringReadIdLabel => 'ID Bacaan';

  @override
  String get monitoringReadValueLabel => 'Nilai Bacaan (opsional)';

  @override
  String get monitoringReadStsLabel => 'Status Bacaan (opsional)';

  @override
  String get monitoringReadIdRequired => 'read_id wajib diisi';

  @override
  String get monitoringReadValueMustBeNumber => 'read_value harus berupa angka';

  @override
  String get monitoringReadValueOrStatusRequired =>
      'Isi read_value atau read_sts';

  @override
  String get monitoringReadUpdated => 'Read diperbarui';

  @override
  String get monitoringReadUpdateFailed => 'Gagal memperbarui read';

  @override
  String monitoringDailyRecapTriggered(String day) {
    return 'Rekap diproses untuk $day';
  }

  @override
  String get monitoringDailyRecapTriggerFailed => 'Gagal trigger rekap';

  @override
  String get monitoringRefreshActiveTab => 'Refresh tab aktif';

  @override
  String get monitoringNoDeviceStats => 'Belum ada statistik device';

  @override
  String get monitoringTotalDevice => 'Total device';

  @override
  String get monitoringTotalSensor => 'Total sensor';

  @override
  String get monitoringShowLess => 'Tampilkan Lebih Sedikit';

  @override
  String monitoringShowAllCount(int count) {
    return 'Tampilkan Semua ($count)';
  }

  @override
  String get monitoringPlantRecommendationEmpty =>
      'Belum ada rekomendasi untuk site ini';

  @override
  String monitoringRecommendationActionCount(int count) {
    return '$count aksi';
  }

  @override
  String monitoringRecommendationMoreCount(int count) {
    return '+$count rekomendasi lainnya';
  }

  @override
  String get monitoringRecommendationSiteTitle => 'Rekomendasi Site';

  @override
  String get monitoringRecommendationCachedSubtitle =>
      'Berdasarkan data sensor tersimpan';

  @override
  String get monitoringRecommendationActiveSiteSubtitle =>
      'Berdasarkan sensor site aktif';

  @override
  String get monitoringNpkAdjustment => 'Penyesuaian NPK';

  @override
  String get monitoringSoilPhAdjustment => 'Penyesuaian pH Tanah';

  @override
  String get monitoringSoilPhLabel => 'pH Tanah';

  @override
  String get monitoringNoActiveAlarmTitle => 'Tidak ada alarm aktif';

  @override
  String get monitoringNoActiveAlarmDescription =>
      'Semua sensor berjalan normal';

  @override
  String get monitoringAlarmSummaryTitle => 'Ringkasan Alarm';

  @override
  String monitoringAlarmSummaryDescription(int total) {
    return '$total total alarm tercatat';
  }

  @override
  String get monitoringLatestAlarm => 'Alarm Terbaru';

  @override
  String get monitoringAlarmLast24Hours => 'Alarm 24 Jam';

  @override
  String get monitoringTotalAlarm => 'Total Alarm';

  @override
  String get monitoringAlarmDetected => 'Alarm terdeteksi';

  @override
  String get forumMyPosts => 'Postingan Saya';

  @override
  String get forumLikedPosts => 'Postingan Disukai';

  @override
  String get forumMyComments => 'Komentar Saya';

  @override
  String get forumLiked => 'Disukai';

  @override
  String get forumNoPostsTitle => 'Belum ada postingan';

  @override
  String get forumNoPostsMessage =>
      'Jadilah yang pertama membuat postingan di forum komunitas';

  @override
  String get forumCreatePost => 'Buat Postingan';

  @override
  String get forumLoadPostsFailed => 'Gagal memuat postingan';

  @override
  String get forumManagePosts => 'Kelola Postingan';

  @override
  String get forumEditPost => 'Edit Postingan';

  @override
  String get forumDeletePost => 'Hapus Postingan';

  @override
  String get forumDeletePostConfirm =>
      'Apakah Anda yakin ingin menghapus postingan ini?';

  @override
  String get forumDeletePostPermanent => 'Postingan ini akan dihapus permanen.';

  @override
  String get forumPostDeleted => 'Postingan berhasil dihapus';

  @override
  String get forumSharePostTitle => 'Bagikan Postingan';

  @override
  String get forumSharePostMessage =>
      'Bagikan postingan ini ke teman atau komunitas Anda.';

  @override
  String get forumPostShared => 'Postingan berhasil dibagikan';

  @override
  String get forumFirstPostMessage =>
      'Buat postingan pertama Anda untuk berbagi dengan komunitas.';

  @override
  String forumPostCount(int count) {
    return '$count postingan';
  }

  @override
  String get forumMyPostsSummary =>
      'Postingan yang Anda buat di forum komunitas.';

  @override
  String get forumLikedPostsEmptyTitle => 'Belum ada postingan disukai';

  @override
  String get forumLikedPostsEmptyMessage =>
      'Postingan yang Anda sukai akan tersimpan di sini.';

  @override
  String forumLikedPostCount(int count) {
    return '$count postingan disukai';
  }

  @override
  String get forumLikedPostsSummary =>
      'Daftar postingan yang pernah Anda sukai.';

  @override
  String get forumNoCommentsTitle => 'Belum ada komentar';

  @override
  String get forumNoCommentsMessage =>
      'Komentar Anda pada postingan akan muncul di sini.';

  @override
  String forumCommentCount(int count) {
    return '$count komentar';
  }

  @override
  String get forumMyCommentsSummary =>
      'Komentar yang Anda tulis di postingan forum.';

  @override
  String get forumLoadCommentsFailed => 'Gagal memuat komentar';

  @override
  String get forumNoTitle => 'Tanpa Judul';

  @override
  String get forumOpenPostHint => 'Ketuk untuk membuka postingan';

  @override
  String get forumCommentActions => 'Aksi komentar';

  @override
  String get forumEdited => 'Diedit';

  @override
  String get forumManageComments => 'Kelola Komentar';

  @override
  String get forumEditComment => 'Edit Komentar';

  @override
  String get forumDeleteComment => 'Hapus Komentar';

  @override
  String get forumWriteComment => 'Tulis komentar';

  @override
  String get forumCommentUpdated => 'Komentar diperbarui';

  @override
  String get forumDeleteCommentPermanent =>
      'Komentar ini akan dihapus permanen.';

  @override
  String get forumCommentDeleted => 'Komentar dihapus';

  @override
  String forumLikesCount(int count) {
    return '$count suka';
  }

  @override
  String forumCommentsCount(int count) {
    return '$count komentar';
  }

  @override
  String forumSharesCount(int count) {
    return '$count bagikan';
  }

  @override
  String get forumLike => 'Suka';

  @override
  String get forumComment => 'Komentar';

  @override
  String get forumShare => 'Bagikan';

  @override
  String get forumDislike => 'Dislike';

  @override
  String get forumNoReactions => 'Belum ada reaksi';

  @override
  String get forumAddPost => 'Tambah Postingan';

  @override
  String get forumSelectImage => 'Pilih Gambar';

  @override
  String get forumPickFromGallery => 'Pilih dari Galeri';

  @override
  String get forumTakePhoto => 'Ambil Foto';

  @override
  String get forumDeleteImage => 'Hapus Gambar';

  @override
  String forumPickImageFailed(String message) {
    return 'Gagal memilih gambar: $message';
  }

  @override
  String get forumSiteRequiredMain =>
      'Pilih site terlebih dahulu di halaman utama';

  @override
  String get forumSiteNotSelectedTitle => 'Site belum dipilih';

  @override
  String forumLoadDataFailed(String message) {
    return 'Gagal memuat data: $message';
  }

  @override
  String get forumPostTitleLabel => 'Judul';

  @override
  String get forumPostTitleHint => 'Masukkan judul postingan';

  @override
  String get forumPostTitleRequired => 'Judul tidak boleh kosong';

  @override
  String get forumPostTitleMinLength => 'Judul minimal 3 karakter';

  @override
  String get forumPostContentLabel => 'Isi Postingan';

  @override
  String get forumPostContentHint => 'Tulis informasi yang ingin Anda bagikan';

  @override
  String get forumPostContentRequired => 'Konten tidak boleh kosong';

  @override
  String get forumPostContentMinLength => 'Konten minimal 10 karakter';

  @override
  String get forumMediaLabel => 'Media';

  @override
  String get forumPostGuideline =>
      'Pastikan isi postingan tetap jelas, relevan, dan sesuai pedoman komunitas.';

  @override
  String get forumAddImage => 'Tambahkan gambar';

  @override
  String get forumImageOptionalHint =>
      'Opsional. Postingan tanpa gambar tetap dapat dipublikasikan.';

  @override
  String get forumChoose => 'Pilih';

  @override
  String get forumNewImageReady => 'Gambar baru siap diunggah';

  @override
  String get forumActivePostImage => 'Gambar postingan aktif';

  @override
  String get forumChange => 'Ganti';

  @override
  String get forumPostCreated => 'Postingan berhasil ditambahkan';

  @override
  String get forumPostUpdated => 'Postingan berhasil diperbarui';

  @override
  String get forumSelectActiveSiteBeforePosting =>
      'Pilih site aktif di dashboard sebelum membuat postingan forum.';

  @override
  String forumSendCommentFailed(String message) {
    return 'Gagal mengirim komentar: $message';
  }

  @override
  String get forumFirstCommentMessage => 'Jadilah yang pertama berkomentar';

  @override
  String get forumReactions => 'Reaksi';

  @override
  String get forumDeleteCommentConfirm =>
      'Apakah Anda yakin ingin menghapus komentar ini?';

  @override
  String get adminAccessDeniedTitle => 'Akses Ditolak';

  @override
  String get adminFeatureOnlyMessage =>
      'Fitur admin hanya dapat diakses oleh Admin.';

  @override
  String get adminNoPagePermissionMessage =>
      'Anda tidak memiliki izin untuk mengakses halaman ini.';

  @override
  String get adminUsersTitle => 'Users';

  @override
  String get adminRoleTitle => 'Role';

  @override
  String get adminUnitTitle => 'Unit';

  @override
  String get adminDeviceSensorTitle => 'Device Sensor';

  @override
  String get adminPermissionTitle => 'Permission';

  @override
  String get adminNoPermissionsAvailable => 'Tidak ada permission tersedia';

  @override
  String adminLoadPermissionsFailed(String message) {
    return 'Gagal memuat permissions: $message';
  }

  @override
  String get adminNoThresholdData => 'Belum ada data threshold';

  @override
  String get adminNoUsers => 'Belum ada user';

  @override
  String get adminNoUsersMessage => 'Tambahkan user untuk mengakses sistem';

  @override
  String get adminNoUnits => 'Belum ada unit';

  @override
  String get adminNoUnitsMessage => 'Tambahkan unit satuan untuk sensor';

  @override
  String get adminNoDevices => 'Belum ada device';

  @override
  String get adminNoDevicesMessage =>
      'Tambahkan device untuk memulai monitoring';

  @override
  String get adminNoSensors => 'Belum ada sensor';

  @override
  String get adminNoSensorsMessage =>
      'Tambahkan sensor untuk memulai monitoring';

  @override
  String get adminNoRoles => 'Belum ada role';

  @override
  String get adminNoRolesMessage => 'Tambahkan role untuk mengatur hak akses';

  @override
  String get adminNoPermissions => 'Belum ada permission';

  @override
  String get adminNoPermissionsMessage => 'Tidak ada permission yang terdaftar';

  @override
  String get adminNoPlants => 'Belum ada tanaman';

  @override
  String get adminNoPlantsMessage =>
      'Tambahkan tanaman untuk memulai monitoring';

  @override
  String get adminNoMappings => 'Belum ada mapping';

  @override
  String get adminNoMappingsMessage =>
      'Tambahkan mapping device-sensor untuk monitoring';

  @override
  String get adminPlantActionsTooltip => 'Aksi tanaman';

  @override
  String get adminEditMapping => 'Edit Mapping';

  @override
  String get adminHarvestPlantTitle => 'Panen Tanaman?';

  @override
  String adminDeleteSuccess(String item) {
    return '$item berhasil dihapus';
  }

  @override
  String adminDeleteFailed(String item) {
    return 'Gagal menghapus $item';
  }

  @override
  String get adminRoleDeleteWarning =>
      'Semua user dengan role ini akan kehilangan akses.';

  @override
  String get adminUnitReadonlyMessage =>
      'Data Unit bersifat read-only. Perubahan dan penghapusan unit tidak didukung oleh sistem backend saat ini.';

  @override
  String adminTotalPermissions(int count) {
    return '$count Total Permission';
  }

  @override
  String adminResourceGroupCount(int count) {
    return '$count Grup Resource';
  }

  @override
  String adminPermissionCount(int count) {
    return '$count permission';
  }

  @override
  String adminPermissionBadge(int count) {
    return '$count Permission';
  }

  @override
  String get adminMappingTab => 'Mapping';

  @override
  String get adminThresholdValuesTab => 'Nilai Ambang';

  @override
  String get commonViewDetail => 'Lihat Detail';

  @override
  String get commonOffline => 'Offline';

  @override
  String commonDays(int count) {
    return '$count hari';
  }

  @override
  String commonMinCharacters(int count) {
    return 'Minimal $count karakter';
  }

  @override
  String get recommendationSiteTitle => 'Rekomendasi Site';

  @override
  String get recommendationSiteSubtitle =>
      'Kondisi site terpilih dan kebutuhan tindakan';

  @override
  String get recommendationSiteDescription =>
      'Analisis umum kondisi site dan kebutuhan tindakan.';

  @override
  String get recommendationPlantTitle => 'Rekomendasi Tanaman';

  @override
  String get recommendationPlantSubtitle => 'Tanaman aktif di site terpilih';

  @override
  String get recommendationPlantDescription =>
      'Rekomendasi terbaru berbasis data tanaman aktif.';

  @override
  String get recommendationPlantLoadFailed =>
      'Gagal memuat rekomendasi tanaman';

  @override
  String get recommendationPhaseTitle => 'Rekomendasi Fase';

  @override
  String get recommendationPhaseDescription =>
      'Saran aksi spesifik sesuai fase pertumbuhan aktif.';

  @override
  String get recommendationPhaseLoadFailed => 'Gagal memuat rekomendasi fase';

  @override
  String get recommendationActivePhaseLoadFailed => 'Gagal memuat fase aktif';

  @override
  String get recommendationPhaseNoActive => 'Belum ada fase aktif';

  @override
  String get recommendationPhaseUnavailable => 'Fase aktif belum tersedia';

  @override
  String get recommendationPhaseAvailableForActivePlant =>
      'Rekomendasi fase tersedia untuk tanaman aktif.';

  @override
  String get recommendationPhaseNoneForPlant =>
      'Belum ada fase aktif untuk tanaman ini.';

  @override
  String recommendationPhaseLabel(String phase) {
    return 'Fase: $phase';
  }

  @override
  String recommendationHstLabel(int hst) {
    return 'HST $hst';
  }

  @override
  String get monitoringDailySummaryTitle => 'Ringkasan Harian';

  @override
  String get monitoringDailyAggregationEmpty =>
      'Belum ada data agregasi untuk rentang ini';

  @override
  String get monitoringLast30Days => '30 hari terakhir';

  @override
  String get monitoringCustomRange => 'Rentang custom';

  @override
  String monitoringSensorCount(int count) {
    return '$count sensor';
  }

  @override
  String monitoringRegisteredSensorCount(int count) {
    return '$count sensor terdaftar';
  }

  @override
  String monitoringDataPointCount(int count) {
    return '$count titik data';
  }

  @override
  String get monitoringActionRequiredDescription =>
      '0 sensor tersedia, belum ada konfigurasi. Silakan konfigurasi sensor untuk mulai monitoring';

  @override
  String get monitoringEnvironmentSubtitle => 'Skor kondisi sensor site aktif';

  @override
  String get monitoringNoSensorsConfiguredStatus =>
      'Belum ada sensor tersedia, silakan konfigurasi untuk mulai monitoring.';

  @override
  String monitoringSensorsStableStatus(int total) {
    return '$total sensor tersedia, kondisi monitoring stabil.';
  }

  @override
  String monitoringSensorsAttentionStatus(int total) {
    return '$total sensor tersedia, beberapa parameter perlu perhatian.';
  }

  @override
  String get monitoringHealthNeedsSetup => 'Perlu Konfigurasi';

  @override
  String get monitoringHealthExcellent => 'Sangat Baik';

  @override
  String get monitoringHealthExcellentDesc =>
      'Kondisi lingkungan optimal untuk pertumbuhan tanaman';

  @override
  String get monitoringHealthGood => 'Baik';

  @override
  String get monitoringHealthGoodDesc =>
      'Kondisi lingkungan mendukung pertumbuhan tanaman';

  @override
  String get monitoringHealthFair => 'Cukup';

  @override
  String get monitoringHealthFairDesc => 'Beberapa parameter perlu perhatian';

  @override
  String get monitoringHealthNeedsAttention => 'Perlu Perhatian';

  @override
  String get monitoringHealthNeedsAttentionDesc =>
      'Kondisi lingkungan memerlukan perbaikan segera';

  @override
  String monitoringSensorsMonitoredCount(int count) {
    return '$count sensor dipantau';
  }

  @override
  String get agroParameterScoreTitle => 'Skor Parameter';

  @override
  String get agroRecVentilationLowerHumidity =>
      'Tingkatkan ventilasi untuk menurunkan kelembaban';

  @override
  String get agroRecIncreaseIrrigationHumidity =>
      'Tingkatkan penyiraman dan kelembaban udara';

  @override
  String get agroRecIncreaseWateringFrequency =>
      'Tingkatkan frekuensi penyiraman';

  @override
  String get agroRecHighEtcCheckSoil =>
      'ETC tinggi, periksa kelembaban tanah dan irigasi';

  @override
  String get agroRecIntenseMonitoring => 'Lakukan monitoring lebih intensif';

  @override
  String get agroRecConsultAgronomist => 'Konsultasikan dengan ahli agronomi';

  @override
  String get monitoringSensorByTypeTitle => 'Sensor Berdasarkan Jenis';

  @override
  String get monitoringNoRegisteredSensors => 'Belum ada sensor terdaftar';

  @override
  String get monitoringNoSensorData => 'Belum ada data sensor';

  @override
  String get monitoringDistributionByTypeTitle =>
      'Distribusi Berdasarkan Jenis';

  @override
  String get monitoringPlantCompositionSubtitle =>
      'Komposisi tanaman site aktif';

  @override
  String get monitoringAverageGrowthPhase => 'Fase Pertumbuhan Rata-rata';

  @override
  String get agroSelectSiteMessage =>
      'Pilih site terlebih dahulu untuk melihat data agro (VDP, GDD, ETC).';

  @override
  String get agroActionRecommendationTitle => 'Rekomendasi Tindakan';

  @override
  String get agroPlantingPhaseTitle => 'Fase Tanam';

  @override
  String get agroInformationTitle => 'Informasi';

  @override
  String get agroAboutTitle => 'Tentang Agro Indicator';

  @override
  String get agroVdpDescription =>
      'Mengukur defisit tekanan uap air. Nilai optimal: 0.4-1.2 kPa. VDP rendah (<0.4) meningkatkan risiko penyakit, VDP tinggi (>1.6) menyebabkan stres air.';

  @override
  String get agroGddDescription =>
      'Akumulasi suhu yang diperlukan tanaman untuk tumbuh. Digunakan untuk memprediksi fase pertumbuhan dan waktu panen.';

  @override
  String get agroEtcDescription =>
      'Kebutuhan air tanaman berdasarkan evaporasi dan transpirasi. Membantu menentukan jadwal dan volume penyiraman yang optimal.';

  @override
  String get agroVdpTitle => 'Vapor Pressure Deficit';

  @override
  String get agroGddTitle => 'Growing Degree Days';

  @override
  String get agroEtcTitle => 'Evapotranspiration';

  @override
  String get agroSmartRecommendation => 'Rekomendasi Cerdas';

  @override
  String get agroNoCriticalRecommendations =>
      'Tidak ada rekomendasi kritis saat ini';

  @override
  String get agroRecommendationSubtitle => 'Tindakan berdasarkan AI & Data';

  @override
  String get agroWateringRecommendation => 'Rekomendasi Penyiraman';

  @override
  String get agroWaterRequirement => 'Kebutuhan Air Tanaman';

  @override
  String get agroEtcTrend7Days => 'Tren ETC (7 Hari)';

  @override
  String get agroDailyClimateDetail => 'Detail Iklim Harian';

  @override
  String get agroTableDate => 'Tanggal';

  @override
  String get agroTableTemp => 'Suhu (Min-Maks)';

  @override
  String get agroTableRh => 'Kelembaban (Min-Maks)';

  @override
  String get agroEtcDataUnavailable => 'Data ETC tidak tersedia';

  @override
  String get agroUnitMmPerDay => 'mm/hari';

  @override
  String get agroUnitCoefficient => 'koefisien';

  @override
  String get agroWaterNeedsLabel => 'Kebutuhan';

  @override
  String get agroRecWaterNeedsLow =>
      'Kebutuhan air rendah. Penyiraman minimal atau tidak diperlukan.';

  @override
  String get agroRecWaterNeedsMedium =>
      'Kebutuhan air sedang. Lakukan penyiraman rutin sesuai jadwal.';

  @override
  String get agroRecWaterNeedsHigh =>
      'Kebutuhan air tinggi. Tingkatkan frekuensi penyiraman.';

  @override
  String get agroRecWaterNeedsVeryHigh =>
      'Kebutuhan air sangat tinggi! Penyiraman intensif diperlukan.';

  @override
  String get agroStatusEtc => 'Status ETC';

  @override
  String get agroRecEtcLow =>
      'ETC rendah. Kebutuhan evapotranspirasi tanaman sedang ringan.';

  @override
  String get agroRecEtcMedium =>
      'ETC berada pada rentang sedang. Pantau kelembaban dan jadwal irigasi.';

  @override
  String get agroRecEtcHigh =>
      'ETC tinggi. Periksa kelembaban tanah dan kesiapan irigasi.';

  @override
  String get adminLoadingTitle => 'Memuat...';

  @override
  String get adminEditUserTitle => 'Edit User';

  @override
  String get adminAddUserTitle => 'Tambah User';

  @override
  String get adminEditUnitTitle => 'Edit Unit';

  @override
  String get adminAddUnitTitle => 'Tambah Unit';

  @override
  String get adminEditDeviceTitle => 'Edit Device';

  @override
  String get adminAddDeviceTitle => 'Tambah Device';

  @override
  String get adminEditSensorTitle => 'Edit Sensor';

  @override
  String get adminAddSensorTitle => 'Tambah Sensor';

  @override
  String get adminEditPlantTitle => 'Edit Tanaman';

  @override
  String get adminAddPlantTitle => 'Tambah Tanaman';

  @override
  String get adminEditRoleTitle => 'Edit Role';

  @override
  String get adminAddRoleTitle => 'Tambah Role';

  @override
  String get adminEditDeviceSensorTitle => 'Edit Device Sensor';

  @override
  String get adminAddDeviceSensorTitle => 'Tambah Device Sensor';

  @override
  String get adminSavingChanges => 'Menyimpan perubahan...';

  @override
  String get adminCreatingUser => 'Membuat user...';

  @override
  String get adminCreatingUnit => 'Membuat unit...';

  @override
  String get adminCreatingDevice => 'Membuat device...';

  @override
  String get adminCreatingSensor => 'Membuat sensor...';

  @override
  String get adminCreatingPlant => 'Membuat tanaman...';

  @override
  String get adminCreatingRole => 'Membuat role...';

  @override
  String get adminCreatingMapping => 'Membuat mapping...';

  @override
  String get adminAccountInfoSection => 'Informasi Akun';

  @override
  String get adminSecuritySection => 'Keamanan';

  @override
  String get adminRoleStatusSection => 'Role & Status';

  @override
  String get adminBasicInfoSection => 'Informasi Dasar';

  @override
  String get adminUnitInfoSection => 'Informasi Unit';

  @override
  String get adminPlantInfoSection => 'Informasi Tanaman';

  @override
  String get adminPlantingDateSection => 'Tanggal Tanam';

  @override
  String get adminRoleInfoSection => 'Informasi Role';

  @override
  String get adminRolePermissionSection => 'Permission Role';

  @override
  String get adminConnectionSection => 'Koneksi';

  @override
  String get adminConnectionSubtitle => 'Opsional - IP address dan port device';

  @override
  String get adminCoordinatesSection => 'Koordinat';

  @override
  String get adminDeviceCoordinateSubtitle =>
      'Opsional - untuk pemetaan lokasi device';

  @override
  String get adminSensorCoordinateSubtitle =>
      'Opsional - untuk pemetaan lokasi sensor';

  @override
  String get adminConfigurationSection => 'Konfigurasi';

  @override
  String get adminStatusSection => 'Status';

  @override
  String get adminMappingInfoSection => 'Informasi Mapping';

  @override
  String get adminThresholdSection => 'Threshold';

  @override
  String get adminThresholdSubtitle => 'Konfigurasi batas nilai sensor';

  @override
  String get adminUserIdLabel => 'User ID';

  @override
  String get adminUserIdHint => 'Contoh: USER001';

  @override
  String get adminUserIdRequired => 'User ID wajib diisi';

  @override
  String get adminFullNameHint => 'Contoh: John Doe';

  @override
  String get adminEmailHint => 'Contoh: user@example.com';

  @override
  String get adminPhoneHint => 'Contoh: 081234567890';

  @override
  String get adminRoleLabel => 'Role';

  @override
  String get adminSelectRoleHint => 'Pilih role';

  @override
  String get adminRoleRequired => 'Role wajib dipilih';

  @override
  String get adminSelectStatusHint => 'Pilih status';

  @override
  String get adminPasswordLabel => 'Password';

  @override
  String get adminPasswordHint => 'Minimal 6 karakter';

  @override
  String get adminPasswordRequired => 'Password wajib diisi';

  @override
  String get adminPasswordMinLength => 'Password minimal 6 karakter';

  @override
  String get adminUnitIdLabel => 'Unit ID';

  @override
  String get adminUnitIdHint => 'Contoh: TEMP_C';

  @override
  String get adminUnitIdRequired => 'Unit ID wajib diisi';

  @override
  String get adminUnitNameLabel => 'Nama Unit';

  @override
  String get adminUnitNameHint => 'Contoh: Celsius';

  @override
  String get adminUnitNameRequired => 'Nama unit wajib diisi';

  @override
  String get adminUnitSymbolLabel => 'Simbol';

  @override
  String get adminUnitSymbolHint => 'Contoh: C';

  @override
  String get adminUnitSymbolRequired => 'Simbol wajib diisi';

  @override
  String get adminUnitDescriptionHint =>
      'Contoh: Satuan suhu dalam derajat Celsius';

  @override
  String get adminSensorIdLabel => 'Sensor ID';

  @override
  String get adminSensorIdHint => 'Contoh: soil_nitro';

  @override
  String get adminSensorIdRequired => 'Sensor ID wajib diisi';

  @override
  String get adminSensorNameLabel => 'Nama Sensor';

  @override
  String get adminSensorNameHint => 'Contoh: Nitrogen Sensor';

  @override
  String get adminSensorNameRequired => 'Nama sensor wajib diisi';

  @override
  String get adminSensorAddressLabel => 'Alamat Sensor';

  @override
  String get adminSensorAddressHint => 'Contoh: 0x10';

  @override
  String get adminSensorLocationHint => 'Contoh: Soil Layer 1';

  @override
  String get adminSelectDeviceOptional => 'Pilih device (opsional)';

  @override
  String get adminNoDevice => 'Tidak ada device';

  @override
  String get adminLoadDeviceFailed => 'Gagal memuat device';

  @override
  String get adminDeviceRequired => 'Device wajib dipilih';

  @override
  String get adminDeviceIdHint => 'Contoh: DEV001';

  @override
  String get adminDeviceNameHint => 'Contoh: Main Gateway';

  @override
  String get adminDeviceLocationHint => 'Contoh: Greenhouse A';

  @override
  String get adminIpInvalid => 'IP tidak valid';

  @override
  String get adminPlantIdLabel => 'Plant ID';

  @override
  String get adminServerIdHint => 'ID dari server';

  @override
  String get adminPlantNameLabel => 'Nama Tanaman';

  @override
  String get adminPlantNameHint => 'Contoh: Padi Sawah Blok A';

  @override
  String get adminPlantNameRequired => 'Nama tanaman wajib diisi';

  @override
  String get adminCropTypeLabel => 'Jenis Tanaman';

  @override
  String get adminSelectCropTypeHint => 'Pilih jenis tanaman';

  @override
  String get adminCropTypeRequired => 'Jenis tanaman wajib dipilih';

  @override
  String get adminVarietasIdLabel => 'Varietas ID';

  @override
  String get adminVarietasIdHint => 'Contoh: VAR_001';

  @override
  String get adminVarietasIdRequired => 'Varietas ID wajib diisi';

  @override
  String get adminChooseVarietasFromList => 'Pilih dari daftar varietas';

  @override
  String get adminVarietasLabel => 'Varietas';

  @override
  String get adminSelectVarietasHint => 'Pilih varietas dari backend';

  @override
  String get adminVarietasRequired => 'Varietas wajib dipilih';

  @override
  String get adminVarietasLoadFailedManual =>
      'Gagal memuat varietas. Gunakan input manual.';

  @override
  String get adminManualIdInput => 'Input ID manual';

  @override
  String get adminSelectPlantingDate => 'Pilih tanggal tanam';

  @override
  String get adminPlantingDateRequired => 'Tanggal tanam wajib dipilih';

  @override
  String get adminRoleIdLabel => 'Role ID';

  @override
  String get adminRoleIdHint => 'Contoh: ROLE001';

  @override
  String get adminRoleIdRequired => 'Role ID wajib diisi';

  @override
  String get adminRoleNameLabel => 'Nama Role';

  @override
  String get adminRoleNameHint => 'Contoh: Admin, Operator, Viewer';

  @override
  String get adminRoleNameRequired => 'Nama role wajib diisi';

  @override
  String get adminRoleDescriptionHint =>
      'Contoh: Role untuk administrator sistem';

  @override
  String get adminDsIdLabel => 'DS ID';

  @override
  String get adminDsIdHint => 'Contoh: DS001';

  @override
  String get adminDsIdRequired => 'DS ID wajib diisi';

  @override
  String get adminMappingNameHint => 'Contoh: Nitrogen Sensor DEV001';

  @override
  String get adminNameRequired => 'Nama wajib diisi';

  @override
  String get adminSelectDeviceHint => 'Pilih device';

  @override
  String get adminSelectSensorOptional => 'Pilih sensor (opsional)';

  @override
  String get adminSelectUnitOptional => 'Pilih unit (opsional)';

  @override
  String get adminLoadSensorFailed => 'Gagal memuat sensor';

  @override
  String get adminLoadUnitFailed => 'Gagal memuat unit';

  @override
  String get adminNoSelection => 'Tidak ada';

  @override
  String get adminAddressLabel => 'Alamat';

  @override
  String get adminSequenceLabel => 'Urutan (Seq)';

  @override
  String get adminSequenceHint => 'Contoh: 1';

  @override
  String get adminNormalValueLabel => 'Nilai Normal';

  @override
  String get adminExampleDecimalHint => 'Contoh: 25.0';

  @override
  String get adminMinNormalLabel => 'Min Normal';

  @override
  String get adminMaxNormalLabel => 'Max Normal';

  @override
  String get adminMinAbsoluteLabel => 'Min Absolut';

  @override
  String get adminMaxAbsoluteLabel => 'Max Absolut';

  @override
  String get adminMinWarningLabel => 'Min Warning';

  @override
  String get adminMaxWarningLabel => 'Max Warning';

  @override
  String get adminStatusUserLabel => 'Status User';

  @override
  String get adminStatusUnitLabel => 'Status Unit';

  @override
  String get adminStatusDeviceLabel => 'Status Device';

  @override
  String get adminStatusSensorLabel => 'Status Sensor';

  @override
  String get adminStatusPlantLabel => 'Status Tanaman';

  @override
  String get adminStatusRoleLabel => 'Status Role';

  @override
  String get adminStatusMappingLabel => 'Status Mapping';

  @override
  String adminUpdateSuccess(String item) {
    return '$item berhasil diperbarui';
  }

  @override
  String adminCreateSuccess(String item) {
    return '$item berhasil ditambahkan';
  }

  @override
  String adminSaveFailed(String item) {
    return 'Gagal menyimpan $item';
  }

  @override
  String get adminMinNormalGreaterThanMaxNormal =>
      'Min Normal tidak boleh lebih besar dari Max Normal';

  @override
  String get adminMinAbsoluteGreaterThanMaxAbsolute =>
      'Min Absolut tidak boleh lebih besar dari Max Absolut';

  @override
  String get adminMinWarningGreaterThanMaxWarning =>
      'Min Warning tidak boleh lebih besar dari Max Warning';

  @override
  String get adminMinAbsoluteGreaterThanMinNormal =>
      'Min Absolut tidak boleh lebih besar dari Min Normal';

  @override
  String get adminMinAbsoluteGreaterThanMinWarning =>
      'Min Absolut tidak boleh lebih besar dari Min Warning';

  @override
  String get adminMaxAbsoluteLessThanMaxNormal =>
      'Max Absolut tidak boleh lebih kecil dari Max Normal';

  @override
  String get adminMaxAbsoluteLessThanMaxWarning =>
      'Max Absolut tidak boleh lebih kecil dari Max Warning';

  @override
  String get adminMinWarningGreaterThanMinNormal =>
      'Min Warning tidak boleh lebih besar dari Min Normal';

  @override
  String get adminMaxWarningLessThanMaxNormal =>
      'Max Warning tidak boleh lebih kecil dari Max Normal';

  @override
  String get adminFullNameLabel => 'Nama Lengkap';

  @override
  String get adminEmailLabel => 'Email';

  @override
  String get adminPhoneLabel => 'No. Telepon';

  @override
  String get adminEmailInvalid => 'Format email tidak valid';

  @override
  String get adminPhoneInvalid => 'No. telepon tidak valid';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleUser => 'User';

  @override
  String get roleViewer => 'Viewer';

  @override
  String adminIdPrefix(String id) {
    return 'ID: $id';
  }

  @override
  String adminDevicePrefix(String id) {
    return 'Device: $id';
  }

  @override
  String adminSensorPrefix(String id) {
    return 'Sensor: $id';
  }

  @override
  String get adminDeviceLabel => 'Device';

  @override
  String get adminSensorLabel => 'Sensor';

  @override
  String get adminUnitLabel => 'Unit';

  @override
  String get adminDeviceIdLabel => 'Device ID';

  @override
  String get adminDeviceIdRequired => 'Device ID wajib diisi';

  @override
  String get adminDeviceNameLabel => 'Nama Device';

  @override
  String get adminDeviceNameRequired => 'Nama device wajib diisi';

  @override
  String get adminIpAddressLabel => 'IP Address';

  @override
  String get adminPortLabel => 'Port';

  @override
  String get adminAltitudeLabel => 'Altitude (meter)';

  @override
  String recommendationHstRangeLabel(int min, int max) {
    return 'HST $min-$max';
  }

  @override
  String adminDsDevSubtitle(String dsId, String devId) {
    return 'DS ID: $dsId · Device ID: $devId';
  }

  @override
  String adminSensIdBadge(String id) {
    return 'sens_id: $id';
  }

  @override
  String adminUnitBadge(String id) {
    return 'unit: $id';
  }

  @override
  String get sensorTypeAirTemperature => 'Suhu Udara';

  @override
  String get sensorTypeAirHumidity => 'Kelembaban Udara';

  @override
  String get sensorTypeSoilMoisture => 'Kelembaban Tanah';

  @override
  String get sensorTypeSoilPh => 'pH Tanah';

  @override
  String get sensorTypeSoilNitrogen => 'Nitrogen Tanah';

  @override
  String get sensorTypeSoilPhosphorus => 'Fosfor Tanah';

  @override
  String get sensorTypeSoilPotassium => 'Kalium Tanah';

  @override
  String get sensorTypeLightIntensity => 'Intensitas Cahaya';

  @override
  String get sensorTypeAtmosphericPressure => 'Tekanan Udara';

  @override
  String get sensorTypeWindSpeed => 'Kecepatan Angin';

  @override
  String get agroVdpDeficitTitle => 'Defisit Tekanan Uap';

  @override
  String get agroVdpValueLabel => 'Nilai VPD';

  @override
  String get agroVdpRangeLabel => 'VDP Range';

  @override
  String get agroVdpDetailTitle => 'Detail VPD';

  @override
  String get agroVdpUnavailable => 'Data VDP tidak tersedia';

  @override
  String get agroVdpStatusLow => 'Terlalu Rendah';

  @override
  String get agroVdpStatusOptimal => 'Optimal';

  @override
  String get agroVdpStatusWarning => 'Waspada';

  @override
  String get agroVdpStatusHigh => 'Terlalu Tinggi';

  @override
  String get agroVdpDescLow =>
      'Kelembaban relatif tinggi. Tingkatkan ventilasi agar risiko penyakit turun.';

  @override
  String get agroVdpDescOptimal =>
      'Kondisi defisit tekanan uap berada pada rentang ideal.';

  @override
  String get agroVdpDescWarning =>
      'Tanaman mulai berisiko kehilangan air lebih cepat. Pantau irigasi dan kelembaban.';

  @override
  String get agroVdpDescHigh =>
      'Defisit tekanan uap tinggi. Tingkatkan penyiraman dan jaga kelembaban area tanam.';

  @override
  String get agroGddSuhuAccumLabel => 'Akumulasi Suhu Pertumbuhan';

  @override
  String get agroGddTotalLabel => 'Total GDD';

  @override
  String get agroGddAccumLabel => 'Akumulasi';

  @override
  String get agroGddDailyChartTitle => 'GDD Harian (7 Hari Terakhir)';

  @override
  String get agroGddDetailTitle => 'Detail GDD Harian';

  @override
  String get agroGddUnavailable => 'Data GDD tidak tersedia';

  @override
  String get plantGrowthPhaseTitle => 'Fase Pertumbuhan';

  @override
  String get plantActivePhaseDesc => 'Fase aktif tanaman saat ini';

  @override
  String get plantTimeProgressLabel => 'Progress Waktu';

  @override
  String get plantGrowthPhaseUnavailable =>
      'Data fase pertumbuhan belum tersedia';

  @override
  String get commonNotAvailableYet => 'Belum ada';

  @override
  String get agroGddTrackingNoData => 'Belum ada data GDD';

  @override
  String get agroGddTrackingNoDataDesc =>
      'Data GDD akan ditarik dari API Agro setelah tanaman aktif terdaftar di site ini.';

  @override
  String get agroGddTrackingSummaryTitle => 'Ringkasan GDD';

  @override
  String get agroGddTrackingTotalReal => 'Total GDD (Riil)';

  @override
  String get agroGddTrackingFieldProgress => 'Progress Lahan';

  @override
  String get agroGddTrackingDurationTitle => 'Durasi HST per Fase';

  @override
  String get agroGddTrackingDurationSubtitle =>
      'Durasi Hari Setelah Tanam per fase pertumbuhan';

  @override
  String get agroGddTrackingDurationDetailTitle => 'Detail Durasi per Fase';

  @override
  String get agroGddTrackingDurationDetailSubtitle =>
      'Detail rincian durasi setiap fase pertumbuhan';

  @override
  String get agroGddTrackingTablePhase => 'Fase';

  @override
  String get agroGddTrackingTableCurrentHst => 'HST Kini';

  @override
  String get agroGddTrackingTableDuration => 'Durasi';

  @override
  String get profilePermissionsLoadError => 'Tidak dapat memuat hak akses';

  @override
  String get profilePermissionsNoAccess => 'Tidak Ada Akses';

  @override
  String get profilePermissionsNoAccessDesc => 'Belum ada hak akses tersedia';

  @override
  String get profilePermissionsSystemAccess => 'Hak Akses Sistem';

  @override
  String get permissionActionRead => 'Lihat';

  @override
  String get permissionActionCreate => 'Tambah';

  @override
  String get permissionActionUpdate => 'Ubah';

  @override
  String get permissionActionDelete => 'Hapus';

  @override
  String get permissionActionManage => 'Kelola';

  @override
  String get sensorEditTitle => 'Edit Sensor';

  @override
  String get sensorNameLabel => 'Nama Sensor';

  @override
  String get sensorNameRequired => 'Nama sensor wajib diisi';

  @override
  String get sensorTypeRequired => 'Tipe sensor wajib dipilih';

  @override
  String get sensorUnitRequired => 'Satuan wajib diisi';

  @override
  String get sensorUnitHint => 'Contoh: °C, %, pH';

  @override
  String get sensorDescLabel => 'Deskripsi (Opsional)';

  @override
  String get sensorDescHint => 'Masukkan deskripsi sensor';

  @override
  String get sensorStatusActiveLabel => 'Status Aktif';

  @override
  String get sensorStatusActiveDesc => 'Sensor aktif';

  @override
  String get sensorStatusInactiveDesc => 'Sensor tidak aktif';

  @override
  String get sensorUpdatedSuccess => 'Sensor berhasil diperbarui';

  @override
  String get sensorCreatedSuccess => 'Sensor berhasil ditambahkan';

  @override
  String get commonOptimal => 'Optimal';

  @override
  String get commonWarning => 'Waspada';

  @override
  String get commonNitrogen => 'Nitrogen';

  @override
  String get commonPhosphorus => 'Fosfor';

  @override
  String get commonPotassium => 'Kalium';

  @override
  String get monitoringActionRequiredTitle => 'Tindakan Diperlukan';

  @override
  String get monitoringNoSensorConfiguredDesc =>
      '0 sensor tersedia, belum ada konfigurasi. Silakan konfigurasi sensor untuk mulai monitoring';

  @override
  String get monitoringPlantCompositionTitle => 'Distribusi Berdasarkan Jenis';

  @override
  String get monitoringChartTypeLabel => 'Tipe Grafik';

  @override
  String get monitoringChartTypeLine => 'Garis';

  @override
  String get monitoringChartTypeBar => 'Batang';

  @override
  String get monitoringChartTypeArea => 'Area';

  @override
  String get monitoringDailyNoAggregationDesc =>
      'Belum ada data agregasi untuk rentang ini';

  @override
  String get monitoringRangeToday => 'Hari ini';

  @override
  String get monitoringRangeLast7Days => '7 hari terakhir';

  @override
  String get monitoringRangeLast30Days => '30 hari terakhir';

  @override
  String get monitoringRangeCustom => 'Rentang custom';

  @override
  String monitoringDataPointsCount(int count) {
    return '$count titik data';
  }

  @override
  String get monitoringFilterThirtyDay => '30 Hari';

  @override
  String get monitoringFilterCustom => 'Kustom';

  @override
  String get monitoringRangeLabel => 'Rentang';

  @override
  String monitoringActiveAlarmsCount(int count) {
    return '$count Alarm Aktif';
  }

  @override
  String get monitoringDetectedInLast24Hours =>
      'Terdeteksi dalam 24 jam terakhir';

  @override
  String monitoringOtherAlarmsCount(int count) {
    return '+ $count alarm lainnya';
  }

  @override
  String get monitoringCloseLog => 'Tutup Log';

  @override
  String monitoringShowAllLogsCount(int count) {
    return 'Lihat Semua Log ($count)';
  }

  @override
  String get monitoringChartDescLine => 'Tren sensor berdasarkan waktu';

  @override
  String get monitoringChartDescBar => 'Perbandingan nilai sensor per waktu';

  @override
  String get monitoringChartDescArea => 'Perubahan sensor dengan area tren';

  @override
  String get agroIndicatorLabel => 'Agro Indikator';

  @override
  String get environmentalHealthScore => 'Skor Kesehatan Lingkungan';

  @override
  String get gddCDaysUnit => 'C-hari';

  @override
  String get etcLitrePerSqmUnit => 'L/m²';

  @override
  String get commonFair => 'Cukup';

  @override
  String get commonPoor => 'Kurang';

  @override
  String dashboardWelcomeUser(String userName) {
    return 'Halo, $userName';
  }

  @override
  String get dashboardSelectSitePrompt =>
      'Pilih site untuk memuat data monitoring dan rekomendasi';

  @override
  String get dashboardNoSensorReadings => 'Belum ada bacaan sensor';

  @override
  String dashboardActiveSensorsCount(num count) {
    return '$count Sensor Aktif';
  }

  @override
  String get dashboardRecentActivities => 'Aktivitas Terbaru';

  @override
  String get dashboardNoActivities => 'Belum ada aktivitas';

  @override
  String get dashboardTaskSummaryTitle => 'Ringkasan Task';

  @override
  String get dashboardCompletionRateLabel => 'Tingkat Penyelesaian';

  @override
  String dashboardShowOtherSensors(num count) {
    return 'Lihat $count sensor lainnya';
  }

  @override
  String get dashboardAverageLabel => 'Rata-rata';

  @override
  String get commonViewAll => 'Lihat Semua';

  @override
  String get commonHide => 'Sembunyikan';

  @override
  String get timeJustNow => 'Baru saja';

  @override
  String timeMinutesAgo(num count) {
    return '$count menit yang lalu';
  }

  @override
  String timeHoursAgo(num count) {
    return '$count jam yang lalu';
  }

  @override
  String timeDaysAgo(num count) {
    return '$count hari yang lalu';
  }

  @override
  String get recommendationReasonLabel => 'Alasan';

  @override
  String profilePermissionsCount(int count) {
    return '$count izin';
  }

  @override
  String get errorNetwork =>
      'Koneksi tidak stabil. Periksa internet Anda lalu coba lagi.';

  @override
  String get errorServer =>
      'Server belum bisa memuat data saat ini. Silakan coba lagi.';

  @override
  String get errorSessionExpired =>
      'Sesi Anda berakhir. Silakan login kembali.';

  @override
  String get errorDataNotFound => 'Data tidak ditemukan untuk site ini.';

  @override
  String get errorLoadFailed =>
      'Terjadi kendala saat memuat data. Silakan coba lagi.';
}
