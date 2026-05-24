import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/plant/domain/plant_type_validator.dart';
import 'package:simpulagromobile/features/plant/domain/entities/plant.dart';
import 'package:simpulagromobile/core/error/failures.dart';

void main() {
  late PlantTypeValidator validator;

  setUp(() => validator = PlantTypeValidator());

  group('PlantTypeValidator.validatePlantType', () {
    test('returns Right(CropType.PADI) for "PADI"', () {
      final result = validator.validatePlantType('PADI');
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (t) => expect(t, CropType.PADI),
      );
    });

    test('returns Right(CropType.JAGUNG) for "JAGUNG"', () {
      final result = validator.validatePlantType('JAGUNG');
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (t) => expect(t, CropType.JAGUNG),
      );
    });

    test('returns Right(CropType.KEDELAI) for "KEDELAI"', () {
      final result = validator.validatePlantType('KEDELAI');
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (t) => expect(t, CropType.KEDELAI),
      );
    });

    test('is case-insensitive — accepts "padi"', () {
      final result = validator.validatePlantType('padi');
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (t) => expect(t, CropType.PADI),
      );
    });

    test('is case-insensitive — accepts "Jagung"', () {
      final result = validator.validatePlantType('Jagung');
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (t) => expect(t, CropType.JAGUNG),
      );
    });

    test('returns Left(ValidationFailure) for unknown type', () {
      final result = validator.validatePlantType('GANDUM');
      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(ValidationFailure) for null', () {
      final result = validator.validatePlantType(null);
      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(ValidationFailure) for empty string', () {
      final result = validator.validatePlantType('');
      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('PlantTypeValidator.isValidType', () {
    test(
      'returns true for "PADI"',
      () => expect(validator.isValidType('PADI'), true),
    );
    test(
      'returns true for "JAGUNG"',
      () => expect(validator.isValidType('JAGUNG'), true),
    );
    test(
      'returns true for "KEDELAI"',
      () => expect(validator.isValidType('KEDELAI'), true),
    );
    test(
      'returns true for lowercase "padi"',
      () => expect(validator.isValidType('padi'), true),
    );
    test(
      'returns false for unknown type',
      () => expect(validator.isValidType('GANDUM'), false),
    );
    test(
      'returns false for null',
      () => expect(validator.isValidType(null), false),
    );
    test(
      'returns false for empty string',
      () => expect(validator.isValidType(''), false),
    );
  });
}
