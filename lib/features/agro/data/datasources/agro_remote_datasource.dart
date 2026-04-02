import 'package:dio/dio.dart';
import '../models/agro_model.dart';

class AgroRemoteDataSource {
  // ignore: unused_field
  final Dio _dio;

  AgroRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/agro
  Future<AgroModel> getAgroData(String siteId) async {
    // TODO: Replace with real API call when backend is ready
    await Future.delayed(const Duration(milliseconds: 800));
    return _getMockAgroData();

    /* Real API implementation:
    final response = await _dio.get('/sites/$siteId/agro');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return AgroModel.fromJson(data);
    */
  }

  AgroModel _getMockAgroData() {
    return AgroModel(
      vdp: const VdpModel(vdp: 0.85, status: 'optimal'),
      gdd: GddModel(
        totalGDD: 2250.5,
        daily: [
          const GddDailyModel(
            day: '2026-03-25',
            tempMin: 22.5,
            tempMax: 32.8,
            gdd: 17.65,
          ),
          const GddDailyModel(
            day: '2026-03-26',
            tempMin: 23.1,
            tempMax: 33.2,
            gdd: 18.15,
          ),
          const GddDailyModel(
            day: '2026-03-27',
            tempMin: 22.8,
            tempMax: 31.9,
            gdd: 17.35,
          ),
          const GddDailyModel(
            day: '2026-03-28',
            tempMin: 23.5,
            tempMax: 32.5,
            gdd: 18.0,
          ),
          const GddDailyModel(
            day: '2026-03-29',
            tempMin: 22.2,
            tempMax: 31.5,
            gdd: 16.85,
          ),
          const GddDailyModel(
            day: '2026-03-30',
            tempMin: 23.8,
            tempMax: 33.5,
            gdd: 18.65,
          ),
          const GddDailyModel(
            day: '2026-03-31',
            tempMin: 23.2,
            tempMax: 32.1,
            gdd: 17.65,
          ),
        ],
      ),
      etc: const [
        EtcDailyModel(
          day: '2026-03-31',
          tempMin: 23.2,
          tempMax: 32.1,
          rhMin: 65.0,
          rhMax: 85.0,
          etc: 4.8,
          kc: 1.15,
          waterNeeds: 5.52,
        ),
        EtcDailyModel(
          day: '2026-03-30',
          tempMin: 23.8,
          tempMax: 33.5,
          rhMin: 62.0,
          rhMax: 82.0,
          etc: 5.2,
          kc: 1.15,
          waterNeeds: 5.98,
        ),
        EtcDailyModel(
          day: '2026-03-29',
          tempMin: 22.2,
          tempMax: 31.5,
          rhMin: 68.0,
          rhMax: 88.0,
          etc: 4.5,
          kc: 1.12,
          waterNeeds: 5.04,
        ),
        EtcDailyModel(
          day: '2026-03-28',
          tempMin: 23.5,
          tempMax: 32.5,
          rhMin: 64.0,
          rhMax: 84.0,
          etc: 4.9,
          kc: 1.12,
          waterNeeds: 5.49,
        ),
        EtcDailyModel(
          day: '2026-03-27',
          tempMin: 22.8,
          tempMax: 31.9,
          rhMin: 66.0,
          rhMax: 86.0,
          etc: 4.6,
          kc: 1.10,
          waterNeeds: 5.06,
        ),
        EtcDailyModel(
          day: '2026-03-26',
          tempMin: 23.1,
          tempMax: 33.2,
          rhMin: 63.0,
          rhMax: 83.0,
          etc: 5.1,
          kc: 1.10,
          waterNeeds: 5.61,
        ),
        EtcDailyModel(
          day: '2026-03-25',
          tempMin: 22.5,
          tempMax: 32.8,
          rhMin: 65.0,
          rhMax: 85.0,
          etc: 4.7,
          kc: 1.08,
          waterNeeds: 5.08,
        ),
      ],
    );
  }
}
