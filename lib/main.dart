import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:glitched/ar/gate_pass_list_screen.dart';
import 'package:glitched/screens/onBoarding/intro_Screen.dart';
import 'package:glitched/screens/onBoarding/onBoardingScreen_1.dart';
import 'package:glitched/screens/splash/splash_Screen.dart';

import 'ar/app_binding.dart';
import 'firebase_options.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Glitched',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),

      initialBinding: AppBinding(),
      home:GatePassListScreen(),
    );
  }
}


