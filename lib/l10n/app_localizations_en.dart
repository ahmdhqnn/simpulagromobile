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
}
