import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mdi/mdi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pool_automation_system/LandingScreen/components/default_button.dart';
import 'package:pool_automation_system/SensorScreen/components/sensor_screen.dart';
import 'package:pool_automation_system/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreenBody extends StatefulWidget {
  @override
  _LandingScreenBodyState createState() => _LandingScreenBodyState();
}

class _LandingScreenBodyState extends State<LandingScreenBody> {
  File _image;
  PlatformFile _selectedFile;
  TextStyle labelStyle = TextStyle(color: Colors.green[700]);
  bool loadingImage = false;
  bool loadingCsv = false;

  /// Capture image from camera
  Future<String> _imgFromCamera() async {
    print('in Image from camera');
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if (image != null)
      setState(() {

        _image = image;
        _saveImagePathInSharedPreference();
        //loadingImage = false;
      });
    else
      print('No image captured');
  }

  /// SELECT image form gallery
  Future<String> _imgFromGallery() async {
    print('in Image from gallery');
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (image != null)
      setState(() {
        _image = image;
        _saveImagePathInSharedPreference();
       // loadingImage = false;
      });
    else
      print('No image selected');
  }

  /// SAVE PATH OF IMAGE FILE
  void _saveImagePathInSharedPreference() async {
    print('selected image path: ${_image.path}');
    //TODO save path in shared preferences and load from shared when required
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imagePath', _image.path);
  }

  /// SAVE PATH OF CSV FILE
  void saveCsvPathInSharedPreference() async {

    print('selected csv file path: ${_selectedFile.path}');

    //TODO save path in shared preferences and load from shared when required
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('csvFilePath', _selectedFile.path);

    // print(data.length);
  }

  /// SHOW PICKER
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        setState(() {
                          loadingImage = true;
                        });
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      setState(() {
                        loadingCsv = true;
                      });
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Select CSV file
  Future selectCSVFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['csv']);

    // var localpath = await _localFile;
    // log("CSV PICKED RESULT PATHS: ${result.paths} : local path : $localpath");
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
        saveCsvPathInSharedPreference();
      });
    } else {
      _selectedFile = null;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    log("local app path: $path");
    return File('$path/counter.txt');
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: size.height * 0.1),
          Center(
            child: Text(
              'App configuration screen',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Center(
            child: Text(
              'Upload CSV file and the pool image.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kDarkGreyColor, fontSize: 18),
            ),
          ),
          DefaultButton(
            size: size,
            title: "Choose CSV file",
            buttonColor: kOrangeColor,
            press: () {
              selectCSVFile();
            },
          ),
          _selectedFile != null
              ? Text(
                  'File saved',
                  style: labelStyle,
                )
              : Container(),
          DefaultButton(
            buttonColor: kOrangeColor,
            size: size,
            title: "Upload Pool Image",
            press: () {
              _showPicker(context);
            },
          ),
          _image != null ? Text('Image saved', style: labelStyle) : Container(),
          SizedBox(height: size.height * 0.05),
          DefaultButton(
            size: size,
            title: "Next",
            buttonColor: _selectedFile != null && _image != null
                ? kOrangeColor
                : kLightGreyColor,
            press: () {
              _selectedFile != null && _image != null
                  ? Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SensorScreen(_image.path, _selectedFile.path),
                      ),
                    )
                  // ignore: unnecessary_statements
                  : null;
            },
          ),
          SizedBox(height: size.height * 0.05),
        ],
      ),
    );
  }
}
