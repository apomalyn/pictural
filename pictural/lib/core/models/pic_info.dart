import 'package:flutter/material.dart';

import 'friend.dart';

class PicInfo {
  final String uuid;

  final String ownerUuid;

  final List<Friend> authorized;

  PicInfo(
      {@required this.uuid,
      @required this.ownerUuid,
      @required this.authorized});

  factory PicInfo.fromJson(Map<String, dynamic> json) => PicInfo(
      uuid: json["uuid"] as String,
      ownerUuid: json["ownerUuid"] as String,
      authorized: (json["authorized"] as List).map((i) => Friend.fromJson(i)).toList());
}
