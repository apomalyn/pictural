import 'dart:typed_data';

import 'package:logger/logger.dart';
import 'package:pictural/core/models/friend.dart';
import 'package:pictural/core/models/pic_info.dart';
import 'package:pictural/core/services/pictural_api.dart';
import 'package:pictural/core/utils/api_exception.dart';
import 'package:pictural/locator.dart';

class PictureRepository {
  static const String tag = "PictureRepository";
  final PicturalApi _picturalApi = locator<PicturalApi>();
  final Logger _logger = locator<Logger>();

  List<PicInfo> _pictures = [];

  List<PicInfo> get pictures => _pictures;

  int _errorCode;

  int get errorCode => _errorCode;

  /// Get the list of pictures owned/shared with the user
  Future<List<PicInfo>> getPictures() async {
    try {
      final images = await _picturalApi.getPictures();

      // Load the new images.
      _pictures.clear();
      _pictures.addAll(images);
      _logger.i("$tag - ${_pictures.length} pictures loaded");

      return _pictures;
    } catch (e) {
      _logger.e("$tag - $e");
      if (e is ApiException) {
        // TODO add analytics to log error
        _errorCode = e.errorCode;
      }
    }
    return null;
  }

  /// Upload an picture with [fileName] and composed by [data]
  Future<bool> uploadPicture(String fileName, Uint8List data) async {
    final isSuccess = await _picturalApi.uploadPicture(fileName, data);

    if (isSuccess) {
      _logger.d("$tag - Upload succeed.");
      // Reload pictures
      await getPictures();
    }

    return isSuccess;
  }

  /// Share [picture] with [friend].
  Future<bool> sharePictureWith(PicInfo picture, Friend friend) async {
    try {
      await _picturalApi.sharePictureWith(picture.uuid, friend);
    } catch (e) {
      _logger.e("$tag - $e");
      if(e is ApiException) {
        // TODO add analytics to log error
        _errorCode = e.errorCode;
      }
      return false;
    }
    await getPictures();
    return true;
  }

  /// Remove [friend] access to [picture].
  Future<bool> removeAccessOf(PicInfo picture, Friend friend) async {
    try {
      await _picturalApi.removePictureAccess(picture.uuid, friend);
    } catch (e) {
      _logger.e("$tag - $e");
      if(e is ApiException) {
        // TODO add analytics to log error
        _errorCode = e.errorCode;
      }
      return false;
    }
    await getPictures();
    return true;
  }

  /// Delete permanently [picture]
  Future<bool> deletePicture(PicInfo picture) async {
    try {
      await _picturalApi.deletePicture(picture.uuid);
    } catch (e) {
      _logger.e("$tag - $e");
      if(e is ApiException) {
        // TODO add analytics to log error
        _errorCode = e.errorCode;
      }
      return false;
    }
    // Refresh the pictures list.
    await getPictures();
    return true;
  }
}
