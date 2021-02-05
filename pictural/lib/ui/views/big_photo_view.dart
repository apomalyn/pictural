import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pictural/core/constants/urls.dart';
import 'package:pictural/core/models/friend.dart';
import 'package:pictural/core/models/pic_info.dart';
import 'package:pictural/core/viewmodels/big_picture_viewmodel.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';
import 'package:pictural/ui/widgets/base_scaffold.dart';
import 'package:stacked/stacked.dart';

class BigPhoto extends StatefulWidget {
  @override
  _BigPhotoState createState() => _BigPhotoState();
}

class _BigPhotoState extends State<BigPhoto> {
  /// Size (radius) of the "already shared" bubble
  final double _bubbleSize = 22;

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<BigPictureViewModel>.reactive(
        viewModelBuilder: () => BigPictureViewModel(
            ModalRoute.of(context).settings.arguments as PicInfo),
        builder: (context, model, child) => BaseScaffold(
          showNavigationRail: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              if (model.isOwner)
                IconButton(
                    icon: Icon(Icons.share),
                    tooltip: model.friendListAdjusted.isEmpty
                        ? AppIntl.of(context)
                            .big_picture_share_action_disabled_tooltip
                        : AppIntl.of(context).big_picture_share_action_tooltip,
                    onPressed: model.friendListAdjusted.isEmpty
                        ? null
                        : () {
                            showDialog(
                                context: context,
                                builder: (context) => _buildFriendsListDialog(
                                    model, model.friendListAdjusted,
                                    title: Text(
                                        AppIntl.of(context)
                                            .big_picture_share_with_title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                    onTap: (index) => model.sharePictureWith(
                                        model.friendListAdjusted[index]),
                                    trailing: Icon(Icons.person_add_outlined)));
                          }),
            ],
          ),
          body: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Padding(
                padding:
                    EdgeInsets.all(AppTheme.instance.mediumHorizontalSpacing),
                child: Hero(
                    tag: model.picture.uuid,
                    child: Image.network(Urls.image(model.picture.uuid))),
              ),
              Positioned(
                  // alignment: Alignment.bottomRight,
                  bottom: 20,
                  right: 20,
                  child: _buildAuthorizedUserBubbles(model)),
            ],
          ),
        ),
      );

  /// Build the "already shared with" bubble
  Widget _buildAuthorizedUserBubbles(BigPictureViewModel model) {
    List<Widget> bubbles = [];

    // Add the 4th first friends bubbles
    for (int i = 0; i < min(4, model.picture.authorized.length); i++) {
      bubbles.add(Positioned(
          right: (min(4, model.picture.authorized.length) - i) *
              (_bubbleSize * 0.90),
          child: model.picture.authorized[i].pictureUrl == null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(_bubbleSize),
                  child: Icon(Icons.account_circle_outlined,
                      size: _bubbleSize * 2),
                )
              : CircleAvatar(
                  radius: _bubbleSize,
                  backgroundImage:
                      NetworkImage(model.picture.authorized[i].pictureUrl),
                  backgroundColor: AppTheme.yellowPic)));
    }

    if (model.picture.authorized.length > 4) {
      // Add +n bubble
      bubbles.add(Positioned(
          right: 0,
          child: Container(
            height: _bubbleSize * 2,
            width: _bubbleSize * 2,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(_bubbleSize)),
            child: Center(
                child: Text("+${model.picture.authorized.length - 4}",
                    style: AppTheme.lightTheme.textTheme.headline2
                        .copyWith(color: Colors.black))),
          )));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => showDialog(
            context: context,
            builder: (context) =>
                _buildFriendsListDialog(model, model.picture.authorized,
                    onTap: (index) => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(AppIntl.of(context)
                                  .big_picture_remove_access(
                                      model.picture.authorized[index].name)),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(AppIntl.of(context).cancel)),
                                TextButton(
                                    onPressed: () => model.removeAccessOf(
                                        model.picture.authorized[index]),
                                    child: Text(AppIntl.of(context).confirm))
                              ],
                            )),
                    trailing: Icon(Icons.person_remove_outlined))),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: _bubbleSize * 2, maxWidth: 200),
          child: Stack(fit: StackFit.loose, children: bubbles),
        ),
      ),
    );
  }

  Widget _buildFriendsListDialog(BigPictureViewModel model, List<Friend> list,
          {Widget title, Function onTap, Widget trailing}) =>
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: AppTheme.instance.useMobileLayout
                ? 500
                : AppTheme.instance.size.width * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) title,
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => ListTile(
                              onTap: onTap != null ? () => onTap(index) : null,
                              leading: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: list[index].pictureUrl ==
                                          null
                                      ? Icon(Icons.account_circle_outlined,
                                          size: 22)
                                      : NetworkImage(list[index].pictureUrl),
                                  backgroundColor: AppTheme.yellowPic),
                              title: Text(list[index].name),
                              trailing: trailing,
                            )),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
