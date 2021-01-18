
import 'package:flutter/material.dart';

class ApiException implements Exception {
  final String _message;
  final String _prefix;
  final int _errorCode;

  const ApiException(
      {@required String prefix, @required int errorCode, String message = "" })
      : _message = message,
        _prefix = prefix,
        _errorCode = errorCode;

  @override
  String toString() {
    return "$_prefix - Code: $_errorCode Message: $_message";
  }
}
