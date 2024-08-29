import 'package:flutter_utils/text_view/text_view_extensions.dart';

enum cacheStatus {
  scheduled,
  processing,
  completed,
  partial,
}

extension cacheExt on cacheStatus {
  String get name {
    return this.toString().replaceAll("cacheStatus.", "").capitalizeEachWord;
  }
}

class OfflineCacheItem {
  final String path;
  final String tableName;
  final String? nickName;
  late int totalCount;
  late int count;
  late cacheStatus status;
  final int pageSize;

  OfflineCacheItem({
    required this.path,
    required this.tableName,
    this.nickName,
    this.totalCount = 0,
    this.pageSize = 100,
    this.status = cacheStatus.scheduled,
    this.count = 0,
  });

  String get status_name {
    return status.name.capitalizeEachWord;
  }
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

class OfflineCacheStatus {
  List<OfflineCacheItem> cachepages;
  OfflineCacheStatus({this.cachepages = const []});
}
