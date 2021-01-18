import 'package:flutter/material.dart';
import 'package:pictural/core/viewmodels/startup_viewmodel.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';
import 'package:stacked/stacked.dart';

/// Initial view shown
class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppTheme.instance.init(MediaQuery.of(context));

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => StartupViewModel(),
      onModelReady: (StartupViewModel model) => model.handleStartUp(),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                    tag: "logo",
                    child: Text(AppIntl.of(context).app_name.toLowerCase(),
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppTheme.yellowPic
                                    : AppTheme.bluePic,
                            letterSpacing: 15))),
                SizedBox(height: 75),
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.yellowPic
                            : AppTheme.bluePic))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
