import 'package:flutter/material.dart';

class User {
  final String uuid;

  final String name;

  final bool darkModeEnabled;

  String pictureUrl;

  User(
      {@required this.uuid,
      @required this.name,
      this.darkModeEnabled,
      this.pictureUrl});

  User.fromJson(Map<String, dynamic> json)
      : uuid = json["uuid"] as String,
        name = json["name"] as String,
        darkModeEnabled = json["darkModeEnabled"] as bool;

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'darkModeEnabled': darkModeEnabled
  };
}
