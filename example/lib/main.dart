import 'package:flutter/material.dart';
import 'package:flutter_auth/login.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';

void main() {
  Get.put<APIConfig>(APIConfig(
      apiEndpoint: "https://dukapi.roometo.com",
      version: "api/v1",
      clientId: "NUiCuG59zwZJR14tIdWD7iQ5ILFnpxbdrO2epHIG",
      tokenUrl: 'o/token/',
      grantType: "password",
      revokeTokenUrl: 'o/revoke_token/'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  late String title;
  MyHomePage({super.key, this.title = "Hello world !"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoginWidget(),
        ],
      ),
    );
  }
}
