import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class YgoCard {
  YgoCard(this.name);

  final String name;
}

abstract class YgoProRemoteDataSource {
  Future<List<YgoCard>> getCardInfo();
}

class YgoProRemoteDataSourceImpl extends YgoProRemoteDataSource {
  @override
  Future<List<YgoCard>> getCardInfo() {
    return Future.delayed(Duration.zero,
        () => List.generate(5, (index) => YgoCard("Impl $index")));
  }
}

abstract class YgoProRepository {
  Future<List<YgoCard>> getAllCards();
}

class YgoProRepositoryImpl implements YgoProRepository {
  final YgoProRemoteDataSource remoteDataSource;

  YgoProRepositoryImpl({
    required this.remoteDataSource,
  });

  static Future<List<YgoCard>> _fetchCards(
      YgoProRemoteDataSource dataSource) async {
    final cards = await dataSource.getCardInfo();
    cards.sort((a, b) => a.name.compareTo(b.name));
    return cards;
  }

  @override
  Future<List<YgoCard>> getAllCards() async {
    final cards = await compute(_fetchCards, sl<YgoProRemoteDataSource>());
    return cards;
  }
}

void setupLocator() {
  sl.registerLazySingleton<YgoProRepository>(
    () => YgoProRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<YgoProRemoteDataSource>(
    () => YgoProRemoteDataSourceImpl(),
  );
}
