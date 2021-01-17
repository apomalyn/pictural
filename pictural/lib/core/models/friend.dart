import 'package:flutter/material.dart';

class Friend {
  final String uuid;

  final String name;

  final String pictureUuid;

  Friend(
      {@required this.uuid,
        @required this.name,
        this.pictureUuid});

  Friend.fromJson(Map<String, dynamic> json)
      : uuid = json["uuid"] as String,
        name = json["name"] as String,
        pictureUuid = json["pictureUuid"] as String;

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'pictureUuid': pictureUuid
  };
}
