import 'package:dartz/dartz.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'entities/plant.dart';

/// Service to validate plant type strings and convert them to CropType enum
class PlantTypeValidator {
  /// Valid plant types as strings
  static const validTypes = ['PADI', 'JAGUNG', 'KEDELAI'];

  /// Validates a plant type string and returns a CropType or ValidationFailure
  /// 
  /// Returns Either<Failure, CropType> where:
  /// - Left: ValidationFailure if the type is unknown
  /// - Right: CropType enum value if valid
  Either<Failure, CropType> validatePlantType(String? typeStr) {
    // Handle null or empty input
    if (typeStr == null || typeStr.isEmpty) {
      return Left(
        ValidationFailure(
          'Plant type cannot be null or empty. Valid types: ${validTypes.join(", ")}',
        ),
      );
    }

    final upperType = typeStr.toUpperCase().trim();

    // Validate against allowed types
    if (!validTypes.contains(upperType)) {
      return Left(
        ValidationFailure(
          'Unknown plant type: "$typeStr". Valid types: ${validTypes.join(", ")}',
        ),
      );
    }

    // Convert string to enum
    try {
      final cropType = CropType.values.firstWhere(
        (e) => e.name == upperType,
      );
      return Right(cropType);
    } catch (e) {
      return Left(
        ValidationFailure(
          'Failed to parse plant type: "$typeStr"',
        ),
      );
    }
  }

  /// Checks if a type string is valid
  bool isValidType(String? type) {
    if (type == null || type.isEmpty) return false;
    return validTypes.contains(type.toUpperCase().trim());
  }
}
