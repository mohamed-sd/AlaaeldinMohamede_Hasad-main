import 'package:hasad/app/app_theme.dart';
import 'package:hasad/app/routes.dart';
import 'package:hasad/data/cubits/favorite/favorite_cubit.dart';
import 'package:hasad/data/cubits/favorite/manage_fav_cubit.dart';
import 'package:hasad/data/cubits/system/app_theme_cubit.dart';
import 'package:hasad/data/model/home/home_screen_section.dart';
import 'package:hasad/data/model/item/item_model.dart';
import 'package:hasad/data/repositories/favourites_repository.dart';
import 'package:hasad/ui/screens/navigations/home_screen.dart';
import 'package:hasad/ui/screens/home/widgets/grid_list_adapter.dart';
import 'package:hasad/ui/screens/widgets/promoted_widget.dart';
import 'package:hasad/ui/theme/theme.dart';
import 'package:hasad/utils/app_icon.dart';
import 'package:hasad/utils/custom_text.dart';
import 'package:hasad/utils/extensions/extensions.dart';
import 'package:hasad/utils/extensions/lib/currency_formatter.dart';
import 'package:hasad/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeSectionsAdapter extends StatelessWidget {
  final HomeScreenSection section;

  const HomeSectionsAdapter({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    if (section.style == "style_1") {
      return section.sectionData!.isNotEmpty
          ? Column(
        children: [
          TitleHeader(
            title: section.title ?? "",
            onTap: () {
              Navigator.pushNamed(context, Routes.sectionWiseItemsScreen,
                  arguments: {
                    "title": section.title,
                    "sectionId": section.sectionId,
                  });
            },
            // section: section,
          ),
          GridListAdapter(
            type: ListUiType.List,
            height: MediaQuery.of(context).size.height / 3.5,
            listAxis: Axis.horizontal,
            listSeparator: (BuildContext p0, int p1) => const SizedBox(
              width: 14,
            ),
            builder: (context, int index, bool) {
              ItemModel? item = section.sectionData?[index];

              return ItemCard(
                item: item,
                bigCard: true,
              );
            },
            total: section.sectionData?.length ?? 0,
          ),
        ],
      )
          : SizedBox.shrink();
    } else if (section.style == "style_2") {
      return section.sectionData!.isNotEmpty
          ? Column(
        children: [
          TitleHeader(
            title: section.title ?? "",
            onTap: () {
              Navigator.pushNamed(context, Routes.sectionWiseItemsScreen,
                  arguments: {
                    "title": section.title,
                    "sectionId": section.sectionId,
                  });
            },
          ),
          GridListAdapter(
            type: ListUiType.List,
            height: MediaQuery.of(context).size.height / 3.5,
            listAxis: Axis.horizontal,
            listSeparator: (BuildContext p0, int p1) => const SizedBox(
              width: 14,
            ),
            builder: (context, int index, bool) {
              ItemModel? item = section.sectionData?[index];

              return ItemCard(
                item: item,
                width: 144,
              );
            },
            total: section.sectionData?.length ?? 0,
          ),
        ],
      )
          : SizedBox.shrink();
    } else if (section.style == "style_3") {
      return section.sectionData!.isNotEmpty
          ? Column(
        children: [
          TitleHeader(
            title: section.title ?? "",
            onTap: () {
              Navigator.pushNamed(context, Routes.sectionWiseItemsScreen,
                  arguments: {
                    "title": section.title,
                    "sectionId": section.sectionId,
                  });
            },
          ),
          GridListAdapter(
            type: ListUiType.Grid,
            crossAxisCount: 2,
            height: MediaQuery.of(context).size.height / 3.5,
            builder: (context, int index, bool) {
              ItemModel? item = section.sectionData?[index];

              return ItemCard(
                item: item,
                width: 192,
              );
            },
            total: section.sectionData?.length ?? 0,
          ),
        ],
      )
          : SizedBox.shrink();
    } else if (section.style == "style_4") {
      return section.sectionData!.isNotEmpty
          ? Column(
        children: [
          TitleHeader(
            title: section.title ?? "",
            onTap: () {
              Navigator.pushNamed(context, Routes.sectionWiseItemsScreen,
                  arguments: {
                    "title": section.title,
                    "sectionId": section.sectionId,
                  });
            },
          ),
          GridListAdapter(
            type: ListUiType.List,
            height: MediaQuery.of(context).size.height / 3.5,
            listAxis: Axis.horizontal,
            listSeparator: (BuildContext p0, int p1) => const SizedBox(
              width: 14,
            ),
            builder: (context, int index, bool) {
              ItemModel? item = section.sectionData?[index];

              return ItemCard(
                item: item,
                width: 192,
              );
            },
            total: section.sectionData?.length ?? 0,
          ),
        ],
      )
          : SizedBox.shrink();
    } else {
      return Container();
    }
  }
}

