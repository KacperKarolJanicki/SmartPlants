import 'package:esp32_module/function_components/local_data_storage.dart';
import 'package:esp32_module/views/settings/components/automatics.dart';
import 'package:esp32_module/views/settings/components/wireless_settings.dart';
import 'package:esp32_module/widget_components/app_style_scaffold.dart';
import 'package:esp32_module/widget_components/sensor_percentage_toolbar.dart';
import 'package:flutter/material.dart';
import '../../widget_components/button.dart';
import 'components/voltage_settings.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {

  bool voltageSettings = false;
  bool wirelessSettings = false;
  bool automaticsSettings = false;
  final Size settingsButtonSize = Size(300, 40);

  @override
  Widget build(BuildContext context) {
    return AppStyleScaffold(body: ListView(children: [Column(
        spacing: 10,
        children: [
          Image.asset('assets/images/settings.png'),
          SizedBox(height: 20),
          voltageSettings ? VoltageSettings() : AppStyleButton(
              minSize: settingsButtonSize,
              buttonText: 'Voltage Borders',
              icon: Image.asset('assets/images/sensorIcon.png', width: 50),
              fontSize: 13,
              onPressed: () {
                setState(() {
                  voltageSettings = !voltageSettings;
                });
              }),
          voltageSettings ? AppStyleButton(
              buttonText: 'Close', icon: Icon(Icons.close), onPressed: () {
            setState(() {
              voltageSettings = !voltageSettings;
            });
          }) : SizedBox.shrink(),
          AppStyleButton(buttonText: 'State toolbar: ${percentageToolbar
              ? 'Percentage'
              : 'Just color'}', fontSize: 14, minSize: settingsButtonSize,
            icon: Image.asset('assets/images/${percentageToolbar
                ? 'percentage.png'
                : 'justcolor.png'}', width: 55),
            onPressed: () {
              setState(() {
                percentageToolbar = !percentageToolbar;
                LocalDataStorage('percentageToolbar').setData(
                    percentageToolbar.toString());
              });
            },
          ),
          AppStyleButton(buttonText: 'Show voltage: ${showVoltage ? 'On' : 'Off'}', fontSize: 14, minSize: settingsButtonSize,
            icon: Image.asset('assets/images/${showVoltage
                ? 'voltageON.png'
                : 'voltageOFF.png'}', width: 55),
            onPressed: () {
              setState(() {
                showVoltage = !showVoltage;
                LocalDataStorage('showVoltage').setData(
                    showVoltage.toString());
              });
            },
          ),
          wirelessSettings ? WirelessSettings() : AppStyleButton(
              minSize: settingsButtonSize,
              buttonText: 'Wireless settings',
              icon: Icon(Icons.wifi),
              fontSize: 13,
              onPressed: () {
                setState(() {
                  wirelessSettings = !wirelessSettings;
                });
              }),
          wirelessSettings ? AppStyleButton(
              buttonText: 'Close', icon: Icon(Icons.close), onPressed: () {
            setState(() {
              wirelessSettings = !wirelessSettings;
            });
          }) : SizedBox.shrink(),
          automaticsSettings ? Automatics() : AppStyleButton(
              minSize: settingsButtonSize,
              buttonText: 'Automatics',
              icon: Icon(Icons.auto_mode),
              fontSize: 13,
              onPressed: () {
                setState(() {
                  automaticsSettings = !automaticsSettings;
                });
              }),
          automaticsSettings ? AppStyleButton(
              buttonText: 'Close', icon: Icon(Icons.close), onPressed: () {
            setState(() {
              automaticsSettings = !automaticsSettings;
            });
          }) : SizedBox.shrink(),
          // AppStyleButton(buttonText: 'Auto mode: off', fontSize: 14, minSize: settingsButtonSize,
          //   icon: Image.asset('assets/images/autoOFF.png', width: 70)
          // )
        ])]));
  }
}