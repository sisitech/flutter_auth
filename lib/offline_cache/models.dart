class OfflineCacheItem {
  final String path;
  final String tableName;

  OfflineCacheItem({
    required this.path,
    required this.tableName,
  });
}

class PageResult {
  late String? next;
  late bool isSuccessful;
  late String? previous;
  late int count;
  late List<dynamic> results;

  PageResult({
    this.next,
    this.previous,
    this.isSuccessful = false,
    this.count = 0,
    this.results = const [],
  });
}

class CachePageIndicator {
  late String name;
  late String status;
  late int totalCount;
  late int pageSize;
  late int page;
  CachePageIndicator({
    required this.name,
    this.status = "Scheduled",
    this.totalCount = 0,
    this.pageSize = 0,
    this.page = 0,
  });
}

class OfflineCacheStatus {
  List<CachePageIndicator> cachepages;
  OfflineCacheStatus({this.cachepages = const []});
}
