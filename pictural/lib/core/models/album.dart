import 'package:flutter/material.dart';
import 'package:pictural/core/models/pic_info.dart';

import 'friend.dart';
import 'pic_info.dart';

class Album {
  final String uuid;

  final String title;

  final List<PicInfo> images;

  final List<Friend> friends;

  Album(
      {@required this.uuid,
      @required this.title,
      @required this.images,
      @required this.friends});

  factory Album.fromJson(Map<String, dynamic> json) => Album(
      uuid: json["uuid"] as String,
      title: json["title"] as String,
      images: (json["images"] as List).map((i) => PicInfo.fromJson(i)).toList(),
      friends:
          (json["friends"] as List).map((i) => Friend.fromJson(i)).toList());
}
