import 'package:flutter/material.dart';
import 'package:pictural/core/models/friend.dart';
import 'package:pictural/core/viewmodels/friends_viewmodel.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';
import 'package:pictural/ui/widgets/base_scaffold.dart';
import 'package:pictural/ui/widgets/friend_card.dart';
import 'package:pictural/ui/widgets/search.dart';
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
              : _buildFriendsList(context, model),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: SearchBar<Friend>(
                        searchFunction: model.search,
                        listItemBuilder:
                            (BuildContext context, Friend friend) => ListTile(
                              leading: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: friend.pictureUrl == null
                                      ? Icon(Icons.account_circle_outlined,
                                      size: 22)
                                      : NetworkImage(friend.pictureUrl),
                                  backgroundColor: AppTheme.yellowPic),
                              title: Text(friend.name),
                              trailing: IconButton(
                                icon: Icon(Icons.group_add_outlined),
                                onPressed: () {},
                              ),
                            ),
                      ),
                    ));
          },
          child: Icon(Icons.group_add_outlined),
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

  Widget _buildFriendsList(BuildContext context, FriendsViewModel model) =>
      Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: model.friends
              .map<Widget>((e) => FriendCard(
                  friend: e,
                  deleteCallback: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(
                                AppIntl.of(context).friends_delete(e.name)),
                            actions: [
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(AppIntl.of(context).cancel)),
                              FlatButton(
                                  onPressed: () => model.deleteFriend(e.uuid),
                                  child: Text(AppIntl.of(context).confirm)),
                            ],
                          ))))
              .toList());
}
