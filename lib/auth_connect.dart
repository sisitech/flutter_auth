library flutter_auth;

import 'dart:async';

import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'flutter_auth_controller.dart';
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
    updateHttModifier();
  }

  updateHttModifier() {
    dprint(config);
    dprint("The base url is");
    dprint(httpClient.baseUrl);
    httpClient.timeout = const Duration(seconds: 10);
    httpClient.addRequestModifier<dynamic>((request) async {
      var token = await getToken();
      // Refresh ahead of the call once the stored expiry (80% of expires_in) has passed.
      if (!_isAuthUrl("${request.url}") &&
          token?["refresh_token"] != null &&
          _isExpired(token)) {
        await refreshToken();
        token = await getToken();
      }
      if (token != null) {
        request.headers['Authorization'] = 'Bearer ${token["access_token"]}';
      }
      return request;
    });
    // On a 401 GetConnect calls this, then re-runs the request modifier and retries once.
    httpClient.maxAuthRetries = 1;
    httpClient.addAuthenticator<dynamic>((request) async {
      final token = await getToken();
      // Skip when another request already refreshed after this one was sent.
      if (token != null &&
          !_isAuthUrl("${request.url}") &&
          request.headers['Authorization'] ==
              'Bearer ${token["access_token"]}') {
        await refreshToken();
      }
      return request;
    });
  }

  Future<Map<String, dynamic>?> getToken() async {
    return box.read<Map<String, dynamic>?>('token');
  }

  bool _isAuthUrl(String url) => [config?.tokenUrl, config?.revokeTokenUrl]
      .any((path) => path != null && path.isNotEmpty && url.contains(path));

  bool _isExpired(Map<String, dynamic>? token) {
    final expiresAt = token?["expires_at"];
    if (expiresAt == null) return false;
    try {
      return DateFormat("yyyy-MM-ddTHH:mm")
          .parse("$expiresAt")
          .isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  // Shared across every provider so concurrent requests trigger a single refresh call.
  static Completer<bool>? _refreshing;

  /// Exchanges the stored refresh_token for a new token. Resolves false when it could not.
  Future<bool> refreshToken() {
    if (_refreshing != null) return _refreshing!.future;
    final completer = _refreshing = Completer<bool>();
    _requestNewToken().then((ok) {
      _refreshing = null;
      completer.complete(ok);
    });
    return completer.future;
  }

  Future<bool> _requestNewToken() async {
    final refresh = (await getToken())?["refresh_token"];
    if (refresh == null) {
      _sessionExpired();
      return false;
    }
    try {
      // A plain client, so the refresh call skips these modifiers and cannot recurse.
      final res = await GetConnect(timeout: const Duration(seconds: 10)).post(
        "${config!.apiEndpoint}/${config!.tokenUrl}",
        mapToFormUrlEncoded({
          "grant_type": "refresh_token",
          "refresh_token": refresh,
          "client_id": config!.clientId,
        }),
        contentType: "application/x-www-form-urlencoded",
      );
      dprint("Refresh token status ${res.statusCode}");
      if (res.statusCode == 200 && res.body is Map) {
        final body = Map<String, dynamic>.from(res.body);
        body["refresh_token"] ??= refresh;
        await Get.find<AuthController>().saveToken(body);
        return true;
      }
      // The refresh token was rejected. Offline or server errors keep the session.
      if (res.statusCode == 400 || res.statusCode == 401) _sessionExpired();
      return false;
    } catch (e) {
      dprint(e);
      return false;
    }
  }

  void _sessionExpired() {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().handleSessionExpired();
    }
  }

  Future<Response> formPost(String? path, dynamic body,
      {contentType = "application/json"}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);

    return post(url, body, contentType: contentType);
  }

  Future<Response> formGet(String? path,
      {contentType = "application/json", Map<String, dynamic>? query = null}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);
    dprint(query);
    return get(url, query: query);
  }

  Future<Response> formDelete(String? path,
      {contentType = "application/json", Map<String, dynamic>? query = null}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);
    dprint(query);
    return delete(url, query: query);
  }

  Future<Response> formPatch(String? path, dynamic body,
      {contentType = "application/json", shouldRemoveNullFields = true}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);
    var dataToPatch;
    if (shouldRemoveNullFields) {
      dataToPatch = removeNullFields(body);
    } else {
      dataToPatch = body;
    }

    return patch(url, dataToPatch, contentType: contentType);
  }

  Future<Response> formPostUrlEncoded(String? path, dynamic body,
      {contentType = "application/x-www-form-urlencoded"}) async {
    var url = "${config!.apiEndpoint}/${path}";

    var bodyStr = mapToFormUrlEncoded(body);
    var contentType = "application/x-www-form-urlencoded";
    dprint(body);
    var rest = await formPost(path, bodyStr, contentType: contentType);
    dprint("rest.bodyString");
    dprint(rest.hasError);
    dprint(rest.statusText);
    return rest;
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
