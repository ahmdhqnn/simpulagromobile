import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/app.dart';

void main() {
  testWidgets('AgroApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AgroApp()));

    // App should render — verify no crash
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
