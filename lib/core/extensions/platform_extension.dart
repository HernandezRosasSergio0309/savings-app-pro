import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension PlatformExtension on BuildContext {
  /// Retorna [true] si la plataforma actual es iOS o macOS
  bool get isApple => !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  /// Retorna [true] si la plataforma actual es Android
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
}
