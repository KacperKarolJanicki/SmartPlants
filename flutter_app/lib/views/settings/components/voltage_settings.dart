import 'package:esp32_module/widget_components/container_widget.dart';
import 'package:flutter/material.dart';
import '../../../widget_components/pomp_toolbar.dart';
import '../../../widget_components/sensor_percentage_toolbar.dart';

class VoltageSettings extends StatelessWidget{
  const VoltageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerWidget(
        height: MediaQuery.of(context).size.height / 2.2,
        width: MediaQuery.of(context).size.width-50, scrollable: true,
        children: [
          SizedBox(height: 15),
          PompToolbar(
              pompLabel: 'Pomp 1', pompID: 'water_pomp_1', functionButtons: false,
              otherWidget: PercentageToolbar(
                  voltageId: 'sensor_voltage_1',
                  stateId: 'sensor_1_ground', settingsMode: true)),
          SizedBox(height: 5),
          PompToolbar(
              pompLabel: 'Pomp 2', pompID: 'water_pomp_2', functionButtons: false,
              otherWidget: PercentageToolbar(
                  voltageId: 'sensor_voltage_2',
                  stateId: 'sensor_2_ground', settingsMode: true)),
          SizedBox(height: 5),
          PompToolbar(
              pompLabel: 'Pomp 3', pompID: 'water_pomp_3', functionButtons: false,
              otherWidget: PercentageToolbar(
                  voltageId: 'sensor_voltage_3',
                  stateId: 'sensor_3_ground', settingsMode: true)),
          SizedBox(height: 5),
          PompToolbar(
              pompLabel: 'Pomp 4', pompID: 'water_pomp_4', functionButtons: false,
              otherWidget: PercentageToolbar(
                  voltageId: 'sensor_voltage_4',
                  stateId: 'sensor_4_ground', settingsMode: true)),
    ]);
  }
}