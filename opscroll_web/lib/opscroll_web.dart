import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OpscrollWeb extends StatefulWidget {
  static const MethodChannel _channel = MethodChannel('opscroll_web');

  const OpscrollWeb({Key? key}) : super(key: key);

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  State<OpscrollWeb> createState() => _OpscrollWebState();
}

class _OpscrollWebState extends State<OpscrollWeb> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}
