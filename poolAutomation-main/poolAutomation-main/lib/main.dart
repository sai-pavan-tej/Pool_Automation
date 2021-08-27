import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pool_automation_system/LandingScreen/landing_screen.dart';
import 'package:pool_automation_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SensorScreen/components/sensor_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();


  bool imageExists = prefs.containsKey('imagePath');
  bool csvExists = prefs.containsKey('csvFilePath');
  Directory tempDir = await getTemporaryDirectory();

  if(csvExists && imageExists && tempDir.existsSync())
    {
      var imagePath = prefs.getString('imagePath');
      var csvPath = prefs.getString('csvFilePath');

      log('CSV PATH: $csvPath');
      log('IMAGE PATH: $imagePath');
      runApp(MyApp(csvExists, imageExists, imagePath: imagePath, csvPath: csvPath,));
    }
  else runApp(MyApp(csvExists, imageExists));
}

class MyApp extends StatelessWidget {
  MyApp(this.csvExists, this.imageExists, {this.imagePath, this.csvPath});
  bool csvExists, imageExists;
  var imagePath, csvPath;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins'
      ),
      home: csvExists && imageExists ?  SensorScreen(imagePath, csvPath) : LandingScreen(),
    );
  }
}


