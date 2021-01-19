import 'package:flutter/material.dart';
import 'package:pictural/core/constants/urls.dart';
import 'package:pictural/core/models/pic_info.dart';
import 'package:pictural/core/viewmodels/photos_viewmodel.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';
import 'package:pictural/ui/widgets/base_scaffold.dart';
import 'package:stacked/stacked.dart';

class PhotosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PhotosViewModel>.reactive(
      viewModelBuilder: () => PhotosViewModel(),
      builder: (context, model, child) => BaseScaffold(
        isLoading: model.isBusy,
        body: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (model.pictures.isEmpty)
                _buildEmptyList(context, () => model.refresh())
              else
                _buildPicturesList(model.pictures)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_photo_alternate_outlined),
          tooltip: AppIntl.of(context).photos_tooltip_add,
          onPressed: () => model.upload(),
        ),
      ),
    );
  }

  Widget _buildEmptyList(BuildContext context, VoidCallback refreshAction) =>
      Center(
        child: Column(
          children: [
            Icon(Icons.image_not_supported_outlined, size: 50),
            SizedBox(height: AppTheme.instance.smallVerticalSpacing),
            Text(
              AppIntl.of(context).photos_empty,
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
                  tooltip: AppIntl.of(context).photos_tooltip_refresh),
            )
          ],
        ),
      );

  Widget _buildPicturesList(List<PicInfo> pictures) => Expanded(
        child: GridView.builder(
          itemBuilder: (context, index) => Image.network(Urls.image(pictures[index].uuid)),
          itemCount: pictures.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
        ),
      );
}
