import 'package:flutter/material.dart';

class Friend {
  final String uuid;

  final String name;

  final String pictureUrl;

  Friend({@required this.uuid, @required this.name, this.pictureUrl});

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
      uuid: json["uuid"] as String,
      name: json["name"] as String,
      pictureUrl: json["pictureUrl"] as String);

  Map<String, dynamic> toJson() =>
      {'uuid': uuid, 'name': name, 'pictureUrl': pictureUrl};
}
