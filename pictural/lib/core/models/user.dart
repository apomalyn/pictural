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

  factory User.fromJson(Map<String, dynamic> json) => User(
      uuid: json["uuid"] as String,
      name: json["name"] as String,
      darkModeEnabled: json["darkModeEnabled"] as bool);

  Map<String, dynamic> toJson() =>
      {'uuid': uuid, 'name': name, 'darkModeEnabled': darkModeEnabled, 'pictureUrl': pictureUrl};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid &&
          name == other.name &&
          darkModeEnabled == other.darkModeEnabled &&
          pictureUrl == other.pictureUrl;

  @override
  int get hashCode =>
      uuid.hashCode ^
      name.hashCode ^
      darkModeEnabled.hashCode ^
      pictureUrl.hashCode;
}
