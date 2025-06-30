// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:eClassify/app/routes.dart';
import 'package:eClassify/data/cubits/category/fetch_category_cubit.dart';
import 'package:eClassify/data/cubits/chat/blocked_users_list_cubit.dart';
import 'package:eClassify/data/cubits/chat/get_buyer_chat_users_cubit.dart';
import 'package:eClassify/data/cubits/favorite/favorite_cubit.dart';
import 'package:eClassify/data/cubits/fetch_blogs_cubit.dart';
import 'package:eClassify/data/cubits/slider_cubit.dart';
import 'package:eClassify/data/cubits/system/fetch_system_settings_cubit.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:eClassify/data/model/system_settings_model.dart';
import 'package:eClassify/ui/screens/home/GoldShimmerCard.dart';
import 'package:eClassify/ui/screens/home/slider_widget.dart';
import 'package:eClassify/ui/screens/home/widgets/category_widget_home.dart';
import 'package:eClassify/ui/screens/home/widgets/location_widget.dart';
import 'package:eClassify/ui/screens/widgets/CustomDrawerWidget.dart';
import 'package:eClassify/ui/screens/widgets/marqeeWidget.dart';
import 'package:eClassify/ui/theme/theme.dart';
//import 'package:uni_links/uni_links.dart';
import 'package:eClassify/utils/app_icon.dart';
import 'package:eClassify/utils/constant.dart';
import 'package:eClassify/utils/custom_text.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/hive_utils.dart';
import 'package:eClassify/utils/notification/awsome_notification.dart';
import 'package:eClassify/utils/notification/notification_service.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

const double sidePadding = 10;

class HomeGuide extends StatefulWidget {
  final String? from;

