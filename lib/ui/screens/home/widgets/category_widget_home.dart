import 'package:hasad/app/routes.dart';
import 'package:hasad/data/cubits/category/fetch_category_cubit.dart';
import 'package:hasad/data/model/category_model.dart';
import 'package:hasad/ui/screens/home/GoldShimmerCard.dart';
import 'package:hasad/ui/screens/navigations/home_screen.dart';
import 'package:hasad/ui/screens/home/widgets/category_home_card.dart';
import 'package:hasad/ui/screens/main_activity.dart';
import 'package:hasad/ui/screens/widgets/errors/no_data_found.dart';
import 'package:hasad/ui/theme/theme.dart';
import 'package:hasad/utils/app_icon.dart';
import 'package:hasad/utils/custom_text.dart';
import 'package:hasad/utils/extensions/extensions.dart';
import 'package:hasad/utils/hive_utils.dart';
import 'package:hasad/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String expandedCategroryId = HiveUtils.getExpandedCategoryId() ?? "";
String categoryTitleHeader = 'إعلانات التعدين بين يديك';
bool isFixExpanded = false;
bool isFixExpanded2 = false;

class CategoryWidgetHome extends StatefulWidget {
  const CategoryWidgetHome({super.key});

  @override
  State<CategoryWidgetHome> createState() => _CategoryWidgetHomeState();
}

class _CategoryWidgetHomeState extends State<CategoryWidgetHome> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchCategoryCubit, FetchCategoryState>(
      builder: (context, state) {
        if (state is FetchCategorySuccess) {
          if (state.categories.isNotEmpty) {
            return Column(
              spacing: 5,
              children: [
                categoryWidget(state.categories),
              ],
            );

            /*  return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: context.screenWidth,
                height: 103,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: sidePadding,
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (state.categories.length > 10 &&
                        index == state.categories.length) {
                      return moreCategory(context);
                    } else {
                      return CategoryHomeCard(
                        title: state.categories[index].name!,
                        url: state.categories[index].url!,
                        onTap: () {
                          if (state.categories[index].children!.isNotEmpty) {
                            Navigator.pushNamed(
                                context, Routes.subCategoryScreen,
                                arguments: {
                                  "categoryList":
                                      state.categories[index].children,
                                  "catName": state.categories[index].name,
                                  "catId": state.categories[index].id,
                                  "categoryIds": [
                                    state.categories[index].id.toString()
                                  ]
                                });
                          } else {
                            Navigator.pushNamed(context, Routes.itemsList,
                                arguments: {
                                  'catID':
                                      state.categories[index].id.toString(),
                                  'catName': state.categories[index].name,
                                  "categoryIds": [
                                    state.categories[index].id.toString()
                                  ]
                                });
                          }
                        },
                      );
                    }
                  },
                  itemCount: state.categories.length > 10
                      ? state.categories.length + 1
                      : state.categories.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 12,
                    );
                  },
                ),
              ),
            );
         */
          } else {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: NoDataFound(
                onTap: () {},
              ),
            );
          }
        }
        if (state is FetchCategoryInProgress) {
          return UiUtils.progress();
        }
        if (state is FetchCategoryFailure) {
          return NoDataFound(
            mainMessage: state.errorMessage,
          );
        }
        return Container();
      },
    );
  }

  Widget moreCategory(BuildContext context) {
    return SizedBox(
      width: 70,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.categories,
              arguments: {"from": Routes.home}).then(
            (dynamic value) {
              if (value != null) {
                selectedCategory = value;
                //setState(() {});
              }
            },
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color:
                          context.color.textLightColor.withValues(alpha: 0.33),
                      width: 1),
                  color: context.color.secondaryColor,
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      // color: Colors.blue,
                      width: 48,
                      height: 48,
                      child: Center(
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: UiUtils.getSvg(AppIcons.more,
                                color: context.color.territoryColor)),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: CustomText(
                        "more".translate(context),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        color: context.color.textDefaultColor,
                      )))
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryWidget(List<CategoryModel> categories) {
    return Padding(
      padding:EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          if (categories.length > 10 && index == categories.length) {
            return moreCategory(context);
          }
          final item = categories[index];
          bool isExpanded = expandedCategroryId == item.id.toString();
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (item.children!.isNotEmpty) {
                      setState(() {
                        expandedCategroryId =
                            isExpanded ? '' : item.id.toString();
                      });
                      HiveUtils.setExpandedCategoryId(expandedCategroryId);
                    } else {
                      Navigator.pushNamed(context, Routes.itemsList, arguments: {
                        'catID': item.id.toString(),
                        'catName': item.name,
                        "categoryIds": [item.id.toString()]
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 138,
                    padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // image: DecorationImage(
                      //   image: AssetImage(AppIcons.categoryBg),
                      //   fit: BoxFit.fill,
                      // ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x33000000),
                          offset: Offset(
                            0,
                            2,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white,
                        width: 6,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            // color: Colors.green,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // margin: EdgeInsets.only(top: 8),
                          // padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0, 1),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    item.url ?? "",
                                    width: double.infinity,
                                    height: 90,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center
                            ,children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      item.name ?? "",
                                      fontSize: 16,
                                      textAlign: TextAlign.right,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: context.color.mainBrown,
                                    weight: 8,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            ],
                          ),
                        ),

                        // Icon(
                        //   isExpanded
                        //       ? Icons.keyboard_arrow_up
                        //       : Icons.keyboard_arrow_down,
                        //   color: Colors.black,
                        // ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  subCategoryWidget(item.children!, item.id ?? 0, item.name ?? "")
              ],
            ),
          );
        },
      ),
    );
  }

  Widget subCategoryWidget(
      List<CategoryModel> subcategories, int categoryId, String categoryName) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(
              subcategories.length > 6 ? 6 : subcategories.length,
                  (i) {
                final subcategory = subcategories[i];
                return GestureDetector(
                  onTap: () {
                    if (subcategory.children!.isEmpty &&
                        subcategory.subcategoriesCount == 0) {
                      Navigator.pushNamed(context, Routes.itemsList,
                          arguments: {
                            'catID': subcategory.id.toString(),
                            'catName': subcategory.name,
                            "categoryIds": [
                              categoryId.toString(),
                              subcategory.id.toString()
                            ]
                          });
                    } else {
                      Navigator.pushNamed(context, Routes.subCategoryScreen,
                          arguments: {
                            "categoryList": subcategory.children,
                            "catName": subcategory.name,
                            "catId": subcategory.id,
                            "categoryIds": [
                              categoryId.toString(),
                              subcategory.id.toString()
                            ]
                          });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // color: context.color.mainGold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: UiUtils.imageType(
                            subcategory.url ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            // color: Colors.black.withValues(alpha: 0.5),
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.0),
                                  Colors.black.withValues(alpha: 1), // أسود شبه شفاف في الأسفل
                                ],
                              ),
                            ),
                            child: Text(
                              subcategory.name ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: context.font.small,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (subcategories.length > 6) ...[
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.subCategoryScreen,
                      arguments: {
                        "categoryList": subcategories,
                        "catName": categoryName,
                        "catId": categoryId,
                        "categoryIds": [categoryId.toString()]
                      });
                },
                child: Center(
                  child: CustomText(
                    "seeAll".translate(context),
                    showUnderline: true,
                    fontSize: context.font.smaller + 3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5)
          ],
        ],
      ),
    );
  }
}
