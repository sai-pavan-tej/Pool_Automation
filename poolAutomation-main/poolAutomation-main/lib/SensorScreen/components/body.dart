import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pool_automation_system/LandingScreen/components/default_button.dart';
import 'package:pool_automation_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:pool_automation_system/LandingScreen/components/control_button.dart';
import 'package:pool_automation_system/SensorScreen/components/custom_button.dart';
import 'package:mdi/mdi.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';

class ButtonObj {
  String rqName;
  var status;
  ControlButton button;
  ButtonObj(this.rqName, this.status, this.button);
}

class DropDownObj {
  String rqName;
  var status;
  String PullDownName;
  List<DropdownMenuItem<String>> menuItems = [];

  DropDownObj(this.rqName, this.status, this.PullDownName, this.menuItems);
}

class CommonScreenData {
  String imagPath;
  String familyName = '';
  String uniqueSystemId = '';
  String ipAddress = '';

  CommonScreenData(
      {this.imagPath, this.familyName, this.uniqueSystemId, this.ipAddress});
}

class SensorScreenBody extends StatelessWidget {
  var csvPath;
  var imagePath;
  SensorScreenBody(this.imagePath, this.csvPath);
  String familyName = '';
  String uniqueSystemId = '';
  String ipAddress = '';

  CommonScreenData commonScreenData = CommonScreenData();

  List<ButtonObj> operatingModeButtons = [];
  List<ButtonObj> valvesButtons = [];
  List<DropDownObj> pumpAndLightDropdowns = [];
  List<DropDownObj> cleaningScheduleDropdown = [];

  List<DropdownMenuItem<String>> _pullDown1menuItems = [];
  List<DropdownMenuItem<String>> _pullDown2menuItems = [];
  List<DropdownMenuItem<String>> _pullDown3menuItems = [];
  List<DropdownMenuItem<String>> _pullDown4menuItems = [];
  List<DropdownMenuItem<String>> _pullDown5menuItems = [];

  List<DropdownMenuItem<String>> _pullDown6menuItems = [];

