import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_auth/options.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    APIConfig config = Get.find<APIConfig>();

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
      onSuccess: (res) {
        dprint("Logged in");
        dprint(res);
      },
      formGroupOrder: const [
        ["username"],
        ["password"]
      ],
      formTitle: "Signup",
    );
  }
}
