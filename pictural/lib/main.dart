import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pictural/locator.dart';
import 'package:pictural/ui/router.dart';
import 'package:pictural/ui/utils/app_theme.dart';
import 'package:pictural/ui/views/startup_view.dart';

import 'core/services/navigation_service.dart';
import 'generated/l10n.dart';

void main() {
  setupLocator();

  runApp(Pictural());
}

class Pictural extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pictural",
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppIntl.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      navigatorKey: locator<NavigationService>().navigatorKey,
      supportedLocales: AppIntl.delegate.supportedLocales,
      onGenerateRoute: AppRouter.generateRoute,
      home: StartUpView(),
    );
  }
}
