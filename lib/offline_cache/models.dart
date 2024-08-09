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
