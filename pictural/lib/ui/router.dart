import 'package:flutter/material.dart';
import 'package:pictural/core/constants/paths.dart';
import 'package:pictural/ui/views/friends_view.dart';
import 'package:pictural/ui/views/login_view.dart';
import 'package:pictural/ui/views/not_found_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Paths.login:
        return PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var tween = Tween(begin: 0.0, end: 1.0);

              return FadeTransition(
                opacity: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(seconds: 1, milliseconds: 500),
            settings: RouteSettings(name: routeSettings.name),
            pageBuilder: (_, __, ___) => LoginView());
      case Paths.friends:
        return PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var tween = Tween(begin: 0.0, end: 1.0);

              return FadeTransition(
                opacity: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(seconds: 1, milliseconds: 500),
            settings: RouteSettings(name: routeSettings.name),
            pageBuilder: (_, __, ___) => FriendsView());
      default:
        return PageRouteBuilder(
            settings: RouteSettings(name: routeSettings.name),
            pageBuilder: (_, __, ___) => NotFoundView());
    }
  }
}
