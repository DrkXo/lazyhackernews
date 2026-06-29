import '../../../../core/error/exceptions.dart';
import '../../../../core/services/http_service.dart';
import '../models/models.dart';

class HackerNewsRemoteDataSource {
  final HttpService _http;

  HackerNewsRemoteDataSource({required this._http});

  Future<List<int>> fetchFeedIds(FeedType feed) async {
    final data = await _http.getList(_endpoint(feed));
    return data.cast<int>();
  }

  Future<Item> fetchItem(int id) async {
    try {
      final data = await _http.getMap('/item/$id.json');
      return Item.fromJson(data);
    } on FormatException catch (e) {
      throw DataFormattingException(
        message: 'Invalid data format for item $id',
        invalidData: e,
      );
    }
  }

  Future<List<Item>> fetchItems(List<int> ids) async {
    return Future.wait(ids.map(fetchItem));
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
}
