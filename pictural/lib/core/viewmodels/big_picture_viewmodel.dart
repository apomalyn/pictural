import 'package:logger/logger.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pictural/core/managers/friend_repository.dart';
import 'package:pictural/core/managers/picture_repository.dart';
import 'package:pictural/core/managers/user_repository.dart';
import 'package:pictural/core/models/friend.dart';
import 'package:pictural/core/models/pic_info.dart';
import 'package:pictural/core/services/navigation_service.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/locator.dart';
import 'package:stacked/stacked.dart';

class BigPictureViewModel extends FutureViewModel {
  final PictureRepository _pictureRepository = locator<PictureRepository>();

  final FriendRepository _friendRepository = locator<FriendRepository>();

  final UserRepository _userRepository = locator<UserRepository>();

  final NavigationService _navigationService = locator<NavigationService>();

  final Logger _logger = locator<Logger>();

  /// Picture currently open
  /// This field isn't final because in case of update (add, remove access)
  /// will want to update the picture
  PicInfo picture;

  /// Friends of the current user who haven't access to [picture].
  List<Friend> _friendListAdjusted = [];

  List<Friend> get friendListAdjusted => _friendListAdjusted;

  /// Determine if the current user own [picture]
  bool get isOwner => picture.ownerUuid == _userRepository.user.uuid;

  BigPictureViewModel(this.picture);

  @override
  Future futureToRun() {
    return _friendRepository.getFriendsList().then((value) {
      if (value == null) {
        onError(_friendRepository.errorCode);
      } else {
        _friendListAdjusted = value;
        _friendListAdjusted
            .removeWhere((element) => picture.authorized.contains(element));
        _friendListAdjusted
            .removeWhere((element) => element.uuid == picture.uuid);
      }
    });
  }

  @override
  void onError(error) {
    _logger.e("Error ! $error");
    showToast(AppIntl.current.error, duration: const Duration(seconds: 3));
  }

  /// Share the picture loaded with a friend.
  Future sharePictureWith(Friend shareWith) async {
    _logger.i("User ask to share ${picture.uuid} with ${shareWith.uuid}");
    setBusy(true);
    final success =
        await _pictureRepository.sharePictureWith(picture, shareWith);

    if (success) {
      var index = _pictureRepository.pictures
          .indexWhere((element) => element.uuid == picture.uuid);
      picture = _pictureRepository.pictures[index];
      // Refresh list of friends
      await futureToRun();
      _navigationService.pop();
    } else {
      onError(_pictureRepository.errorCode);
    }

    setBusy(false);
  }
}
