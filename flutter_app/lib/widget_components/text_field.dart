import 'package:flutter/material.dart';

class AppStyleTextField extends StatelessWidget {
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final double? width;
  final double? height;
  final double textAlignVertical;
  final Widget? icon;
  final String labelText;
  final TextInputType keyboardType;

  const AppStyleTextField ({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.width,
    this.height,
    this.textAlignVertical = -0.8,
    this.icon,
    this.labelText = '',
    this.keyboardType = TextInputType.number
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height, child: TextField(
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical(y: textAlignVertical),
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          icon: icon,
          labelText: labelText,
          border: OutlineInputBorder(
          borderSide: BorderSide(width: 4),
          borderRadius: BorderRadius.circular(30))),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    ));
  }
}