  const HomeGuide({super.key, this.from});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeGuide>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeGuide> {
  //
  @override
  bool get wantKeepAlive => true;

  //
  List<ItemModel> itemLocalList = [];

  //
  bool isCategoryEmpty = false;

  //
  late final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Color mainColor = Color(0xff271301);
  Color marqueeBgColor = Color(0xff150900);
  @override
  void initState() {
    super.initState();
    initializeSettings();
    addPageScrollListener();
    notificationPermissionChecker();
    LocalAwesomeNotification().init(context);
    ///////////////////////////////////////
    NotificationService.init(context);
    //for marquee
    context.read<FetchBlogsCubit>().fetchBlogs();
    //
    loadItemData();
    if (HiveUtils.isUserAuthenticated()) {
      context.read<FavoriteCubit>().getFavorite();
      //fetchApiKeys();
      context.read<GetBuyerChatListCubit>().fetch();
      context.read<BlockedUsersListCubit>().blockedUsersList();
    }
  }

  void _openCustomSideSheet(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // خلفية شفافة
      builder: (context) {
        return Align(
          alignment: Alignment.centerRight,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              height: double.infinity,
              width: MediaQuery.of(context).size.width * 0.70,
              color: Color.fromARGB(255, 66, 37, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: context.color.mainGold,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      Icons.close,
                      color: context.color.mainGold,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: context.color.mainGold, width: 1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: UiUtils.getSvg(AppIcons.appbarLogo,
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Equipation@info.com",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void loadItemData() {
    context.read<SliderCubit>().fetchSlider(
          context,
        );
    context.read<FetchCategoryCubit>().fetchCategories();
    /*  context.read<FetchHomeScreenCubit>().fetch(
          city: HiveUtils.getCityName(),
          country: HiveUtils.getCountryName(),
          state: HiveUtils.getStateName(),
          radius: HiveUtils.getNearbyRadius(),
          longitude: HiveUtils.getLongitude(),
          latitude: HiveUtils.getLatitude(),
        );
    context.read<FetchHomeAllItemsCubit>().fetch(
        city: HiveUtils.getCityName(),
        radius: HiveUtils.getNearbyRadius(),
        longitude: HiveUtils.getLongitude(),
        latitude: HiveUtils.getLatitude(),
        country: HiveUtils.getCountryName(),
        state: HiveUtils.getStateName()); */
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeSettings() {
    final settingsCubit = context.read<FetchSystemSettingsCubit>();
    if (!const bool.fromEnvironment("force-disable-demo-mode",
        defaultValue: false)) {
      Constant.isDemoModeOn =
          settingsCubit.getSetting(SystemSetting.demoMode) ?? false;
    }
  }

  void addPageScrollListener() {
    //homeScreenController.addListener(pageScrollListener);
  }

  bool section1 = false;
  bool section2 = false;
  bool section3 = false;
  bool section4 = false;
  bool section5 = false;
  bool section6 = false;
  bool section7 = false;
  bool section8 = false;
  bool section9 = false;
  bool section10 = false;
  bool section11 = false;
  bool section12 = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          //leadingWidth: double.maxFinite,
          titleSpacing: 0,
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.profileScreen);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            width: 1, color: context.color.mainGold)),
                    child: Icon(Icons.person, color: context.color.mainGold),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: InkWell(
              //       onTap: () {
              //         showModalBottomSheet(
              //             context: context,
              //             isScrollControlled: true,
              //             backgroundColor: Colors.transparent,
              //             shape: RoundedRectangleBorder(
              //               borderRadius:
              //                   BorderRadius.vertical(top: Radius.circular(25)),
              //             ),
              //             builder: (context) => const CustomDrawerWidget());
              //         // _openCustomSideSheet(context);
              //       },
              //       child: Icon(Icons.menu)),
              // ),
              Padding(
                  padding: EdgeInsetsDirectional.only(end: sidePadding),
                  child: appbarTitleWidget()),
            ],
          ),
          backgroundColor: context.color.mainBrown,
          foregroundColor: context.color.mainGold,
          // backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          actions: appbarActionsWidget(),
        ),
        backgroundColor: context.color.mainBrown,
        body: Column(
          children: [
            blogMarqueeWidget(),
            Container(

                padding: const EdgeInsetsDirectional.only(
                    start: sidePadding, end: sidePadding, bottom: 10, top: 0),
                alignment: AlignmentDirectional.centerStart,
                child: LocationWidget()),
            // SizedBox(
            //   height: 10,
            // ),
            // Container(
            //     margin: EdgeInsets.symmetric(horizontal: 10),
            //     child: SliderWidget()),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 0),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                padding: EdgeInsetsDirectional.only(top: 10, bottom: 80),
                decoration: BoxDecoration(
                    color: context.color.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  key: _refreshIndicatorKey,
                  color: context.color.territoryColor,
                  onRefresh: () async {
                    print("refresh-------");
                    loadItemData();
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    controller: _scrollController,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(30, 0, 20, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 15, 0, 5),
                              child: Text(
                                'أهلاً بك في  إجراءات الشركة!',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'IBMPlexArabic'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 3, 0),
                              child: Text(
                                'حيث نضع كلما تبحث عنه امام عينيك ،',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'IBMPlexArabic'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 3, 0),
                              child: Text(
                                'لتكون علي خطوة واحدة عن عالم إنجاز.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'IBMPlexArabic'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SliderWidget(),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: const SliderWidget()),
                      SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        'دليل الاجراءات بين يديك',
                        textAlign: TextAlign.center,
                        height: 1,
                        customTextStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section1)
                              section1 = false;
                            else
                              section1 = true;
                          });
                        },
                        child: title_card(' إدارة الطلبات والعقودات ', section1,'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A5%D8%AF%D8%A7%D8%B1%D8%A9%20%D8%A7%D9%84%D8%B7%D9%84%D8%A8%D8%A7%D8%AA.png?alt=media&token=cde6bd1b-f856-4d00-b418-437ea6e9dbd7'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section1)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.guide,
                                        arguments:
                                        {
                                          'title': 'إدارة الطلبات',
                                          'flag': '1',
                                        }, // هذا هو الـ title
                                      );
                                    },
                                    child: custom_card_Item(
                                        context,
                                        'استقبال وتسجيل طلبات العملاء ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F12-%20%D8%A7%D8%B3%D8%AA%D9%82%D8%A8%D8%A7%D9%84%20%D8%A7%D9%84%D8%B7%D9%84%D8%A8%D8%A7%D8%AA%20%D9%85%D9%86%20%D8%A7%D9%84%D8%B9%D9%85%D9%84%D8%A7%D8%A1.jpeg.jpg?alt=media&token=e8a52bc1-b02c-46a7-8c6d-49095d7258b2'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.guide,
                                        arguments:
                                        {
                                          'title': 'إدارة الطلبات',
                                          'flag': '2',
                                        }, // هذا هو الـ title
                                      );
                                    },
                                    child: custom_card_Item(
                                        context,
                                        'التحقق من توفر المعدات',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F13-%20%D8%A7%D9%84%D8%AA%D8%AD%D9%82%D9%82%20%D9%85%D9%86%20%D8%AA%D9%88%D9%81%D8%B1%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D8%A7%D8%AA%20%D8%A7%D9%84%D9%85%D8%B7%D9%84%D9%88%D8%A8%D9%87.jpeg.jpg?alt=media&token=9d0df0fd-3e19-43d2-8ea0-a2433705b72b'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.guide,
                                        arguments:
                                        {
                                          'title': 'إدارة الطلبات',
                                          'flag': '3',
                                        },
                                      );
                                    },
                                    child: custom_card_Item(
                                        context,
                                        'تسعير الخدمات ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F14-%20%D8%AA%D8%B3%D8%B9%D9%8A%D8%B1%20%D8%A7%D9%84%D8%AE%D8%AF%D9%85%D8%A7%D8%AA.jpeg.jpg?alt=media&token=d4ecf7e1-fbb8-4052-b99b-b9f830c3499e'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.guide,
                                        arguments:
                                        {
                                          'title': 'إدارة الطلبات',
                                          'flag': '4',
                                        }, // هذا هو الـ title
                                      );
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' جدولة المعدات ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F15-%20%D8%AC%D8%AF%D9%88%D9%84%D8%A9%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D8%A7%D8%AA.jpeg.jpg?alt=media&token=33a7c485-2030-4887-b79d-cba1dc896790'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.guide,
                                        arguments:
                                        {
                                          'title': 'إدارة الطلبات',
                                          'flag': '5',
                                        }, // هذا هو الـ title
                                      );
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' إعداد العقود ومراجعتها ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F16-%20%D8%A5%D8%B9%D8%AF%D8%A7%D8%AF%20%D8%A7%D9%84%D8%B9%D9%82%D9%88%D8%AF.jpeg.jpg?alt=media&token=3755050c-6567-4994-a60e-c232750832ba'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.guide,
                                        arguments:
                                        {
                                          'title': 'إدارة الطلبات',
                                          'flag': '6',
                                        }, // هذا هو الـ title
                                      );
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' توقيع العقود ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F17-%20%D8%AA%D9%88%D9%82%D9%8A%D8%B9%20%D8%A7%D9%84%D8%B9%D9%82%D9%88%D8%AF.jpeg.jpg?alt=media&token=71154ce6-8b94-4058-8f5b-e001e857dfe4'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.guide,
                                        arguments:
                                        {
                                          'title': 'إدارة الطلبات',
                                          'flag': '7',
                                        }, // هذا هو الـ title
                                      );
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' إدارة تعديلات العقود ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F18-%20%D8%A5%D8%AF%D8%A7%D8%B1%D8%A9%20%D8%AA%D8%B9%D8%AF%D9%8A%D9%84%D8%A7%D8%AA%20%D8%A7%D9%84%D8%B9%D9%82%D9%88%D8%AF.jpeg.jpg?alt=media&token=e57da1d3-0811-417a-bbb5-d5a3c477b3c2'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      //section 2
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section2)
                              section2 = false;
                            else
                              section2 = true;
                          });
                        },
                        child: title_card(' توقيع عقود الإيجار', section2,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%AA%D9%88%D9%82%D9%8A%D8%B9%20%D8%B9%D9%82%D9%88%D8%AF%20%D8%A7%D9%84%D8%A7%D9%8A%D8%AC%D8%A7%D8%B1.png?alt=media&token=83b94bf3-c2d2-4f7d-9171-8b7035893a47"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section2)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' إعداد نموذج العقد ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F19-%20%D8%A5%D8%B9%D8%AF%D8%A7%D8%AF%20%D9%86%D9%85%D9%88%D8%B0%D8%AC%20%D8%A7%D9%84%D8%B9%D9%82%D8%AF.jpeg.jpg?alt=media&token=0392180c-45e6-4eb1-a251-bd1807b808c3'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' مراجعة العقد مع العميل ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F20-%20%D9%85%D8%B1%D8%A7%D8%AC%D8%B9%D8%A9%20%D8%A7%D9%84%D8%B9%D9%82%D8%AF%20%D9%85%D8%B9%20%D8%A7%D9%84%D8%B9%D9%85%D9%8A%D9%84.jpeg.jpg?alt=media&token=3c61fed3-5d40-4318-b340-54362055dd82'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        'توقيع العقد مع العميل ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F21-%20%D8%AA%D9%88%D9%82%D9%8A%D8%B9%20%D8%A7%D9%84%D8%B9%D9%82%D8%AF%20%D9%85%D8%B9%20%D8%A7%D9%84%D8%B9%D9%85%D9%8A%D9%84.jpeg.jpg?alt=media&token=64b4f570-1a17-42d2-be56-8c8c6654ce99'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      //secation 3
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section3)
                              section3 = false;
                            else
                              section3 = true;
                          });
                        },
                        child: title_card('  تجهيز المعدة وتسليمها', section3,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%AA%D8%AC%D9%87%D9%8A%D8%B2%20%D9%85%D8%B9%D8%AF%20%D9%88%D8%AA%D8%B3%D9%84%D9%8A%D9%85%D9%87%D8%A7.png?alt=media&token=6ab7e53d-6dc2-4b09-aef4-0f35b6374f45"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section3)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                      context,
                                        ' فحص المعدات قبل التسليم ',

                                            'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F22-%20%D9%81%D8%AD%D8%B5%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D8%A7%D8%AA%20%D9%82%D8%A8%D9%84%20%D8%A7%D9%84%D8%AA%D8%B3%D9%84%D9%8A%D9%85.jpeg.jpg?alt=media&token=4ec24764-21e6-4ffd-b98d-ec4939bf309c'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   تعبئة الوقود وتجهيز المعدات ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F23-%20%D8%AA%D8%B9%D8%A8%D8%A6%D8%A9%20%D8%A7%D9%84%D9%88%D9%82%D9%88%D8%AF%20%D9%88%D8%AA%D8%AC%D9%87%D9%8A%D8%B2%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D8%A7%D8%AA.jpeg.jpg?alt=media&token=593784f7-bbea-49ca-9c84-616e3258dcf6'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '  تسليم المعدات وتسجيل حالتها ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F24-%20%D8%AA%D8%B3%D9%84%D9%8A%D9%85%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D8%A7%D8%AA.jpeg.jpg?alt=media&token=63b44dce-1807-400b-b1c4-5028981af3a6'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      //section 4
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section4)
                              section4 = false;
                            else
                              section4 = true;
                          });
                        },
                        child:
                            title_card('  تشغيل المعدات في الموقع', section4,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%AA%D8%B4%D8%BA%D9%8A%D9%84%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D8%A7%D8%AA%20%D9%81%D9%8A%20%D8%A7%D9%84%D9%85%D9%88%D9%82%D8%B9.png?alt=media&token=c878bc32-5137-46c1-a3ea-2ed74f00f12d"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section4)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '  إرشاد المشغلين علي استلام المعدات ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F25-%20%D8%A5%D8%B1%D8%B4%D8%A7%D8%AF%20%D8%A7%D9%84%D9%85%D8%B4%D8%BA%D9%84%D9%8A%D9%86%20%D8%B9%D9%84%D9%89%20%D8%A7%D8%B3%D8%AA%D9%84%D8%A7%D9%85%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D8%A7%D8%AA.jpeg.jpg?alt=media&token=19ae150a-8865-4237-954e-1b560901bb42'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   متابعة الأداء اليومي للمعدات ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F26-%20%D9%85%D8%AA%D8%A7%D8%A8%D8%B9%D8%A9%20%D8%A7%D9%84%D8%A7%D8%AF%D8%A7%D8%A1%20%D8%A7%D9%84%D9%8A%D9%88%D9%85%D9%8A.jpeg.jpg?alt=media&token=10e43727-d30c-4825-868b-f6a12df55cc3'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   تسجيل ساعات العمل والإنتاج ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F27-%20%D8%AA%D8%B3%D8%AC%D9%8A%D9%84%20%D8%B9%D8%AF%D8%AF%20%D8%B3%D8%A7%D8%B9%D8%A7%D8%AA%20%D8%A7%D9%84%D8%B9%D9%85%D9%84.jpeg.jpg?alt=media&token=822ae08d-eab7-4514-b8b5-a736191ace23'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      ///section 5
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section5)
                              section5 = false;
                            else
                              section5 = true;
                          });
                        },
                        child: title_card('صيانة المعدات', section5,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%B5%D9%8A%D8%A7%D9%86%D8%A9%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D8%A7%D8%AA.png?alt=media&token=9a420a25-4ffe-43ef-8b90-fb66219733f2"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section5)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' إجراء الصيانة الدورية الوقائية ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F28-%20%D8%A5%D8%AC%D8%B1%D8%A7%D8%A1%20%D8%A7%D9%84%D8%B5%D9%8A%D8%A7%D9%86%D8%A9%20%D8%A7%D9%84%D8%AF%D9%88%D8%B1%D9%8A%D8%A9.jpeg?alt=media&token=b9320986-4d93-40f0-8af2-16ba4a5e9cdf'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '  معالجة الأعطال الطارئة',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F29-%20%D9%85%D8%B9%D8%A7%D9%84%D8%AC%D8%A9%20%D8%A7%D9%84%D8%A7%D8%B9%D8%B7%D8%A7%D9%84%20%D8%A7%D9%84%D8%B7%D8%A7%D8%B1%D8%A6%D8%A9.jpeg?alt=media&token=14d55376-be0e-453a-9890-cc62206cf386'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' متابعة حالة المعدات بعد الصيانة',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F30-%20%D9%85%D8%AA%D8%A7%D8%A8%D8%B9%D8%A9%20%D8%AD%D8%A7%D9%84%D8%A9%20%D8%A7%D9%84%D8%A2%D9%84%D9%8A%D8%A9.jpeg?alt=media&token=eeb4d0d9-9f1a-4e97-973e-402cbd9fe815'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      //section 6
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section6)
                              section6 = false;
                            else
                              section6 = true;
                          });
                        },
                        child: title_card('توفير قطع الغيار', section6,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%AA%D9%88%D9%81%D9%8A%D8%B1%20%D9%82%D8%B7%D8%B9%20%D8%A7%D9%84%D8%BA%D9%8A%D8%A7%D8%B1.png?alt=media&token=9e024c50-e1e5-4e15-961d-0346ba9d5566"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section6)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' تحديد احتياجات قطع الغيار للمعدات',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F31-%20%D8%AA%D8%AD%D8%AF%D9%8A%D8%AF%20%D8%A7%D8%AD%D8%AA%D9%8A%D8%A7%D8%AC%D8%A7%D8%AA%20%D9%82%D8%B7%D8%B9%20%D8%A7%D9%84%D8%BA%D9%8A%D8%A7%D8%B1.jpeg?alt=media&token=999fb40d-4922-4b32-bba6-fd146c3331b7'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' طلب قطع الغيار من الموردين ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F32-%20%D8%B7%D9%84%D8%A8%20%D9%82%D8%B7%D8%B9%20%D8%A7%D9%84%D8%BA%D9%8A%D8%A7%D8%B1%20%D9%85%D9%86%20%D8%A7%D9%84%D9%85%D9%88%D8%B1%D8%AF%D9%8A%D9%86.jpeg?alt=media&token=51170098-c7b2-4448-8bfa-6fceb5a67195'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' استلام وتخزين قطع الغيار ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F33-%20%D8%A7%D8%B3%D8%AA%D9%84%D8%A7%D9%85%20%D9%88%D8%AA%D8%AE%D8%B2%D9%8A%D9%86%20%D9%82%D8%B7%D8%B9%20%D8%A7%D9%84%D8%BA%D9%8A%D8%A7%D8%B1.jpeg?alt=media&token=7a044d53-a762-433a-9130-7868e5065ddd'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' توزيع قطع الغيار علي الفرق الفنية',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F34-%20%D8%AA%D9%88%D8%B2%D9%8A%D8%B9%20%D9%82%D8%B7%D8%B9%20%D8%A7%D9%84%D8%BA%D9%8A%D8%A7%D8%B1.jpeg?alt=media&token=85291ded-e161-41a5-a3b7-191d137166c3'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      //section 7

                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section7)
                              section7 = false;
                            else
                              section7 = true;
                          });
                        },
                        child: title_card('  النقل والترحيل', section7,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A7%D9%84%D9%86%D9%82%D9%84%20%D9%88%D8%A7%D9%84%D8%AA%D8%B1%D8%AD%D9%8A%D9%84.png?alt=media&token=3ab722e5-3e65-49b4-ac2c-37f073c899c4"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section7)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' التخطيط لعملية النقل ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F35-%20%D8%A7%D9%84%D8%AA%D8%AE%D8%B7%D9%8A%D8%B7%20%D9%84%D8%B9%D9%85%D9%84%D9%8A%D8%A9%20%D8%A7%D9%84%D9%86%D9%82%D9%84.jpeg?alt=media&token=54fd3bc0-28d3-4324-9d46-88b394a345cb'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '  تجهيز المعدات للنقل ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F36-%20%D8%AA%D8%AC%D9%87%D9%8A%D8%B2%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D9%87%20%D9%84%D9%84%D9%86%D9%82%D9%84.jpeg?alt=media&token=94975a52-c6e3-4cce-8d59-3352ed7b71d5'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '  نقل المعدات الي الموقع المطلوب',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F37-%20%D9%86%D9%82%D9%84%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D8%A7%D8%AA.jpeg?alt=media&token=267df85f-0ba0-4fe4-8f58-cda0089c7958'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   تنزيل المعدات في الموقع ',
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F38-%20%D8%AA%D9%86%D8%B2%D9%8A%D9%84%20%D8%A7%D9%84%D9%85%D8%B9%D8%AF%D8%A7%D8%AA.jpeg?alt=media&token=e1fafa06-0927-4299-b7c2-240de0a42b2e'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      //section 8

                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section8)
                              section8 = false;
                            else
                              section8 = true;
                          });
                        },
                        child: title_card('  آليات التحصيل المالي', section8,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A7%D9%84%D9%8A%D8%A7%D8%AA%20%D8%A7%D9%84%D8%AA%D8%AD%D8%B5%D9%8A%D9%84%20%D8%A7%D9%84%D9%85%D8%A7%D9%84%D9%8A.png?alt=media&token=621a2321-8331-43bf-81f5-e68f5f73ed64"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section8)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   إصدار الفواتير ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   متابعة تحصيل المدفوعات ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '  استلام المدفوعات ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   تسوية الحسابات ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      //section 9

                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section9)
                              section9 = false;
                            else
                              section9 = true;
                          });
                        },
                        child: title_card('  إدارة القوى البشرية', section9,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A7%D8%AF%D8%A7%D8%B1%D8%A9%20%D8%A7%D9%84%D9%82%D9%88%D9%89%20%D8%A7%D9%84%D8%A8%D8%B4%D8%B1%D9%8A%D8%A9.png?alt=media&token=4498c5ec-f3b6-4bea-bfbf-4c72df1ce1d3"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section9)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   تحديد احتياجات القوى البشرية',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   الإعلان عن الوظائف واستقبال الطلبات ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   إجراء التقييمات والمقابلات ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   توظيف العاملين الجدد وتوجيههم ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' تدريب وتطوير القوى البشرية ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' إدارة شؤون الموظفين',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   تدوير العاملين بين المواقع ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      //secation 10

                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section10)
                              section10 = false;
                            else
                              section10 = true;
                          });
                        },
                        child:
                            title_card(' إدارة العمليات الميدانية', section10,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A7%D8%AF%D8%A7%D8%B1%D8%A9%20%D8%A7%D9%84%D8%B9%D9%85%D9%84%D9%8A%D8%A7%D8%AA%20%D8%A7%D9%84%D9%85%D9%8A%D8%AF%D8%A7%D9%86%D9%8A%D8%A9.png?alt=media&token=34ea721c-0199-4c3c-a9be-e28dd4badd59"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section10)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   إصدار الفواتير ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' تنظيم وتنسيق فرق العمل الميدانية',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' إدارة المعدات الميدانية',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' متابعة كفاءة الاداء الميداني',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   التعامل مع الطوارئ الميدانية ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   ضمان تطبيق إجراءات السلامة والجودة ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' إدارة التواصل مع العملاء الميدانيين',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      //secation 11

                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section11)
                              section11 = false;
                            else
                              section11 = true;
                          });
                        },
                        child: title_card(' إدارة علاقات العملاء', section11,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A7%D8%AF%D8%A7%D8%B1%D8%A9%20%D8%B9%D9%84%D8%A7%D9%82%D8%A7%D8%AA%20%D8%A7%D9%84%D8%B9%D9%85%D9%84%D8%A7%D8%A1.png?alt=media&token=a091d4c4-069e-4882-ab47-6894621d9314"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section11)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' تسجيل بيانات العملاء',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        'التواصل مع العملاء',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '  إدارة شكاوى العملاء ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' متابعة عقود العملاء',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        'قياس رضا العملاء ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   بناء ولاء العملاء ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        'متابعة الملاحظات والتوصيات ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      // section 12

                      InkWell(
                        onTap: () {
                          setState(() {
                            if (section12)
                              section12 = false;
                            else
                              section12 = true;
                          });
                        },
                        child: title_card(
                            '   إدارة المشتروات التشغيلية', section12,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A7%D9%84%D9%85%D8%B4%D8%AA%D8%B1%D9%88%D8%A7%D8%AA.png?alt=media&token=057e2cda-8d62-49cf-91e9-7d9339f24c73"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (section12)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  // The Card
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        'تحديد الاحتياجات التشغيلية',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   إعداد طلبات الشراء ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   الاتفاق مع الموردين المحليين المناسبين  ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        '   متابعة تنفيذ المشتروات ',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        'فحص المواد المستلمة',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        'إدارة المخزون التشغيلي',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' التعامل مع الطوارئ التشغيلية',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' تحديد الإحتياجات التشغيلية',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: custom_card_Item(
                                        context,
                                        ' إعداد طلبات الشراء',
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container title_card(String title, bool section,String url ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13),
      width: double.infinity,
      height: 100,
      padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppIcons.categoryBg),
          fit: BoxFit.fill,
        ),
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
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  section ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.black,
                  weight: 8,
                  size: 35,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title ?? "",
                  fontSize: 16,
                  textAlign: TextAlign.right,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional(0, 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: UiUtils.imageType(
                    url,
                    width: 60,
                    height: 55,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget appbarTitleWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(Constant.appName,
              fontSize: context.font.large,
              fontWeight: FontWeight.bold,
              color: context.color.mainGold),
          //UiUtils.getSvg(AppIcons.appbarLogo, height: 40, width: 40 ,fit: BoxFit.cover ),
        ]);
  }

  Widget appbarIconWidget(IconData icon, Function callback) {
    return IconButton(
        onPressed: () {
          callback();
        },
        icon: Icon(
          icon,
        ));
  }

  List<Widget> appbarActionsWidget() {
    return [
      appbarIconWidget(Icons.favorite_border, () {
        UiUtils.checkUser(
            onNotGuest: () {
              Navigator.pushNamed(context, Routes.favoritesScreen);
            },
            context: context);
      }),
      appbarIconWidget(Icons.search, () {
        Navigator.pushNamed(context, Routes.searchScreenRoute, arguments: {
          "autoFocus": true,
        });
      }),
      appbarIconWidget(Icons.notifications_active_outlined, () {
        UiUtils.checkUser(
            onNotGuest: () {
              Navigator.pushNamed(context, Routes.notificationPage);
            },
            context: context);
      }),
      // appbarIconWidget(Icons.person_2_outlined, () {
      //   Navigator.pushNamed(context, Routes.profileScreen);
      // }),
    ];
  }

  Widget blogMarqueeWidget() {
    return BlocBuilder<FetchBlogsCubit, FetchBlogsState>(
        builder: (context, state) {
      if (state is FetchBlogsSuccess) {
        String mergedTitle = state.blogModel.map((e) => e.title).join('\t\t\t');
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.blogsScreenRoute,
            );
          },
          child: Container(
            color: context.color.mainBrown,
            padding: EdgeInsetsDirectional.symmetric(vertical: 5),
            child: MarqueeText(
              text: mergedTitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
              velocity: 50,
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Container custom_card_Item(BuildContext context, String title, String url) {
    return Container(
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child: UiUtils.imageType(
               url,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 1), // أسود شبه شفاف في الأسفل
                    ],
                  ),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: context.font.smaller,
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
  }

  Container the_gold_sec(String title) {
    bool expand = true;
    return Container(
        child: Column(children: [
      InkWell(
        onTap: () {
          if (expand)
            setState(() {
              expand = false;
            });
          else
            setState(() {
              expand = true;
            });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 13),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppIcons.categoryBg),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                expand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              Expanded(
                child: CustomText(
                  title,
                  // item.name ?? "",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                expand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10),
      if (expand)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  // The Card
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(
                      context,
                        'المسجل التجاري',
                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/23dwc45aegqv/8_copy.jpg'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(
                      context ,
                      ' وزارة الإستثمار ',

                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/8iy777zlezzx/9_copy.jpg'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(
                      context,
                       '   وزارة المعادن ',
                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/kqgp4p9tgsdw/10_copy.jpg'),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(context, ' الابحاث الجيلوجية ',
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/fu508h0w64cp/11_copy.jpg'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(context, ' الولايات والمحاليات  ',
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/irp2v834y4x6/12_copy.jpg'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(
                        context,
                        ' المالية والتخطيط الأقتصادي  ',
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/mina24dtpbp3/13_copy.jpg'),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(context, ' هيئة الجمارك ',
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/pxyx3p1md655/14_copy.jpg'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(context, ' وزارة التجارة ',
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/vq8ys7favedu/15_copy.jpg'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(context, ' مكتب العمل ',
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/a5ozl80fvqk4/16_copy.jpg'),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(context, 'وزارة العدل ',
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/aqm2fk2oi1cm/17_copy.jpg'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(context, ' التأمينات الإجتماعية ',
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/6iqubtvxmlic/18_copy.jpg'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.guide);
                    },
                    child: custom_card_Item(context, ' شركات التأمين ',
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/80k6u2xj7rn9/19_copy.jpg'),
                  ),
                ],
              ),
            ],
          ),
        ),
    ]));
  }
}

Future<void> notificationPermissionChecker() async {
  if (!(await Permission.notification.isGranted)) {
    await Permission.notification.request();
  }
}

class GoldSection extends StatefulWidget {
  final String title;

  GoldSection({required this.title});

  @override
  _GoldSectionState createState() => _GoldSectionState();
}

class _GoldSectionState extends State<GoldSection> {
  bool expand = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                expand = !expand;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 13),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppIcons.categoryBg),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    expand
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: CustomText(
                      widget.title,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    expand
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          if (expand)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.guide);
                        },
                        child: GoldShimmerCard(
                          title: 'المسجل التجاري',
                          url:
                              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/23dwc45aegqv/8_copy.jpg',
                        ),
                      ),
                      // باقي العناصر كما هي...
                      // نسخ كل InkWell والباقي كما هو عندك
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
