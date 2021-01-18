import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:pictural/core/constants/urls.dart';
import 'package:pictural/core/models/friend.dart';
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
      print(idToken);
      var response = await _client.post(Urls.login,
          body: "idToken=$idToken");

      if (response.statusCode == HttpStatus.ok) {
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("HEllo - $e.");
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
  Future<bool> updateUserInfo(
      String name, bool darkModeEnabled, String pictureUuid) async {
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
}
