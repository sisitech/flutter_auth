import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../auth_connect.dart';
import 'interface.dart';
import 'models.dart';

class OfflineCacheSyncController extends GetxController {
  List<OfflineCacheItem> offlineCacheItems;
  GetStorage? box;
  OfflineCacheTable? database;
  var isLoading = false.obs;
  final bool enableIncrementalSync;

  AuthProvider authProv = Get.find<AuthProvider>();
  AuthController authController = Get.find<AuthController>();

  Rx<OfflineCacheStatus> offlineCacheStatus = Rx(OfflineCacheStatus());

  var allProgress = 0.0.obs;
  var allTotalCount = 0.obs;
  var currentTotalCount = 0.obs;
  var currentOfflineItemIndex = 0.obs;
  var syncedItemsCount = 0.obs;
  var skippedItemsCount = 0.obs;

  OfflineCacheSyncController({
    this.offlineCacheItems = const [],
    this.box,
    this.database,
    this.enableIncrementalSync = true,
  });

  @override
  void onInit() {
    super.onInit();
    offlineCacheStatus.value =
        OfflineCacheStatus(cachepages: offlineCacheItems);
    //
    // updateCache();
  }

  updateCache() async {
    if (database == null && box == null) {
      throw ("Both the database and box cannot be null");
    }
    // dprint("Auth ::==> ${authController.isAuthenticated$.value} ");
    // await authController.checkloggedIn();
    // if(authController.isAuthenticated$.value){
    syncedItemsCount.value = 0;
    skippedItemsCount.value = 0;
    await getOfflineCacheItem();
    // }else {
    //   dprint("Waiting for authentication, will try on next rebbot");
    // }
  }

