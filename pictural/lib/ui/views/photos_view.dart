import 'package:flutter/material.dart';
import 'package:pictural/core/models/pic_info.dart';
import 'package:pictural/core/viewmodels/photos_viewmodel.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';
import 'package:pictural/ui/widgets/base_scaffold.dart';
import 'package:pictural/ui/widgets/picture_card.dart';
import 'package:stacked/stacked.dart';

class PhotosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PhotosViewModel>.reactive(
      viewModelBuilder: () => PhotosViewModel(),
      builder: (context, model, child) => DefaultTabController(
        length: 3,
        child: BaseScaffold(
          isLoading: model.isBusy,
          body: NestedScrollView(
            headerSliverBuilder: (context, bool innexBoxIsScrolled) => [
              SliverAppBar(
                elevation: 0.0,
                pinned: true,
                floating: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                flexibleSpace: TabBar(isScrollable: true, tabs: [
                  Tab(text: AppIntl.of(context).photos_tab_all),
                  Tab(text: AppIntl.of(context).photos_tab_mine),
                  Tab(text: AppIntl.of(context).photos_tab_shared)
                ]),
              )
            ],
            body: TabBarView(children: [
              (model.pictures.isEmpty)
                  ? _buildEmptyList(context, AppIntl.of(context).photos_empty,
                      () => model.refresh())
                  : _buildPicturesList(model.pictures, model),
              (model.userPictures.isEmpty)
                  ? _buildEmptyList(context, AppIntl.of(context).photos_empty,
                      () => model.refresh())
                  : _buildPicturesList(model.userPictures, model),
              (model.picturesSharedWithUser.isEmpty)
                  ? _buildEmptyList(
                      context,
                      AppIntl.of(context).photos_shared_empty,
                      () => model.refresh())
                  : _buildPicturesList(model.picturesSharedWithUser, model)
            ]),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_photo_alternate_outlined),
            tooltip: AppIntl.of(context).photos_tooltip_add,
            onPressed: () => model.upload(),
          ),
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
          Icon(Icons.image_not_supported_outlined, size: 50),
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
                tooltip: AppIntl.of(context).photos_tooltip_refresh),
          )
        ],
      ),
    );
  }

  Widget _buildPicturesList(List<PicInfo> pictures,PhotosViewModel model) => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 4.0,
        spacing: 4.0,
        children: pictures
            .map<Widget>((e) =>
                PictureCard(pictureInfo: e, onTap: () => model.goToBigPicture(e)))
            .toList(),
      );
}
