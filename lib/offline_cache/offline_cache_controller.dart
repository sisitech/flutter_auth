import 'package:drift/drift.dart';
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
  
  OfflineCacheSyncController({this.offlineCacheItems=const [],this.box,this.database});

  @override
  void onInit() {
    super.onInit();
    //
    updateCache();
  }

  updateCache()async{
    if(database==null && box==null){
      throw("Both the database and box cannot be null");
    }
    // dprint("Auth ::==> ${authController.isAuthenticated$.value} ");
    // await authController.checkloggedIn();
    // if(authController.isAuthenticated$.value){
      getOfflineCacheItem();
    // }else {
    //   dprint("Waiting for authentication, will try on next rebbot");
    // }
  }

  getOfflineCacheItem() async {
    for (var i = 0; i < offlineCacheItems.length; i++) {
      
      var name = offlineCacheItems[i].tableName;
      var path = offlineCacheItems[i].path;
      dprint("Getting cache $name");
      var items = await getItemFromApi(path);
      
      // dprint(items);
      // if (name == "states") {
      //   dprint(items);
      // }
      if (items != null) {
        if(box !=null){
          dprint("Saving ${items.length} $name");
          await box?.write(name, items);
        }else if(database !=null){
          dprint("Saving katadabase..");
          for(var item in items){
            try {
             await database?.insertItem(name, item);              
            } catch (e) {
              print(e);
            }
          }
        }
        dprint("Saved $name");
      }
    }
    dprint("Notifiy people");
  }

  Future<dynamic?> getItemFromApi(path) async {
    try {
      var res = await authProv.formGet(path);
      if (res.statusCode == 200) {
        try {
          return res.body["results"];
        } catch (e) {
          dprint(e);
          return res.body;
        }
      } else {
        dprint(res.statusCode);
        dprint(res.body);
      }
    } catch (e) {
      dprint("Failed");
      dprint(e);
    }
    dprint("Returning nothing..");
    return null;
  }
}
