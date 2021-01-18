import 'package:flutter/material.dart';
import 'package:pictural/core/constants/paths.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';
import 'package:pictural/locator.dart';
import 'package:pictural/core/services/navigation_service.dart';

class NotFoundView extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppTheme.yellowPic,
        body: Center(
          child: Column(
            children: [
              Text(AppIntl.of(context).app_name.toLowerCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline1.copyWith(color: AppTheme.bluePic, letterSpacing: 20)),
              Text(AppIntl.of(context).not_found,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: AppTheme.bluePic)),
              SizedBox(height: 50),
              FlatButton(
                  onPressed: () => _navigationService.pushNamed(Paths.friends),
                  child: Text(
                      AppIntl.of(context).not_found_button,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: AppTheme.bluePic)))
            ],
          ),
        ),
      );
}
