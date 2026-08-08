import 'package:flutter/material.dart';

class AppStyleScaffold extends StatelessWidget {

  final Widget? body;

  const AppStyleScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: ShapeDecoration(shape: RoundedRectangleBorder(),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/background.png'))),
          child: body),
    );
  }
}