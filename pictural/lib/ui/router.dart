import 'package:flutter/material.dart';
import 'package:pictural/ui/views/not_found_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      default:
        return PageRouteBuilder(
            settings: RouteSettings(name: '/not_found'),
            pageBuilder: (_, __, ___) => NotFoundView());
    }
  }
}
