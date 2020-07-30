import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteShortcut {
  PushReplacement(BuildContext context, Object page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }
  Push(BuildContext context, Object page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}