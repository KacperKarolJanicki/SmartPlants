import 'package:flutter/material.dart';

class AppStyleButton extends StatelessWidget {
  final String buttonText;
  final double fontSize;
  final void Function()? onPressed;
  final Widget? icon;
  final Size? maxSize;
  final Size? minSize;

  const AppStyleButton ({
    super.key,
    this.buttonText = '',
    this.onPressed,
    this.icon,
    this.maxSize,
    this.minSize,
    this.fontSize = 20
  });

  @override
  Widget build(BuildContext context){
    return ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade50,
          foregroundColor: Colors.black,
          maximumSize: maxSize,
          minimumSize: minSize,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.15),
              borderRadius: BorderRadius.circular(15)),
          elevation: 10
        ),
        label: Text(buttonText, style: TextStyle(fontSize: fontSize)),
      icon: icon,
    );
  }
}