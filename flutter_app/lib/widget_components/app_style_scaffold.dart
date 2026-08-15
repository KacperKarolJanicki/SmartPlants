import 'package:backend_connection/backend_connection.dart';
import 'package:flutter/material.dart';

String appBar = 'appBar.png';

class AppStyleScaffold extends StatefulWidget {

  final Widget? body;

  const AppStyleScaffold({super.key, required this.body});
  @override
  State<AppStyleScaffold> createState() => _AppStyleScaffoldState();
}

class _AppStyleScaffoldState extends State<AppStyleScaffold> {

  Map<String,dynamic> sunsetData = {};
  String sunset = '2026-08-${DateTime.now().day}T22:00:17+00:00';
  String sunsetHost = 'https://api.sunrise-sunset.org/json?lat=52.193346&lng=20.899060&formatted=0';

  void sunriseSunset() async {
    sunsetData = await backend.download(sunsetHost, sunsetHost);
    sunset = sunsetData['results']['sunset'];
    if(DateTime.now().hour > DateTime.parse(sunset).hour)
    {
      setState(() {
        appBar = 'appbar_night.png';
      });
    } else {
      setState(() {
        appBar = 'appBar.png';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    sunriseSunset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: ShapeDecoration(shape: RoundedRectangleBorder(),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/${DateTime.now().hour > DateTime.parse(sunset).hour ? 'background_night' : 'background'}.png'))),
          child: widget.body),
    );
  }
}