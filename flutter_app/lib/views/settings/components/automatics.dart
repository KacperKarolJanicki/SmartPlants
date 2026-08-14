import 'package:esp32_module/function_components/connection.dart';
import 'package:esp32_module/views/settings/components/wireless_settings.dart';
import 'package:esp32_module/widget_components/button.dart';
import 'package:esp32_module/widget_components/container_widget.dart';
import 'package:esp32_module/widget_components/pomp_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:backend_connection/backend_connection.dart';

class Automatics extends StatefulWidget {
  const Automatics({super.key});

  @override
  State<Automatics> createState() => _AutomaticsState();
}

class _AutomaticsState extends State<Automatics> {

  bool turnOn = false;
  bool stateLoading = false;

  Future<void> automaticsState(bool turn, {Map<String, dynamic>? data}) async {
    setState(() {
      stateLoading = true;
    });
    if (turn) {
      Map<String, dynamic> response = await backend.sendNReturn(
          '$host/automatics', '$host/automatics',
          headers: {'deviceIp': pumpDeviceIP}, data: data);
      turnOn = response['turn_on'] ?? false;
    } else {
      Map<String, dynamic> response = await backend.download(
          '$host/automatics', '$host/automatics',
          headers: {'deviceIp': pumpDeviceIP});
      turnOn = response['turn_on'] ?? false;
    }
  }

  @override
  void initState() {
    super.initState();
    pumpsData.clear();
    automaticsState(false).whenComplete((){
      setState(() {
        stateLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContainerWidget(
      height: MediaQuery.of(context).size.height / 1.75,
      width: MediaQuery.of(context).size.width-50,
      children: [
        Text('Automatics', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
        stateLoading ? CircularProgressIndicator(color: Colors.green) : Column(children: [
          PompToolbar(pompLabel: 'Pomp 1', pompID: 'water_pomp_1', labelButton: false),
          PompToolbar(pompLabel: 'Pomp 2', pompID: 'water_pomp_2', labelButton: false),
          PompToolbar(pompLabel: 'Pomp 3', pompID: 'water_pomp_3', labelButton: false),
          PompToolbar(pompLabel: 'Pomp 4', pompID: 'water_pomp_4', labelButton: false),
        ]),
        OverflowBar(
            spacing: 20,
            children: [
              stateLoading ? SizedBox.shrink() : turnOn ?
              AppStyleButton(buttonText: 'Stop', onPressed: (){
                automaticsState(true, data: {"turn_on":false}).whenComplete((){
                  setState(() {
                    stateLoading = false;
                    pumpsData.clear();
                  });
                });
              }):
              pumpsData.isNotEmpty ? AppStyleButton(buttonText: 'Start', onPressed: (){
            pumpsData.addAll({'turn_on':true});
            automaticsState(true, data: pumpsData).whenComplete((){
              setState(() {
                stateLoading = false;
                pumpsData.clear();
              });
            });
          }) : SizedBox.shrink()
        ])
      ],
    );
  }
}