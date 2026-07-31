import 'package:backend_connection/backend_connection.dart';
import 'package:esp32_module/views/analitics/components/chart.dart';
import 'package:flutter/material.dart';

import '../../function_components/connection.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {

  List<dynamic> data = [];
  bool isLoading = false;
  int lastResults = 12;

  Future<void> databaseConnection() async {
    setState(() {
      isLoading = true;
    });
    data = await backend.download('$host/plants_data', '$host/plants_data');
  }

  @override
  void initState() {
    super.initState();
    databaseConnection().whenComplete((){
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💧 Soil moisture analytics 💧'),
        centerTitle: true,
        backgroundColor: Colors.green.shade200,
        toolbarHeight: 100,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: [
            SizedBox(height: 10),
            OverflowBar(
                alignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text('Results from:', style: TextStyle(fontSize: 18)),
                  PopupMenuButton(itemBuilder: (context) =>
                  [
                    PopupMenuItem(onTap: () {
                      setState(() {
                        lastResults = 6;
                      });
                    }, child: Text('last 6h')),
                    PopupMenuItem(onTap: () {
                      setState(() {
                        lastResults = 12;
                      });
                    }, child: Text('last 12h')),
                    PopupMenuItem(onTap: () {
                      setState(() {
                        lastResults = 24;
                      });
                    }, child: Text('last 24h')),
                    PopupMenuItem(onTap:(){
                      databaseConnection().whenComplete(() {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    }, child: Row(spacing: 10, children: [Icon(Icons.refresh), Text('Refresh')]))
                  ]),
            ]),
            SizedBox(height: 10),
            Chart(data: data, sensor: 'sensor_voltage_1', lastResults: lastResults),
            SizedBox(height: 10),
            Chart(data: data, sensor: 'sensor_voltage_2', lastResults: lastResults),
            SizedBox(height: 10),
            Chart(data: data, sensor: 'sensor_voltage_3', lastResults: lastResults),
            SizedBox(height: 10),
            Chart(data: data, sensor: 'sensor_voltage_4', lastResults: lastResults),
          ]),
    );
  }
}
