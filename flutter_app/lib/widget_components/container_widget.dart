import 'package:flutter/material.dart';

class ContainerWidget extends StatefulWidget {
  final double width;
  final double height;
  final double spacing;
  final bool scrollable;
  final List<Widget> children;

  const ContainerWidget({
    super.key,
    required this.width,
    required this.height,
    this.children = const [],
    this.scrollable = false,
    this.spacing = 15
  });

  @override
  State<ContainerWidget> createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        decoration: ShapeDecoration(
            color: Colors.green.shade50.withAlpha(200),
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 1),
                borderRadius: BorderRadiusGeometry.circular(20))),
        child: widget.scrollable ? ListView(
          children: widget.children,
        ) : Column(
            mainAxisAlignment: .center,
            spacing: widget.spacing,
            children: widget.children));
  }
}