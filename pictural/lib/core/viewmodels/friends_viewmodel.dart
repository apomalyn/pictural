import 'package:logger/logger.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pictural/core/constants/paths.dart';
import 'package:pictural/core/managers/friend_repository.dart';
import 'package:pictural/core/managers/user_repository.dart';
import 'package:pictural/core/models/friend.dart';
import 'package:pictural/core/services/navigation_service.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:stacked/stacked.dart';
import 'package:pictural/locator.dart';

class FriendsViewModel extends FutureViewModel<List<Friend>> {
  final Logger _logger = locator<Logger>();

  final UserRepository _userRepository = locator<UserRepository>();

  final NavigationService _navigationService = locator<NavigationService>();

  final FriendRepository _friendRepository = locator<FriendRepository>();

  /// Friends list of the user
  List<Friend> get friends => _friendRepository.friendsList;

  @override
  Future<List<Friend>> futureToRun() async {
    if (_userRepository.user == null) {
      if (await _userRepository.logIn(silent: true) == false)
        _navigationService.pushReplacementNamed(Paths.login);
    }

    return _friendRepository.getFriendsList().then((value) {
      if (value == null) {
        onError(_friendRepository.errorCode);
        return [];
      }
      return value;
    });
  }

  @override
  void onError(error) {
    _logger.e("Error ! $error");
    showToast(AppIntl.current.error, duration: const Duration(seconds: 3));
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

  /// Remove a friend from the list.
  Future deleteFriend(String uuid) async {
    _logger.i("User ask to remove a friend from the list");
    setBusy(true);
    final res = await _friendRepository.deleteFriendship(uuid);

    setBusy(false);
    // Close pop up.
    _navigationService.pop();
    // Suppression failed
    if (!res) {
      _logger.e(_friendRepository.errorCode);
      onError(_friendRepository.errorCode);
    }
  }

  /// Search a user based on his name
  Future<List<Friend>> search(String partialName) async {
    _logger.i("User search users that contains $partialName in their name");
    final res = await _friendRepository.searchUsersThatMatch(partialName);

    // Remove the current user
    res.removeWhere((element) => element.uuid == _userRepository.user.uuid);
    // Remove the friends of the user
    res.removeWhere((element) => _friendRepository.friendsList.contains(element));
    if (res == null) {
      _logger.e(_friendRepository.errorCode);
      onError(_friendRepository.errorCode);
    }
    return res;
  }

  /// Add a friend then close the "add" pop up.
  Future addFriend(String uuid) async {
    _logger.i("User try to add a friend");
    setBusy(true);
    final res = await _friendRepository.addFriend(uuid);
    setBusy(false);

    if (res == null) {
      _logger.e(_friendRepository.errorCode);
      onError(_friendRepository.errorCode);
    } else {
      _navigationService.pop();
    }
  }
}
