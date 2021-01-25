class Urls {
  static const String picturalApi = "http://localhost:8080";

  // USER OPERATIONS
  /// Log in the user
  static const String login = "$picturalApi/user/login";

  /// Log out the user
  static const String logout = "$picturalApi/user/logout";

  /// Get, update the current user or create a new user
  static const String user = "$picturalApi/user";

  /// Get the friend list of the user
  static const String getFriends = "$picturalApi/user/friends";

  /// Add or remove a friend of the list
  static String friend(friendUuid) => "$picturalApi/user/friends/$friendUuid";

  // IMAGE OPERATIONS
  /// Get or delete an image
  static String image(imageUuid) => "$picturalApi/image/$imageUuid";

  /// Add or remove access to an image
  static String imageFriend(imageUuid, friendUuid) =>
      "$picturalApi/image/$imageUuid/$friendUuid";

  /// Upload an image
  static const String uploadImage = "$picturalApi/image/upload";

  /// Get image info
  static String imageInfo(imageUuid) => "$picturalApi/image/$imageUuid/info";

  /// Get all images owned/shared with the user
  static const String images = "$picturalApi/images";

  // ALBUM OPERATIONS
  /// Get all albums owned/shared with the user
  static const String albums = "$picturalApi/albums";

  /// Add a new album
  static const String albumAdd = "$picturalApi/album";

  /// Update or delete the album
  static String album(albumUuid) => "$picturalApi/album/$albumUuid";

  /// Give access to the album at some friends
  static String albumFriendAdd(albumUuid) => "$picturalApi/album/$albumUuid/friend";

  /// Give access to the album at some friends
  static String albumFriendRemove(albumUuid, friendUuid) =>
      "$picturalApi/album/$albumUuid/friend/$friendUuid";

  /// Add some images in the album
  static String albumImagesAdd(albumUuid) => "$picturalApi/album/$albumUuid/image";

  /// Remove an image of the album
  static String albumImageRemove(albumUuid, imageUuid) =>
      "$picturalApi/album/$albumUuid/image/$imageUuid";
}
