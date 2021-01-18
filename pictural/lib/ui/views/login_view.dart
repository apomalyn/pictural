import 'package:flutter/material.dart';
import 'package:pictural/core/viewmodels/login_viewmodel.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';
import 'package:stacked/stacked.dart';

/// Initial view shown
class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    AppTheme.instance.init(MediaQuery.of(context));

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
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
                SizedBox(height: AppTheme.instance.largeVerticalSpacing),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  color: Colors.white,
                  child: InkWell(
                    splashColor: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    onTap: () => model.handleStartUp(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        vsync: this,
                        child: model.isBusy
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.bluePic))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset("assets/images/google.png",
                                      width: 40, height: 40),
                                  SizedBox(
                                      width: AppTheme
                                              .instance.smallHorizontalSpacing /
                                          3),
                                  Text(
                                    AppIntl.of(context).google_sign_in_button,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Color(0xff69696f)),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
