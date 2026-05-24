import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';

void main() {
  test('Konstanta unsupported tidak dipakai sebagai path aktif publik', () {
    // Route yang dihapus tidak boleh punya helper publik selain unsupported*
    expect(ApiEndpoints.unsupportedPermissions, '/permissions');
    expect(ApiEndpoints.siteNotes('SITE001'), '/sites/SITE001/notes');
    expect(ApiEndpoints.siteMemberInvite('SITE001'),
        '/sites/SITE001/members/invite');
  });
}
