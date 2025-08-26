import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Dio createDio() {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['API_URL'] ?? '',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
  ));

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  return dio;
}



class ArticleService {
  final Dio _dio;
  ArticleService(this._dio);

  Future<Map<String, dynamic>> fetchArticle(String id) async {
    try {
      final res = await _dio.get('/articles/article/$id'); // <- ruta típica REST
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al obtener artículo: ${e.message}');
    }
  }
  Future<Map<String, dynamic>> fetchArticlesById(String id) async {
    try {
      final res = await _dio.get('/articles/$id'); // <- ruta típica REST
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al obtener artículo: ${e.message}');
    }
  }

  Future<List<dynamic>> fetchAllArticlesById(String id) async {
    try {

      final res = await _dio.get('/articles/$id'); // <- ruta típica REST
      return res.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al listar artículos: ${e.message}');
    }
  }


  Future<List<dynamic>> fetchArticles() async {
    try {
      final res = await _dio.get('/articles'); // devuelve una lista
      return res.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al listar artículos: ${e.message}');
    }
  }

  Future<List<dynamic>> fetchAllNivel0() async {
    try {
      final res = await _dio.get('/nivel0'); // devuelve una lista
      return res.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al listar nivel0: ${e.message}');
    }
  }
  Future<List<dynamic>> fetchAllNivel1(String id) async {
    try {
      final res = await _dio.get('/nivel1'); // devuelve una lista
      return res.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al listar nivel1: ${e.message}');
    }
  }

  Future<List<dynamic>> fetchAllNivel2() async {
    try {
      final res = await _dio.get('/nivel2'); // devuelve una lista
      return res.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al listar nivel2: ${e.message}');
    }
  }

  Future<List<dynamic>> fetchAllNivelFiltered2(String id) async {
    try {
      final res = await _dio.get('/nivel2/$id'); // devuelve una lista
      return res.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al listar nivel2: ${e.message}');
    }
  }
  Future<List<dynamic>> fetchAllNivel3() async {
    try {
      final res = await _dio.get('/nivel3'); // devuelve una lista
      return res.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al listar nivel13 ${e.message}');
    }
  }
  Future<List<dynamic>> fetchAllNivel4() async {
    try {
      final res = await _dio.get('/nivel4'); // devuelve una lista
      return res.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al listar nivel14 ${e.message}');
    }
  }

  Future<List<dynamic>> fetchAllNivelesScraping(String id,int level) async {
    try {
      final res = await _dio.get('/nivelesScraping/$id/$level');
      return res.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al listar nivel1: ${e.message}');
    }
  }



}