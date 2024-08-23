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

  AuthProvider authProv = Get.put<AuthProvider>(AuthProvider());
  AuthController authController = Get.put<AuthController>(AuthController());

  Rx<OfflineCacheStatus> offlineCacheStatus = Rx(OfflineCacheStatus());

  OfflineCacheSyncController(
      {this.offlineCacheItems = const [], this.box, this.database});

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
    await getOfflineCacheItem();
    // }else {
    //   dprint("Waiting for authentication, will try on next rebbot");
    // }
  }

  getOfflineCacheItem() async {
    offlineCacheStatus.value =
        OfflineCacheStatus(cachepages: offlineCacheItems);
    for (var i = 0;
        i < (offlineCacheStatus.value?.cachepages.length ?? 0);
        i++) {
      var item = offlineCacheStatus.value?.cachepages?[i];
      if (item != null) {
        await getOfflineCacheSinglePage(item, i);
      }
    }
    dprint("Notifiy people");
  }

  getOfflineCacheSinglePage(OfflineCacheItem offlineItem, int mainIndex) async {
    var name = offlineItem.tableName;
    var path = offlineItem.path;
    dprint("Cache $name");
    var hadMoredata = true;
    var page = 1;
    isLoading.value = true;
    offlineItem.count = 0;

    while (hadMoredata) {
      dprint("Getting cache $name  Page:$page");
      offlineItem.status = cacheStatus.processing;
      var pageResult = await getItemFromApi(path, page.toString());
      var items = pageResult.results;
      dprint(pageResult.count);
      offlineItem.totalCount = pageResult.count;
      var hasErrors = false;

      if (items != null) {
        if (box != null) {
          // dprint("Saving ${items.length} $name");
          await box?.write(name, items);
        } else if (database != null) {
          // dprint("Saving katadabase..");
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
        dprint("Saved $name page $page");
      }
      page++;
      if (pageResult.next == null) {
        hadMoredata = false;
      }
      offlineItem.status =
          hasErrors ? cacheStatus.partial : cacheStatus.completed;
      updateOfflineStatus(mainIndex, offlineItem);

      isLoading.value = false;
    }
  }

  updateOfflineStatus(int index, OfflineCacheItem offlineItem) {
    offlineCacheItems[index] = offlineItem;
    offlineCacheStatus.value =
        OfflineCacheStatus(cachepages: offlineCacheItems);
  }

  Future<PageResult> getItemFromApi(String path, String page) async {
    PageResult pageResult = PageResult();

    try {
      var res = await authProv.formGet(path, query: {"page": page});
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
        }
      } else {
        dprint(res.statusCode);
        dprint(res.body);
      }
    } catch (e) {
      dprint("Failed");
      dprint(e);
    }
    return pageResult;
  }
}
