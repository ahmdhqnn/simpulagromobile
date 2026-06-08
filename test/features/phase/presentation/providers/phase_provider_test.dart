import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/features/phase/domain/entities/phase.dart';
import 'package:simpulagromobile/features/phase/domain/repositories/phase_repository.dart';
import 'package:simpulagromobile/features/phase/presentation/providers/phase_provider.dart';

class _FakePhaseRepository implements PhaseRepository {
  int getPhaseByIdCalls = 0;

  @override
  Future<Either<Failure, List<Phase>>> getPhasesByPlant(String plantId) async {
    expect(plantId, 'SITE001');
    return const Right([
      Phase(
        id: 'PHASE001',
        cropType: 'PADI',
        phaseName: 'Perkecambahan',
        phaseOrder: 1,
        hstMin: 0,
        hstMax: 7,
        currentHst: 8,
        status: 'completed',
        progress: 1.0,
      ),
      Phase(
        id: 'PHASE002',
        cropType: 'PADI',
        phaseName: 'Fase Bibit',
        phaseOrder: 2,
        hstMin: 8,
        hstMax: 21,
        currentHst: 8,
        status: 'active',
        progress: 0.25,
      ),
    ]);
  }

  @override
  Future<Either<Failure, Phase>> getPhaseById(String id) async {
    getPhaseByIdCalls++;
    return Right(
      Phase(
        id: id,
        cropType: 'PADI',
        phaseName: 'Fase Bibit',
        phaseOrder: 2,
        hstMin: 8,
        hstMax: 21,
      ),
    );
  }

  @override
  Future<Either<Failure, Phase?>> getCurrentPhase(String plantId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<Phase>>> getPhaseHistory(String plantId) async {
    return const Right([]);
  }
}

void main() {
  test('phase detail reads enriched progress from site phase list', () async {
    final repository = _FakePhaseRepository();
    final container = ProviderContainer(
      overrides: [phaseRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final phase = await container.read(
      enrichedPhaseDetailProvider((
        phaseId: 'PHASE002',
        siteId: 'SITE001',
      )).future,
    );

    expect(phase.id, 'PHASE002');
    expect(phase.currentHst, 8);
    expect(phase.status, 'active');
    expect(phase.progress, 0.25);
    expect(repository.getPhaseByIdCalls, 0);
  });
}
