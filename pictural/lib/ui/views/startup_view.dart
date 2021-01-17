import 'package:flutter/material.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';

/// Initial view shown
class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppTheme.instance.init(MediaQuery.of(context));

    return Scaffold(
      backgroundColor: AppTheme.yellowPic,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("pictural",
                  style: Theme.of(context)
                      .textTheme
                      .headline1.copyWith(color: AppTheme.bluePic, letterSpacing: 20)),
              SizedBox(height: 75),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bluePic))
            ],
          ),
        ),
      ),
    );
  }
}
