// repositories/article_repository.dart
import '../service/ArticleService.dart';
import '../models/ArticleModel.dart';
import '../models/Nivel0Model.dart';
import '../models/Nivel1Model.dart';
import '../models/Nivel2Model.dart';
import '../models/Nivel3Model.dart';
import '../models/Nivel4Model.dart';

class ArticleRepository {
  final ArticleService service;
  ArticleRepository(this.service);

  Future<ArticleModel> getArticleById(String id) async {
    final json = await service.fetchArticle(id);
    return ArticleModel.fromJson(json);
    // si tu API envuelve la data (p.ej. {"data": {...}}):
    // return ArticleModel.fromJson(json['data']);
  }

  Future<ArticleModel> fetchArticle(String id) async {
    final json = await service.fetchArticle(id);
    return ArticleModel.fromJson(json);
    // si tu API envuelve la data (p.ej. {"data": {...}}):
    // return ArticleModel.fromJson(json['data']);
  }




  Future<List<ArticleModel>> fetchAllArticlesById(String id) async {
    final list = await service.fetchAllArticlesById(id); // List<dynamic>
    return list
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
    // si tu API regresa {"data":[...]}:
    // final list = (json['data'] as List).map(...).toList();
  }


  Future<List<ArticleModel>> getAllArticles() async {
    final list = await service.fetchArticles(); // List<dynamic>
    return list
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
    // si tu API regresa {"data":[...]}:
    // final list = (json['data'] as List).map(...).toList();
  }

  Future<List<ArticleModel>> getAllArticlesById(String id) async {
    print("llamo");
    final list = await service.fetchAllArticlesById(id); // List<dynamic>
    return list
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
    // si tu API regresa {"data":[...]}:
    // final list = (json['data'] as List).map(...).toList();
  }


  Future<List<Nivel0Model>> getAllNivel0() async {
    final list = await service.fetchAllNivel0(); // List<dynamic>
    return list
        .map((e) => Nivel0Model.fromJson(e as Map<String, dynamic>))
        .toList();
    // si tu API regresa {"data":[...]}:
    // final list = (json['data'] as List).map(...).toList();
  }

  Future<List<Nivel1Model>> getAllNivel1(String id) async {
    final list = await service.fetchAllNivel1(id); // List<dynamic>
    return list
        .map((e) => Nivel1Model.fromJson(e as Map<String, dynamic>))
        .toList();
    // si tu API regresa {"data":[...]}:
    // final list = (json['data'] as List).map(...).toList();
  }
  Future<List<Nivel2Model>> getAllNivel2() async {
    final list = await service.fetchAllNivel2(); // List<dynamic>
    return list
        .map((e) => Nivel2Model.fromJson(e as Map<String, dynamic>))
        .toList();
    // si tu API regresa {"data":[...]}:
    // final list = (json['data'] as List).map(...).toList();
  }
  Future<List<Nivel2Model>> fetchAllNivelFiltered2(String id) async {
    final list = await service.fetchAllNivelFiltered2(id); // List<dynamic>
    return list
        .map((e) => Nivel2Model.fromJson(e as Map<String, dynamic>))
        .toList();
    // si tu API regresa {"data":[...]}:
    // final list = (json['data'] as List).map(...).toList();
  }

  Future<List<Nivel3Model>> getAllNivel3() async {
    final list = await service.fetchAllNivel3(); // List<dynamic>
    return list
        .map((e) => Nivel3Model.fromJson(e as Map<String, dynamic>))
        .toList();
    // si tu API regresa {"data":[...]}:
    // final list = (json['data'] as List).map(...).toList();
  }

  Future<List<Nivel4Model>> getAllNivel4() async {
    final list = await service.fetchAllNivel4(); // List<dynamic>
    return list
        .map((e) => Nivel4Model.fromJson(e as Map<String, dynamic>))
        .toList();
    // si tu API regresa {"data":[...]}:
    // final list = (json['data'] as List).map(...).toList();
  }

  Future<List<Nivel4Model>> fetchAllNivelesScraping(String id,int level ) async {
    final list = await service.fetchAllNivelesScraping(id,level); // List<dynamic>
    return list
        .map((e) => Nivel4Model.fromJson(e as Map<String, dynamic>))
        .toList();
    // si tu API regresa {"data":[...]}:
    // final list = (json['data'] as List).map(...).toList();
  }


}