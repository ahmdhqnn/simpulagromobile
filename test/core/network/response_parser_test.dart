import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/core/network/response_parser.dart';
import 'package:simpulagromobile/core/error/exceptions.dart';

void main() {
  group('ResponseParser Tests', () {
    group('extractDataMap', () {
      test('extracts map from flat response', () {
        final raw = {'foo': 'bar'};
        final result = ResponseParser.extractDataMap(raw);
        expect(result, equals({'foo': 'bar'}));
      });

      test('extracts map from single-nested response', () {
        final raw = {
          'data': {'foo': 'bar'},
        };
        final result = ResponseParser.extractDataMap(raw);
        expect(result, equals({'foo': 'bar'}));
      });

      test('extracts map from double-nested response', () {
        final raw = {
          'data': {
            'status': 200,
            'data': {'foo': 'bar'},
          },
        };
        final result = ResponseParser.extractDataMap(raw);
        expect(result, equals({'foo': 'bar'}));
      });

      test('throws ServerException if data is null', () {
        expect(
          () => ResponseParser.extractDataMap(null),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws ServerException if data is not a Map', () {
        expect(
          () => ResponseParser.extractDataMap([1, 2, 3]),
          throwsA(isA<ServerException>()),
        );
      });

      test('returns empty map for empty data list envelope', () {
        final raw = {'success': true, 'data': <dynamic>[]};
        final result = ResponseParser.extractDataMap(raw);
        expect(result, isEmpty);
      });

      test('extracts first map from singleton data list envelope', () {
        final raw = {
          'success': true,
          'data': [
            {'foo': 'bar'},
          ],
        };
        final result = ResponseParser.extractDataMap(raw);
        expect(result, equals({'foo': 'bar'}));
      });
    });

    group('extractDataList', () {
      test('extracts list from List response', () {
        final raw = [1, 2, 3];
        final result = ResponseParser.extractDataList(raw);
        expect(result, equals([1, 2, 3]));
      });

      test('extracts list from single-nested response', () {
        final raw = {
          'data': [1, 2, 3],
        };
        final result = ResponseParser.extractDataList(raw);
        expect(result, equals([1, 2, 3]));
      });

      test('extracts list from double-nested response', () {
        final raw = {
          'data': {
            'status': 200,
            'data': [1, 2, 3],
          },
        };
        final result = ResponseParser.extractDataList(raw);
        expect(result, equals([1, 2, 3]));
      });

      test('returns single item list when map is provided instead of list', () {
        final raw = {
          'data': {'foo': 'bar'},
        };
        final result = ResponseParser.extractDataList(raw);
        expect(
          result,
          equals([
            {'foo': 'bar'},
          ]),
        );
      });

      test('extracts list from named collection envelope', () {
        final raw = {
          'data': {
            'plants': [
              {'plant_id': 'PLANT_001'},
            ],
          },
        };
        final result = ResponseParser.extractDataList(raw);
        expect(result, hasLength(1));
        expect(result.first, equals({'plant_id': 'PLANT_001'}));
      });

      test('extracts list from singular sensor collection envelope', () {
        final raw = {
          'data': {
            'sensor': [
              {'sens_id': 'SENS_001'},
            ],
          },
        };
        final result = ResponseParser.extractDataList(raw);
        expect(result, hasLength(1));
        expect(result.first, equals({'sens_id': 'SENS_001'}));
      });

      test('returns empty list for null responseData', () {
        final result = ResponseParser.extractDataList(null);
        expect(result, isEmpty);
      });
    });

    group('extractMessage', () {
      test('extracts message when key exists', () {
        final raw = {'message': 'Operation successful'};
        expect(
          ResponseParser.extractMessage(raw),
          equals('Operation successful'),
        );
      });

      test('extracts msg when msg key exists', () {
        final raw = {'msg': 'Operation successful'};
        expect(
          ResponseParser.extractMessage(raw),
          equals('Operation successful'),
        );
      });

      test('returns default message when keys not found', () {
        final raw = {'foo': 'bar'};
        expect(
          ResponseParser.extractMessage(raw, 'Default'),
          equals('Default'),
        );
      });

      test('extracts message from non-map and list message responses', () {
        expect(
          ResponseParser.extractMessage('Plain backend error', 'Default'),
          'Plain backend error',
        );
        expect(
          ResponseParser.extractMessage({
            'message': ['Name is required', 'Email is invalid'],
          }, 'Default'),
          'Name is required, Email is invalid',
        );
      });
    });

    group('extractPaginationMeta', () {
      test('extracts meta map when meta key exists', () {
        final raw = {
          'meta': {'page': 1, 'limit': 10},
        };
        expect(
          ResponseParser.extractPaginationMeta(raw),
          equals({'page': 1, 'limit': 10}),
        );
      });

      test('extracts flat page/limit/total pagination details', () {
        final raw = {'page': 2, 'limit': 20, 'total': 100, 'total_pages': 5};
        expect(
          ResponseParser.extractPaginationMeta(raw),
          equals({'page': 2, 'limit': 20, 'total': 100, 'total_pages': 5}),
        );
      });

      test('returns null when no pagination details exist', () {
        final raw = {'foo': 'bar'};
        expect(ResponseParser.extractPaginationMeta(raw), isNull);
      });
    });

    test('extracts nested pagination meta from data envelope', () {
      final raw = {
        'data': {
          'data': [],
          'meta': {'page': 3, 'limit': 25, 'total_pages': 8},
        },
      };

      expect(
        ResponseParser.extractPaginationMeta(raw),
        equals({'page': 3, 'limit': 25, 'total_pages': 8}),
      );
    });
  });
}
