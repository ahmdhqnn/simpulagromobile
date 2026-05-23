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
}
