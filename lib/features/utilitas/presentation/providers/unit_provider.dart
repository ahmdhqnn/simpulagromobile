import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/unit_remote_datasource.dart';
import '../../data/repositories/unit_repository_impl.dart';
import '../../domain/entities/unit.dart';
import '../../domain/repositories/unit_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATASOURCE PROVIDER
// ═══════════════════════════════════════════════════════════
final unitRemoteDatasourceProvider = Provider<UnitRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UnitRemoteDatasourceImpl(dioClient.dio);
});

// ═══════════════════════════════════════════════════════════
// REPOSITORY PROVIDER
// ═══════════════════════════════════════════════════════════
final unitRepositoryProvider = Provider<UnitRepository>((ref) {
  final datasource = ref.watch(unitRemoteDatasourceProvider);
  return UnitRepositoryImpl(datasource);
});

// ═══════════════════════════════════════════════════════════
// UNIT LIST PROVIDER (global, no site context)
// ═══════════════════════════════════════════════════════════
final utilitasUnitListProvider = FutureProvider<List<Unit>>((ref) async {
  final repository = ref.watch(unitRepositoryProvider);
  return repository.getAllUnits();
});

// ═══════════════════════════════════════════════════════════
// UNIT DETAIL PROVIDER (by ID)
// ═══════════════════════════════════════════════════════════
final utilitasUnitDetailProvider = FutureProvider.family<Unit, String>((
  ref,
  unitId,
) async {
  final repository = ref.watch(unitRepositoryProvider);
  return repository.getUnitById(unitId);
});

// ═══════════════════════════════════════════════════════════
// UNIT FORM STATE
// ═══════════════════════════════════════════════════════════
class UnitFormState {
  final bool isLoading;
  final String? error;
  final Unit? savedUnit;

  const UnitFormState({this.isLoading = false, this.error, this.savedUnit});

  UnitFormState copyWith({bool? isLoading, String? error, Unit? savedUnit}) {
    return UnitFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedUnit: savedUnit ?? this.savedUnit,
    );
  }
}

// ═══════════════════════════════════════════════════════════
// UNIT FORM NOTIFIER
// ═══════════════════════════════════════════════════════════
class UnitFormNotifier extends StateNotifier<UnitFormState> {
  final UnitRepository _repository;
  final Ref _ref;

  UnitFormNotifier(this._repository, this._ref) : super(const UnitFormState());

  Future<bool> createUnit(Unit unit) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final savedUnit = await _repository.createUnit(unit);
      state = UnitFormState(savedUnit: savedUnit);
      _ref.invalidate(utilitasUnitListProvider);
      return true;
    } catch (e) {
      state = UnitFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateUnit(String unitId, Unit unit) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final savedUnit = await _repository.updateUnit(unitId, unit);
      state = UnitFormState(savedUnit: savedUnit);
      _ref.invalidate(utilitasUnitListProvider);
      _ref.invalidate(utilitasUnitDetailProvider(unitId));
      return true;
    } catch (e) {
      state = UnitFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteUnit(String unitId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteUnit(unitId);
      state = const UnitFormState();
      _ref.invalidate(utilitasUnitListProvider);
      return true;
    } catch (e) {
      state = UnitFormState(error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const UnitFormState();
  }
}

// ═══════════════════════════════════════════════════════════
// UNIT FORM PROVIDER
// ═══════════════════════════════════════════════════════════
final unitFormProvider = StateNotifierProvider<UnitFormNotifier, UnitFormState>(
  (ref) {
    final repository = ref.watch(unitRepositoryProvider);
    return UnitFormNotifier(repository, ref);
  },
);
