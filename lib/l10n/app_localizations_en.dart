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
  String get sensorSectionTitle => 'Sensor Parameter Status';

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
  String get emptySensor => 'No sensor parameter data available';

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
  String get phaseGrowthTitle => 'Growth Phase';

  @override
  String get phaseOverallProgressTitle => 'Overall Progress';

  @override
  String get phaseOverallProgressSubtitle => 'Overall phase progress';

  @override
  String get phaseStatusCompleted => 'Completed';

  @override
  String get phaseStatusActive => 'Active';

  @override
  String get phaseStatusUpcoming => 'Upcoming';

  @override
  String get phaseEmptyTitle => 'No phase data yet';

  @override
  String get phaseEmptyMessage =>
      'Growth phase data will appear after an active plant is registered on this site.';

  @override
  String get phaseReload => 'Reload';

  @override
  String get phaseHstLabel => 'DAP';

  @override
  String get phaseDurationLabel => 'Duration';

  @override
  String phaseDaysValue(String count) {
    return '$count days';
  }

  @override
  String phaseProgressDone(String percent) {
    return '$percent% complete';
  }

  @override
  String get phaseDetailProgressTitle => 'Phase Progress';

  @override
  String get phaseDetailProgressSubtitle => 'Phase progress tracking';

  @override
  String get phaseCurrentHstLabel => 'Current DAP';

  @override
  String get phaseRemainingDaysLabel => 'Days Left';

  @override
  String get phaseTargetHstLabel => 'Target DAP';

  @override
  String get phaseHstRangeTitle => 'DAP Range';

  @override
  String get phaseHstRangeSubtitle => 'Days After Planting';

  @override
  String get phaseTimelineStartLabel => 'Start';

  @override
  String get phaseTimelineEndLabel => 'Finish';

  @override
  String get phaseTimelineStartSubtitle => 'Phase start';

  @override
  String get phaseTimelineCompleted => 'Completed';

  @override
  String get phaseTimelineNotStarted => 'Not started';

  @override
  String phaseDaysRemaining(String count) {
    return '~$count days left';
  }

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
  String get monitoringLatestStatusTitle => 'Latest Parameter Status';

  @override
  String get monitoringTodayChartSection => 'Today\'s Chart';

  @override
  String get monitoringSensorDetailSection => 'Sensor Parameter Status Detail';

  @override
  String get monitoringEmptySensor => 'No sensor parameter data yet';

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

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonRefresh => 'Reload';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonLoadFailed => 'Failed to load data';

  @override
  String get commonNoData => 'No data';

  @override
  String get commonNoDataYet => 'No data yet';

  @override
  String get commonActive => 'Active';

  @override
  String get commonInactive => 'Inactive';

  @override
  String get commonUnknown => 'Unknown';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonPriority => 'Priority';

  @override
  String get commonTotal => 'Total';

  @override
  String get commonPending => 'Pending';

  @override
  String get commonInProgress => 'In Progress';

  @override
  String get commonCompleted => 'Completed';

  @override
  String get commonFailed => 'Failed';

  @override
  String get commonLow => 'Low';

  @override
  String get commonMedium => 'Medium';

  @override
  String get commonHigh => 'High';

  @override
  String get commonCritical => 'Critical';

  @override
  String get commonApplied => 'Applied';

  @override
  String get commonDismissed => 'Dismissed';

  @override
  String get commonExpired => 'Expired';

  @override
  String get commonAll => 'All';

  @override
  String get commonOther => 'Other';

  @override
  String get commonGeneral => 'General';

  @override
  String get commonHighPriority => 'High Priority';

  @override
  String get commonActionRequired => 'Action Required';

  @override
  String get commonInformation => 'Information';

  @override
  String get commonLocation => 'Location';

  @override
  String get commonName => 'Name';

  @override
  String get commonAddress => 'Address';

  @override
  String get commonCoordinates => 'Coordinates';

  @override
  String get commonAltitude => 'Altitude';

  @override
  String get commonCreatedAt => 'Created';

  @override
  String get commonUpdatedAt => 'Last Updated';

  @override
  String get commonCompletedAt => 'Completed At';

  @override
  String get commonDescription => 'Description';

  @override
  String get commonDate => 'Date';

  @override
  String get commonUnit => 'Unit';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonActions => 'Actions';

  @override
  String get commonClose => 'Close';

  @override
  String get commonPreview => 'Preview';

  @override
  String get commonNone => 'None';

  @override
  String get commonInvalid => 'Invalid';

  @override
  String get commonRequired => 'Required';

  @override
  String get siteTitle => 'Site';

  @override
  String get siteSelectFirst => 'Select a site first';

  @override
  String get siteSelect => 'Select Site';

  @override
  String get taskTypePlanting => 'Planting';

  @override
  String get taskTypeFertilizing => 'Fertilizing';

  @override
  String get taskTypeHarvesting => 'Harvesting';

  @override
  String get taskTypeWatering => 'Watering';

  @override
  String get taskTypePestControl => 'Pest Control';

  @override
  String get taskTypeMonitoring => 'Monitoring';

  @override
  String get taskTypeMaintenance => 'Maintenance';

  @override
  String get cropRice => 'Rice';

  @override
  String get cropCorn => 'Corn';

  @override
  String get cropSoybean => 'Soybean';

  @override
  String get recommendationTypeNpk => 'NPK Fertilization';

  @override
  String get recommendationTypePh => 'pH Adjustment';

  @override
  String get recommendationAllStatuses => 'All Statuses';

  @override
  String get taskAddTitle => 'Add Task';

  @override
  String get taskEditTitle => 'Edit Task';

  @override
  String get taskNameLabel => 'Task Name';

  @override
  String get taskNameHint => 'Enter task name';

  @override
  String get taskNameRequired => 'Task name is required';

  @override
  String get taskDescriptionHint => 'Add task description';

  @override
  String get taskTypeLabel => 'Task Type';

  @override
  String get taskEmptyAll => 'No tasks yet';

  @override
  String get taskEmptyPending => 'No pending tasks';

  @override
  String get taskEmptyProgress => 'No tasks in progress';

  @override
  String get taskEmptyCompleted => 'No completed tasks yet';

  @override
  String get taskEmptyFailed => 'No failed tasks';

  @override
  String get taskSiteRequiredForEditTitle => 'Site not selected';

  @override
  String get taskSiteRequiredForEditMessage =>
      'Select a site before editing a task.';

  @override
  String get taskLoadFailed => 'Failed to load task';

  @override
  String get taskNoSite => 'No sites yet';

  @override
  String get taskSiteIdMissing => 'Site ID not found';

  @override
  String get taskUpdateSuccess => 'Task updated successfully';

  @override
  String get taskCreateSuccess => 'Task added successfully';

  @override
  String get taskDeleteTitle => 'Delete Task';

  @override
  String get taskDeleteSuccess => 'Task deleted successfully';

  @override
  String get taskMarkComplete => 'Mark Complete';

  @override
  String get taskStartWork => 'Start Work';

  @override
  String get taskInfoTitle => 'Task Information';

  @override
  String get taskTimeDetailsTitle => 'Time Details';

  @override
  String get taskTimelineTitle => 'Timeline';

  @override
  String get taskCreatedTimeline => 'Task Created';

  @override
  String get taskProgressTimeline => 'Task In Progress';

  @override
  String get taskFailedTimeline => 'Task Failed';

  @override
  String get taskCompletedTimeline => 'Task Completed';

  @override
  String taskDeleteMessage(String name) {
    return 'Are you sure you want to delete task \"$name\"?';
  }

  @override
  String taskDeleteFailure(String message) {
    return 'Failed to delete task: $message';
  }

  @override
  String taskUpdateStatusFailure(String message) {
    return 'Failed to update status: $message';
  }

  @override
  String taskStatusUpdated(String status) {
    return 'Status updated to \"$status\"';
  }

  @override
  String taskLoadSiteFailed(String message) {
    return 'Failed to load site: $message';
  }

  @override
  String taskUpdateFailure(String message) {
    return 'Failed to update task: $message';
  }

  @override
  String taskCreateFailure(String message) {
    return 'Failed to add task: $message';
  }

  @override
  String commonDeleteTitle(String itemName) {
    return 'Delete $itemName?';
  }

  @override
  String get commonDeleteIrreversible => 'Deleted data cannot be restored.';

  @override
  String get commonErrorTitle => 'Something Went Wrong';

  @override
  String get sensorDetailTitle => 'Sensor Detail';

  @override
  String get sensorTypeLabel => 'Sensor Type';

  @override
  String get sensorLoadFailed => 'Failed to load sensor';

  @override
  String get recommendationConfidenceLabel => 'Confidence Level';

  @override
  String get recommendationAppliedBy => 'Applied by';

  @override
  String get monitoringCurrentGrowthPhase => 'Current Growth Phase';

  @override
  String get recommendationConfidenceUnknown => 'Unknown';

  @override
  String get recommendationConfidenceVeryHigh => 'Very High';

  @override
  String get plantStatusHarvested => 'Harvested';

  @override
  String get plantStatusGrowing => 'Growing';

  @override
  String get dashboardTodayDailyRecap => 'Today Daily Recap';

  @override
  String get dashboardLatestRecommendations => 'Latest Recommendations';

  @override
  String get dashboardLatestActivity => 'Latest Activity';

  @override
  String get dashboardActivityLoadFailed => 'Failed to load activity';

  @override
  String get dashboardLatestNotes => 'Latest Notes';

  @override
  String get dashboardNoDailyRecapToday => 'No daily recap for today yet';

  @override
  String get notesEmptyForSite => 'No notes for this site yet';

  @override
  String get forumTitle => 'Forum';

  @override
  String get authWelcome => 'Welcome to SimpulAgro';

  @override
  String get authSkip => 'Skip';

  @override
  String get authNext => 'Next';

  @override
  String get authGetStarted => 'Get Started';

  @override
  String get onboardingMonitorTitle => 'Monitor Fields\nMore Accurately';

  @override
  String get onboardingMonitorDesc =>
      'Monitor crop conditions and soil health in real time from your smartphone, anywhere and anytime.';

  @override
  String get onboardingDataTitle => 'Data-Driven\nDecisions';

  @override
  String get onboardingDataDesc =>
      'Get accurate insights into moisture, temperature, and soil nutrients to choose the right care actions.';

  @override
  String get onboardingRiskTitle => 'Minimize Crop\nFailure Risk';

  @override
  String get onboardingRiskDesc =>
      'Receive early notifications when field anomalies occur so you can act before issues grow.';

  @override
  String get loginHeroTitle => 'The Future of\nFarming, Today.';

  @override
  String get loginSubtitle => 'Please sign in to your account';

  @override
  String get loginUsernameHint => 'Your Username';

  @override
  String get loginPasswordHint => 'Your Password';

  @override
  String get loginUsernameRequired => 'Username cannot be empty';

  @override
  String get loginPasswordRequired => 'Password cannot be empty';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginFailedTitle => 'Login Failed';

  @override
  String get loginFailedMessage =>
      'Username or password is incorrect. Please check your login details.';

  @override
  String get authSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get siteListTitle => 'Select Location';

  @override
  String get siteDetailTitle => 'Location Detail';

  @override
  String get siteAddTitle => 'Add Location';

  @override
  String get siteEditTitle => 'Edit Location';

  @override
  String get siteEmptyTitle => 'No locations yet';

  @override
  String get siteEmptyMessage => 'Add your farm location';

  @override
  String get siteIdLabel => 'Location ID';

  @override
  String get siteIdRequired => 'Location ID cannot be empty';

  @override
  String get siteNameLabel => 'Location Name';

  @override
  String get siteNameRequired => 'Location name cannot be empty';

  @override
  String get siteNameMinLength => 'Name must be at least 3 characters';

  @override
  String get siteAddressHint => 'Example: 123 Farming Road';

  @override
  String get siteIdHint => 'Example: SITE001';

  @override
  String get siteNameHint => 'Example: North Field';

  @override
  String get siteAltitudeLabel => 'Altitude (meters)';

  @override
  String get siteAltitudeHint => 'Example: 150';

  @override
  String get siteGpsCoordinates => 'GPS Coordinates';

  @override
  String get siteStatusLabel => 'Location Status';

  @override
  String get siteUpdateSuccess => 'Location updated successfully';

  @override
  String get siteCreateSuccess => 'Location added successfully';

  @override
  String siteLoadDataFailed(String message) {
    return 'Failed to load data: $message';
  }

  @override
  String get siteDataTitle => 'Site Data';

  @override
  String get siteOverviewTab => 'Overview';

  @override
  String get siteNotesTab => 'Notes';

  @override
  String get siteLocationInfo => 'Location Information';

  @override
  String get siteAdditionalInfo => 'Additional Information';

  @override
  String get siteInviteTooltip => 'Invite Member';

  @override
  String get commonSaveChanges => 'Save Changes';

  @override
  String get recommendationTitle => 'Recommendations';

  @override
  String get recommendationHubTitle => 'Recommendation Center';

  @override
  String get recommendationSearchHint =>
      'Search title, description, plant, action, or phase';

  @override
  String get recommendationEmptyTitle => 'No recommendations';

  @override
  String get recommendationEmptyAll =>
      'No active recommendations for today\'s actions, plant ML, or active phase.';

  @override
  String get recommendationReload => 'Reload';

  @override
  String get recommendationLoadFailed => 'Failed to load recommendations';

  @override
  String get recommendationEmptyDataTitle => 'Recommendation data is empty';

  @override
  String get recommendationEmptyForSite =>
      'No recommendations are available for this context yet.';

  @override
  String get recommendationFilterCategory => 'Category Filter';

  @override
  String get recommendationFilterStatus => 'Status Filter';

  @override
  String get recommendationPriorityStat => 'Priority';

  @override
  String get recommendationDismiss => 'Dismiss';

  @override
  String get recommendationApply => 'Apply';

  @override
  String recommendationEmptyFiltered(String filter) {
    return 'No recommendations for filter \"$filter\".';
  }

  @override
  String recommendationEmptyScoped(String scope, String status) {
    return 'No data for $scope filter with $status status.';
  }

  @override
  String recommendationAccuracy(String level) {
    return 'Accuracy: $level';
  }

  @override
  String get recommendationStepsTitle => 'Steps';

  @override
  String get recommendationParametersTitle => 'Parameters';

  @override
  String get recommendationSelectPhaseFirst => 'Select a phase first';

  @override
  String get recommendationLabSaved => 'Recommendation saved';

  @override
  String get recommendationLabTestTitle =>
      '[TEST] Dummy recommendation - admin only';

  @override
  String get recommendationPlantInputTitle =>
      'Enter sensor values for plant recommendations';

  @override
  String get recommendationNpkStatusLabel => 'NPK Status';

  @override
  String get recommendationNpkDoseLabel => 'NPK Dose';

  @override
  String get recommendationPhStatusLabel => 'pH Status';

  @override
  String get recommendationPhDoseLabel => 'pH Dose';

  @override
  String get recommendationNoAdditionalDose => 'No additional dose needed';

  @override
  String get recommendationBackendDataUnavailable =>
      'Not available from backend';

  @override
  String get recommendationLabAdminTestTitle =>
      '[TEST] Dummy recommendation - admin only';

  @override
  String recommendationSaveFailed(Object error) {
    return 'Failed: $error';
  }

  @override
  String get recommendationAllTab => 'All Recommendations';

  @override
  String get recommendationHistoryTab => 'History';

  @override
  String get recommendationByPhaseTab => 'By Phase';

  @override
  String get recommendationSelectPhase => 'Select Phase';

  @override
  String get recommendationNoData => 'No data';

  @override
  String get recommendationSensorInputTitle =>
      'Enter sensor values for plant recommendations';

  @override
  String get commonOk => 'OK';

  @override
  String get settingsNotificationsSection => 'Notifications';

  @override
  String get settingsEnableNotifications => 'Enable Notifications';

  @override
  String get settingsNotificationsSubtitle =>
      'Receive notifications for alerts and updates';

  @override
  String get settingsDataSyncSection => 'Data & Sync';

  @override
  String get settingsAutoRefresh => 'Auto Refresh';

  @override
  String get settingsAutoRefreshSubtitle =>
      'Refresh active-screen data on the selected interval';

  @override
  String get settingsRefreshInterval => 'Refresh Interval';

  @override
  String settingsRefreshIntervalSeconds(int seconds) {
    return '$seconds seconds';
  }

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeUnavailableSubtitle =>
      'Not available in this version';

  @override
  String get settingsThemeUnavailableMessage =>
      'Theme settings are not available in this app version.';

  @override
  String get settingsTemperatureUnit => 'Temperature Unit';

  @override
  String get settingsAppVersion => 'App Version';

  @override
  String get settingsHelpSupport => 'Help & Support';

  @override
  String get settingsHelpSupportSubtitle => 'Contact technical support';

  @override
  String get settingsHelpSupportMessage =>
      'For technical help, contact the support team through the email or WhatsApp listed in the app.';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicySubtitle => 'Data security and usage';

  @override
  String get settingsPrivacyPolicyMessage =>
      'Your data is stored securely and is not shared with third parties without your consent.';

  @override
  String get settingsSelectLanguage => 'Select Language';

  @override
  String get settingsSelectTheme => 'Select Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'Follow System';

  @override
  String get settingsLanguageIndonesian => 'Indonesian';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsTemperatureCelsius => 'Celsius (C)';

  @override
  String get settingsTemperatureFahrenheit => 'Fahrenheit (F)';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profilePhotoUploadComingSoon =>
      'Photo upload will be available soon';

  @override
  String get profileFullNameLabel => 'Full Name';

  @override
  String get profileNameRequired => 'Name cannot be empty';

  @override
  String get profileNameMinLength => 'Name must be at least 3 characters';

  @override
  String get profileEmailRequired => 'Email cannot be empty';

  @override
  String get profileEmailInvalid => 'Invalid email';

  @override
  String get profilePhoneNumberLabel => 'Phone Number';

  @override
  String get profilePhoneRequired => 'Phone number cannot be empty';

  @override
  String get profilePhoneInvalid => 'Invalid phone number';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully';

  @override
  String get profileAccountInfoTitle => 'Account Information';

  @override
  String get profilePhoneLabel => 'Phone';

  @override
  String get profileAdminSubtitle => 'Manage system data and access';

  @override
  String get profileForumManagement => 'Forum Management';

  @override
  String get profileForumManagementSubtitle => 'Manage posts and comments';

  @override
  String get profileMyPosts => 'My Posts';

  @override
  String get profileMyPostsSubtitle => 'View and manage posts';

  @override
  String get profileLikedPosts => 'Liked Posts';

  @override
  String get profileLikedPostsSubtitle => 'Posts you liked';

  @override
  String get profileMyComments => 'My Comments';

  @override
  String get profileMyCommentsSubtitle => 'View all comments';

  @override
  String get profilePermissionsSection => 'Access Rights';

  @override
  String get profileSignout => 'Sign Out';

  @override
  String get profileLogoutTitle => 'Confirm Sign Out';

  @override
  String get profileLogoutMessage =>
      'Are you sure you want to sign out of the app?';

  @override
  String get profileLogoutConfirm => 'Sign Out';

  @override
  String get commonLatitude => 'Latitude';

  @override
  String get commonLongitude => 'Longitude';

  @override
  String get commonPort => 'Port';

  @override
  String get commonIpAddress => 'IP Address';

  @override
  String get commonSaved => 'Saved';

  @override
  String get siteNoSitesAvailable => 'No sites available';

  @override
  String get notesNew => 'New Note';

  @override
  String get notesContentHint => 'Write a note...';

  @override
  String get notesSaved => 'Note saved';

  @override
  String get notesSaveFailed => 'Failed to save note';

  @override
  String get sensorAddTitle => 'Add Sensor';

  @override
  String get sensorEmptyTitle => 'No sensors yet';

  @override
  String get sensorEmptyMessage =>
      'Add sensors to start monitoring field conditions.';

  @override
  String sensorUnitValue(String unit) {
    return 'Unit: $unit';
  }

  @override
  String get deviceIoTTitle => 'IoT Devices';

  @override
  String get deviceAddTitle => 'Add Device';

  @override
  String get deviceEditTitle => 'Edit Device';

  @override
  String get deviceDetailTitle => 'Device Details';

  @override
  String get deviceEmptyMessage => 'No devices found';

  @override
  String get deviceIdLabel => 'Device ID';

  @override
  String get deviceIdRequired => 'Device ID is required';

  @override
  String get deviceNameLabel => 'Device Name';

  @override
  String get deviceNameRequired => 'Device name is required';

  @override
  String get deviceNumberIdLabel => 'Number ID';

  @override
  String get deviceInformationTitle => 'Device Information';

  @override
  String get deviceStatusActive => 'Active Status';

  @override
  String get deviceCreateSuccess => 'Device added successfully';

  @override
  String get deviceUpdateSuccess => 'Device updated successfully';

  @override
  String get monitoringMapsNoDeviceLocations =>
      'No device locations to display yet';

  @override
  String get monitoringDeviceSensorList => 'Device & Sensor List';

  @override
  String get monitoringNoDevicesAvailable => 'No devices available yet';

  @override
  String get monitoringAnalyticsOverview => 'Analytics Overview';

  @override
  String get monitoringPlantStatisticsSection => 'Plant Statistics';

  @override
  String get monitoringPlantRecommendationSection => 'Plant Recommendations';

  @override
  String get monitoringDeviceSensorOverviewSection =>
      'Device & Sensor Overview';

  @override
  String get monitoringMonthlySensorRecap => 'Monthly Sensor Recap';

  @override
  String get monitoringRawParameterUnavailable =>
      'Sensor parameter is unavailable in raw data';

  @override
  String get monitoringAdminOnlyMessage =>
      'The admin tab is only available to users with the admin role.';

  @override
  String get monitoringReadCorrectionTitle => 'Correct Sensor Read';

  @override
  String get monitoringReadCorrectionDescription =>
      'Update the read value or status for the active site';

  @override
  String get monitoringSaving => 'Saving...';

  @override
  String get monitoringSaveCorrection => 'Save Correction';

  @override
  String get monitoringGenerateDailyRecapTitle => 'Generate Daily Recap';

  @override
  String get monitoringGenerateDailyRecapDescription =>
      'Reprocess sensor aggregation for the selected date';

  @override
  String get monitoringProcessing => 'Processing...';

  @override
  String get monitoringGenerateRecap => 'Generate Recap';

  @override
  String get monitoringReadIdLabel => 'Read ID';

  @override
  String get monitoringReadValueLabel => 'Read Value (optional)';

  @override
  String get monitoringReadStsLabel => 'Read Status (optional)';

  @override
  String get monitoringReadIdRequired => 'read_id is required';

  @override
  String get monitoringReadValueMustBeNumber => 'read_value must be a number';

  @override
  String get monitoringReadValueOrStatusRequired =>
      'Fill read_value or read_sts';

  @override
  String get monitoringReadUpdated => 'Read updated';

  @override
  String get monitoringReadUpdateFailed => 'Failed to update read';

  @override
  String monitoringDailyRecapTriggered(String day) {
    return 'Recap processed for $day';
  }

  @override
  String get monitoringDailyRecapTriggerFailed => 'Failed to trigger recap';

  @override
  String get monitoringRefreshActiveTab => 'Refresh active tab';

  @override
  String get monitoringNoDeviceStats => 'No device statistics yet';

  @override
  String get monitoringTotalDevice => 'Total devices';

  @override
  String get monitoringTotalSensor => 'Total sensors';

  @override
  String get monitoringShowLess => 'Show Less';

  @override
  String monitoringShowAllCount(int count) {
    return 'Show All ($count)';
  }

  @override
  String get monitoringPlantRecommendationEmpty =>
      'No ML plant recommendations for the last 7 days of sensor averages';

  @override
  String monitoringRecommendationActionCount(int count) {
    return '$count actions';
  }

  @override
  String monitoringRecommendationMoreCount(int count) {
    return '+$count more recommendations';
  }

  @override
  String get monitoringRecommendationSiteTitle => 'Plant ML Recommendation';

  @override
  String get monitoringRecommendationCachedSubtitle =>
      'Fresh from the plant ML endpoint';

  @override
  String get monitoringRecommendationActiveSiteSubtitle =>
      'Based on 7-day sensor averages';

  @override
  String get monitoringNpkAdjustment => 'NPK Adjustment';

  @override
  String get monitoringSoilPhAdjustment => 'Soil pH Adjustment';

  @override
  String get monitoringSoilPhLabel => 'Soil pH';

  @override
  String get monitoringNoActiveAlarmTitle => 'No active alarms';

  @override
  String get monitoringNoActiveAlarmDescription =>
      'All sensors are running normally';

  @override
  String get monitoringAlarmSummaryTitle => 'Alarm Summary';

  @override
  String monitoringAlarmSummaryDescription(int total) {
    return '$total total alarms recorded';
  }

  @override
  String get monitoringLatestAlarm => 'Latest Alarm';

  @override
  String get monitoringAlarmLast24Hours => '24-hour Alarm';

  @override
  String get monitoringTotalAlarm => 'Total Alarms';

  @override
  String get monitoringAlarmDetected => 'Alarm detected';

  @override
  String get forumMyPosts => 'My Posts';

  @override
  String get forumLikedPosts => 'Liked Posts';

  @override
  String get forumMyComments => 'My Comments';

  @override
  String get forumLiked => 'Liked';

  @override
  String get forumNoPostsTitle => 'No posts yet';

  @override
  String get forumNoPostsMessage =>
      'Be the first to create a post in the community forum';

  @override
  String get forumCreatePost => 'Create Post';

  @override
  String get forumLoadPostsFailed => 'Failed to load posts';

  @override
  String get forumManagePosts => 'Manage Posts';

  @override
  String get forumEditPost => 'Edit Post';

  @override
  String get forumDeletePost => 'Delete Post';

  @override
  String get forumDeletePostConfirm =>
      'Are you sure you want to delete this post?';

  @override
  String get forumDeletePostPermanent =>
      'This post will be deleted permanently.';

  @override
  String get forumPostDeleted => 'Post deleted successfully';

  @override
  String get forumSharePostTitle => 'Share Post';

  @override
  String get forumSharePostMessage =>
      'Share this post with your friends or community.';

  @override
  String get forumPostShared => 'Post shared successfully';

  @override
  String get forumFirstPostMessage =>
      'Create your first post to share with the community.';

  @override
  String forumPostCount(int count) {
    return '$count posts';
  }

  @override
  String get forumMyPostsSummary => 'Posts you created in the community forum.';

  @override
  String get forumLikedPostsEmptyTitle => 'No liked posts yet';

  @override
  String get forumLikedPostsEmptyMessage =>
      'Posts you like will be saved here.';

  @override
  String forumLikedPostCount(int count) {
    return '$count liked posts';
  }

  @override
  String get forumLikedPostsSummary => 'Posts you have liked.';

  @override
  String get forumNoCommentsTitle => 'No comments yet';

  @override
  String get forumNoCommentsMessage =>
      'Your comments on posts will appear here.';

  @override
  String forumCommentCount(int count) {
    return '$count comments';
  }

  @override
  String get forumMyCommentsSummary => 'Comments you wrote on forum posts.';

  @override
  String get forumLoadCommentsFailed => 'Failed to load comments';

  @override
  String get forumNoTitle => 'Untitled';

  @override
  String get forumOpenPostHint => 'Tap to open post';

  @override
  String get forumCommentActions => 'Comment actions';

  @override
  String get forumEdited => 'Edited';

  @override
  String get forumManageComments => 'Manage Comments';

  @override
  String get forumEditComment => 'Edit Comment';

  @override
  String get forumDeleteComment => 'Delete Comment';

  @override
  String get forumWriteComment => 'Write a comment';

  @override
  String get forumCommentUpdated => 'Comment updated';

  @override
  String get forumDeleteCommentPermanent =>
      'This comment will be deleted permanently.';

  @override
  String get forumCommentDeleted => 'Comment deleted';

  @override
  String forumLikesCount(int count) {
    return '$count likes';
  }

  @override
  String forumCommentsCount(int count) {
    return '$count comments';
  }

  @override
  String forumSharesCount(int count) {
    return '$count shares';
  }

  @override
  String get forumLike => 'Like';

  @override
  String get forumComment => 'Comment';

  @override
  String get forumShare => 'Share';

  @override
  String get forumDislike => 'Dislike';

  @override
  String get forumNoReactions => 'No reactions yet';

  @override
  String get forumAddPost => 'Add Post';

  @override
  String get forumSelectImage => 'Select Image';

  @override
  String get forumPickFromGallery => 'Choose from Gallery';

  @override
  String get forumTakePhoto => 'Take Photo';

  @override
  String get forumDeleteImage => 'Delete Image';

  @override
  String forumPickImageFailed(String message) {
    return 'Failed to choose image: $message';
  }

  @override
  String get forumSiteRequiredMain => 'Select a site first on the main page';

  @override
  String get forumSiteNotSelectedTitle => 'Site not selected';

  @override
  String forumLoadDataFailed(String message) {
    return 'Failed to load data: $message';
  }

  @override
  String get forumPostTitleLabel => 'Title';

  @override
  String get forumPostTitleHint => 'Enter post title';

  @override
  String get forumPostTitleRequired => 'Title cannot be empty';

  @override
  String get forumPostTitleMinLength => 'Title must be at least 3 characters';

  @override
  String get forumPostContentLabel => 'Post Content';

  @override
  String get forumPostContentHint => 'Write the information you want to share';

  @override
  String get forumPostContentRequired => 'Content cannot be empty';

  @override
  String get forumPostContentMinLength =>
      'Content must be at least 10 characters';

  @override
  String get forumMediaLabel => 'Media';

  @override
  String get forumPostGuideline =>
      'Keep your post clear, relevant, and aligned with community guidelines.';

  @override
  String get forumAddImage => 'Add image';

  @override
  String get forumImageOptionalHint =>
      'Optional. Posts without images can still be published.';

  @override
  String get forumChoose => 'Choose';

  @override
  String get forumNewImageReady => 'New image is ready to upload';

  @override
  String get forumActivePostImage => 'Active post image';

  @override
  String get forumChange => 'Change';

  @override
  String get forumPostCreated => 'Post added successfully';

  @override
  String get forumPostUpdated => 'Post updated successfully';

  @override
  String get forumSelectActiveSiteBeforePosting =>
      'Select an active site on the dashboard before creating a forum post.';

  @override
  String forumSendCommentFailed(String message) {
    return 'Failed to send comment: $message';
  }

  @override
  String get forumFirstCommentMessage => 'Be the first to comment';

  @override
  String get forumReactions => 'Reactions';

  @override
  String get forumDeleteCommentConfirm =>
      'Are you sure you want to delete this comment?';

  @override
  String get adminAccessDeniedTitle => 'Access Denied';

  @override
  String get adminFeatureOnlyMessage =>
      'Admin features can only be accessed by Admin users.';

  @override
  String get adminNoPagePermissionMessage =>
      'You do not have permission to access this page.';

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
  String get adminNoPermissionsAvailable => 'No permissions available';

  @override
  String adminLoadPermissionsFailed(String message) {
    return 'Failed to load permissions: $message';
  }

  @override
  String get adminNoThresholdData => 'No threshold data yet';

  @override
  String get adminNoUsers => 'No users yet';

  @override
  String get adminNoUsersMessage => 'Add users to access the system';

  @override
  String get adminNoUnits => 'No units yet';

  @override
  String get adminNoUnitsMessage => 'Add measurement units for sensors';

  @override
  String get adminNoDevices => 'No devices yet';

  @override
  String get adminNoDevicesMessage => 'Add devices to start monitoring';

  @override
  String get adminNoSensors => 'No sensors yet';

  @override
  String get adminNoSensorsMessage => 'Add sensors to start monitoring';

  @override
  String get adminNoRoles => 'No roles yet';

  @override
  String get adminNoRolesMessage => 'Add roles to manage access rights';

  @override
  String get adminNoPermissions => 'No permissions yet';

  @override
  String get adminNoPermissionsMessage => 'No permissions are registered';

  @override
  String get adminNoPlants => 'No plants yet';

  @override
  String get adminNoPlantsMessage => 'Add plants to start monitoring';

  @override
  String get adminNoMappings => 'No mappings yet';

  @override
  String get adminNoMappingsMessage =>
      'Add device-sensor mappings for monitoring';

  @override
  String get adminPlantActionsTooltip => 'Plant actions';

  @override
  String get adminEditMapping => 'Edit Mapping';

  @override
  String get adminHarvestPlantTitle => 'Harvest Plant?';

  @override
  String adminDeleteSuccess(String item) {
    return '$item deleted successfully';
  }

  @override
  String adminDeleteFailed(String item) {
    return 'Failed to delete $item';
  }

  @override
  String get adminRoleDeleteWarning =>
      'All users with this role will lose access.';

  @override
  String get adminUnitReadonlyMessage =>
      'Unit data is read-only. Updating and deleting units is not supported by the backend system at this time.';

  @override
  String adminTotalPermissions(int count) {
    return '$count Total Permissions';
  }

  @override
  String adminResourceGroupCount(int count) {
    return '$count Resource Groups';
  }

  @override
  String adminPermissionCount(int count) {
    return '$count permissions';
  }

  @override
  String adminPermissionBadge(int count) {
    return '$count Permissions';
  }

  @override
  String get adminMappingTab => 'Mapping';

  @override
  String get adminThresholdValuesTab => 'Threshold Values';

  @override
  String get commonViewDetail => 'View Detail';

  @override
  String get commonOffline => 'Offline';

  @override
  String commonDays(int count) {
    return '$count days';
  }

  @override
  String commonMinCharacters(int count) {
    return 'At least $count characters';
  }

  @override
  String get recommendationSiteTitle => 'Action Recommendations';

  @override
  String get recommendationSiteSubtitle =>
      'Today\'s actions from field sensor conditions';

  @override
  String get recommendationSiteDescription =>
      'Direct action suggestions for today based on your field\'s current conditions.';

  @override
  String get recommendationPlantTitle => 'Plant Recommendations';

  @override
  String get recommendationPlantSubtitle => '7-day sensor average analysis';

  @override
  String get recommendationPlantDescription =>
      'Recommendations for the most suitable types of plants based on soil condition history over the last week.';

  @override
  String get recommendationPlantLoadFailed =>
      'Failed to load plant recommendations';

  @override
  String get recommendationPhaseTitle => 'Active Phase Recommendations';

  @override
  String get recommendationPhaseDescription =>
      'Crop care guide tailored to the current age and growth phase.';

  @override
  String get recommendationPhaseLoadFailed =>
      'Failed to load phase recommendations';

  @override
  String get recommendationActivePhaseLoadFailed =>
      'Failed to load active phase';

  @override
  String get recommendationPhaseNoActive => 'No active phase yet';

  @override
  String get recommendationPhaseUnavailable =>
      'Active phase is not available yet';

  @override
  String get recommendationPhaseAvailableForActivePlant =>
      'Phase recommendations are available for active plants.';

  @override
  String get recommendationPhaseNoneForPlant =>
      'No active phase for this plant yet.';

  @override
  String recommendationPhaseLabel(String phase) {
    return 'Phase: $phase';
  }

  @override
  String get recommendationActionScopeLabel => 'Actions';

  @override
  String get recommendationPlantMlScopeLabel => 'Plant ML';

  @override
  String get recommendationActivePhaseScopeLabel => 'Active Phase';

  @override
  String get recommendationSourceLabel => 'Data source';

  @override
  String get recommendationDataRuleLabel => 'Display rule';

  @override
  String get recommendationActionSourceTitle => 'Action Recommendation';

  @override
  String get recommendationActionSourceDescription =>
      'Direct action suggestions based on the latest conditions of your land today.';

  @override
  String get recommendationPlantSourceTitle => 'Plant Recommendation';

  @override
  String get recommendationPlantSourceDescription =>
      'Recommendations for the most suitable types of plants based on soil condition history over the last week.';

  @override
  String get recommendationPhaseSourceTitle => 'Active Phase Recommendation';

  @override
  String get recommendationPhaseSourceDescription =>
      'Crop care guide tailored to the current age and growth phase.';

  @override
  String get recommendationGeneratedTodayLabel => 'Today';

  @override
  String get recommendationFreshMlLabel => '7-day analysis';

  @override
  String get recommendationSeededDatabaseLabel => 'Planting phase';

  @override
  String get recommendationEmptyAction =>
      'No action recommendations for today.';

  @override
  String get recommendationEmptyPlant =>
      'No ML plant recommendations for the last 7 days of sensor averages.';

  @override
  String get recommendationEmptyPhase =>
      'No phase recommendations because there is no active planting phase.';

  @override
  String recommendationHstLabel(int hst) {
    return 'DAP $hst';
  }

  @override
  String get monitoringDailySummaryTitle => 'Daily Summary';

  @override
  String get monitoringDailyAggregationEmpty =>
      'No aggregation data for this range yet';

  @override
  String get monitoringLast30Days => 'Last 30 days';

  @override
  String get monitoringCustomRange => 'Custom range';

  @override
  String monitoringSensorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sensors',
      one: 'sensor',
    );
    return '$count $_temp0';
  }

  @override
  String monitoringRegisteredSensorCount(int count) {
    return '$count registered sensors';
  }

  @override
  String monitoringDataPointCount(int count) {
    return '$count data points';
  }

  @override
  String get monitoringActionRequiredDescription =>
      'No sensor parameters can be evaluated yet. Check the configuration and latest sensor data.';

  @override
  String get monitoringEnvironmentSubtitle =>
      'Environmental parameter score for the active site';

  @override
  String get monitoringNoSensorsConfiguredStatus =>
      'No sensor parameters can be evaluated yet. Check the configuration and latest data.';

  @override
  String monitoringSensorsStableStatus(int total) {
    return '$total parameters monitored, environmental conditions are stable.';
  }

  @override
  String monitoringSensorsAttentionStatus(int total) {
    return '$total parameters monitored, some parameters need attention.';
  }

  @override
  String get monitoringHealthNeedsSetup => 'Needs Setup';

  @override
  String get monitoringHealthExcellent => 'Excellent';

  @override
  String get monitoringHealthExcellentDesc =>
      'Optimal environmental conditions for plant growth';

  @override
  String get monitoringHealthGood => 'Good';

  @override
  String get monitoringHealthGoodDesc =>
      'Environmental conditions support plant growth';

  @override
  String get monitoringHealthFair => 'Fair';

  @override
  String get monitoringHealthFairDesc => 'Some parameters need attention';

  @override
  String get monitoringHealthNeedsAttention => 'Needs Attention';

  @override
  String get monitoringHealthNeedsAttentionDesc =>
      'Environmental conditions require immediate improvement';

  @override
  String monitoringSensorsMonitoredCount(int count) {
    return '$count parameters monitored';
  }

  @override
  String get agroParameterScoreTitle => 'Parameter Scores';

  @override
  String get agroRecVentilationLowerHumidity =>
      'Increase ventilation to reduce humidity';

  @override
  String get agroRecIncreaseIrrigationHumidity =>
      'Increase watering and air humidity';

  @override
  String get agroRecIncreaseWateringFrequency => 'Increase watering frequency';

  @override
  String get agroRecHighEtcCheckSoil =>
      'High ETC, check soil moisture and irrigation';

  @override
  String get agroRecIntenseMonitoring => 'Conduct more intensive monitoring';

  @override
  String get agroRecConsultAgronomist => 'Consult with an agronomist';

  @override
  String get monitoringSensorByTypeTitle => 'Sensors by Type';

  @override
  String get monitoringNoRegisteredSensors => 'No registered sensors yet';

  @override
  String get monitoringNoSensorData => 'No sensor data yet';

  @override
  String get monitoringDistributionByTypeTitle => 'Distribution by Type';

  @override
  String get monitoringPlantCompositionSubtitle =>
      'Active site plant composition';

  @override
  String get monitoringAverageGrowthPhase => 'Average Growth Phase';

  @override
  String get agroSelectSiteMessage =>
      'Select a site first to view agro data (VPD, GDD, ETc).';

  @override
  String get agroActionRecommendationTitle => 'Action Recommendations';

  @override
  String get agroPlantingPhaseTitle => 'Planting Phase';

  @override
  String get agroInformationTitle => 'Information';

  @override
  String get agroAboutTitle => 'About Agro Indicator';

  @override
  String get agroVdpDescription =>
      'Measures the vapor pressure deficit. Optimal value: 0.4-1.2 kPa. Low VPD (<0.4) increases disease risk, while high VPD (>1.6) causes water stress.';

  @override
  String get agroGddDescription =>
      'Accumulated temperature needed by plants to grow. Used to predict growth phases and harvest timing.';

  @override
  String get agroEtcDescription =>
      'Plant water requirement based on evaporation and transpiration. Helps determine optimal watering schedule and volume.';

  @override
  String get agroVdpTitle => 'Vapor Pressure Deficit';

  @override
  String get agroGddTitle => 'Growing Degree Days';

  @override
  String get agroEtcTitle => 'Evapotranspiration';

  @override
  String get agroSmartRecommendation => 'Smart Recommendation';

  @override
  String get agroNoCriticalRecommendations =>
      'No critical recommendations at this time';

  @override
  String get agroRecommendationSubtitle => 'Actions based on AI & Data';

  @override
  String get agroWateringRecommendation => 'Watering Recommendation';

  @override
  String get agroWaterRequirement => 'Crop Water Requirement';

  @override
  String get agroEtcTrend7Days => 'ETC Trend (7 Days)';

  @override
  String get agroDailyClimateDetail => 'Daily Climate Details';

  @override
  String get agroTableDate => 'Date';

  @override
  String get agroTableTemp => 'Temp (Min-Max)';

  @override
  String get agroTableRh => 'RH (Min-Max)';

  @override
  String get agroEtcDataUnavailable => 'ETC data is unavailable';

  @override
  String get agroUnitMmPerDay => 'mm/day';

  @override
  String get agroUnitCoefficient => 'coefficient';

  @override
  String get agroWaterNeedsLabel => 'Water Needs';

  @override
  String get agroRecWaterNeedsLow =>
      'Low water requirement. Minimal or no watering required.';

  @override
  String get agroRecWaterNeedsMedium =>
      'Medium water requirement. Perform routine watering according to schedule.';

  @override
  String get agroRecWaterNeedsHigh =>
      'High water requirement. Increase watering frequency.';

  @override
  String get agroRecWaterNeedsVeryHigh =>
      'Very high water requirement! Intensive watering required.';

  @override
  String get agroStatusEtc => 'ETC Status';

  @override
  String get agroRecEtcLow =>
      'Low ETC. Plant evapotranspiration requirement is light.';

  @override
  String get agroRecEtcMedium =>
      'ETC is in the medium range. Monitor moisture and irrigation schedules.';

  @override
  String get agroRecEtcHigh =>
      'High ETC. Check soil moisture and irrigation readiness.';

  @override
  String get adminLoadingTitle => 'Loading...';

  @override
  String get adminEditUserTitle => 'Edit User';

  @override
  String get adminAddUserTitle => 'Add User';

  @override
  String get adminEditUnitTitle => 'Edit Unit';

  @override
  String get adminAddUnitTitle => 'Add Unit';

  @override
  String get adminEditDeviceTitle => 'Edit Device';

  @override
  String get adminAddDeviceTitle => 'Add Device';

  @override
  String get adminEditSensorTitle => 'Edit Sensor';

  @override
  String get adminAddSensorTitle => 'Add Sensor';

  @override
  String get adminEditPlantTitle => 'Edit Plant';

  @override
  String get adminAddPlantTitle => 'Add Plant';

  @override
  String get adminEditRoleTitle => 'Edit Role';

  @override
  String get adminAddRoleTitle => 'Add Role';

  @override
  String get adminEditDeviceSensorTitle => 'Edit Device Sensor';

  @override
  String get adminAddDeviceSensorTitle => 'Add Device Sensor';

  @override
  String get adminSavingChanges => 'Saving changes...';

  @override
  String get adminCreatingUser => 'Creating user...';

  @override
  String get adminCreatingUnit => 'Creating unit...';

  @override
  String get adminCreatingDevice => 'Creating device...';

  @override
  String get adminCreatingSensor => 'Creating sensor...';

  @override
  String get adminCreatingPlant => 'Creating plant...';

  @override
  String get adminCreatingRole => 'Creating role...';

  @override
  String get adminCreatingMapping => 'Creating mapping...';

  @override
  String get adminAccountInfoSection => 'Account Information';

  @override
  String get adminSecuritySection => 'Security';

  @override
  String get adminRoleStatusSection => 'Role & Status';

  @override
  String get adminBasicInfoSection => 'Basic Information';

  @override
  String get adminUnitInfoSection => 'Unit Information';

  @override
  String get adminPlantInfoSection => 'Plant Information';

  @override
  String get adminPlantingDateSection => 'Planting Date';

  @override
  String get adminRoleInfoSection => 'Role Information';

  @override
  String get adminRolePermissionSection => 'Role Permissions';

  @override
  String get adminConnectionSection => 'Connection';

  @override
  String get adminConnectionSubtitle => 'Optional - device IP address and port';

  @override
  String get adminCoordinatesSection => 'Coordinates';

  @override
  String get adminDeviceCoordinateSubtitle =>
      'Optional - for mapping the device location';

  @override
  String get adminSensorCoordinateSubtitle =>
      'Optional - for mapping the sensor location';

  @override
  String get adminConfigurationSection => 'Configuration';

  @override
  String get adminStatusSection => 'Status';

  @override
  String get adminMappingInfoSection => 'Mapping Information';

  @override
  String get adminThresholdSection => 'Threshold';

  @override
  String get adminThresholdSubtitle => 'Sensor value threshold configuration';

  @override
  String get adminUserIdLabel => 'User ID';

  @override
  String get adminUserIdHint => 'Example: USER001';

  @override
  String get adminUserIdRequired => 'User ID is required';

  @override
  String get adminFullNameHint => 'Example: John Doe';

  @override
  String get adminEmailHint => 'Example: user@example.com';

  @override
  String get adminPhoneHint => 'Example: 081234567890';

  @override
  String get adminRoleLabel => 'Role';

  @override
  String get adminSelectRoleHint => 'Select a role';

  @override
  String get adminRoleRequired => 'Role is required';

  @override
  String get adminSelectStatusHint => 'Select a status';

  @override
  String get adminPasswordLabel => 'Password';

  @override
  String get adminPasswordHint => 'At least 6 characters';

  @override
  String get adminPasswordRequired => 'Password is required';

  @override
  String get adminPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get adminUnitIdLabel => 'Unit ID';

  @override
  String get adminUnitIdHint => 'Example: TEMP_C';

  @override
  String get adminUnitIdRequired => 'Unit ID is required';

  @override
  String get adminUnitNameLabel => 'Unit Name';

  @override
  String get adminUnitNameHint => 'Example: Celsius';

  @override
  String get adminUnitNameRequired => 'Unit name is required';

  @override
  String get adminUnitSymbolLabel => 'Symbol';

  @override
  String get adminUnitSymbolHint => 'Example: C';

  @override
  String get adminUnitSymbolRequired => 'Symbol is required';

  @override
  String get adminUnitDescriptionHint =>
      'Example: Temperature unit in degrees Celsius';

  @override
  String get adminSensorIdLabel => 'Sensor ID';

  @override
  String get adminSensorIdHint => 'Example: soil_nitro';

  @override
  String get adminSensorIdRequired => 'Sensor ID is required';

  @override
  String get adminSensorNameLabel => 'Sensor Name';

  @override
  String get adminSensorNameHint => 'Example: Nitrogen Sensor';

  @override
  String get adminSensorNameRequired => 'Sensor name is required';

  @override
  String get adminSensorAddressLabel => 'Sensor Address';

  @override
  String get adminSensorAddressHint => 'Example: 0x10';

  @override
  String get adminSensorLocationHint => 'Example: Soil Layer 1';

  @override
  String get adminSelectDeviceOptional => 'Select a device (optional)';

  @override
  String get adminNoDevice => 'No device';

  @override
  String get adminLoadDeviceFailed => 'Failed to load devices';

  @override
  String get adminDeviceRequired => 'Device is required';

  @override
  String get adminDeviceIdHint => 'Example: DEV001';

  @override
  String get adminDeviceNameHint => 'Example: Main Gateway';

  @override
  String get adminDeviceLocationHint => 'Example: Greenhouse A';

  @override
  String get adminIpInvalid => 'Invalid IP';

  @override
  String get adminPlantIdLabel => 'Plant ID';

  @override
  String get adminServerIdHint => 'Server ID';

  @override
  String get adminPlantNameLabel => 'Plant Name';

  @override
  String get adminPlantNameHint => 'Example: Rice Field Block A';

  @override
  String get adminPlantNameRequired => 'Plant name is required';

  @override
  String get adminCropTypeLabel => 'Plant Type';

  @override
  String get adminSelectCropTypeHint => 'Select a plant type';

  @override
  String get adminCropTypeRequired => 'Plant type is required';

  @override
  String get adminVarietasIdLabel => 'Variety ID';

  @override
  String get adminVarietasIdHint => 'Example: VAR_001';

  @override
  String get adminVarietasIdRequired => 'Variety ID is required';

  @override
  String get adminChooseVarietasFromList => 'Choose from the variety list';

  @override
  String get adminVarietasLabel => 'Variety';

  @override
  String get adminSelectVarietasHint => 'Select a variety from the backend';

  @override
  String get adminVarietasRequired => 'Variety is required';

  @override
  String get adminVarietasLoadFailedManual =>
      'Failed to load varieties. Use manual input.';

  @override
  String get adminManualIdInput => 'Manual ID input';

  @override
  String get adminSelectPlantingDate => 'Select planting date';

  @override
  String get adminPlantingDateRequired => 'Planting date is required';

  @override
  String get adminRoleIdLabel => 'Role ID';

  @override
  String get adminRoleIdHint => 'Example: ROLE001';

  @override
  String get adminRoleIdRequired => 'Role ID is required';

  @override
  String get adminRoleNameLabel => 'Role Name';

  @override
  String get adminRoleNameHint => 'Example: Admin, Operator, Viewer';

  @override
  String get adminRoleNameRequired => 'Role name is required';

  @override
  String get adminRoleDescriptionHint =>
      'Example: Role for system administrators';

  @override
  String get adminDsIdLabel => 'DS ID';

  @override
  String get adminDsIdHint => 'Example: DS001';

  @override
  String get adminDsIdRequired => 'DS ID is required';

  @override
  String get adminMappingNameHint => 'Example: Nitrogen Sensor DEV001';

  @override
  String get adminNameRequired => 'Name is required';

  @override
  String get adminSelectDeviceHint => 'Select a device';

  @override
  String get adminSelectSensorOptional => 'Select a sensor (optional)';

  @override
  String get adminSelectUnitOptional => 'Select a unit (optional)';

  @override
  String get adminLoadSensorFailed => 'Failed to load sensors';

  @override
  String get adminLoadUnitFailed => 'Failed to load units';

  @override
  String get adminNoSelection => 'None';

  @override
  String get adminAddressLabel => 'Address';

  @override
  String get adminSequenceLabel => 'Order (Seq)';

  @override
  String get adminSequenceHint => 'Example: 1';

  @override
  String get adminNormalValueLabel => 'Normal Value';

  @override
  String get adminExampleDecimalHint => 'Example: 25.0';

  @override
  String get adminMinNormalLabel => 'Min Normal';

  @override
  String get adminMaxNormalLabel => 'Max Normal';

  @override
  String get adminMinAbsoluteLabel => 'Min Absolute';

  @override
  String get adminMaxAbsoluteLabel => 'Max Absolute';

  @override
  String get adminMinWarningLabel => 'Min Warning';

  @override
  String get adminMaxWarningLabel => 'Max Warning';

  @override
  String get adminStatusUserLabel => 'User Status';

  @override
  String get adminStatusUnitLabel => 'Unit Status';

  @override
  String get adminStatusDeviceLabel => 'Device Status';

  @override
  String get adminStatusSensorLabel => 'Sensor Status';

  @override
  String get adminStatusPlantLabel => 'Plant Status';

  @override
  String get adminStatusRoleLabel => 'Role Status';

  @override
  String get adminStatusMappingLabel => 'Mapping Status';

  @override
  String adminUpdateSuccess(String item) {
    return '$item updated successfully';
  }

  @override
  String adminCreateSuccess(String item) {
    return '$item added successfully';
  }

  @override
  String adminSaveFailed(String item) {
    return 'Failed to save $item';
  }

  @override
  String get adminMinNormalGreaterThanMaxNormal =>
      'Min Normal cannot be greater than Max Normal';

  @override
  String get adminMinAbsoluteGreaterThanMaxAbsolute =>
      'Min Absolute cannot be greater than Max Absolute';

  @override
  String get adminMinWarningGreaterThanMaxWarning =>
      'Min Warning cannot be greater than Max Warning';

  @override
  String get adminMinAbsoluteGreaterThanMinNormal =>
      'Min Absolute cannot be greater than Min Normal';

  @override
  String get adminMinAbsoluteGreaterThanMinWarning =>
      'Min Absolute cannot be greater than Min Warning';

  @override
  String get adminMaxAbsoluteLessThanMaxNormal =>
      'Max Absolute cannot be less than Max Normal';

  @override
  String get adminMaxAbsoluteLessThanMaxWarning =>
      'Max Absolute cannot be less than Max Warning';

  @override
  String get adminMinWarningGreaterThanMinNormal =>
      'Min Warning cannot be greater than Min Normal';

  @override
  String get adminMaxWarningLessThanMaxNormal =>
      'Max Warning cannot be less than Max Normal';

  @override
  String get adminFullNameLabel => 'Full Name';

  @override
  String get adminEmailLabel => 'Email';

  @override
  String get adminPhoneLabel => 'Phone Number';

  @override
  String get adminEmailInvalid => 'Invalid email format';

  @override
  String get adminPhoneInvalid => 'Invalid phone number';

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
  String get adminDeviceIdRequired => 'Device ID is required';

  @override
  String get adminDeviceNameLabel => 'Device Name';

  @override
  String get adminDeviceNameRequired => 'Device name is required';

  @override
  String get adminIpAddressLabel => 'IP Address';

  @override
  String get adminPortLabel => 'Port';

  @override
  String get adminAltitudeLabel => 'Altitude (meters)';

  @override
  String recommendationHstRangeLabel(int min, int max) {
    return 'DAP $min-$max';
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
  String get sensorTypeAirTemperature => 'Air Temperature';

  @override
  String get sensorTypeAirHumidity => 'Air Humidity';

  @override
  String get sensorTypeSoilMoisture => 'Soil Moisture';

  @override
  String get sensorTypeSoilPh => 'Soil pH';

  @override
  String get sensorTypeSoilNitrogen => 'Soil Nitrogen';

  @override
  String get sensorTypeSoilPhosphorus => 'Soil Phosphorus';

  @override
  String get sensorTypeSoilPotassium => 'Soil Potassium';

  @override
  String get sensorTypeLightIntensity => 'Light Intensity';

  @override
  String get sensorTypeAtmosphericPressure => 'Atmospheric Pressure';

  @override
  String get sensorTypeWindSpeed => 'Wind Speed';

  @override
  String get agroVdpDeficitTitle => 'Vapor Pressure Deficit';

  @override
  String get agroVdpValueLabel => 'VPD Value';

  @override
  String get agroVdpRangeLabel => 'VPD Range';

  @override
  String get agroVdpDetailTitle => 'VPD Detail';

  @override
  String get agroVdpUnavailable => 'VPD data unavailable';

  @override
  String get agroVdpStatusLow => 'Too Low';

  @override
  String get agroVdpStatusOptimal => 'Optimal';

  @override
  String get agroVdpStatusWarning => 'Warning';

  @override
  String get agroVdpStatusHigh => 'Too High';

  @override
  String get agroVdpDescLow =>
      'Relative humidity is high. Increase ventilation to lower disease risk.';

  @override
  String get agroVdpDescOptimal =>
      'Vapor pressure deficit condition is in the ideal range.';

  @override
  String get agroVdpDescWarning =>
      'Plant is starting to lose water faster. Monitor irrigation and humidity.';

  @override
  String get agroVdpDescHigh =>
      'High vapor pressure deficit. Increase watering and maintain humidity of planting area.';

  @override
  String get agroGddSuhuAccumLabel => 'Accumulated Growth Temperature';

  @override
  String get agroGddTotalLabel => 'Total GDD';

  @override
  String get agroGddAccumLabel => 'Accumulation';

  @override
  String get agroGddDailyChartTitle => 'Daily GDD (Last 7 Days)';

  @override
  String get agroGddDetailTitle => 'Daily GDD Details';

  @override
  String get agroGddUnavailable => 'GDD data unavailable';

  @override
  String get plantGrowthPhaseTitle => 'Growth Phase';

  @override
  String get plantActivePhaseDesc => 'Current active phase of the plant';

  @override
  String get plantTimeProgressLabel => 'Time Progress';

  @override
  String get plantGrowthPhaseUnavailable =>
      'Growth phase data not available yet';

  @override
  String get commonNotAvailableYet => 'None';

  @override
  String get agroGddTrackingNoData => 'No GDD data yet';

  @override
  String get agroGddTrackingNoDataDesc =>
      'GDD data will be fetched from Agro API after active plants are registered in this site.';

  @override
  String get agroGddTrackingSummaryTitle => 'GDD Summary';

  @override
  String get agroGddTrackingTotalReal => 'Total GDD (Real)';

  @override
  String get agroGddTrackingFieldProgress => 'Field Progress';

  @override
  String get agroGddTrackingDurationTitle => 'DAP Duration by Phase';

  @override
  String get agroGddTrackingDurationSubtitle =>
      'Days After Planting duration by growth phase';

  @override
  String get agroGddTrackingDurationDetailTitle => 'Detailed Duration by Phase';

  @override
  String get agroGddTrackingDurationDetailSubtitle =>
      'Detailed breakdown of duration for each growth phase';

  @override
  String get agroGddTrackingTablePhase => 'Phase';

  @override
  String get agroGddTrackingTableCurrentHst => 'Current DAP';

  @override
  String get agroGddTrackingTableDuration => 'Duration';

  @override
  String get profilePermissionsLoadError => 'Failed to load permissions';

  @override
  String get profilePermissionsNoAccess => 'No Access';

  @override
  String get profilePermissionsNoAccessDesc => 'No permissions available yet';

  @override
  String get profilePermissionsSystemAccess => 'System Permissions';

  @override
  String get permissionActionRead => 'Read';

  @override
  String get permissionActionCreate => 'Create';

  @override
  String get permissionActionUpdate => 'Update';

  @override
  String get permissionActionDelete => 'Delete';

  @override
  String get permissionActionManage => 'Manage';

  @override
  String get sensorEditTitle => 'Edit Sensor';

  @override
  String get sensorNameLabel => 'Sensor Name';

  @override
  String get sensorNameRequired => 'Sensor name is required';

  @override
  String get sensorTypeRequired => 'Sensor type is required';

  @override
  String get sensorUnitRequired => 'Unit is required';

  @override
  String get sensorUnitHint => 'Example: °C, %, pH';

  @override
  String get sensorDescLabel => 'Description (Optional)';

  @override
  String get sensorDescHint => 'Enter sensor description';

  @override
  String get sensorStatusActiveLabel => 'Active Status';

  @override
  String get sensorStatusActiveDesc => 'Sensor active';

  @override
  String get sensorStatusInactiveDesc => 'Sensor inactive';

  @override
  String get sensorUpdatedSuccess => 'Sensor updated successfully';

  @override
  String get sensorCreatedSuccess => 'Sensor added successfully';

  @override
  String get commonOptimal => 'Optimal';

  @override
  String get commonWarning => 'Warning';

  @override
  String get commonNitrogen => 'Nitrogen';

  @override
  String get commonPhosphorus => 'Phosphorus';

  @override
  String get commonPotassium => 'Potassium';

  @override
  String get monitoringActionRequiredTitle => 'Action Required';

  @override
  String get monitoringNoSensorConfiguredDesc =>
      'No sensor parameters can be evaluated yet. Check the configuration and latest sensor data.';

  @override
  String get monitoringPlantCompositionTitle => 'Distribution by Type';

  @override
  String get monitoringChartTypeLabel => 'Chart Type';

  @override
  String get monitoringChartTypeLine => 'Line';

  @override
  String get monitoringChartTypeBar => 'Bar';

  @override
  String get monitoringChartTypeArea => 'Area';

  @override
  String get monitoringDailyNoAggregationDesc =>
      'No aggregation data for this range';

  @override
  String get monitoringRangeToday => 'Today';

  @override
  String get monitoringRangeLast7Days => 'Last 7 days';

  @override
  String get monitoringRangeLast30Days => 'Last 30 days';

  @override
  String get monitoringRangeCustom => 'Custom range';

  @override
  String monitoringDataPointsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'data points',
      one: 'data point',
    );
    return '$count $_temp0';
  }

  @override
  String get monitoringFilterThirtyDay => '30 Days';

  @override
  String get monitoringFilterCustom => 'Custom';

  @override
  String get monitoringRangeLabel => 'Range';

  @override
  String monitoringActiveAlarmsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alarms',
      one: 'Alarm',
    );
    return '$count Active $_temp0';
  }

  @override
  String get monitoringDetectedInLast24Hours => 'Detected in the last 24 hours';

  @override
  String monitoringOtherAlarmsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alarms',
      one: 'alarm',
    );
    return '+ $count other $_temp0';
  }

  @override
  String get monitoringCloseLog => 'Close Log';

  @override
  String monitoringShowAllLogsCount(int count) {
    return 'Show All Logs ($count)';
  }

  @override
  String get monitoringChartDescLine => 'Sensor trend over time';

  @override
  String get monitoringChartDescBar => 'Sensor value comparison over time';

  @override
  String get monitoringChartDescArea => 'Sensor changes with area trend';

  @override
  String get agroIndicatorLabel => 'Agro Indicator';

  @override
  String get environmentalHealthScore => 'Environmental Health Score';

  @override
  String get gddCDaysUnit => 'C-days';

  @override
  String get etcLitrePerSqmUnit => 'L/m²';

  @override
  String get commonFair => 'Fair';

  @override
  String get commonPoor => 'Poor';

  @override
  String dashboardWelcomeUser(String userName) {
    return 'Hello, $userName';
  }

  @override
  String get dashboardSelectSitePrompt =>
      'Select a site to load monitoring and recommendation data';

  @override
  String get dashboardNoSensorReadings => 'No sensor readings yet';

  @override
  String dashboardActiveSensorsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Parameters',
      one: 'Parameter',
    );
    return '$count $_temp0 Monitored';
  }

  @override
  String get dashboardRecentActivities => 'Recent Activities';

  @override
  String get dashboardNoActivities => 'No activities yet';

  @override
  String get dashboardTaskSummaryTitle => 'Task Summary';

  @override
  String get dashboardCompletionRateLabel => 'Completion Rate';

  @override
  String dashboardShowOtherSensors(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'parameters',
      one: 'parameter',
    );
    return 'Show $count other $_temp0';
  }

  @override
  String get dashboardAverageLabel => 'Avg';

  @override
  String get commonViewAll => 'View All';

  @override
  String get commonHide => 'Hide';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return '$count $_temp0 ago';
  }

  @override
  String timeHoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return '$count $_temp0 ago';
  }

  @override
  String timeDaysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$count $_temp0 ago';
  }

  @override
  String get recommendationReasonLabel => 'Reason';

  @override
  String profilePermissionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count permissions',
      one: '1 permission',
    );
    return '$_temp0';
  }

  @override
  String get errorNetwork =>
      'Connection unstable. Please check your internet connection and try again.';

  @override
  String get errorServer =>
      'The server cannot load data at the moment. Please try again later.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get errorDataNotFound => 'No data found for this site.';

  @override
  String get errorLoadFailed => 'Failed to load data. Please try again.';
}
