import 'package:esp32_module/function_components/local_data_storage.dart';
import 'package:esp32_module/widget_components/button.dart';
import 'package:esp32_module/widget_components/container_widget.dart';
import 'package:esp32_module/widget_components/lights_widget.dart';
import 'package:esp32_module/widget_components/text_field.dart';
import 'package:flutter/material.dart';
import '../../../function_components/connection.dart';

String pumpDeviceIP = '';
String lightsDeviceIP = '';

Future<void> getIP() async {
  pumpDeviceIP = await LocalDataStorage('pump_ip').getData('');
  lightsDeviceIP = await LocalDataStorage('lights_ip').getData('');
  host = await LocalDataStorage('main_host').getData('');
  lightsOn = bool.parse(await LocalDataStorage('lightsState').getData('light_off'));
}

class WirelessSettings extends StatefulWidget {
  const WirelessSettings({super.key});

  @override
  State<WirelessSettings> createState()=> _WirelessSettingsState();
}

class _WirelessSettingsState extends State<WirelessSettings> {

  @override
  Widget build (BuildContext context){
    return ContainerWidget(
        height: MediaQuery.of(context).size.height / 1.75,
        width: MediaQuery.of(context).size.width-50,
    spacing: 30,
    children: [
      Text('Main host: $host'),
      Text('Pump device IP: $pumpDeviceIP'),
      Text('Light device IP: $lightsDeviceIP'),
      OverflowBar(spacing:10, children: [
        AppStyleTextField(width: 200, labelText: 'Main host', icon: Icon(Icons.wifi),
            keyboardType: TextInputType.text,
            onChanged: (input){
              setState(() {
                host = 'https://$input';
              });
            }),
        AppStyleButton(buttonText: 'Save', fontSize:10, onPressed: (){
          LocalDataStorage('main_host').setData(host);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green.shade200,
              content: Text('Saved',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20, color: Colors.black))));
        })
      ]),
      OverflowBar(spacing:10, children: [
        AppStyleTextField(width: 200, labelText: 'Pump device IP 💧', icon: Icon(Icons.wifi),
            onChanged: (input){
              setState(() {
                pumpDeviceIP = 'http://$input';
              });
            }),
        AppStyleButton(buttonText: 'Save', fontSize:10, onPressed: (){
          LocalDataStorage('pump_ip').setData(pumpDeviceIP);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green.shade200,
              content: Text('Saved',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20, color: Colors.black))));
        })
      ]),
      OverflowBar(spacing:10, children: [
        AppStyleTextField(width: 200, labelText: 'Lights device IP 💡', icon: Icon(Icons.wifi),
            onChanged: (input){
              setState(() {
                lightsDeviceIP = 'http://$input';
              });
            }),
        AppStyleButton(buttonText: 'Save', fontSize: 10, onPressed: (){
          LocalDataStorage('lights_ip').setData(lightsDeviceIP);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green.shade200,
              content: Text('Saved',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20, color: Colors.black))));
        })
      ])
    ]);
  }
}