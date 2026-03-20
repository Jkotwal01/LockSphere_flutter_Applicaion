import 'package:flutter/material.dart';

class AccessProvider extends ChangeNotifier {
  // Stub for accesses
  final List<dynamic> _accesses = [];

  List<dynamic> get accesses => _accesses;
}
