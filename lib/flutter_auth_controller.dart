library get_storage;

import 'package:flutter_form/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'auth_connect.dart';

class AuthController extends GetxController {
  var isAuthenticated$ = false.obs;
  final box = GetStorage();
  var config = Get.find<APIConfig>();
  var authProv = Get.put<AuthProvider>(AuthProvider());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkloggedIn();
    print("Auth controller init...");
  }

  checkloggedIn() {
    var token = getToken();
    print("The token is ");
    print(token);
    isAuthenticated$.value = token != null;
  }

  saveToken(dynamic body) async {
    print("The token is ");
    await box.write('token', body);
    checkloggedIn();

    // formPost();
  }

  logout() async {
    print("Logout");
    //  const url = `${this.config.APIEndpoint}/${this.config.revokeTokenUrl}`
    var token = await getToken();
    print(token);
    try {
      var data = {"token": token["access_token"], "client_id": config.clientId};
      print(data);
      print(config.revokeTokenUrl);
      var response =
          await authProv.formPostUrlEncoded(config.revokeTokenUrl, data);
      print(response);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        await box.remove('token');
        checkloggedIn();
      }
    } catch (e) {
      print(e);
    }
  }

  getToken() {
    return box.read('token');
  }
}
