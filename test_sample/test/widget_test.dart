// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:test_sample/classes.dart';

import 'package:test_sample/main.dart';

void main() {
  setUpAll(() async {
    setupFakeLocator();
  });

  testWidgets('Test mocked data source', (WidgetTester tester) async {
    // Wrapping with runAync() is required to have real async in place
    await tester.runAsync(() async {
      await tester.pumpWidget(const MyApp());
      // Let the isolate spawned by compute() complete, Debug run might require longer wait
      await Future.delayed(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('Fake 9'), findsOneWidget);
    });
  });
}

class YgoProRemoteDataSourceFake extends YgoProRemoteDataSource {
  @override
  Future<List<YgoCard>> getCardInfo() {
    return Future.delayed(Duration.zero,
        () => List.generate(10, (index) => YgoCard("Fake $index")));
  }
}

void setupFakeLocator() {
  sl.registerLazySingleton<YgoProRepository>(
    () => YgoProRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<YgoProRemoteDataSource>(
    () => YgoProRemoteDataSourceFake(),
  );
}
