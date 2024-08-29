import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_auth/offline_cache/models.dart';
import 'package:flutter_auth/offline_cache/offline_cache_controller.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'database/db.dart';
import 'internalization/translate.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_auth/offline_cache/offline_cache_widget.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';

getApiConfig() {
  return APIConfig(
      apiEndpoint: "https://api.expensetracker.wavvy.dev",
      version: "api/v1",
      clientId: "fbaPXGrD6wewVEqoOkJfvierIrYbnROPXMa8CDv5",
      tokenUrl: 'o/token/',
      grantType: "password",
      revokeTokenUrl: 'o/revoke_token/');
}

// APIConfig(
//         apiEndpoint: "https://dukapi.roometo.com",
//         version: "api/v1",
//         clientId: "NUiCuG59zwZJR14tIdWD7iQ5ILFnpxbdrO2epHIG",
//         tokenUrl: 'o/token/',
//         grantType: "password",
//         revokeTokenUrl: 'o/revoke_token/'),

drift.LazyDatabase _openConnection() {
  return drift.LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'dbata11P2OI8678U.sqlite'));
    return NativeDatabase(file);
  });
}

void main() async {
  // Get.put<APIConfig>(getApiConfig());
  Get.put<APIConfig>(getApiConfig());
  await GetStorage.init(offline_login_storage_container);
  await GetStorage.init();
  Get.put(AuthController());
  Get.put(NetworkStatusController());
  const v1 = "api/v1";

  Get.put(OfflineCacheSyncController(
    database: AppDatabase(_openConnection()),
    offlineCacheItems: [
      OfflineCacheItem(
          tableName: 'category',
          pageSize: 300,
          nickName: 'Dataset 1',
          path: "$v1/tagging-rules"),
      // OfflineCacheItem(
      //   tableName: 'sub_categories',
      //   nickName: "Dataset 2",
      //   path: "$v1/sub-categories",
      // ),
    ],
  ));

  // StoreBinding();
  runApp(const MyApp());
}

class StoreBinding implements Bindings {
// default dependency
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // initialBinding: ,
      title: 'Flutter Demo',
      translations: AppTranslations(),
      locale: const Locale('swa', 'KE'),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  late String title;

  AuthController authController = Get.find<AuthController>();

  MyHomePage({super.key, this.title = "Hello world !"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (authController.isAuthenticated$.value) ...[
                Text("hello"),
                OfflineCacheListWidget(),
                HomePage(),
              ] else
                // LoginWidget(
                //   // override_options: const {
                //   //   "instance": {
                //   //     "username": "michameiu@gmail.com",
                //   //     "password": "mm",
                //   //   }
                //   // },
                //   onLoginChange: (state) {
                //     dprint(state);
                //   },
                // ),
                LoginWidgetA(),
            ],
          )),
    );
  }
}

class LoginWidgetA extends StatelessWidget {
  const LoginWidgetA({super.key});

  @override
  Widget build(BuildContext context) {
    APIConfig config = Get.find<APIConfig>();
    AuthController authController = Get.find<AuthController>();
    Map<String, dynamic>? offlineCred;
    return MyCustomForm(
      url: "o/token/",
      submitButtonText: "Login".tr,
      submitButtonPreText: "",
      enableOfflineMode: true,
      enableOfflineSave: false,
      loadingMessage: "Signing in...".tr,
      validateOfflineData: (data) async {
        var res = await authController.confirmOfflineCreds(data);

        if (res == null) {
          return {"detail": "No offline credentials found".tr};
        }
        if (!res) {
          return {"password": "Confirm password".tr};
        } else {
          dprint("Offline Authenticated $res");
          dprint("${authController.offlineCred}");
          return null;
        }
      },
      instance: {
        "username": "michameiu@gmail.com",
        "password": "mm",
      },
      onOfflineSuccess: (res) {
        dprint("Login offline successful");
        authController.unLock();
      },
      contentType: ContentType.form_url_encoded,
      extraFields: {
        "client_id": config.clientId,
        "grant_type": config.grantType,
      },
      PreSaveData: (res) {
        authController.loginForm.value = res;
        //Save the login Form
        return res;
      },
      handleErrors: (err) {
        dprint(err);
        return err;
      },
      onSuccess: (res) async {
        dprint("Logged in");
        dprint(res);
        dprint("creds");
        dprint(authController.loginForm.value);
        await authController.saveOfflineCreds();
        await authController.getSaveProfile(res);

        return null;
      },
      formGroupOrder: const [
        ["username"],
        ["password"]
      ],
      formTitle: "Signup",
      name: 'loginwidget',
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Logged in"),
        ElevatedButton(
          onPressed: logout,
          child: Text("Logout"),
        ),
        SizedBox(
          height: 40,
        ),
        ElevatedButton(
          onPressed: lock,
          child: Text("Lock"),
        ),
        ElevatedButton(
          onPressed: () {
            authController.updateOfflineProfile();
          },
          child: Text("Get Profile"),
        )
      ],
    );
  }

  logout() async {
    await authController.logout();
  }

  lock() async {
    await authController.lock();
  }
}
