import 'package:esp32_module/widget_components/pomp_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Chart extends StatefulWidget {
  final List<dynamic> data;
  final String sensor;
  final int lastResults;

  const Chart({super.key, required this.data, required this.sensor, this.lastResults=12});

  @override

  State<Chart> createState()=> _ChartState();
}

class _ChartState extends State<Chart> {

  @override
  Widget build(BuildContext context) {

    double chartSize = MediaQuery.of(context).size.width / 1.3;

    return PompToolbar(
      pompID: widget.sensor.replaceAll('sensor_voltage_', 'water_pomp_'),
      pompLabel: widget.sensor.replaceAll('sensor_voltage_', 'Pomp '),
      functionButtons: false,
      backgroundColor: Colors.black.withAlpha(50),
      labelColor: Colors.white,
      otherWidget: Container(decoration: ShapeDecoration(color: Colors.white.withAlpha(200),
          shape: RoundedRectangleBorder(side: BorderSide(width: 0.3))),
          child: Column(children: [
            OverflowBar(children: [
              SizedBox(width: chartSize, child: SfSparkAreaChart(
                labelDisplayMode: widget.lastResults == 6
                    ? SparkChartLabelDisplayMode.all
                    : SparkChartLabelDisplayMode.last,
                axisLineColor: Colors.brown,
                color: Colors.blue.withAlpha(70),
                marker: SparkChartMarker(
                    displayMode: SparkChartMarkerDisplayMode.all),
                data: <double>[
                  for(var i in widget.data.take(widget.lastResults).toList().reversed.toList())
                    i[widget.sensor],
                ],
              )),
            ]),
            OverflowBar(
                spacing: widget.lastResults == 12 ? 7 : widget.lastResults == 6 ? 39 : 2,
                children: [
                  // SizedBox(width: widget.lastResults == 24 ? scaleSpacing + 25 : scaleSpacing),
                  for(var j in widget.data.take(widget.lastResults).toList().reversed.toList())
                    Text('${DateTime.parse(j['datetime']).toLocal().hour}:${DateTime.parse(j['datetime']).toLocal().minute}',
                      style: TextStyle(fontSize: widget.lastResults == 24 ? 4 : 7),)
                ])
          ])),
    );
  }
}