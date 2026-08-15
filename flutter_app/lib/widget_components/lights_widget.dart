import 'package:flutter/material.dart';

String currentLightsState = '';
bool lightsOn = false;

class LightsOn extends StatelessWidget {

  const LightsOn({super.key});

  @override
  Widget build(BuildContext context){
    return Image.asset(
        'assets/images/lightson.png', width: 350);
  }
}

class LightsOff extends StatelessWidget {

  const LightsOff({super.key});

  @override
  Widget build(BuildContext context){
    return Image.asset(
        'assets/images/lightsoff.png', width: 350);
  }
}