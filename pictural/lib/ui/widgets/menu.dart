import 'package:flutter/material.dart';
import 'package:pictural/core/constants/paths.dart';
import 'package:pictural/core/managers/user_repository.dart';
import 'package:pictural/core/models/user.dart';
import 'package:pictural/core/services/navigation_service.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/locator.dart';
import 'package:pictural/ui/utils/app_theme.dart';

class Menu extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();
  final User _user = locator<UserRepository>().user;

  static const int profileView = 0;
  static const int photosView = 1;
  static const int albumsView = 2;
  static const int friendsView = 3;

  @override
  Widget build(BuildContext context) => NavigationRail(
        labelType: NavigationRailLabelType.selected,
        destinations: [
          NavigationRailDestination(
              icon: _user == null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Icon(Icons.account_circle_outlined, size: 22),
                    )
                  : CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(_user.pictureUrl),
                      backgroundColor: AppTheme.yellowPic),
              label: Text(AppIntl.of(context).profile_section)),
          NavigationRailDestination(
              icon: const Icon(Icons.image),
              label: Text(AppIntl.of(context).photos_section)),
          NavigationRailDestination(
              icon: const Icon(Icons.photo_album_outlined),
              selectedIcon: const Icon(Icons.photo_album),
              label: Text(AppIntl.of(context).album_section)),
          NavigationRailDestination(
              icon: const Icon(Icons.group_outlined),
              selectedIcon: const Icon(Icons.group),
              label: Text(AppIntl.of(context).friends_section)),
        ],
        selectedIndex: _defineIndex(ModalRoute.of(context).settings.name),
        onDestinationSelected: _onTap,
      );

  int _defineIndex(String routeName) {
    int currentView = photosView;

    switch (routeName) {
      case Paths.profile:
        currentView = profileView;
        break;
      case Paths.friends:
        currentView = friendsView;
        break;
      case Paths.photos:
        currentView = photosView;
        break;
      case Paths.albums:
        currentView = albumsView;
        break;
    }

    return currentView;
  }

  void _onTap(int index) {
    switch (index) {
      case profileView:
        _navigationService.pushNamed(Paths.profile);
        break;
      case friendsView:
        _navigationService.pushNamed(Paths.friends);
        break;
      case photosView:
        _navigationService.pushNamed(Paths.photos);
        break;
      case albumsView:
        _navigationService.pushNamed(Paths.albums);
        break;
    }
  }
}
