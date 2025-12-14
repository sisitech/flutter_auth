import 'package:flutter_utils/text_view/text_view_extensions.dart';

enum cacheStatus {
  scheduled,
  processing,
  completed,
  partial,
  skipped,
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
  final bool enableIncrementalSync;
  final String idField;

  OfflineCacheItem({
    required this.path,
    required this.tableName,
    this.nickName,
    this.totalCount = 0,
    this.pageSize = 100,
    this.status = cacheStatus.scheduled,
    this.count = 0,
    this.enableIncrementalSync = true,
    this.idField = "id",
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
  late String? error;
  late String? statusCode;

  PageResult({
    this.next,
    this.previous,
    this.statusCode,
    this.error,
    this.isSuccessful = false,
    this.count = 0,
    this.results = const [],
  });
}

class OfflineCacheStatus {
  List<OfflineCacheItem> cachepages;
  OfflineCacheStatus({this.cachepages = const []});
}

class StoredSyncInfo {
  final String modified;
  final DateTime syncTime;
  final int count;

  StoredSyncInfo({
    required this.modified,
    required this.syncTime,
    required this.count,
  });

  Map<String, dynamic> toJson() => {
        'modified': modified,
        'syncTime': syncTime.toIso8601String(),
        'count': count,
      };

  factory StoredSyncInfo.fromJson(Map<String, dynamic> json) {
    return StoredSyncInfo(
      modified: json['modified'] as String,
      syncTime: DateTime.parse(json['syncTime'] as String),
      count: json['count'] as int,
    );
  }
}
