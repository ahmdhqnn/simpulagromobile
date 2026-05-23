# Agro UseCase Layer - Implementation Summary

## Overview
The UseCase layer for the Agro feature has been implemented following Clean Architecture principles and the Riverpod-based state management pattern.

## Structure

```
lib/features/agro/domain/usecases/
├── get_agro_data_usecase.dart  (Main data retrieval)
├── get_vdp_usecase.dart         (VDP-specific logic)
├── get_gdd_usecase.dart         (GDD-specific logic)
├── get_etc_usecase.dart         (ETC-specific logic)
└── usecases.dart                (Barrel export)
```

## Implementation Details

### Pattern Used
- **Class per UseCase**: Each use case has its own class
- **Dependency Injection**: Repository injected via constructor
- **Return Type**: `Future<Either<Failure, T>>` using dartz
- **Error Handling**: Consistent failure mapping through repository

### UseCase Classes

#### GetAgroDataUseCase
- **Purpose**: Retrieve complete agro data (VDP, GDD, ETC combined)
- **Input**: `siteId: String`
- **Output**: `Future<Either<Failure, AgroModel>>`
- **Usage**: For dashboard or overview screens

#### GetVdpUseCase
- **Purpose**: Retrieve Vapor Pressure Deficit (VDP) data
- **Input**: `siteId: String`
- **Output**: `Future<Either<Failure, VdpModel>>`
- **Data**: VDP value, status, temperature, humidity, and descriptive data
- **Use Case**: Crop health monitoring and disease prediction

#### GetGddUseCase
- **Purpose**: Retrieve Growing Degree Days (GDD) data
- **Input**: `siteId: String`
- **Output**: `Future<Either<Failure, GddModel>>`
- **Data**: Total GDD and daily breakdown with min/max temperatures
- **Use Case**: Crop development prediction and harvest planning

#### GetEtcUseCase
- **Purpose**: Retrieve Evapotranspiration (ETC) data
- **Input**: `siteId: String`
- **Output**: `Future<Either<Failure, List<EtcDailyModel>>>`
- **Data**: Daily ETC values with temperature, humidity, and water needs
- **Use Case**: Irrigation management and water conservation

## Repository Enhancements

### AgroRepository (Abstract)
Added method signatures:
```dart
Future<Either<Failure, VdpModel>> getVdpData(String siteId);
Future<Either<Failure, GddModel>> getGddData(String siteId);
Future<Either<Failure, List<EtcDailyModel>>> getEtcData(String siteId);
```

### AgroRepositoryImpl (Implementation)
- Implemented all methods with proper error handling
- Uses `DioException.toFailure()` for API error mapping
- Returns `NotFoundFailure` when data is unavailable
- Returns `UnknownFailure` for unexpected errors

## Integration Points

### Error Handling
- Network errors: `NetworkFailure`
- Server errors: `ServerFailure` (with status code)
- Data not found: `NotFoundFailure`
- Unexpected errors: `UnknownFailure`

### Data Models
Uses existing models from `data/models/agro_model.dart`:
- `AgroModel`
- `VdpModel`
- `GddModel`
- `GddDailyModel`
- `EtcDailyModel`

## Next Steps for Presentation Layer

When implementing Presentation/UI layer with Riverpod:

```dart
// Example provider using the UseCase
final getAgroDataProvider = FutureProvider<AgroModel>((ref) async {
  final useCase = ref.watch(getAgroDataUseCaseProvider);
  final result = await useCase('site-id');
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

// Providers for each UseCase (in providers/agro_providers.dart)
final getAgroDataUseCaseProvider = Provider((ref) {
  final repository = ref.watch(agroRepositoryProvider);
  return GetAgroDataUseCase(repository);
});

final getVdpUseCaseProvider = Provider((ref) {
  final repository = ref.watch(agroRepositoryProvider);
  return GetVdpUseCase(repository);
});

final getGddUseCaseProvider = Provider((ref) {
  final repository = ref.watch(agroRepositoryProvider);
  return GetGddUseCase(repository);
});

final getEtcUseCaseProvider = Provider((ref) {
  final repository = ref.watch(agroRepositoryProvider);
  return GetEtcUseCase(repository);
});
```

## Files Modified

1. `lib/features/agro/domain/repositories/agro_repository.dart` - Added method signatures
2. `lib/features/agro/data/repositories/agro_repository_impl.dart` - Implemented all methods

## Files Created

1. `lib/features/agro/domain/usecases/get_agro_data_usecase.dart`
2. `lib/features/agro/domain/usecases/get_vdp_usecase.dart`
3. `lib/features/agro/domain/usecases/get_gdd_usecase.dart`
4. `lib/features/agro/domain/usecases/get_etc_usecase.dart`
5. `lib/features/agro/domain/usecases/usecases.dart`

## Status
✅ UseCase layer implementation complete and ready for Riverpod integration
