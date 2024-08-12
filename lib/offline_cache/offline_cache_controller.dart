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

  AuthProvider authProv = Get.put<AuthProvider>(AuthProvider());
  AuthController authController = Get.put<AuthController>(AuthController());

  Rx<OfflineCacheStatus?> offlineCacheStatus = Rx(null);

  OfflineCacheSyncController(
      {this.offlineCacheItems = const [], this.box, this.database});

  @override
  void onInit() {
    super.onInit();
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
    getOfflineCacheItem();
    // }else {
    //   dprint("Waiting for authentication, will try on next rebbot");
    // }
  }

  getOfflineCacheSinglePage(OfflineCacheItem item) async {
    var name = item.tableName;
    var path = item.path;
    dprint("Cache $name");
    var hadMoredata = true;
    var page = 1;
    while (hadMoredata) {
      dprint("Getting cache $name  Page:$page");
      var pageResult = await getItemFromApi(path, page.toString());
      var items = pageResult.results;
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
              print("Db add failed.");
              // TODO: remove
              debugPrintStack(stackTrace: stackTrace);
              print(e);
            }
          }
        }
        dprint("Saved $name page $page");
      }
      page++;
      if (pageResult.next == null) {
        hadMoredata = false;
      }
    }
  }

  getOfflineCacheItem() async {
    var pages = offlineCacheItems
        .map((e) => CachePageIndicator(name: e.tableName))
        .toList();
    offlineCacheStatus.value = OfflineCacheStatus();
    for (var i = 0; i < offlineCacheItems.length; i++) {
      var item = offlineCacheItems[i];
      await getOfflineCacheSinglePage(item);
    }
    dprint("Notifiy people");
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
