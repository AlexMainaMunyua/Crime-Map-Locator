import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final configProvider = Provider<Config>((_) => Config());

class Config {
  final lightGradientShadecolor = const Color(0xfff8a31b);
  final darkGradientShadecolor = const Color(0xff000424);
  final colorWhite = const Color(0xffffffff);
}
