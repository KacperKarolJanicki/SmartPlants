import 'package:esp32_module/views/analitics/analytics.dart';
import 'package:esp32_module/views/settings/components/wireless_settings.dart';
import 'package:esp32_module/views/settings/settings.dart';
import 'package:esp32_module/widget_components/app_style_scaffold.dart';
import 'package:esp32_module/widget_components/lights_widget.dart';
import 'package:esp32_module/widget_components/pomp_toolbar.dart';
import 'package:esp32_module/widget_components/sensor_percentage_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:backend_connection/backend_connection.dart';
import 'function_components/local_data_storage.dart';
import 'widget_components/container_widget.dart';
import 'widget_components/button.dart';
import 'function_components/connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String connectionIconPath = '';
  bool percentageLoading = false;
  bool lightLoading = false;

  void connection() async {
    setState(() {
      isLoading = true;
      lightLoading = true;
    });
    if(lightsOn){
    currentLightsState = await backend.download(
        '$host/light',
        '$host/light').whenComplete((){
          setState(() {
            lightLoading = false;
          });
    });}
    fromSensorsData = await backend.download('$host/ground_data', '$host/ground_data', headers: {'deviceIp':pumpDeviceIP}).whenComplete((){
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getIP().whenComplete((){connection();});
  }

  @override
  Widget build(BuildContext context) {
    return AppStyleScaffold(body: Center(
        child:
        Column(
            spacing: 5,
            mainAxisAlignment: .center,
            children: [
              lightLoading ? LightsOff() : currentLightsState == 'light_on' ?  lightsOn ? LightsOn() : LightsOff() : LightsOff(),
              Image.asset('assets/images/$appBar',
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 1.5),
              isLoading
                  ? CircularProgressIndicator(color: Colors.green)
                  :
              pumpDeviceIP
                  .replaceAll('http://', '')
                  .isNotEmpty ? ContainerWidget(
                  width: 325, height: 425, scrollable: true,
                  children: [
                    SizedBox(height: 10),
                    PompToolbar(
                        pompLabel: 'Pomp 1', pompID: 'water_pomp_1',
                        otherWidget: percentageLoading
                            ? CircularProgressIndicator(color: Colors.green)
                            : PercentageToolbar(
                            voltageId: 'sensor_voltage_1',
                            stateId: 'sensor_1_ground')
                    ),
                    SizedBox(height: 5),
                    PompToolbar(
                        pompLabel: 'Pomp 2', pompID: 'water_pomp_2',
                        otherWidget: percentageLoading
                            ? CircularProgressIndicator(color: Colors.green)
                            : PercentageToolbar(
                            voltageId: 'sensor_voltage_2',
                            stateId: 'sensor_2_ground')
                    ),
                    SizedBox(height: 5),
                    PompToolbar(
                        pompLabel: 'Pomp 3', pompID: 'water_pomp_3',
                        otherWidget: percentageLoading
                            ? CircularProgressIndicator(color: Colors.green)
                            : PercentageToolbar(
                            voltageId: 'sensor_voltage_3',
                            stateId: 'sensor_3_ground')),
                    SizedBox(height: 5),
                    PompToolbar(
                      pompLabel: 'Pomp 4', pompID: 'water_pomp_4',
                      otherWidget: percentageLoading
                          ? CircularProgressIndicator(color: Colors.green)
                          : PercentageToolbar(
                          voltageId: 'sensor_voltage_4',
                          stateId: 'sensor_4_ground'),
                    )
                  ]) : WirelessSettings(),
              AppStyleButton(
                buttonText: 'More',
                fontSize: 10,
                icon: Icon(Icons.expand_more),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          duration: Duration(seconds: 15),
                          backgroundColor: Colors.green.shade200.withAlpha(230),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.5),
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 0,
                          content: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              spacing: 10,
                              children: [
                                OverflowBar(
                                    alignment: MainAxisAlignment.center,
                                    spacing: 20,
                                    children: [
                                      AppStyleButton(onPressed: () {
                                        if (lightsOn == false) {
                                          setState(() {
                                            lightsOn = true;
                                          });
                                          backend.send(
                                              '$host/light',
                                              '$host/light',
                                              data: {"turn_on": true},
                                              headers: {
                                                'deviceIP': lightsDeviceIP,
                                              });
                                          LocalDataStorage('lightsState').setData(lightsOn.toString());
                                        }
                                      }, buttonText: "On", fontSize: 10, icon: Icon(Icons.lightbulb, size: 10)),
                                      AppStyleButton(onPressed: () {
                                        setState(() {
                                          lightsOn = false;
                                        });
                                        backend.send(
                                            '$host/light',
                                            '$host/light',
                                            data: {"turn_on": false},
                                            headers: {
                                              'deviceIP': lightsDeviceIP,
                                            });
                                        LocalDataStorage('lightsState').setData(lightsOn.toString());
                                      }, buttonText: "Off", fontSize: 10, icon: Icon(Icons.lightbulb_outline, size: 10)),
                                      AppStyleButton(onPressed: () async {
                                        setState(() {
                                          lightLoading = true;
                                        });
                                        currentLightsState = await backend.download(
                                            '$host/light',
                                            '$host/light').whenComplete((){
                                              setState(() {
                                                lightLoading = false;
                                              });
                                        });
                                      }, buttonText: "Refresh", fontSize: 10, icon: Icon(Icons.refresh, size: 10)),
                                    ]),
                                OverflowBar(
                                    spacing: 10,
                                    children: [
                                      AppStyleButton(
                                          buttonText: 'Sensors',
                                          icon: Image.asset(
                                              'assets/images/sensorIcon.png',
                                              width: 35),
                                          fontSize: 10,
                                          onPressed: () async {
                                            ScaffoldMessenger
                                                .of(
                                                context)
                                                .clearSnackBars();
                                            setState(() {
                                              percentageLoading = true;
                                            });
                                            fromSensorsData =
                                            await backend.download(
                                                '$host/ground_data',
                                                '$host/ground_data',
                                                headers: {
                                                  'deviceIp': pumpDeviceIP
                                                });
                                            setState(() {
                                              percentageLoading = false;
                                            });
                                          }),
                                      pumpsData.isNotEmpty
                                          ? AppStyleButton(
                                          minSize: (Size(80, 40)),
                                          buttonText: 'Start',
                                          fontSize: 10,
                                          icon: Image.asset(
                                              'assets/images/pompIcon.png',
                                              width: 35),
                                          onPressed: () async {
                                            backend.sendNReturn(
                                                "$host/ground_data",
                                                "$host/ground_data",
                                                data: pumpsData,
                                                headers: {
                                                  'deviceIp': pumpDeviceIP
                                                }).whenComplete(() {
                                              connection();
                                              pumpsData.clear();
                                            });
                                          }
                                      )
                                          : SizedBox.shrink()
                                    ]),
                                OverflowBar(
                                    spacing: 5,
                                    children: [
                                      AppStyleButton(
                                          buttonText: 'Settings',
                                          icon: Icon(Icons.settings),
                                          onPressed: () {
                                            ScaffoldMessenger
                                                .of(
                                                context)
                                                .clearSnackBars();
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AppSettings()));
                                          }),
                                      AppStyleButton(
                                          buttonText: 'Analytics',
                                          icon: Icon(Icons.analytics),
                                          onPressed: () {
                                            ScaffoldMessenger
                                                .of(
                                                context)
                                                .clearSnackBars();
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Analytics()));
                                          })
                                    ])
                              ]))
                  );
                },
              )
            ])
    ));
  }
}
