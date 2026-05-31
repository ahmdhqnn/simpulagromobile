import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final featureDartFiles = Directory('lib/features')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .where((file) => !file.path.endsWith('.g.dart'))
      .where((file) => !file.path.endsWith('.freezed.dart'))
      .toList();

  test('domain layer is independent from Flutter, Dio, and parser code', () {
    final violations = <String>[];

    for (final file in featureDartFiles.where(_isDomainFile)) {
      final content = file.readAsStringSync();
      for (final forbidden in [
        "package:flutter",
        "package:dio",
        "ResponseParser",
        "dart:ui",
        "dart:io",
      ]) {
        if (content.contains(forbidden)) {
          violations.add('${file.path} imports or references $forbidden');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('data layer does not depend on Flutter UI/runtime packages', () {
    final violations = <String>[];

    for (final file in featureDartFiles.where(_isDataFile)) {
      final content = file.readAsStringSync();
      if (content.contains("package:flutter")) {
        violations.add('${file.path} imports package:flutter');
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test(
    'screens and widgets do not call datasources or HTTP clients directly',
    () {
      final violations = <String>[];

      for (final file in featureDartFiles.where(_isPresentationSurfaceFile)) {
        final content = file.readAsStringSync();
        for (final forbidden in [
          "RemoteDatasource",
          "RemoteDataSource",
          "Datasource",
          "DataSource",
          "datasourceProvider",
          ".get(",
          ".post(",
          ".put(",
          ".patch(",
          ".delete(",
        ]) {
          if (content.contains(forbidden)) {
            violations.add('${file.path} references $forbidden');
          }
        }
      }

      expect(violations, isEmpty, reason: violations.join('\n'));
    },
  );
}

bool _isDomainFile(File file) {
  return _normalized(file).contains('/domain/');
}

bool _isDataFile(File file) {
  return _normalized(file).contains('/data/');
}

bool _isPresentationSurfaceFile(File file) {
  final path = _normalized(file);
  return path.contains('/presentation/screens/') ||
      path.contains('/presentation/widgets/');
}

String _normalized(File file) => file.path.replaceAll('\\', '/');
