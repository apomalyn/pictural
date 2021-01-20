import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pictural/core/managers/picture_repository.dart';
import 'package:pictural/core/managers/user_repository.dart';
import 'package:pictural/core/models/pic_info.dart';
import 'package:stacked/stacked.dart';
import 'package:pictural/locator.dart';

class PhotosViewModel extends FutureViewModel<List<PicInfo>> {
  final PictureRepository _pictureRepository = locator<PictureRepository>();
  final UserRepository _userRepository = locator<UserRepository>();

  final Logger _logger = locator<Logger>();

  final ImagePicker _picker = ImagePicker();

  /// Retrieve all the pictures owned/shared with the user.
  List<PicInfo> get pictures => _pictureRepository.pictures;

  /// Retrieve only the pictures shared with the user.
  List<PicInfo> get picturesSharedWithUser {
    if(_userRepository.user == null)
      return [];
    final List<PicInfo> picturesShared = [];

    for (PicInfo picture in _pictureRepository.pictures) {
      if (picture.ownerUuid != _userRepository.user.uuid) {
        picturesShared.add(picture);
      }
    }

    return picturesShared;
  }

  /// Retrieve only the pictures owned by the user.
  List<PicInfo> get userPictures {
    if(_userRepository.user == null)
      return [];
    final List<PicInfo> userPictures = [];

    for (PicInfo picture in _pictureRepository.pictures) {
      if (picture.ownerUuid == _userRepository.user.uuid) {
        userPictures.add(picture);
      }
    }

    return userPictures;
  }

  @override
  Future<List<PicInfo>> futureToRun() =>
      _pictureRepository.getPictures().then((value) {
        if (value == null) onError(_pictureRepository.errorCode);
        return [];
      });

  @override
  void onError(error) {
    // TODO toast error message
    _logger.e("Error ! $error");
  }

  /// Refresh the list of pictures
  Future refresh() async {
    _logger.i("User ask to refresh the picture list.");
    setBusy(true);
    final res = await _pictureRepository.getPictures();
    if (res == null) {
      _logger.e(_pictureRepository.errorCode);
      onError(_pictureRepository.errorCode);
    }
    setBusy(false);
  }

  Future upload() async {
    setBusy(true);
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _logger.i("Image received, ready to upload");
        await _pictureRepository.uploadPicture(
            pickedFile.path, await pickedFile.readAsBytes());
      }
    } catch (e) {
      _logger.e(e);
    }
    setBusy(false);
  }
}
