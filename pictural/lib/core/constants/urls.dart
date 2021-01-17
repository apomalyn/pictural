class Urls {
  static const String picturalApi = "http://localhost:8080";

  // USER OPERATIONS
  /// Log in the user
  static const String login = "/user/login";
  /// Log out the user
  static const String logout = "/user/logout";
  /// Get, update the current user or create a new user
  static const String user = "/user";
  /// Get the friend list of the user
  static const String getFriends = "/user/friends";
  /// Add or remove a friend of the list
  static String friend(friendUuid) => "/user/friend/$friendUuid";

  // IMAGE OPERATIONS
  /// Get or delete an image
  static String image(imageUuid) => "/image/$imageUuid";

  /// Add or remove access to an image
  static String imageFriend(imageUuid, friendUuid) => "/image/$imageUuid/$friendUuid";

  /// Upload an image
  static const String uploadImage = "/image/upload";

  /// Get image info
  static String imageInfo(imageUuid) => "/image/$imageUuid/info";

  /// Get all images owned/shared with the user
  static const String images = "/images";

  // ALBUM OPERATIONS
  /// Get all albums owned/shared with the user
  static const String albums = "/albums";

  /// Add a new album
  static const String albumAdd = "/album";

  /// Update or delete the album
  static String album(albumUuid) => "/album/$albumUuid";

  /// Give access to the album at some friends
  static String albumFriendAdd(albumUuid) => "/album/$albumUuid/friend";

  /// Give access to the album at some friends
  static String albumFriendRemove(albumUuid, friendUuid) =>
      "/album/$albumUuid/friend/$friendUuid";

  /// Add some images in the album
  static String albumImagesAdd(albumUuid) => "/album/$albumUuid/image";

  /// Remove an image of the album
  static String albumImageRemove(albumUuid, imageUuid) =>
      "/album/$albumUuid/image/$imageUuid";
}
