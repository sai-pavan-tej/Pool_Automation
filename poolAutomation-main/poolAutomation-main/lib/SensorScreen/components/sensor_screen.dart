import 'package:pool_automation_system/SensorScreen/components/body.dart';
import 'package:pool_automation_system/constants.dart';
import 'package:flutter/material.dart';

class SensorScreen extends StatelessWidget {
  var csvPath;
  var imagePath;
  SensorScreen(this.imagePath, this.csvPath);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:kBgColor,
      body: SensorScreenBody(imagePath, csvPath),
    );
  }
}

