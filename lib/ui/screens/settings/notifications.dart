import 'package:eClassify/app/routes.dart';
import 'package:eClassify/data/cubits/fetch_notifications_cubit.dart';
import 'package:eClassify/data/helper/custom_exception.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:eClassify/data/model/notification_data.dart';
import 'package:eClassify/ui/screens/widgets/animated_routes/blur_page_route.dart';
import 'package:eClassify/ui/screens/widgets/errors/no_data_found.dart';
import 'package:eClassify/ui/screens/widgets/errors/no_internet.dart';
import 'package:eClassify/ui/screens/widgets/errors/something_went_wrong.dart';
import 'package:eClassify/ui/screens/widgets/intertitial_ads_screen.dart';
import 'package:eClassify/ui/screens/widgets/shimmerLoadingContainer.dart';
import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/api.dart';
import 'package:eClassify/utils/custom_text.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/helper_utils.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late NotificationData selectedNotification;

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  NotificationsState createState() => NotificationsState();

  static Route route(RouteSettings routeSettings) {
    return BlurredRouter(
      builder: (_) => const Notifications(),
    );
  }
}

class NotificationsState extends State<Notifications> {
  late final ScrollController _pageScrollController = ScrollController();

  List<ItemModel> itemData = [];

  @override
  void initState() {
    super.initState();
    AdHelper.loadInterstitialAd();
    context.read<FetchNotificationsCubit>().fetchNotifications();
    _pageScrollController.addListener(_pageScroll);
  }

  void _pageScroll() {
    if (_pageScrollController.isEndReached()) {
      if (context.read<FetchNotificationsCubit>().hasMoreData()) {
        context.read<FetchNotificationsCubit>().fetchNotificationsMore();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdHelper.showInterstitialAd();
    return Scaffold(
      backgroundColor: context.color.mainColor,
      appBar: UiUtils.buildAppBar(
        context,
        backgroundColor: context.color.mainBrown,
        //title: "notifications".translate(context),
        showBackButton: true,
      ),
      body: BlocBuilder<FetchNotificationsCubit, FetchNotificationsState>(
          builder: (context, state) {
        if (state is FetchNotificationsInProgress) {
          return buildNotificationShimmer();
        }
        if (state is FetchNotificationsFailure) {
          if (state.errorMessage is ApiException) {
            if (state.errorMessage.error == "no-internet") {
              return NoInternet(
                onRetry: () {
                  context.read<FetchNotificationsCubit>().fetchNotifications();
                },
              );
            }
          }

          return const SomethingWentWrong();
        }

        if (state is FetchNotificationsSuccess) {
          if (state.notificationdata.isEmpty) {
            return NoDataFound(
              onTap: () {
                context.read<FetchNotificationsCubit>().fetchNotifications();
              },
            );
          }

          return buildNotificationListWidget(state);
        }

        return const SizedBox.square();
      }),
    );
  }

  Widget buildNotificationShimmer() {
    return ListView.separated(
        padding: const EdgeInsets.all(10),
        separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
        itemCount: 20,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return SizedBox(
            height: 55,
            child: Row(
              children: <Widget>[
                const CustomShimmer(
                  width: 50,
                  height: 50,
                  borderRadius: 11,
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomShimmer(
                      height: 7,
                      width: 200,
                    ),
                    const SizedBox(height: 5),
                    CustomShimmer(
                      height: 7,
                      width: 100,
                    ),
                    const SizedBox(height: 5),
                    CustomShimmer(
                      height: 7,
                      width: 150,
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  Column buildNotificationListWidget(FetchNotificationsSuccess state) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(vertical: 5 , horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.color.mainGold,
            borderRadius: BorderRadius.circular(16)
          ),
          child: CustomText( "notifications".translate(context) ,
              fontSize: 20 , fontWeight: FontWeight.bold, textAlign: TextAlign.center,),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: ListView.separated(
              controller: _pageScrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
              itemCount: state.notificationdata.length,
              itemBuilder: (context, index) {
                NotificationData notificationData =
                    state.notificationdata[index];
                return GestureDetector(
                  onTap: () {
                    selectedNotification = notificationData;

                    HelperUtils.goToNextPage(
                        Routes.notificationDetailPage, context, false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: context.color.borderColor,
                            width: 1),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0, 2),
                              blurStyle: BlurStyle.normal
                          ),]
                    ),
                    // margin: EdgeInsets.symmetric(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.color.mainGold,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(18)
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(width: 25,
                              height: 53,
                              padding: EdgeInsets.all(1),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  color: context.color.mainGold,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:  Icon(
                                  Icons.notifications_active_rounded ,
                                  color: Colors.white,
                                  size: 15,),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                  Text(
                                    notificationData.title!.firstUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                        color:
                                        context.color.mainGold)
                                        .merge(const TextStyle(
                                            fontWeight: FontWeight.w800 , fontFamily: "Rubik")),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Text(
                                        notificationData.message!
                                            .firstUpperCase(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color:
                                                    Colors.black),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: CustomText(
                                      textAlign: TextAlign.end,
                                      notificationData.createdAt!
                                          .formatDate()
                                          .toString(),
                                      fontSize: context.font.smaller,
                                      color: context.color.textLightColor,
                                    ),
                                  )
                                ])),
                            const SizedBox(width: 12),
                            ClipRRect(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              child: UiUtils.getImage(notificationData.image!,
                                  height: 53, width: 53, fit: BoxFit.scaleDown , showFullScreenImage: true),
                            ),
                          ]),
                    ),
                  ),
                );
              }),
        ),
        if (state.isLoadingMore) UiUtils.progress()
      ],
    );
  }

  Future<List<ItemModel>> getItemById() async {
    Map<String, dynamic> body = {
      // ApiParams.id: itemsId,//String itemsId
    };

    var response = await Api.get(url: Api.getItemApi, queryParameters: body);

    if (!response[Api.error]) {
      List list = response['data'];
      itemData = list.map((model) => ItemModel.fromJson(model)).toList();
    } else {
      throw CustomException(response[Api.message]);
    }
    return itemData;
  }
}
