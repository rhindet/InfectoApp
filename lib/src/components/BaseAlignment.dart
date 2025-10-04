import 'package:flutter/material.dart';


class BaseAlignment extends StatefulWidget {
  final Widget child;
  const BaseAlignment({Key? key, required this.child}) : super(key: key);

  @override
  _BaseAlignmentState createState() => _BaseAlignmentState();
}

class _BaseAlignmentState extends State<BaseAlignment> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:20,right: 20,left: 20),
      child: widget.child,
    );
  }
}