  String p1_state;
  String p2_state;
  String p3_state;
  String p4_state;

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    //super.dispose();
  }

  Future<String> getDataforall(path) async {
    commonScreenData.imagPath = imagePath;

    var id;
    var name;
    var itemsLength;
    var status;

    final input = new File(path).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

    print('fields length: ${fields.length}');
    int i = 0;
    for (; i < 4; i++) {
      print("$i : info");
      if (i == 0) {
        familyName =
            fields[i].toString().split(':')[1].split(']')[0].split(',')[0];
        commonScreenData.familyName = familyName.trim();
        print("Family name: $familyName");
      }
      if (i == 1) {
        uniqueSystemId =
            fields[i].toString().split(':')[1].split(']')[0].split(',')[0];
        commonScreenData.uniqueSystemId = uniqueSystemId.trim();
        print("Unique system id: $uniqueSystemId");
      }
      if (i == 3) {
        ipAddress =
            fields[i].toString().split(':')[1].split(']')[0].split(',')[0];
        commonScreenData.ipAddress = ipAddress.trim();
        print("IP address: ${ipAddress.trim()}");
      }
    }

    for (; i < 28; i++) {
      // var splitted = fields[i].toString().split(':')[1].split(',');

      var splitted =
          fields[i].toString().split('[')[1].split(']')[0].split(',');
      id = splitted[0].split(':')[1].trim();
      name = splitted[1];
      name = name.substring(1, splitted[1].length).toString().trim();
      status = int.parse(splitted[2].trim());
      print(
          "$i: BUTTON id --- $id  --- name: ${name} : status: ${status.toString()}");
      // print("$i: Buttons --- ${fields[i].toString().split(':')[1].split(',')[1]}");
      if (i < 12) {
        switch (id) {
          case 'B01':
            operatingModeButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.autorenew,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B02':
            operatingModeButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Mdi.shower,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B03':
            operatingModeButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.hot_tub,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B04':
            operatingModeButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.water_damage,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B05':
            operatingModeButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.pool,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B06':
            operatingModeButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.waves,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B07':
            operatingModeButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.opacity,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B08':
            operatingModeButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Mdi.sailBoat,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
        }
      } else {
        switch (id) {
          case 'B09':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_back,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B10':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_forward,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B11':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_back,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B12':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_forward,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B13':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_back,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B14':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_forward,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B15':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_back,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B16':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_forward,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B17':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_back,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B18':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_forward,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B19':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_back,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B20':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_forward,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B21':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_back,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B22':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_forward,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B23':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_back,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
          case 'B24':
            valvesButtons.add(ButtonObj(
                id,
                status,
                ControlButton(
                  icon: Icons.arrow_forward,
                  title: status == 0 ? "NA" : name,
                  color: status == 0 ? kLightGreyColor : kOrangeColor,
                )));
            break;
        }
        // valvesButtons.add(ButtonObj(
        //     id,
        //     status,
        //     ControlButton(
        //       title: status == 0 ? "NA":name,
        //       color: status == 0 ? kLightGreyColor : kOrangeColor,
        //     )));
      }
    }

    for (; i < fields.length; i++) {
      // print('$i: pull downs ${fields[i].toString()}');
      var splitted =
          fields[i].toString().split('[')[1].split(']')[0].split(',');
      // print("SPLIT => $splitted");
      id = splitted.toString().split(',')[0].split(':')[1].substring(1);
      name = splitted[1];
      status = int.parse(splitted[2].trim());
      itemsLength = name.toString().trim() != "NA" ? splitted[3] : '0';
      log('pull down name: ${id} -- length: ${itemsLength}');
      itemsLength = int.parse(itemsLength);
      try {
        switch (id) {
          case 'P01':
            p1_state = 'empty';
            if (itemsLength == 0 || status == 0) {
              _pullDown1menuItems
                  .add(DropdownMenuItem(value: id, child: Text('NA')));
            } else {
              for (int j = itemsLength > 0 ? 4 : splitted.length;
                  j < (4 + itemsLength);
                  j++) {
                // print('splitted[j] : ${splitted[j]}');
                _pullDown1menuItems.add(DropdownMenuItem(
                    value: splitted[j].toString(),
                    child: Text('${splitted[j].toString()}')));
              }
            }
            pumpAndLightDropdowns.add(DropDownObj(
                id, status, status == 0 ? "NA" : name, _pullDown1menuItems));
            // print("PULL DOWN ! length ${_pullDown1menuItems.length}");
            break;
          case 'P02':
            p2_state = 'empty';
            if (itemsLength == 0 || status == 0) {
              _pullDown2menuItems
                  .add(DropdownMenuItem(value: id, child: Text('NA')));
            } else {
              for (int j = itemsLength > 0 ? 4 : splitted.length;
                  j < (4 + itemsLength);
                  j++) {
                print('splitted[j] : ${splitted[j]}');
                _pullDown2menuItems.add(DropdownMenuItem(
                    value: splitted[j].toString(),
                    child: Text('${splitted[j].toString()}')));
              }
            }

            pumpAndLightDropdowns.add(DropDownObj(
                id, status, status == 0 ? "NA" : name, _pullDown2menuItems));
            // print("PULL DOWN 2 length ${_pullDown1menuItems.length}");
            break;
          case 'P03':
            p3_state = 'empty';
            if (itemsLength == 0 || status == 0) {
              _pullDown3menuItems
                  .add(DropdownMenuItem(value: id, child: Text('NA')));
            } else {
              for (int j = 4; j < (4 + itemsLength); j++) {
                // print('splitted[j] : ${splitted[j]}');
                _pullDown3menuItems.add(DropdownMenuItem(
                    value: splitted[j].toString(),
                    child: Text('${splitted[j].toString()}')));
              }
            }
            pumpAndLightDropdowns.add(DropDownObj(
                id, status, status == 0 ? "NA" : name, _pullDown3menuItems));
            // print("PULL DOWN 3 length ${_pullDown3menuItems.length}");
            break;
          case 'P04':
            p4_state = 'empty';
            if (itemsLength == 0 || status == 0) {
              _pullDown4menuItems
                  .add(DropdownMenuItem(value: id, child: Text('NA')));
            } else {
              for (int j = 4; j < (4 + itemsLength); j++) {
                // print('splitted[j] : ${splitted[j]}');
                _pullDown4menuItems.add(DropdownMenuItem(
                    value: splitted[j].toString(),
                    child: Text('${splitted[j].toString()}')));
              }
            }
            pumpAndLightDropdowns.add(DropDownObj(
                id, status, status == 0 ? "NA" : name, _pullDown4menuItems));
            // print("PULL DOWN 3 length ${_pullDown4menuItems.length}");
            break;
          case 'P05':
            if (itemsLength == 0 || status == 0) {
              _pullDown5menuItems
                  .add(DropdownMenuItem(value: id, child: Text('NA')));
            } else {
              for (int j = 4; j < (4 + itemsLength); j++) {
                _pullDown5menuItems.add(DropdownMenuItem(
                    value: splitted[j].toString(),
                    child: Text('${splitted[j].toString()}')));
              }
            }
            pumpAndLightDropdowns.add(DropDownObj(
                id, status, status == 0 ? "NA" : name, _pullDown5menuItems));
            // print("PULL DOWN 5 length ${_pullDown5menuItems.length}");
            break;
          case 'P06':
            if (itemsLength == 0 || status == 0) {
              _pullDown6menuItems
                  .add(DropdownMenuItem(value: id, child: Text('NA')));
            } else {
              for (int j = 4; j < (4 + itemsLength); j++) {
                _pullDown6menuItems.add(DropdownMenuItem(
                    value: splitted[j].toString(),
                    child: Text('${splitted[j].toString()}')));
              }
            }
            cleaningScheduleDropdown.add(DropDownObj(
                id, status, status == 0 ? "NA" : name, _pullDown6menuItems));
            // print("PULL DOWN 6 length ${_pullDown6menuItems.length}");
            break;
        }
      } catch (error) {
        print("ERROR $error");
      }
    }
    return 'ok';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDataforall(csvPath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ProgressHUD(
              child: PageView(
                controller: _controller,
                children: [
                  Page1Widget(commonScreenData, operatingModeButtons),
                  Page2Widget(commonScreenData, pumpAndLightDropdowns, p1_state,
                      p2_state, p3_state, p4_state),
                  Page3Widget(commonScreenData, valvesButtons),
                  Page4Widget(commonScreenData, cleaningScheduleDropdown),
                  Page5Widget(
                    commonScreenData,
                    operatingModeButtons,
                    pumpAndLightDropdowns,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError)
            return Center(
                child: Text('Something went wrong! ${snapshot.error}'));
          else
            return Center(child: Text('Loading'));
        });
  }
}

SharedPreferences prefs;
init() async {
  prefs = await SharedPreferences.getInstance();
}

class Page1Widget extends StatefulWidget {
  CommonScreenData screenData;
  List<ButtonObj> buttons = [];
  Page1Widget(this.screenData, this.buttons);

  @override
  _Page1WidgetState createState() => _Page1WidgetState();
}

class _Page1WidgetState extends State<Page1Widget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> _deleteCacheDir() async {
    Directory tempDir = await getTemporaryDirectory();

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.menu,
                  size: 30,
                  color: kDarkGreyColor,
                ),
                Text(
                  '${widget.screenData.familyName}\'s Family Pool',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  height: size.height * 0.045,
                  width: size.width * 0.095,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () async {
                      ///Remove data for testing purposes only
                      prefs.remove("imagePath");
                      prefs.remove("csvFilePath");
                      prefs.clear();
                      _deleteCacheDir();
                      _deleteAppDir();
                      print("Shared pref cleared -- Just for testing purpose ");
                    },
                    child: Icon(
                      Icons.notifications_none,
                      color: kDarkGreyColor,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 300,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: widget.screenData.imagPath == null
                          ? Image.asset(
                              "assets/images/profile_picture.jpg",
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(widget.screenData.imagPath),
                              fit: BoxFit.cover,
                            )),
                ),
                SizedBox(width: size.width * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //  'JUNE 14, 2020',
                    //  style: TextStyle(
                    //   color: Colors.grey,
                    //   fontWeight: FontWeight.w600,
                    //  ),
                    // ),
                    // Text(
                    // 'Good Day,\nMiguel',
                    // style: TextStyle(
                    //  color: Colors.black87,
                    //  fontWeight: FontWeight.bold,
                    //  fontSize: 30,
                    //  ),
                    //),
                  ],
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Operating Modes',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1.5),
                  itemCount: widget.buttons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: InkWell(
                        onTap: () => widget.buttons[index].status == 0
                            ? {}
                            : rq(widget.buttons[index].rqName),
                        child: ControlButton(
                          color: widget.buttons[index].button.color,
                          size: size,
                          title: '${widget.buttons[index].button.title}',
                          icon: widget.buttons[index].button.icon,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void rq(String command) async {
    /*
    var url = Uri.parse('http://${widget.screenData.ipAddress}/?' +
        command +
        "1@" +
        widget.screenData.uniqueSystemId);
    var response = await http.get(url);
*/
    final progress = ProgressHUD.of(context);
    progress.show();

    final channel =
        IOWebSocketChannel.connect('ws://${widget.screenData.ipAddress}:81');

    channel.sink.add(command + "1@" + widget.screenData.uniqueSystemId);

    channel.stream.listen((message) {
      print(message);
      channel.sink.close(status.goingAway);

      if (message == "Task is done") progress.dismiss();

      if (message.toString().substring(0, 10) == "set_state:") {
        print("set state found");

        for (int i = 0; i < 8; i++) widget.buttons[i].status = false;

        widget.buttons[int.tryParse(message.toString().substring(10, 11))]
            .status = true;
      }
    });
  }
}

class Page2Widget extends StatefulWidget {
  Page2Widget(this.screenData, this._menuItems, this.p1_state, this.p2_state,
      this.p3_state, this.p4_state);
  CommonScreenData screenData;
  List<DropDownObj> _menuItems; //yahan
  String p1_state;
  String p2_state;
  String p3_state;
  String p4_state;

  @override
  _Page2WidgetState createState() => _Page2WidgetState();
}

class _Page2WidgetState extends State<Page2Widget> {
  String valueChoosen_dropdown1;
  String index_DD1;
  String valueChoosen_dropdown2;
  String index_DD2;
  String valueChoosen_dropdown3;
  String index_DD3;
  String valueChoosen_dropdown4;
  String index_DD4;
  String valueChoosen_dropdown5;
  String index_DD5;

  @override
  void initState() {
    index_DD1 = widget._menuItems[0].menuItems[0].value;
    index_DD2 = widget._menuItems[1].menuItems[0].value;
    index_DD3 = widget._menuItems[2].menuItems[0].value;
    index_DD4 = widget._menuItems[3].menuItems[0].value;
    index_DD5 = widget._menuItems[4].menuItems[0].value;
  }

  // Widget dropDown(List selectionElements, int num) {
  //   return DropdownButton(
  //     items: selectionElements.map((valueItem) {
  //       return DropdownMenuItem(
  //         child: Text(valueItem),
  //         value: valueItem,
  //       );
  //     }).toList(),
  //     hint: Text("Select item"),
  //     value: (num == 1)
  //         ? valueChoosen_dropdown1
  //         : (num == 2)
  //             ? valueChoosen_dropdown2
  //             : (num == 3)
  //                 ? valueChoosen_dropdown3
  //                 : (num == 4)
  //                     ? valueChoosen_dropdown4
  //                     : (num == 5)
  //                         ? valueChoosen_dropdown5
  //                         : null,
  //     dropdownColor: kBgColor,
  //     onChanged: (newValue) {
  //       setState(() {
  //         if (num == 1) {
  //           valueChoosen_dropdown1 = newValue;
  //           index_DD1 = selectionElements.indexOf(newValue).toString();
  //         } else if (num == 2) {
  //           valueChoosen_dropdown2 = newValue;
  //           index_DD2 = selectionElements.indexOf(newValue).toString();
  //         } else if (num == 3) {
  //           valueChoosen_dropdown3 = newValue;
  //           index_DD3 = selectionElements.indexOf(newValue).toString();
  //         } else if (num == 4) {
  //           valueChoosen_dropdown4 = newValue;
  //           index_DD4 = selectionElements.indexOf(newValue).toString();
  //         } else if (num == 5) {
  //           valueChoosen_dropdown5 = newValue;
  //           index_DD5 = selectionElements.indexOf(newValue).toString();
  //         }
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.menu,
                    size: 30,
                    color: kDarkGreyColor,
                  ),
                  Text(
                    '${widget.screenData.familyName}\'s Family Pool',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    height: size.height * 0.045,
                    width: size.width * 0.095,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      color: kDarkGreyColor,
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 300,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: widget.screenData.imagPath == null
                            ? Image.asset(
                                "assets/images/profile_picture.jpg",
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(widget.screenData.imagPath),
                                fit: BoxFit.cover,
                              )),
                  ),
                  SizedBox(width: size.width * 0.05),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //  'JUNE 14, 2020',
                      //  style: TextStyle(
                      //   color: Colors.grey,
                      //   fontWeight: FontWeight.w600,
                      //  ),
                      // ),
                      // Text(
                      // 'Good Day,\nMiguel',
                      // style: TextStyle(
                      //  color: Colors.black87,
                      //  fontWeight: FontWeight.bold,
                      //  fontSize: 30,
                      //  ),
                      //),
                    ],
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Pump and Lights',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(widget._menuItems[0].PullDownName),
                  Container(
                    width: size.width * 0.4,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton<String>(
                    items: widget._menuItems[0].menuItems,
                    value: index_DD1.toString(),
                    onChanged: (value) =>
                        setState(() => index_DD1 = value.toString()),
                  ),
                  InkWell(
                    onTap: () => widget._menuItems[0].status == 0
                        ? {}
                        : rq(widget._menuItems[0].rqName, index_DD1.toString()),
                    child: CustomButton(
                      color: widget._menuItems[0].status == 0
                          ? kLightGreyColor
                          : kOrangeColor,
                      w: 0.3,
                      h: 0.05,
                      fsize: 15,
                      size: size,
                      title: 'Activate',
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(widget._menuItems[1].PullDownName),
                  Container(
                    width: size.width * 0.4,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton<String>(
                    items: widget._menuItems[1].menuItems,
                    value: index_DD2.toString(),
                    onChanged: (value) =>
                        setState(() => index_DD2 = value.toString()),
                  ),
                  InkWell(
                    onTap: () => widget._menuItems[1].status == 0
                        ? {}
                        : rq(widget._menuItems[1].rqName, index_DD2.toString()),
                    child: CustomButton(
                      color: widget._menuItems[1].status == 0
                          ? kLightGreyColor
                          : kOrangeColor,
                      w: 0.3,
                      h: 0.05,
                      fsize: 15,
                      size: size,
                      title: 'Activate',
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(widget._menuItems[2].PullDownName),
                  Container(
                    width: size.width * 0.4,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton<String>(
                    items: widget._menuItems[2].menuItems,
                    value: index_DD3.toString(),
                    onChanged: (value) =>
                        setState(() => index_DD3 = value.toString()),
                  ),
                  InkWell(
                    onTap: () => widget._menuItems[2].status == 0
                        ? {}
                        : rq(widget._menuItems[2].rqName, index_DD3.toString()),
                    child: CustomButton(
                      color: widget._menuItems[2].status == 0
                          ? kLightGreyColor
                          : kOrangeColor,
                      w: 0.3,
                      h: 0.05,
                      fsize: 15,
                      size: size,
                      title: 'Activate',
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(widget._menuItems[3].PullDownName),
                  Container(
                    width: size.width * 0.4,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton<String>(
                    items: widget._menuItems[3].menuItems,
                    value: index_DD4.toString(),
                    onChanged: (value) =>
                        setState(() => index_DD4 = value.toString()),
                  ),
                  InkWell(
                    onTap: () => widget._menuItems[3].status == 0
                        ? {}
                        : rq(widget._menuItems[3].rqName, index_DD4.toString()),
                    child: CustomButton(
                      color: widget._menuItems[3].status == 0
                          ? kLightGreyColor
                          : kOrangeColor,
                      w: 0.3,
                      h: 0.05,
                      fsize: 15,
                      size: size,
                      title: 'Activate',
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget._menuItems[4].PullDownName),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    items: widget._menuItems[4].menuItems,
                    value: index_DD5.toString(),
                    onChanged: (value) =>
                        setState(() => index_DD5 = value.toString()),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => widget._menuItems[4].status == 0
                        ? {}
                        : rq(widget._menuItems[4].rqName, index_DD5.toString()),
                    child: CustomButton(
                      color: widget._menuItems[4].status == 0
                          ? kLightGreyColor
                          : kOrangeColor,
                      w: 0.4,
                      h: 0.07,
                      fsize: 15,
                      size: size,
                      title: 'Start Pump',
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => rq_STOP("B25"),
                    child: CustomButton(
                      color: kOrangeColor,
                      w: 0.6,
                      h: 0.08,
                      fsize: 20,
                      size: size,
                      title: 'Stop',
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  void rq(String command, String index) async {
    final progress = ProgressHUD.of(context);
    progress.show();

    final channel =
        IOWebSocketChannel.connect('ws://${widget.screenData.ipAddress}:81');

    channel.sink
        .add(command + "1@" + widget.screenData.uniqueSystemId + "/" + index);

    channel.stream.listen((message) {
      print(message);
      channel.sink.close(status.goingAway);
      if (message == "Task is done") progress.dismiss();
    });
  }

  void rq_STOP(String command) async {
    final progress = ProgressHUD.of(context);
    progress.show();

    final channel =
        IOWebSocketChannel.connect('ws://${widget.screenData.ipAddress}:81');

    channel.sink.add(command + "1@" + widget.screenData.uniqueSystemId);

    channel.stream.listen((message) {
      print(message);
      channel.sink.close(status.goingAway);

      if (message == "Task is done") progress.dismiss();
    });
  }
}

class Page3Widget extends StatefulWidget {
  Page3Widget(this.screenData, this.buttons);
  CommonScreenData screenData;
  List<ButtonObj> buttons = [];
  // String familyName;
  @override
  _Page3WidgetState createState() => _Page3WidgetState();
}

class _Page3WidgetState extends State<Page3Widget> {
  // String systemID = "123";
  // String IPaddress = "192.168.10.12";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.menu,
                  size: 30,
                  color: kDarkGreyColor,
                ),
                Text(
                  '${widget.screenData.familyName}\'s Family Pool',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  height: size.height * 0.045,
                  width: size.width * 0.095,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    color: kDarkGreyColor,
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 300,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: widget.screenData.imagPath == null
                          ? Image.asset(
                              "assets/images/profile_picture.jpg",
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(widget.screenData.imagPath),
                              fit: BoxFit.cover,
                            )),
                ),
                SizedBox(width: size.width * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //  'JUNE 14, 2020',
                    //  style: TextStyle(
                    //   color: Colors.grey,
                    //   fontWeight: FontWeight.w600,
                    //  ),
                    // ),
                    // Text(
                    // 'Good Day,\nMiguel',
                    // style: TextStyle(
                    //  color: Colors.black87,
                    //  fontWeight: FontWeight.bold,
                    //  fontSize: 30,
                    //  ),
                    //),
                  ],
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Valves Manual Control',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1.5),
                  itemCount: widget.buttons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: InkWell(
                        onTap: () => widget.buttons[index].status == 0
                            ? {}
                            : rq(widget.buttons[index].rqName),
                        child: ControlButton(
                          color: widget.buttons[index].button.color,
                          size: size,
                          title: '${widget.buttons[index].button.title}',
                          icon: widget.buttons[index].button.icon,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void rq(String command) async {
    final progress = ProgressHUD.of(context);
    progress.show();

    final channel =
        IOWebSocketChannel.connect('ws://${widget.screenData.ipAddress}:81');

    channel.sink.add(command + "1@" + widget.screenData.uniqueSystemId);

    channel.stream.listen((message) {
      print(message);
      channel.sink.close(status.goingAway);

      if (message == "Task is done") progress.dismiss();
    });
  }
}

class Page4Widget extends StatefulWidget {
  Page4Widget(this.screenData, this._menuItems);
  CommonScreenData screenData;
  List<DropDownObj> _menuItems;
  @override
  _Page4WidgetState createState() => _Page4WidgetState();
}

class _Page4WidgetState extends State<Page4Widget> {
  String valueChoosen_dropdown1;
  String DD1_value;
  @override
  void initState() {
    DD1_value = widget._menuItems[0].menuItems[0].value;
  }
  // Widget dropDown(List selectionElements) {
  //   return DropdownButton(
  //     items: selectionElements.map((valueItem) {
  //       return DropdownMenuItem(
  //         child: Text(valueItem),
  //         value: valueItem,
  //       );
  //     }).toList(),
  //     hint: Text("Select item"),
  //     value: valueChoosen_dropdown1,
  //     dropdownColor: kBgColor,
  //     onChanged: (newValue) {
  //       setState(() {
  //         valueChoosen_dropdown1 = newValue;
  //         DD1_value = selectionElements.indexOf(newValue).toString();
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.menu,
                    size: 30,
                    color: kDarkGreyColor,
                  ),
                  Text(
                    '${widget.screenData.familyName}\'s Family Pool',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    height: size.height * 0.045,
                    width: size.width * 0.095,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      color: kDarkGreyColor,
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 300,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: widget.screenData.imagPath == null
                            ? Image.asset(
                                "assets/images/profile_picture.jpg",
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(widget.screenData.imagPath),
                                fit: BoxFit.cover,
                              )),
                  ),
                  SizedBox(width: size.width * 0.05),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //  'JUNE 14, 2020',
                      //  style: TextStyle(
                      //   color: Colors.grey,
                      //   fontWeight: FontWeight.w600,
                      //  ),
                      // ),
                      // Text(
                      // 'Good Day,\nMiguel',
                      // style: TextStyle(
                      //  color: Colors.black87,
                      //  fontWeight: FontWeight.bold,
                      //  fontSize: 30,
                      //  ),
                      //),
                    ],
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Schedule Cleaning',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget._menuItems[0].PullDownName),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    items: widget._menuItems[0].menuItems,
                    value: DD1_value.toString(),
                    onChanged: (value) =>
                        setState(() => DD1_value = value.toString()),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.09),
              InkWell(
                onTap: () => widget._menuItems[0].status == 0
                    ? {}
                    : rq(widget._menuItems[0].rqName, DD1_value.toString()),
                child: CustomButton(
                  color: widget._menuItems[0].status == 0
                      ? kLightGreyColor
                      : kOrangeColor,
                  w: 0.4,
                  h: 0.07,
                  fsize: 15,
                  size: size,
                  title: 'Schedule',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void rq(String command, String index) async {
    /*

    var url = Uri.parse('http://${widget.screenData.ipAddress}/?' +
        command +
        "1@" +
        widget.screenData.uniqueSystemId +
        "=" +
        index);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');


  */

    final progress = ProgressHUD.of(context);
    progress.show();

    final channel =
        IOWebSocketChannel.connect('ws://${widget.screenData.ipAddress}:81');

    channel.sink
        .add(command + "1@" + widget.screenData.uniqueSystemId + "/" + index);

    channel.stream.listen((message) {
      print(message);
      channel.sink.close(status.goingAway);

      if (message == "Task is done") progress.dismiss();
    });
  }
}

class Page5Widget extends StatefulWidget {
  CommonScreenData screenData;
  List<ButtonObj> buttons = [];
  List<DropDownObj> _menuItems;

  Page5Widget(this.screenData, this.buttons, this._menuItems);

  @override
  _Page5WidgetState createState() => _Page5WidgetState();
}

class _Page5WidgetState extends State<Page5Widget> {
  String valueChoosen_dropdown1;
  String index_DD1;
  String valueChoosen_dropdown2;
  String index_DD2;
  String valueChoosen_dropdown3;
  String index_DD3;
  String valueChoosen_dropdown4;
  String index_DD4;
  String valueChoosen_dropdown5;
  String index_DD5;

  @override
  void initState() {
    index_DD1 = widget._menuItems[0].menuItems[0].value;
    index_DD2 = widget._menuItems[1].menuItems[0].value;
    index_DD3 = widget._menuItems[2].menuItems[0].value;
    index_DD4 = widget._menuItems[3].menuItems[0].value;
    index_DD5 = widget._menuItems[4].menuItems[0].value;

    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.menu,
                  size: 30,
                  color: kDarkGreyColor,
                ),
                Text(
                  '${widget.screenData.familyName}\'s Family Pool',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  height: size.height * 0.045,
                  width: size.width * 0.095,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 300,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: widget.screenData.imagPath == null
                          ? Image.asset(
                              "assets/images/profile_picture.jpg",
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(widget.screenData.imagPath),
                              fit: BoxFit.cover,
                            )),
                ),
                SizedBox(width: size.width * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [],
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Status Screen',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),
            GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, childAspectRatio: 7),
                itemCount: widget.buttons.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    (widget.buttons[index].button.title == "NA")
                                        ? Colors.grey
                                        : (widget.buttons[index].status == true)
                                            ? Colors.lightGreenAccent[400]
                                            : Colors.green[900])),
                      ),
                      Text('${widget.buttons[index].button.title}'),
                    ],
                  );
                }),
            SizedBox(height: size.height * 0.03),
            Text(
              'Pump',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    )
        //new widgets
        );
  }
}
