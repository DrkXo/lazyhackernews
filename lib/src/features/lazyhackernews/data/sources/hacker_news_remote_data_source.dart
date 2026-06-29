import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/models.dart';

class HackerNewsRemoteDataSource {
  final Dio _dio;

  HackerNewsRemoteDataSource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://hacker-news.firebaseio.com/v0',
            ),
          );

  Future<List<int>> fetchFeedIds(FeedType feed) async {
    try {
      final endpoint = _endpoint(feed);
      final response = await _dio.get<List<dynamic>>(endpoint);
      return response.data!.cast<int>();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Item> fetchItem(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/item/$id.json');
      return Item.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } on FormatException catch (e) {
      throw DataFormattingException(
        message: 'Invalid data format for item $id',
        invalidData: e,
      );
    }
  }

  Future<List<Item>> fetchItems(List<int> ids) async {
    try {
      return await Future.wait(ids.map(fetchItem));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  String _endpoint(FeedType feed) {
    switch (feed) {
      case FeedType.top:
        return '/topstories.json';
      case FeedType.new_:
        return '/newstories.json';
      case FeedType.best:
        return '/beststories.json';
      case FeedType.ask:
        return '/askstories.json';
      case FeedType.show:
        return '/showstories.json';
      case FeedType.jobs:
        return '/jobstories.json';
    }
  }

  Exception _mapDioError(DioException e) {
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
