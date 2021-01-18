import 'package:flutter/material.dart';
import 'package:pictural/core/managers/user_repository.dart';
import 'package:pictural/core/models/user.dart';
import 'package:pictural/core/viewmodels/friends_viewmodel.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';
import 'package:pictural/locator.dart';
import 'package:pictural/ui/widgets/menu.dart';
import 'package:stacked/stacked.dart';

class FriendsView extends StatelessWidget {
  final List<String> tabs = [
    AppIntl.current.photos_section,
    AppIntl.current.album_section,
  ];

  @override
  Widget build(BuildContext context) {
    AppTheme.instance.init(MediaQuery.of(context));

    return ViewModelBuilder<FriendsViewModel>.reactive(
      viewModelBuilder: () => FriendsViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Row(
          children: [
            Menu(),
            if (model.isBusy)
              Center(child: CircularProgressIndicator())
            else
              Center(
                  child: Text(AppIntl.of(context).greetings(model.user.name))),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
