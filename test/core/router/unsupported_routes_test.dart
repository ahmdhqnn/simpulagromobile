import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';

void main() {
  test('Konstanta unsupported tidak dipakai sebagai path aktif publik', () {
    // Endpoint yang belum didokumentasikan backend tetap dikunci sebagai unsupported.
    expect(ApiEndpoints.unsupportedUnitById('UNIT001'), '/sites/units/UNIT001');
    expect(
      ApiEndpoints.unsupportedUpdateUnit('UNIT001'),
      '/sites/units/update-unit/UNIT001',
    );
    expect(ApiEndpoints.siteNotes('SITE001'), '/sites/SITE001/notes');
    expect(
      ApiEndpoints.siteMemberInvite('SITE001'),
      '/sites/SITE001/members/invite',
    );
  });
}
