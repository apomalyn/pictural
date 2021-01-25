import 'package:flutter/material.dart';
import 'package:pictural/core/models/friend.dart';
import 'package:pictural/ui/utils/app_theme.dart';


class FriendCard extends StatefulWidget {
  final Friend friend;

  final VoidCallback deleteCallback;

  const FriendCard({Key key, this.friend, this.deleteCallback})
      : super(key: key);

  @override
  _FriendCardState createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) => _buildDesktopCard();

  Widget _buildDesktopCard() => Card(
    child: MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 20.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isHovered && widget.deleteCallback != null)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    icon: Icon(Icons.delete_outlined),
                    onPressed: () =>
                        widget.deleteCallback()),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: widget.friend.pictureUrl == null
                      ? Icon(Icons.account_circle_outlined, size: 200)
                      : Image.network(widget.friend.pictureUrl, fit: BoxFit.fill),
                ),
                SizedBox(height: AppTheme.instance.smallVerticalSpacing/2),
                Text(widget.friend.name, style: Theme.of(context).textTheme.headline6)
              ],
            )
          ],
        ),
      ),
    ),
  );


}
