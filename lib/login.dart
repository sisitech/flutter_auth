library flutter_auth;

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_auth/options.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';

import 'flutter_auth_controller.dart';

class LoginWidget extends StatelessWidget {
  final Function? onLoginChange;
  const LoginWidget({super.key, this.onLoginChange});

  @override
  Widget build(BuildContext context) {
    APIConfig config = Get.find<APIConfig>();
    AuthController authController = Get.find<AuthController>();

    return MyCustomForm(
      formItems: options,
      url: "o/token/",
      submitButtonText: "Login",
      submitButtonPreText: "",
      loadingMessage: "Signing in...",
      handleErrors: (value) {
        dprint(value);
        return "Your password might be wrong";
      },
      contentType: ContentType.form_url_encoded,
      extraFields: {
        "client_id": config.clientId,
        "grant_type": config.grantType,
      },
      onSuccess: (res) async {
        dprint("Logged in");
        dprint(res);
        await authController.getSaveProfile(res);
        if (onLoginChange != null) {
          onLoginChange!(res);
        }
      },
      formGroupOrder: const [
        ["username"],
        ["password"]
      ],
      formTitle: "Signup",
    );
  }
}
