import 'package:esp32_module/function_components/local_data_storage.dart';
import 'package:esp32_module/widget_components/button.dart';
import 'package:esp32_module/widget_components/sensor_percentage_toolbar.dart';
import 'package:esp32_module/widget_components/text_field.dart';
import 'package:flutter/material.dart';

Map<String,dynamic> pumpsData = {};

class PompToolbar extends StatefulWidget {
  final String pompLabel;
  final String pompID;
  final Color backgroundColor;
  final Color labelColor;
  final Widget? otherWidget;
  final bool functionButtons;
  final bool labelButton;

  const PompToolbar(
      {super.key, this.pompLabel = 'Some Pomp',
        required this.pompID, this.otherWidget,
        this.functionButtons = true,
        this.labelButton = true,
        this.backgroundColor = Colors.transparent,
        this.labelColor = Colors.black
      });

  @override
  State<PompToolbar> createState() => _PompToolbarState();
}

class _PompToolbarState extends State<PompToolbar> {

  bool _turnOn = false;
  bool _turnLabel = false;
  bool _isLoadingData = false;
  String _labelText = '';

  void getData() async {
    setState(() {
      _isLoadingData = true;
    });
      _labelText = await LocalDataStorage(widget.pompLabel).getData(widget.pompLabel);
      setState(() {
        _isLoadingData = false;
      });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: ShapeDecoration(
          color: widget.backgroundColor,
            shape: RoundedRectangleBorder(side: BorderSide(width: 0.1),
                borderRadius: BorderRadius.circular(10))),
        child: Column(children: [
          _turnLabel ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                AppStyleButton(
                    buttonText: 'Save', minSize: Size(30, 30),
                    icon: Icon(Icons.save, size: 10),
                    fontSize: 10,
                    onPressed: () {
                      setState(() {
                        LocalDataStorage(widget.pompLabel).setData(_labelText);
                        _turnLabel=!_turnLabel;
                      });
                    }),
                AppStyleTextField(
                  width: 125, height: 30, keyboardType: TextInputType.text,
                  onChanged: (input){
                    setState(() {
                      _labelText = input;
                    });
                  },
                ),
                AppStyleButton(
                    buttonText: 'Cancel', minSize: Size(30, 30),
                    icon: Icon(Icons.cancel, size: 10),
                    fontSize: 8,
                    onPressed: () async {
                      _labelText = await LocalDataStorage(widget.pompLabel).getData(widget.pompLabel);
                      setState(() {
                        _turnLabel=!_turnLabel;
                      });
                    })
              ]) :
          _turnOn ? OverflowBar(
              spacing: 20,
              children: [
                Image.asset('assets/images/pomp_time.png', width: 30),
                AppStyleTextField(
                    height: 30,
                    onChanged: (input) {
                      setState(() {
                        pumpsData[widget.pompID]['pomp_time'] =
                            int.tryParse(input) ?? 0;
                      });
                    },
                    width: 100,
                    labelText: 'Time'),
                AppStyleButton(
                  buttonText: 'Off',
                  fontSize: 10,
                  minSize: Size(20, 30),
                  icon: Icon(Icons.close, size: 10),
                  onPressed: () {
                    setState(() {
                      _turnOn = !_turnOn;
                      pumpsData.remove(widget.pompID);
                    });
                  },
                )
              ]) : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                _isLoadingData ? SizedBox.shrink() : Text(_labelText, textAlign: TextAlign.center, style: TextStyle(color: widget.labelColor)),
                widget.functionButtons ? AppStyleButton(
                    buttonText: 'On', minSize: Size(30, 30),
                    fontSize: 10,
                    onPressed: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      setState(() {
                        _turnOn = !_turnOn;
                        pumpsData.addAll({
                          widget.pompID: {
                            "turn_on": _turnOn,
                            "pomp_time": 0,
                            "dry_voltage": voltageData["sensor_voltage_${widget
                                .pompID.replaceAll("water_pomp_", "")}"] ?? 2
                          }
                        });
                      });
                    }):SizedBox.shrink(),
                widget.labelButton ? widget.functionButtons ? AppStyleButton(
                    buttonText: 'Label', minSize: Size(30, 30),
                    icon: Icon(Icons.edit, size: 10),
                    fontSize: 10,
                    onPressed: () {
                      setState(() {
                        _turnLabel=!_turnLabel;
                      });
                    }):SizedBox.shrink():SizedBox.shrink(),
              ]),
          SizedBox(height: 10),
          widget.otherWidget ?? SizedBox.shrink(),
          SizedBox(height: 10)
        ]));
  }
}