/// Summary models untuk dashboard cards
/// Data dari API: devices, sensors, plants

class DashboardDeviceSummary {
  final int total;
  final int active;

  const DashboardDeviceSummary({required this.total, required this.active});

  int get inactive => total - active;
}

class DashboardSensorSummary {
  final int total;
  final int active;

  const DashboardSensorSummary({required this.total, required this.active});

  int get inactive => total - active;
}

class DashboardPlantSummary {
  final int total;
  final int active;

  const DashboardPlantSummary({required this.total, required this.active});
}
