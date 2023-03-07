library flutter_auth;

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_utils/flutter_utils.dart';

import 'package:flutter_utils/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'auth_connect.dart';

const offline_login_storage_container = "offline_login";
const offline_password_key = "offline_password_key";

class AuthController extends GetxController {
  var isAuthenticated$ = false.obs;
  final box = GetStorage();
  var config = Get.find<APIConfig>();
  var authProv = Get.put<AuthProvider>(AuthProvider());
  var offline_box = GetStorage(offline_login_storage_container);

  Rx<Map<String, dynamic>?> loginForm = Rx(null);

  Rx<Map<String, dynamic>?> profile = Rx(null);
  Rx<Map<String, dynamic>?> offlineCred = Rx(null);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkloggedIn();
    dprint("Auth controller init...");
  }

  checkloggedIn() async {
    var token = await getToken();
    var read_profile = await getProfile();
    // Token is not null and lock is false
    isAuthenticated$.value = token != null && !(await getLockStatus());
    dprint(token);
    dprint(
        "toke is null ${token != null} and lock status ${await getLockStatus()}");
    profile.value = read_profile;
  }

  Future<bool> getLockStatus() async {
    var res = await box.read<bool>('locked') ?? true;
    return Future.value(res);
  }

  saveToken(dynamic body) async {
    await box.write('token', body);
    return box.write('locked', false);
  }

  Map<String, dynamic> encryptPassword(String username, String password) {
    // dprint("Encryptin $username $password");
    final key = encrypt.Key.fromSecureRandom(32);
    final iv = encrypt.IV.fromSecureRandom(16);
    // dprint(key.base16);
    // dprint(iv.base16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return {
      "iv": iv.base64,
      "password": encrypted.base64,
      "key": key.base64,
      "username": username
    };
  }

  saveOfflineCreds() async {
    if (loginForm.value != null) {
      var encyptredPassword = encryptPassword(
          loginForm.value?["username"], loginForm.value?["password"]);
      // dprint("Saving");
      // dprint(encyptredPassword);
      await offline_box.write(offline_password_key, encyptredPassword);
    }
  }

  confirmOfflineCreds(form) async {
    var res = await offline_box.read(offline_password_key);
    if (res == null) {
      return null;
    }
    var username = form?["username"];
    var password = form?["password"];
    offlineCred.value = res;
    final key = encrypt.Key.fromBase64(res["key"]);
    final iv = encrypt.IV.fromBase64(res["iv"]);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encryptedPassword = encrypter.encrypt(password, iv: iv);
    return res["password"] == encryptedPassword.base64 &&
        res["username"] == username;
  }

  lock() async {
    await box.write('locked', true);
    checkloggedIn();
  }

  unLock() async {
    await box.write('locked', false);
    checkloggedIn();
  }

  logout() async {
    dprint("Logout");
    //  const url = `${this.config.APIEndpoint}/${this.config.revokeTokenUrl}`
    var token = await getToken();
    dprint(token);
    try {
      var data = {"token": token["access_token"], "client_id": config.clientId};
      dprint(data);
      dprint(config.revokeTokenUrl);
      var response =
          await authProv.formPostUrlEncoded(config.revokeTokenUrl, data);
      dprint(response);
      dprint(response.statusCode);
      dprint(response.body);
      if (response.statusCode == 200) {}
      await box.remove('token');
      checkloggedIn();
    } catch (e) {
      dprint(e);
    }
  }

  getSaveProfile(dynamic token) async {
    await saveToken(token);
    authProv.onInit();
    try {
      var received_profile = await authProv.formGet(config.profileUrl);
      dprint(received_profile.statusCode);
      dprint(received_profile.body);
      if (received_profile.statusCode == 200) {
        profile.value = received_profile.body;
        await saveProfile(received_profile.body);
      }
      checkloggedIn();
      return;
    } catch (e) {
      dprint(e);
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
