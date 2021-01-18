import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:pictural/core/constants/urls.dart';
import 'package:pictural/core/models/album.dart';
import 'package:pictural/core/models/friend.dart';
import 'package:pictural/core/models/pic_info.dart';
import 'package:pictural/core/models/user.dart';
import 'package:pictural/core/utils/api_exception.dart';

class PicturalApi {
  static const String tag = "PicturalApi";
  static const String errorTag = "$tag - Error";

  http.Client _client;

  /// Gateway to the Pictural API.
  /// The [client] is only for testing purpose do not use it in production code
  PicturalApi({http.Client client}) : _client = client ?? http.Client();

  /// Login the user
  Future<User> login(String idToken) async {
    try {
      var response = await _client.post(Urls.login, body: "idToken=$idToken");

      if (response.statusCode == HttpStatus.ok) {
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  /// Log out the user currently logged
  Future<bool> logout() async {
    final response = await _client.post(Urls.logout);

    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  /// Update the current user.
  Future<bool> updateUserInfo(String name, bool darkModeEnabled,
      String pictureUuid) async {
    final response = await _client.put(Urls.user,
        body: jsonEncode({
          "name": name,
          "darkModeEnabled": darkModeEnabled,
          "pictureUuid": pictureUuid
        }));

    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  /// Get the list of friend for the current user
  Future<List<Friend>> getFriendList() async {
    final response = await _client.post(Urls.getFriends);

    if (response.statusCode == HttpStatus.ok) {
      var json = jsonDecode(response.body).cast<Map<String, dynamic>>();

      return json["friends"].map<Friend>((i) => Friend.fromJson(i)).toList();
    }
    // Otherwise
    throw ApiException(prefix: errorTag, errorCode: response.statusCode);
  }

  /// Get the list of pictures owned/shared with the current user
  Future<List<PicInfo>> getPictures() async {
    final response = await _client.get(Urls.images);

    if (response.statusCode == HttpStatus.ok) {
      var json = jsonDecode(response.body).cast<Map<String, dynamic>>();

      return json["images"].map<PicInfo>((i) => PicInfo.fromJson(i));
    }
    // Otherwise
    throw ApiException(prefix: errorTag, errorCode: response.statusCode);
  }

  /// Get the informations relative to the image corresponding at [uuid]
  Future<PicInfo> getPictureInfo(String uuid) async {
    final response = await _client.get(Urls.imageInfo(uuid));

    if (response.statusCode == HttpStatus.ok) {
      var json = jsonDecode(response.body).cast<Map<String, dynamic>>();

      return PicInfo.fromJson(json);
    }
    // Otherwise
    throw ApiException(prefix: errorTag, errorCode: response.statusCode);
  }

  /// Delete the picture corresponding to [uuid]
  Future deletePicture(String uuid) async {
    final response = await _client.delete(Urls.image(uuid));

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException(prefix: errorTag, errorCode: response.statusCode);
    }
  }

  /// Share the image corresponding to [imageUuid] with the [friend].
  Future sharePictureWith(String imageUuid, Friend friend) async {
    final response =
    await _client.post(Urls.imageFriend(imageUuid, friend.uuid));

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException(prefix: errorTag, errorCode: response.statusCode);
    }
  }

  /// Remove the access of [friend] to the image corresponding to [imageUuid].
  Future removePictureAccess(String imageUuid, Friend friend) async {
    final response =
    await _client.delete(Urls.imageFriend(imageUuid, friend.uuid));

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException(prefix: errorTag, errorCode: response.statusCode);
    }
  }

  /// Get the list of albums owned/shared with the current user
  Future<List<Album>> getAlbums() async {
    final response = await _client.get(Urls.albums);

    if (response.statusCode == HttpStatus.ok) {
      var json = jsonDecode(response.body).cast<Map<String, dynamic>>();

      return json["albums"].map<Album>((i) => PicInfo.fromJson(i));
    }
    // Otherwise
    throw ApiException(prefix: errorTag, errorCode: response.statusCode);
  }

  /// Create an album named [title], with [images] on it, shared with [friends]
  /// and owned by the current user.
  /// Return the uuid of the created album.
  Future<String> addAlbum(String title, List<PicInfo> images,
      List<Friend> friends) async {
    final response = await _client.post(Urls.albumAdd, body: jsonEncode({
      "title": title,
      "images": images.map<String>((image) => image.uuid),
      "friends": friends.map<String>((friend) => friend.uuid)
    }));

    if (response.statusCode == HttpStatus.ok) {
      return response.body;
    }

    // Otherwise
    throw ApiException(prefix: errorTag, errorCode: response.statusCode);
  }

  /// Update the [title] of album corresponding to [uuid]
  Future updateAlbum(String uuid, String title) async {
    final response = await _client.put(Urls.album(uuid), body: jsonEncode({
      "title": title
    }));

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException(prefix: errorTag, errorCode: response.statusCode);
    }
  }

  /// Delete the album corresponding to [uuid]
  Future deleteAlbum(String uuid) async {
    final response = await _client.delete(Urls.album(uuid));

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException(prefix: errorTag, errorCode: response.statusCode);
    }
  }

  /// Share the album corresponding to [uuid] with [friends].
  Future shareAlbumWith(String uuid, List<Friend> friends) async {
    final response =
    await _client.post(Urls.albumFriendAdd(uuid), body: jsonEncode({
      "friends": friends.map<String>((friend) => friend.uuid)
    }));

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException(prefix: errorTag, errorCode: response.statusCode);
    }
  }

  /// Remove the access of [friend] to the album corresponding to [albumUuid].
  Future removeAlbumAccess(String albumUuid, Friend friend) async {
    final response =
    await _client.delete(Urls.albumFriendRemove(albumUuid, friend.uuid));

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException(prefix: errorTag, errorCode: response.statusCode);
    }
  }

  /// Add [images] into the album corresponding to [uuid].
  Future addImageIntoAlbum(String uuid, List<PicInfo> images) async {
    final response =
    await _client.post(Urls.albumImagesAdd(uuid), body: jsonEncode({
      "images": images.map<String>((image) => image.uuid)
    }));

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException(prefix: errorTag, errorCode: response.statusCode);
    }
  }

  /// Remove the image from the album corresponding to [albumUuid].
  Future removeImageFromAlbum(String albumUuid, PicInfo image) async {
    final response =
    await _client.delete(Urls.albumFriendRemove(albumUuid, image.uuid));

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException(prefix: errorTag, errorCode: response.statusCode);
    }
  }
}
