// lib/core/di/app_deps.dart
import '../service/ArticleService.dart';
import '../Repositories/ArticleRespository.dart';
import 'package:flutter/widgets.dart';

extension AppDepsX on BuildContext {
  ArticleRepository get articles => AppDeps.I.articleRepository;
}

class AppDeps {
  // instancia única (singleton)
  static final AppDeps I = AppDeps._internal();

  late final dio = createDio();
  late final ArticleService articleService = ArticleService(dio);
  late final ArticleRepository articleRepository = ArticleRepository(articleService);

  AppDeps._internal();
}