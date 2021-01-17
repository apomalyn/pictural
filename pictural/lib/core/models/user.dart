import 'package:flutter/material.dart';

class User {
  final String uuid;

  final String name;

  final bool darkModeEnabled;

  final String pictureUuid;

  User(
      {@required this.uuid,
      @required this.name,
      this.darkModeEnabled,
      this.pictureUuid});

  User.fromJson(Map<String, dynamic> json)
      : uuid = json["uuid"] as String,
        name = json["name"] as String,
        darkModeEnabled = json["darkModeEnabled"] as bool,
        pictureUuid = json["pictureUuid"] as String;

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'darkModeEnabled': darkModeEnabled,
    'pictureUuid': pictureUuid
  };
}