class TitleHeader extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool? hideSeeAll;

  const TitleHeader({
    super.key,
    required this.title,
    required this.onTap,
    this.hideSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          top: 18, bottom: 12, start: sidePadding, end: sidePadding),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: CustomText(
                title,
                fontSize: context.font.large,
                fontWeight: FontWeight.w600,
                maxLines: 1,
              )),
          const Spacer(),
          if (!(hideSeeAll ?? false))
            GestureDetector(
                onTap: onTap,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2.2),
                    child: CustomText(
                      "seeAll".translate(context),
                      fontSize: context.font.smaller + 1,
                    )))
        ],
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final double? width;
  final bool? bigCard;
  final ItemModel? item;

  const ItemCard({
    super.key,
    required this.item,
    this.width,
    this.bigCard,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  double likeButtonSize = 30;
  double imageHeight = 140;
  // Use nullable bool to represent initial state

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.adDetailsScreen, arguments: {
          "model": widget.item,
        });
      },
      child: Container(
        height: 250,
        width: widget.width ?? 250,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow:  [
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(0, 2),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ]
        ),
        child:
        Stack(
          fit: StackFit.passthrough,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [

                    Container(
                      padding: EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: UiUtils.getImage(
                          widget.item?.image ?? "",
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (widget.item?.isFeature ?? false)
                      const PositionedDirectional(
                          start: 10,
                          top: 5,
                          child: PromotedCard(type: PromoteCardType.icon)),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: CustomText(
                            widget.item!.name!,
                            fontSize: context.font.large,
                            maxLines: 1,
                            firstUpperCaseWidget: true,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(2),
                          width: double.infinity
                          ,decoration: BoxDecoration(
                            color: context.color.mainGold,
                            borderRadius: BorderRadius.circular(10)
                        ),child: CustomText(
                          textAlign: TextAlign.center,
                          (widget.item?.price ?? 0.0).currencyFormat,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: context.font.large,
                        ),
                        ),
                        if (widget.item?.address != "")
                          Container(
                            padding: EdgeInsets.all(3),
                            width: double.infinity
                            ,decoration: BoxDecoration(
                            color: context.color.mainGold,
                            borderRadius: BorderRadius.circular(8),),
                            child: Row(
                              children: [
                                UiUtils.getSvg(
                                  AppIcons.location,
                                  width: widget.bigCard == true ? 10 : 8,
                                  height: widget.bigCard == true ? 13 : 11,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                    EdgeInsetsDirectional.only(start: 3.0),
                                    child: CustomText(
                                      widget.item?.address ?? "",
                                      fontSize: (widget.bigCard == true)
                                          ? context.font.small
                                          : context.font.smaller,
                                      color: Colors.black,
                                      maxLines: 1,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            favButton(),
          ],
        ),
      ),
    );
  }

  Widget favButton() {
    bool isLike =
    context.read<FavoriteCubit>().isItemFavorite(widget.item!.id!);

    return BlocProvider(
        create: (context) => UpdateFavoriteCubit(FavoriteRepository()),
        child: BlocConsumer<FavoriteCubit, FavoriteState>(
            bloc: context.read<FavoriteCubit>(),
            listener: ((context, state) {
              if (state is FavoriteFetchSuccess) {
                isLike = context
                    .read<FavoriteCubit>()
                    .isItemFavorite(widget.item!.id!);
              }
            }),
            builder: (context, likeAndDislikeState) {
              return BlocConsumer<UpdateFavoriteCubit, UpdateFavoriteState>(
                  bloc: context.read<UpdateFavoriteCubit>(),
                  listener: ((context, state) {
                    if (state is UpdateFavoriteSuccess) {
                      if (state.wasProcess) {
                        context
                            .read<FavoriteCubit>()
                            .addFavoriteitem(state.item);
                      } else {
                        context
                            .read<FavoriteCubit>()
                            .removeFavoriteItem(state.item);
                      }
                    }
                  }),
                  builder: (context, state) {
                    return PositionedDirectional(
                      top: 10,
                      end: 10,
                      child: InkWell(
                        onTap: () {
                          UiUtils.checkUser(
                              onNotGuest: () {
                                context
                                    .read<UpdateFavoriteCubit>()
                                    .setFavoriteItem(
                                  item: widget.item!,
                                  type: isLike ? 0 : 1,
                                );
                              },
                              context: context);
                        },
                        child: Container(
                          width: likeButtonSize,
                          height: likeButtonSize,
                          decoration: BoxDecoration(
                            color: context.color.secondaryColor,
                            shape: BoxShape.circle,
                            boxShadow:
                            context.watch<AppThemeCubit>().state.appTheme ==
                                AppTheme.dark
                                ? null
                                : [
                              BoxShadow(
                                color: Colors.grey[300]!,
                                offset: const Offset(0, 2),
                                spreadRadius: 2,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: FittedBox(
                            fit: BoxFit.none,
                            child: state is UpdateFavoriteInProgress
                                ? Center(child: UiUtils.progress())
                                : UiUtils.getSvg(
                              isLike ? AppIcons.like_fill : AppIcons.like,
                              width: 22,
                              height: 22,
                              color: context.color.mainGold,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }));
  }
}
