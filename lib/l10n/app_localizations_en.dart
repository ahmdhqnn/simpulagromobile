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
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsChangePassword => 'Change Password';

  @override
  String get settingsChangePasswordSubtitle => 'Update your account password';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changePasswordCurrentLabel => 'Current Password';

  @override
  String get changePasswordCurrentHint => 'Enter current password';

  @override
  String get changePasswordCurrentRequired => 'Current password is required';

  @override
  String get changePasswordNewLabel => 'New Password';

  @override
  String get changePasswordNewHint => 'Enter new password';

  @override
  String get changePasswordNewRequired => 'New password is required';

  @override
  String get changePasswordConfirmLabel => 'Confirm New Password';

  @override
  String get changePasswordConfirmHint => 'Repeat new password';

  @override
  String get changePasswordConfirmRequired =>
      'Password confirmation is required';

  @override
  String get changePasswordConfirmMismatch =>
      'Password confirmation does not match';

  @override
  String get changePasswordSubmit => 'Save New Password';

  @override
  String get changePasswordSuccess => 'Password updated successfully';

  @override
  String get changePasswordFailed =>
      'Failed to update password. Please try again.';

  @override
  String get changePasswordErrorConfirmMismatch =>
      'Password confirmation does not match.';

  @override
  String get changePasswordErrorUnauthorized =>
      'Current password is incorrect or session expired.';

  @override
  String get changePasswordErrorUserNotFound => 'User not found.';

  @override
  String get siteInviteTitle => 'Invite Site Member';

  @override
  String siteInviteSiteIdLabel(String siteId) {
    return 'Site ID: $siteId';
  }

  @override
  String get siteInviteUserIdLabel => 'User ID';

  @override
  String get siteInviteUserIdHint => 'Example: USR_001';

  @override
  String get siteInviteUserIdRequired => 'User ID is required';

  @override
  String get siteInviteSubmit => 'Send Invite';

  @override
  String get siteInviteSuccess => 'Member invitation sent successfully';

  @override
  String get siteInviteErrorBadRequest => 'Invalid invitation payload.';

  @override
  String get siteInviteErrorForbidden =>
      'Only admin/site leader can invite members.';

  @override
  String get siteInviteErrorConflict =>
      'User is already a member of this site.';

  @override
  String get siteInviteErrorNoSiteSelected => 'No site selected.';

  @override
  String get siteInviteErrorUnknown => 'Failed to send member invitation.';

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

  @override
  String get plantOverviewTitle => 'Plants Overview';

  @override
  String get plantEmptyTitle => 'There is no planting yet';

  @override
  String get plantEmptyMessage =>
      'Start adding your first crop to monitor plants on this site.';

  @override
  String get plantAddFirst => 'Add first planting';

  @override
  String get plantAddTitle => 'Add First Planting';

  @override
  String get plantEditTitle => 'Edit Planting';

  @override
  String get plantNameLabel => 'Plant Name';

  @override
  String get plantNameHint => 'Ex. Padi Cigentur';

  @override
  String get plantNameRequired => 'Please enter plant name';

  @override
  String get plantVarietasIdLabel => 'Varietas ID';

  @override
  String get plantVarietasIdHint => 'Ex. VARIETAS001';

  @override
  String get plantVarietasIdRequired => 'Varietas ID is required';

  @override
  String get plantVarietasUseManual => 'Manual input';

  @override
  String get plantVarietasUseList => 'Select from list';

  @override
  String get plantVarietasEmptyFallback =>
      'Varietas list is empty. Please enter varietas ID manually.';

  @override
  String get plantVarietasLoadFailedFallback =>
      'Failed to load varietas. Use manual ID input.';

  @override
  String get plantTypeLabel => 'Planting Type';

  @override
  String get plantTypeHint => 'Ex. PADI, JAGUNG, etc.';

  @override
  String get plantTypeRequired => 'Please select a planting type';

  @override
  String get plantDateLabel => 'Planting Date';

  @override
  String plantActiveConflict(String name) {
    return 'This site still has an active plant \"$name\". Harvest it before adding a new one.';
  }

  @override
  String get plantCreateSuccess => 'Plant added successfully';

  @override
  String get plantUpdateSuccess => 'Plant updated successfully';

  @override
  String get plantCreateFailed => 'Failed to add plant. Please try again.';

  @override
  String get plantUpdateFailed => 'Failed to update plant. Please try again.';

  @override
  String get plantListEmpty => 'No plants yet';

  @override
  String get plantListEmptyHint => 'Add your first plant';

  @override
  String get plantLoadFailed => 'Failed to load data';

  @override
  String get plantHarvestDialogTitle => 'Harvest plant?';

  @override
  String plantHarvestDialogMessage(String name) {
    return '\"$name\" will be marked as harvested. This cannot be undone.';
  }

  @override
  String get plantHarvestConfirm => 'Yes, harvest';

  @override
  String plantHarvestSuccess(String name) {
    return '\"$name\" marked as harvested';
  }

  @override
  String get plantHarvestFailed => 'Failed to harvest plant';

  @override
  String plantDeleteDialogMessage(String name) {
    return '\"$name\" will be permanently deleted. This cannot be undone.';
  }

  @override
  String plantDeleteSuccess(String name) {
    return '\"$name\" deleted successfully';
  }

  @override
  String get plantDeleteFailed => 'Failed to delete plant';

  @override
  String get plantInvalidSite => 'Invalid site';

  @override
  String get plantActionEdit => 'Edit plant';

  @override
  String get plantActionHarvest => 'Harvest plant';

  @override
  String get plantActionDelete => 'Delete plant';

  @override
  String get plantGrowthTitle => 'Growth';

  @override
  String get plantInfoTitle => 'Plant information';

  @override
  String get plantHstLabel => 'DAP';

  @override
  String get plantHstSubtitle => 'Days after planting';

  @override
  String get plantPhaseLabel => 'Phase';

  @override
  String get plantPhaseSubtitle => 'Growth phase';

  @override
  String get plantSpeciesLabel => 'Species';

  @override
  String get plantPlantDateLabel => 'Planting date';

  @override
  String get plantHarvestDateLabel => 'Harvest date';

  @override
  String get plantTargetHarvestLabel => 'Target harvest';

  @override
  String get plantViewPhases => 'View growth phases';

  @override
  String get plantGddTracking => 'GDD tracking';

  @override
  String get plantMarkHarvested => 'Mark as harvested';

  @override
  String get plantDetailHarvestTitle => 'Confirm harvest';

  @override
  String plantDetailHarvestMessage(String name) {
    return 'Mark \"$name\" as harvested?';
  }

  @override
  String get plantDetailHarvestConfirm => 'Yes, harvested';

  @override
  String get plantDetailCancel => 'Cancel';

  @override
  String get plantErrorTitle => 'Something went wrong';

  @override
  String get plantDetailTitle => 'Plant\'s Detail';

  @override
  String get plantHstUnit => 'Day';

  @override
  String get plantStatusLabel => 'Status';

  @override
  String get monitoringTitle => 'Monitoring';

  @override
  String get monitoringTabRealtime => 'Realtime';

  @override
  String get monitoringTabRawReads => 'Raw Reads';

  @override
  String get monitoringTabDailyRecap => 'Daily Recap';

  @override
  String get monitoringTabMonthlyRecap => 'Monthly Recap';

  @override
  String get monitoringTabMaps => 'Maps';

  @override
  String get monitoringTabAnalytics => 'Analytics';

  @override
  String get monitoringTabAdmin => 'Admin';

  @override
  String get monitoringSyncWaiting => 'Waiting for sync';

  @override
  String monitoringSyncAt(String time) {
    return 'Synced $time';
  }

  @override
  String get monitoringSyncStale => 'data needs refresh';

  @override
  String monitoringAutoRefreshEvery(int seconds) {
    return 'Auto-refresh every ${seconds}s';
  }

  @override
  String get monitoringAutoRefreshOff => 'Auto-refresh off';

  @override
  String get monitoringNoActivePlantTitle => 'No active plant';

  @override
  String get monitoringNoActivePlantMessage =>
      'Sensor data still updates. Add a plant so monitoring recommendations can follow the planting cycle.';

  @override
  String get monitoringAddPlant => 'Add Plant';

  @override
  String get monitoringViewPlantList => 'View plant list';

  @override
  String get monitoringLatestStatusTitle => 'Latest Sensor Status';

  @override
  String get monitoringTodayChartSection => 'Today\'s Chart';

  @override
  String get monitoringSensorDetailSection => 'Sensor Status Detail';

  @override
  String get monitoringEmptySensor => 'No sensor data yet';

  @override
  String get monitoringEmptyTodayChart => 'No chart data for today yet';

  @override
  String get monitoringHistoryChartSection => 'History Chart';

  @override
  String get monitoringEmptyHistory => 'No history data yet';

  @override
  String get monitoringSelectSensor => 'Select a sensor parameter';

  @override
  String get monitoringHistoryDataSection => 'History Data';

  @override
  String get monitoringChartNoSensorData => 'No data for this sensor yet';

  @override
  String get monitoringChartDailyAggregation => 'Daily Aggregation';

  @override
  String get monitoringChartNoDailyAggregation =>
      'No daily aggregation data yet';

  @override
  String get monitoringChartLast7DaysAggregation => 'Last 7 Days Aggregation';

  @override
  String get monitoringMonthlyRecapSection => 'Monthly Recap';

  @override
  String get monitoringDailyTodaySection => 'Today\'s Recap';

  @override
  String get monitoringDailyByDateSection => 'Recap by Date';

  @override
  String get monitoringDailyNoRecap => 'No recap data available';

  @override
  String get monitoringSelectSiteFirst => 'Select a site first';

  @override
  String get monitoringFilterToday => 'Today';

  @override
  String get monitoringFilterSingleDate => 'By Date';

  @override
  String get monitoringFilterSevenDay => '7 Days';

  @override
  String get monitoringFilterDateRange => 'Date Range';

  @override
  String get monitoringFilterPlantingDate => 'Planting Cycle';

  @override
  String get commonDateLabel => 'Date';

  @override
  String get commonFromLabel => 'From';

  @override
  String get commonToLabel => 'To';

  @override
  String get monitoringTodayCardTitle => 'Today\'s Sensor Data';

  @override
  String get monitoringTodayCardSubtitle => 'Realtime daily sensor monitoring';

  @override
  String get monitoringChartNoDataForSensor => 'No data for this sensor yet';

  @override
  String get commonMin => 'Min';

  @override
  String get commonMax => 'Max';

  @override
  String get commonAverage => 'Average';

  @override
  String monitoringHistoryCardSubtitle(int count) {
    return '$count points - sensor history';
  }

  @override
  String get monitoringInvalidSensorData => 'Invalid sensor data';

  @override
  String get monitoringDailyAnalyticsTitle => 'Daily Sensor Analysis';

  @override
  String get monitoringDailyAnalyticsSubtitle => 'Today\'s Sensor Statistics';

  @override
  String get monitoringDailyEmpty => 'No daily data yet';

  @override
  String get monitoringDailyUnavailableToday =>
      'No sensor data available for today';

  @override
  String get monitoringMonthlyCardEmpty => 'No monthly recap data yet';

  @override
  String get monitoringMonthlyCardNoSensorData => 'No data for this sensor yet';

  @override
  String get monitoringMonthlyCardTitle => 'Monthly Recap';

  @override
  String get monitoringMonthlyCardSubtitle => 'Monthly averages';

  @override
  String monitoringMonthlyLegendAverage(String sensor) {
    return 'Average $sensor';
  }
}
