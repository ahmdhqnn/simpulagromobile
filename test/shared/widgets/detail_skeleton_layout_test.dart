import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_loaders.dart';

void main() {
  testWidgets('detail skeleton variants render in their screen shells', (
    tester,
  ) async {
    final variants = <Widget>[
      const EntityDetailContentSkeleton(
        infoRowCount: 5,
        secondaryRowCount: 3,
        circularIcon: true,
      ),
      const EntityDetailContentSkeleton(infoRowCount: 5),
      const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: TaskDetailContentSkeleton(),
        ),
      ),
      const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: PhaseDetailCardsSkeleton(),
        ),
      ),
      const Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: PostDetailContentSkeleton(),
            ),
          ),
          PostCommentInputSkeleton(),
        ],
      ),
      const AdminDetailScreenSkeleton(sectionRowCounts: [6, 4, 2]),
    ];

    for (final variant in variants) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SafeArea(child: variant)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('form skeleton variants render with standardized spacing', (
    tester,
  ) async {
    final variants = <Widget>[
      const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: TaskFormCardSkeleton(isEditMode: true),
      ),
      const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: PlantFormCardSkeleton(showConflictBanner: true),
      ),
      const AdminFormScreenSkeleton(sectionFieldCounts: [3, 4, 1]),
    ];

    for (final variant in variants) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SafeArea(child: variant)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(tester.takeException(), isNull);
    }
  });
}
