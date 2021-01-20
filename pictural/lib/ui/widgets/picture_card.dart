import 'package:flutter/material.dart';
import 'package:pictural/core/constants/urls.dart';
import 'package:pictural/core/models/pic_info.dart';

class PictureCard extends StatefulWidget {
  final PicInfo pictureInfo;

  final VoidCallback onTap;

  final VoidCallback onLongPress;

  const PictureCard(
      {Key key,
      @required this.pictureInfo,
      @required this.onTap,
      @required this.onLongPress})
      : super(key: key);

  @override
  _PictureCardState createState() => _PictureCardState();
}

class _PictureCardState extends State<PictureCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(
            minWidth: 150, minHeight: 150, maxHeight: 300, maxWidth: 300),
        child: InkWell(
            onTap: widget.onTap,
            onLongPress: () {
              setState(() {
                _isSelected = !_isSelected;
                widget.onLongPress();
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [Image.network(Urls.image(widget.pictureInfo.uuid))],
            )),
      );
}
