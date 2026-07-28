import 'package:esp32_module/function_components/local_data_storage.dart';
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
  final Size settingsButtonSize = Size(300, 40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.green.shade200,
        toolbarHeight: 100,
      ),
        body: ListView(children: [Column(
            spacing: 10,
            children: [
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
              AppStyleButton(buttonText: 'Auto mode: off', fontSize: 14, minSize: settingsButtonSize,
                icon: Image.asset('assets/images/autoOFF.png', width: 70)
              )
            ])]));
  }
}