import 'package:esp32_module/function_components/local_data_storage.dart';
import 'package:esp32_module/widget_components/text_field.dart';
import 'package:flutter/material.dart';
import '../function_components/connection.dart';
import 'button.dart';

Map<String, dynamic> voltageData = {};
bool percentageToolbar = true;
bool showVoltage = true;

class PercentageToolbar extends StatefulWidget {

  final String voltageId;
  final String stateId;
  final bool settingsMode;

  const PercentageToolbar(
      {super.key, required this.voltageId, required this.stateId, this.settingsMode = false});

  @override
  State<PercentageToolbar> createState() => _PercentageToolbarState();
}

class _PercentageToolbarState extends State<PercentageToolbar> {

  late double percentage = fromSensorsData[widget.voltageId] *
      31.69572107765452;
  double dryBorder = 2;
  bool isLoading = false;

  void setDryBorder() async {
    setState(() {
      isLoading = true;
    });
    dryBorder =
        double.parse(await LocalDataStorage(widget.voltageId).getData('2'));
    percentageToolbar =
        bool.parse(await LocalDataStorage('percentageToolbar').getData('true'));
    showVoltage =
        bool.parse(await LocalDataStorage('showVoltage').getData('true'));

    voltageData.addAll({widget.voltageId: dryBorder});

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setDryBorder();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        spacing: 10,
        children: [
          showVoltage ? Text(
              'Sensor Voltage ${widget.voltageId.replaceAll(
                  'sensor_voltage_', '')}: ${fromSensorsData[widget
                  .voltageId]} V',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12)) : SizedBox.shrink(),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                percentageToolbar
                    ? OverflowBar(
                    spacing: 2,
                    children: List.filled(
                        int.parse(percentage.floor().toString()) ~/ 10,
                        Image.asset(
                            percentage > dryBorder * 31.69572107765452
                                ? 'assets/images/green_rectangle.png'
                                : 'assets/images/red_rectangle.png',
                            width: 10))) :
                OverflowBar(children: [
                  Image.asset(
                      percentage > dryBorder * 31.69572107765452
                          ? 'assets/images/green_rectangle.png'
                          : 'assets/images/red_rectangle.png', width: 30)
                ]),
                percentageToolbar ? Text('${percentage.toStringAsFixed(
                    0)} % | ${fromSensorsData[widget
                    .stateId]}') : Text(
                    fromSensorsData[widget.voltageId] <= dryBorder
                        ? 'dry'
                        : 'wet')
              ]),
          widget.settingsMode ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text('dry border: \n$dryBorder V'),
                AppStyleTextField(height: 30, width: 100, onChanged: (input) {
                  setState(() {
                    dryBorder = double.parse(input);
                  });
                }),
                AppStyleButton(buttonText: 'Set',
                    fontSize: 10,
                    minSize: Size(30, 30),
                    onPressed: () {
                      LocalDataStorage(widget.voltageId).setData(
                          dryBorder.toString());
                      voltageData[widget.voltageId] = dryBorder;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green.shade200,
                          content: Text('Saved',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black))));
                    }),
              ]) : SizedBox.shrink()
        ]);
  }
}