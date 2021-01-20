import 'package:logger/logger.dart';
import 'package:pictural/core/services/pictural_api.dart';
import 'package:pictural/core/utils/api_exception.dart';
import 'package:pictural/locator.dart';
import 'package:pictural/core/models/friend.dart';

class FriendRepository {
  static const String tag = "FriendRepository";

  /// Used to get
  final PicturalApi _picturalApi = locator<PicturalApi>();

  final Logger _logger = locator<Logger>();

  final List<Friend> _friendsList = [];

  List<Friend> get friendsList => _friendsList;

  int _errorCode;

  int get errorCode => _errorCode;

  /// Retrieve the list of friends of the user.
  Future<List<Friend>> getFriendsList() async {
    _logger.d("$tag - Try to retrieve the friends list");
    try {
      final res = await _picturalApi.getFriendList();

      if (res.isNotEmpty) {
        _logger.i("$tag - ${res.length} friends loaded.");
        _friendsList.clear();
        _friendsList.addAll(res);

        return _friendsList;
      }
    } catch (e) {
      _logger.e("$tag - $e");
      if (e is ApiException) {
        // TODO add analytics to log error
        _errorCode = e.errorCode;
      }
    }
    return null;
  }
}
