import 'package:flutter/material.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';

class NotFoundView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppTheme.yellowPic,
        body: Center(
          child: Column(
            children: [
              Text(AppIntl.of(context).not_found,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: AppTheme.bluePic)),
              Spacer(flex: 3),
              FlatButton(
                  onPressed: () {},
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
