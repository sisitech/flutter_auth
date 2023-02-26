library flutter_auth;

import 'package:flutter_utils/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'auth_connect.dart';

class AuthController extends GetxController {
  var isAuthenticated$ = false.obs;
  final box = GetStorage();
  var config = Get.find<APIConfig>();
  var authProv = Get.put<AuthProvider>(AuthProvider());
  Rx<Map<String, dynamic>?> profile = Rx(null);
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkloggedIn();
    print("Auth controller init...");
  }

  checkloggedIn() async {
    var token = await getToken();
    var read_profile = await getProfile();
    print("The token is ");
    print(token);
    isAuthenticated$.value = token != null;
    profile.value = read_profile;
  }

  saveToken(dynamic body) async {
    print("The token is ");
    await box.write('token', body);

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
      if (response.statusCode == 200) {}
      await box.remove('token');
      checkloggedIn();
    } catch (e) {
      print(e);
    }
  }

  getSaveProfile(dynamic token) async {
    saveToken(token);
    authProv.onInit();
    try {
      var received_profile = await authProv.formGet(config.profileUrl);
      print(received_profile.statusCode);
      print(received_profile.body);
      if (received_profile.statusCode == 200) {
        profile = received_profile.body;
        await saveProfile(received_profile.body);
      }
      checkloggedIn();
      return;
    } catch (e) {
      print(e);
      return;
    }
  }

  getToken() {
    return box.read('token');
  }

  saveProfile(dynamic body) {
    return box.write('profile', body);
  }

  getProfile() {
    return box.read('profile');
  }
}
