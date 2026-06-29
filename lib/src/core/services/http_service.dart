import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';

import '../error/exceptions.dart';

class HttpService {
  final Dio _dio;

  HttpService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://hacker-news.firebaseio.com/v0',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            contentType: 'application/json',
          ),
        ) {
    final cacheDir = _cacheDirectory();
    cacheDir.createSync(recursive: true);
    _dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: HiveCacheStore(cacheDir.path),
          maxStale: const Duration(minutes: 30),
        ),
      ),
    );
  }

  Directory _cacheDirectory() {
    final home = Platform.environment['HOME'] ?? '/tmp';
    final xdgCache = Platform.environment['XDG_CACHE_HOME'];
    final base = xdgCache ?? '$home/.cache';
    return Directory('$base/lazyhackernews');
  }

  Future<List<dynamic>> getList(String path) async {
    try {
      final response = await _dio.get<List<dynamic>>(path);
      return response.data ?? [];
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> getMap(String path) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
      return response.data ?? {};
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Exception _mapError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return NetworkException(message: 'No internet connection');
    }
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = _statusMessage(statusCode);
      return ApiException(message: message, statusCode: statusCode);
    }
    return ApiException(message: e.message ?? 'Something went wrong');
  }

  String _statusMessage(int? code) {
    switch (code) {
      case 400:
        return 'Bad request';
      case 404:
        return 'Resource not found';
      case 429:
        return 'Rate limited. Please wait and try again';
      case var c when c != null && c >= 500:
        return 'Server error ($code)';
      default:
        return 'Request failed (${code ?? 'unknown'})';
    }
  }
}
