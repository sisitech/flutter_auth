library flutter_auth;

import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;

class AuthProvider extends GetConnect {
  APIConfig? config = Get.find<APIConfig>();
  final box = GetStorage();
  FormProvider() {}

  @override
  void onInit() {
    dprint(config);
    dprint("The base url is");
    dprint(httpClient.baseUrl);
    httpClient.addRequestModifier<dynamic>((request) async {
      var token = await getToken();
      if (token != null) {
        var head = request.headers['Authorization'] =
            'Bearer ${token["access_token"]}';
      }
      // print(request.headers);
      return request;
    });
  }

  getToken() {
    return box.read('token');
  }

  Future<Response> formPost(String? path, dynamic body,
      {contentType = "application/json"}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);

    return post(url, body, contentType: contentType);
  }

  Future<Response> formGet(String? path,
      {contentType = "application/json",
      Map<String, dynamic> query = const {}}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);
    dprint(query);
    return get(url, query: query);
  }

  Future<Response> formDelete(String? path,
      {contentType = "application/json",
      Map<String, dynamic> query = const {}}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);
    dprint(query);
    return delete(url, query: query);
  }

  Future<Response> formPatch(String? path, dynamic body,
      {contentType = "application/json", removeNullFields = true}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);
    var dataToPatch;
    if (removeNullFields) {
      dataToPatch = removeNullFields(body);
    } else {
      dataToPatch = body;
    }

    return patch(url, dataToPatch, contentType: contentType);
  }

  Future<Response> formPostUrlEncoded(String? path, dynamic body,
      {contentType = "application/x-www-form-urlencoded"}) {
    var url = "${config!.apiEndpoint}/${path}";
    // print(url);
    var bodyStr = mapToFormUrlEncoded(body);
    var contentType = "application/x-www-form-urlencoded";
    return formPost(path, bodyStr, contentType: contentType);
  }

  mapToFormUrlEncoded(Map body) {
    var fields = [];
    body.forEach((key, value) {
      fields.add("${key}=${value}");
    });
    return fields.join("&");
  }

  removeNullFields(Map<String, dynamic> formData) {
    dprint("formData");
    dprint(formData);
    Map<String, dynamic> res = {};
    formData.forEach((key, value) {
      if (value != null) {
        res[key] = value;
      }
    });
    return res;
  }
}
