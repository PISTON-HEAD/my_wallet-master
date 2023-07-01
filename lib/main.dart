// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_wallet/LogScreen/signing.dart';
import 'package:my_wallet/tasks/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
  String? logger = "null";
  String? userName = "null";
  userName = sharedPreferences.getString("Name");
  logger = sharedPreferences.getString("LoggedIn");
  runApp(MyApp(logger: logger,userName: userName,));
}

class MyApp extends StatelessWidget {
  final String? logger,userName;
  const MyApp({super.key, required this.logger, this.userName});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your personalized Wallet',
      defaultTransition: Transition.zoom,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home:logger == null || logger=="false"?  signingIn(): requestSender(),
    );
  }
}
