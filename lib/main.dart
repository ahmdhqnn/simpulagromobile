import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'core/providers/app_startup_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Jalankan secara paralel — keduanya tidak saling bergantung
  final results = await Future.wait([
    initializeDateFormatting('id_ID', null),
    initializeDateFormatting('en_US', null),
    preloadAppData(),
  ]);

  final startupData = results[2] as AppStartupData;

  runApp(
    ProviderScope(
      overrides: [
        // Inject data yang sudah dibaca ke provider
        // sehingga tidak perlu baca storage lagi saat build
        appStartupDataProvider.overrideWithValue(startupData),
      ],
      child: const AgroApp(),
    ),
  );
}
