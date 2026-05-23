// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SimpulAgro';

  @override
  String get greetingMorning => 'Good Morning,';

  @override
  String get greetingAfternoon => 'Good Afternoon,';

  @override
  String get greetingEvening => 'Good Evening,';

  @override
  String get greetingNight => 'Good Night,';

  @override
  String get weatherLoading => 'Loading weather...';

  @override
  String get weatherError => 'Failed';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get recentActivityTitle => 'Recent Activity';

  @override
  String get recentActivityEmpty => 'No activity today.';

  @override
  String get sensorSectionTitle => 'Sensor Status';

  @override
  String activeSensors(int count) {
    return '$count Active';
  }

  @override
  String get plantSectionTitle => 'Plants';

  @override
  String activePlants(int count) {
    return '$count Active Phases';
  }

  @override
  String get viewAll => 'View All';

  @override
  String get errorLoadData => 'Failed to load data';

  @override
  String get retry => 'Retry';

  @override
  String get healthSectionTitle => 'Environmental Health';

  @override
  String get summarySectionTitle => 'Summary';

  @override
  String get deviceTitle => 'Device';

  @override
  String get sensorTitle => 'Sensor';

  @override
  String get plantTitle => 'Plant';

  @override
  String get errorLoadSite => 'Failed to load site';

  @override
  String get errorLoadHealth => 'Failed to load health data';

  @override
  String get emptySite => 'Please select a site first';

  @override
  String get emptySensor => 'No sensor data available';

  @override
  String get taskTitle => 'Task';

  @override
  String get taskSummarySectionTitle => 'Task Summary';

  @override
  String get quickActionSectionTitle => 'Quick Actions';
}