  StoredSyncInfo? getStoredSyncInfo(String tableName) {
    try {
      var data = GetStorage().read<Map<String, dynamic>>('sync_$tableName');
      if (data == null) return null;
      return StoredSyncInfo.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveSyncInfo(String tableName, String modified, int count) async {
    var info = StoredSyncInfo(
      modified: modified,
      syncTime: DateTime.now(),
      count: count,
    );
    await GetStorage().write('sync_$tableName', info.toJson());
  }

  Future<void> clearSyncInfo(String tableName) async {
    await GetStorage().remove('sync_$tableName');
  }

  Future<void> clearAllSyncInfo() async {
    for (var item in offlineCacheItems) {
      await clearSyncInfo(item.tableName);
    }
  }

  Future<void> forceFullSync() async {
    await clearAllSyncInfo();
    await updateCache();
  }

  String? extractModified(dynamic item) {
    if (item is Map && item.containsKey('modified')) {
      return item['modified']?.toString();
    }
    return null;
  }

  getOfflineCacheItem() async {
    offlineCacheStatus.value =
        OfflineCacheStatus(cachepages: offlineCacheItems);
    isLoading.value = true;
    for (var i = 0;
        i < (offlineCacheStatus.value?.cachepages.length ?? 0);
        i++) {
      var item = offlineCacheStatus.value?.cachepages?[i];
      if (item != null) {
        await getOfflineCacheSinglePage(item, i);
      }
    }
    isLoading.value = false;
    dprint("Notifiy people");
  }

  updateTotalProgress(var index) {
    List<OfflineCacheItem> pages = offlineCacheStatus.value.cachepages;
    allTotalCount.value = 0;
    currentTotalCount.value = 0;
    if (currentOfflineItemIndex.value != index) {
      currentOfflineItemIndex.value = index;
    }
    for (var page in pages) {
      if (page.status == cacheStatus.completed) {
        allTotalCount.value += page.totalCount;
        currentTotalCount.value += page.count;
      } else {
        allTotalCount.value += page.totalCount;
        currentTotalCount.value += page.count;
      }
    }
    // } else {
    //   currentTotalCount.value += 1;
    // }
    allProgress.value = (allTotalCount.value < 1
            ? 0.0
            : currentTotalCount.value / allTotalCount.value) /
        (pages.length - index);

    // dprint(
    //     "INdex $index, ALL:${allTotalCount.value}, Current:${currentTotalCount.value} ${allProgress.value}");
  }

  getOfflineCacheSinglePage(OfflineCacheItem offlineItem, int mainIndex) async {
    var name = offlineItem.tableName;
    var path = offlineItem.path;
    var hadMoredata = true;
    var page = 1;

    offlineItem.count = 0;

    dprint("Getting ${offlineItem.nickName}");

    // Check for incremental sync
    String? modifiedAfter;
    bool useIncrementalSync =
        enableIncrementalSync && offlineItem.enableIncrementalSync;

    if (useIncrementalSync) {
      var storedInfo = getStoredSyncInfo(name);
      if (storedInfo != null) {
        modifiedAfter = storedInfo.modified;
        dprint("Using incremental sync from: $modifiedAfter");
      }
    }

    String? latestModified;

    while (hadMoredata) {
      offlineItem.status = cacheStatus.processing;
      var pageResult = await getItemFromApi(
        path,
        page.toString(),
        pageSize: offlineItem.pageSize,
        modifiedAfter: modifiedAfter,
      );

      var items = pageResult.results;
      offlineItem.totalCount = pageResult.count;

      // If count=0 and we used modifiedAfter, skip this item
      if (pageResult.count == 0 && modifiedAfter != null) {
        offlineItem.status = cacheStatus.skipped;
        skippedItemsCount.value++;
        updateOfflineStatus(mainIndex, offlineItem);
        dprint("Skipped ${offlineItem.nickName} - no changes since last sync");
        return;
      }

      var hasErrors = false;

      if (items != null && pageResult.statusCode == "200") {
        // Track the latest modified timestamp from items
        for (var item in items) {
          var itemModified = extractModified(item);
          if (itemModified != null) {
            if (latestModified == null || itemModified.compareTo(latestModified) > 0) {
              latestModified = itemModified;
            }
          }
        }

        if (box != null) {
          if (modifiedAfter != null) {
            // Incremental: upsert by ID field
            var existingData = await box?.read(name) as List<dynamic>? ?? [];
            var idKey = offlineItem.idField;
            for (var newItem in items) {
              var newId = newItem[idKey];
              if (newId != null) {
                existingData.removeWhere((e) => e[idKey] == newId);
              }
              existingData.add(newItem);
            }
            await box?.write(name, existingData);
          } else {
            // Full sync: replace data
            await box?.write(name, items);
          }
          dprint("STORED...");
          for (var _ in items) {
            offlineItem.count = offlineItem.count + 1;
            updateOfflineStatus(mainIndex, offlineItem);
          }
        } else if (database != null) {
          for (var item in items) {
            try {
              await database?.insertItem(name, item);
            } catch (e, stackTrace) {
              hasErrors = true;
              print("Db add failed.");
              // TODO: remove
              debugPrintStack(stackTrace: stackTrace);
              print(e);
            }
            offlineItem.count = offlineItem.count + 1;
            updateOfflineStatus(mainIndex, offlineItem);
          }
        }
      }
      page++;
      if (pageResult.next == null) {
        hadMoredata = false;
      }
      offlineItem.status =
          hasErrors ? cacheStatus.partial : cacheStatus.completed;
      updateOfflineStatus(mainIndex, offlineItem);
    }

    // Save sync info after successful sync
    if (latestModified != null && offlineItem.status == cacheStatus.completed) {
      await saveSyncInfo(name, latestModified, offlineItem.totalCount);
      syncedItemsCount.value++;
      dprint("Saved sync info for $name with modified: $latestModified");
    }
  }

  updateOfflineStatus(int index, OfflineCacheItem offlineItem) {
    offlineCacheItems[index] = offlineItem;
    offlineCacheStatus.value =
        OfflineCacheStatus(cachepages: offlineCacheItems);
    updateTotalProgress(index);
  }

  Future<PageResult> getItemFromApi(
    String path,
    String page, {
    int pageSize = 100,
    String? modifiedAfter,
  }) async {
    PageResult pageResult = PageResult();

    try {
      var query = {"page": page, "page_size": pageSize.toString()};
      if (modifiedAfter != null) {
        query["modified_after"] = modifiedAfter;
      }
      var res = await authProv.formGet(path, query: query);
      pageResult.statusCode = res.statusCode.toString();
      if (res.statusCode == 200) {
        pageResult.isSuccessful = true;

        try {
          // return res.body["results"];
          pageResult.next = res.body["next"];
          pageResult.previous = res.body["previous"];
          pageResult.results = res.body["results"];
          pageResult.count = res.body["count"];
        } catch (e) {
          dprint(e);
          pageResult.isSuccessful = true;
          pageResult.error = e.toString();
        }
      } else {
        dprint(res.statusCode);
        dprint(res.body);
        pageResult.error = res.bodyString;
      }
    } catch (e) {
      dprint("Failed");
      pageResult.error = e.toString();
      dprint(e);
    }
    return pageResult;
  }
}
