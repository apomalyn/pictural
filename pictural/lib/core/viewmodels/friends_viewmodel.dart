import 'package:logger/logger.dart';
import 'package:pictural/core/constants/paths.dart';
import 'package:pictural/core/managers/friend_repository.dart';
import 'package:pictural/core/managers/user_repository.dart';
import 'package:pictural/core/models/friend.dart';
import 'package:pictural/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:pictural/locator.dart';

class FriendsViewModel extends FutureViewModel<List<Friend>> {
  final Logger _logger = locator<Logger>();

  final UserRepository _userRepository = locator<UserRepository>();

  final NavigationService _navigationService = locator<NavigationService>();

  final FriendRepository _friendRepository = locator<FriendRepository>();

  List<Friend> get friends => _friendRepository.friendsList;

  @override
  Future<List<Friend>> futureToRun() async {
    if (_userRepository.user == null) {
      if (await _userRepository.logIn(silent: true) == false)
        _navigationService.pushReplacementNamed(Paths.login);
    }

    return _friendRepository.getFriendsList().then((value) {
      if(value == null) {
        onError(_friendRepository.errorCode);
        return [];
      }
      return value;
    });
  }

  @override
  void onError(error) {
    // TODO toast error message
    _logger.e("Error ! $error");
  }

  /// Refresh the list of pictures
  Future refresh() async {
    _logger.i("User ask to refresh the friends list.");
    setBusy(true);
    final res = await _friendRepository.getFriendsList();
    if (res == null) {
      _logger.e(_friendRepository.errorCode);
      onError(_friendRepository.errorCode);
    }
    setBusy(false);
  }

  Future deleteFriend(String uuid) async {
    _logger.i("User ask to remove a friend from the list");
    setBusy(true);
    final res = await _friendRepository.deleteFriendship(uuid);

    setBusy(false);
    _navigationService.pop();
    // Suppression failed
    if(!res) {
      _logger.e(_friendRepository.errorCode);
      onError(_friendRepository.errorCode);
    }
  }
}
