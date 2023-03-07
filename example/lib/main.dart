import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'internalization/translate.dart';

void main() async {
  Get.put<APIConfig>(APIConfig(
      apiEndpoint: "https://dukapi.roometo.com",
      version: "api/v1",
      clientId: "NUiCuG59zwZJR14tIdWD7iQ5ILFnpxbdrO2epHIG",
      tokenUrl: 'o/token/',
      grantType: "password",
      revokeTokenUrl: 'o/revoke_token/'));
  // await GetStorage.init(offline_login_storage_container);
  await GetStorage.init();
  Get.lazyPut(() => AuthController());
  Get.put(NetworkStatusController());
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
                HomePage(),
              ] else
                LoginWidget(),
            ],
          )),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

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
        "username": "micha@sisitech.com",
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
