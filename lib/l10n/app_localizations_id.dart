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
}
