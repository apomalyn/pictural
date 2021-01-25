import 'package:flutter/material.dart';
import 'package:pictural/core/models/friend.dart';
import 'package:pictural/core/viewmodels/friends_viewmodel.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';
import 'package:pictural/ui/widgets/base_scaffold.dart';
import 'package:pictural/ui/widgets/friend_card.dart';
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
      builder: (context, model, child) => BaseScaffold(
        isLoading: model.isBusy,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
          child: model.friends.isEmpty
              ? _buildEmptyList(context, AppIntl.of(context).friends_empty,
                  () => model.refresh())
              : _buildFriendsList(model.friends),
        ),
      ),
    );
  }

  Widget _buildEmptyList(
      BuildContext context, String text, VoidCallback refreshAction) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_outlined, size: 50),
          SizedBox(height: AppTheme.instance.smallVerticalSpacing),
          Text(
            text,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: AppTheme.instance.mediumVerticalSpacing),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
                padding: const EdgeInsets.all(8.0),
                icon: Icon(Icons.refresh),
                onPressed: refreshAction,
                tooltip: AppIntl.of(context).friends_tooltip_refresh),
          )
        ],
      ),
    );
  }

  Widget _buildFriendsList(List<Friend> friends) => Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: friends.map<Widget>((e) => FriendCard(friend: e)).toList());
}
