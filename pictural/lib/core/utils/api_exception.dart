
import 'package:flutter/material.dart';

class ApiException implements Exception {
  final String message;
  final String _prefix;
  final int errorCode;

  const ApiException(
      {@required String prefix, @required int errorCode, String message = "" })
      : message = message,
        _prefix = prefix,
        errorCode = errorCode;

  @override
  String toString() {
    return "$_prefix - Code: $errorCode Message: $message";
  }
}
