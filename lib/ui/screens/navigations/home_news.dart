// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:hasad/app/routes.dart';
import 'package:hasad/data/cubits/category/fetch_category_cubit.dart';
import 'package:hasad/data/cubits/chat/blocked_users_list_cubit.dart';
import 'package:hasad/data/cubits/chat/get_buyer_chat_users_cubit.dart';
import 'package:hasad/data/cubits/favorite/favorite_cubit.dart';
import 'package:hasad/data/cubits/fetch_blogs_cubit.dart';
import 'package:hasad/data/cubits/slider_cubit.dart';
import 'package:hasad/data/cubits/system/fetch_system_settings_cubit.dart';
import 'package:hasad/data/model/item/item_model.dart';
import 'package:hasad/data/model/system_settings_model.dart';
import 'package:hasad/ui/screens/home/GoldShimmerCard.dart';
import 'package:hasad/ui/screens/home/slider_widget.dart';
import 'package:hasad/ui/screens/home/widgets/category_widget_home.dart';
import 'package:hasad/ui/screens/home/widgets/location_widget.dart';
import 'package:hasad/ui/screens/widgets/CustomDrawerWidget.dart';
import 'package:hasad/ui/screens/widgets/marqeeWidget.dart';
import 'package:hasad/ui/theme/theme.dart';
//import 'package:uni_links/uni_links.dart';
import 'package:hasad/utils/app_icon.dart';
import 'package:hasad/utils/constant.dart';
import 'package:hasad/utils/custom_text.dart';
import 'package:hasad/utils/extensions/extensions.dart';
import 'package:hasad/utils/hive_utils.dart';
import 'package:hasad/utils/notification/awsome_notification.dart';
import 'package:hasad/utils/notification/notification_service.dart';
import 'package:hasad/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

const double sidePadding = 10;

class HomeNews extends StatefulWidget {
  final String? from;
  const HomeNews({super.key, this.from});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeNews>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeNews> {
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
        backgroundColor: mainColor,
        body: Column(
          children: [
            // InkWell(
            //   onTap: (){
            //     Navigator.pushNamed(context, Routes.welcome);
            //   },
            //   child: Icon(Icons.ac_unit),
            // ),
            blogMarqueeWidget(),
            Container(
                color: context.color.mainBrown,
                padding: const EdgeInsetsDirectional.only(
                    start: sidePadding, end: sidePadding, bottom: 10, top: 0),
                alignment: AlignmentDirectional.centerStart,
                child: LocationWidget()),
            Expanded(
              child: Container(
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
                                'أهلاً بك في مجتمع إنجاز!',
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
                      const SliderWidget(),
                      SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        ' مجتمع إنجاز بين يديك',
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
                            if(section1)
                            section1 = false;
                            else section1 = true;
                          });
                        },
                        child: title_card('  إرشاداتي' , section1,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A5%D8%B1%D8%B4%D8%A7%D8%AF%D8%A7%D8%AA%D9%8A.png?alt=media&token=3eb93819-37cb-4b53-86d6-299f9b79e4b1"),
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
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' تشغيل المعدات الثقيلة',
                                        url:
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/pn7ueo7p1ys1/4-_%D9%85%D8%AF%D9%88%D9%86%D8%A9_%D8%A7%D9%84%D8%AA%D8%B9%D8%AF%D9%8A%D9%86.jpg'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.mine);
                                    },
                                    child: GoldShimmerCard(
                                        title: '  تشغيل المنجم ',
                                        url:
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/cchsh9teg1dp/3-_%D9%85%D9%8A%D9%83%D8%B1%D9%88%D9%81%D9%88%D9%86_%D8%A7%D9%84%D8%AA%D8%B9%D8%AF%D9%8A%D9%86.jpg'),
                                  ),


                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      InkWell(
                        onTap: () {
                          setState(() {
                            if(section2)
                              section2 = false;
                            else section2 = true;
                          });
                        },
                        child: title_card(' مستلزماتي' , section2,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D9%85%D8%B3%D8%AA%D9%84%D8%B2%D9%85%D8%A7%D8%AA%D9%8A.png?alt=media&token=a0faa9ae-2e84-457e-8018-b08ce8f285e3"),
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
                                      Navigator.pushNamed(
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' مستلزمات المشغل ',
                                        url:
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/appimg%2F4-%20%D8%A7%D9%84%D9%85%D9%82%D8%A7%D9%84%D8%A7%D8%AA%20%D8%A7%D9%84%D8%B9%D9%84%D9%85%D9%8A%D8%A9.jpg?alt=media&token=a718d3dc-a85e-46f1-9c24-aef3f06ab8dc'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: '  مستلزمات المنجم ',
                                        url:
                                        'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/appimg%2F4-%20%D8%A7%D9%84%D9%85%D9%82%D8%A7%D9%84%D8%A7%D8%AA%20%D8%A7%D9%84%D8%B9%D9%84%D9%85%D9%8A%D8%A9.jpg?alt=media&token=a718d3dc-a85e-46f1-9c24-aef3f06ab8dc'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: '    مستلزمات المعدة ',
                                        url: 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/wzgkssd9rseh/71_copy.jpg'),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      InkWell(
                        onTap: () {
                          setState(() {
                            if(section3)
                              section3 = false;
                            else section3 = true;
                          });
                        },
                        child: title_card('المعرفة والبحوث' , section3,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A7%D9%84%D9%85%D8%B9%D8%B1%D9%81%D9%87%20%D9%88%D8%A7%D9%84%D8%A8%D8%AD%D9%88%D8%AB.png?alt=media&token=a8ace6bc-04bc-4c44-b5f8-96566442260a"),
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
                                      Navigator.pushNamed(
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' المقالات العلمية والتحليلية ',
                                        url:
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/68p8l6cu6qxc/2-_%D9%85%D8%AC%D9%84%D8%A9_%D8%A7%D9%84%D8%AA%D8%B9%D8%AF%D9%8A%D9%86.jpg'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' البحوث والأوراق الأكاديمية ',
                                        url:
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/68p8l6cu6qxc/2-_%D9%85%D8%AC%D9%84%D8%A9_%D8%A7%D9%84%D8%AA%D8%B9%D8%AF%D9%8A%D9%86.jpg'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' المواد الدراسية والكتب ',
                                        url: 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/68p8l6cu6qxc/2-_%D9%85%D8%AC%D9%84%D8%A9_%D8%A7%D9%84%D8%AA%D8%B9%D8%AF%D9%8A%D9%86.jpg'),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      InkWell(
                        onTap: () {
                          setState(() {
                            if(section4)
                              section4 = false;
                            else section4 = true;
                          });
                        },
                        child: title_card('الدورات والتأهيل' , section4,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A7%D9%84%D8%AF%D9%88%D8%B1%D8%A7%D8%AA%20%D9%88%D8%A7%D9%84%D8%AA%D8%A7%D9%87%D9%8A%D9%84.png?alt=media&token=2d955d94-c8d8-491c-a881-4c7eabbeb074"),
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
                                      Navigator.pushNamed(
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: 'الدورات التدريبية ',
                                        url:
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/lml0fa6t0p56/73_copy.jpg'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' الندوات وورش العمل ',
                                        url:
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/lml0fa6t0p56/73_copy.jpg'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' برامج تطوير المهارات ',
                                        url: 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/lml0fa6t0p56/73_copy.jpg'),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      InkWell(
                        onTap: () {
                          setState(() {
                            if(section5)
                              section5 = false;
                            else section5 = true;
                          });
                        },
                        child: title_card('الميديا والبودكاست' , section5,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A7%D9%84%D9%85%D9%8A%D8%AF%D9%8A%D8%A7%20%D9%88%D8%A7%D9%84%D8%A8%D9%88%D8%AF%D9%83%D8%A7%D8%B3%D8%AA.png?alt=media&token=3e27f99a-769c-46d3-963b-71b114b94aa9"),
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
                                      Navigator.pushNamed(
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' بودكاست التعدين ',
                                        url:
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/cchsh9teg1dp/3-_%D9%85%D9%8A%D9%83%D8%B1%D9%88%D9%81%D9%88%D9%86_%D8%A7%D9%84%D8%AA%D8%B9%D8%AF%D9%8A%D9%86.jpg'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' فيديوهات توعوية وتدريبية ',
                                        url:
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/r878vk5z12ae/1-_%D9%82%D9%86%D8%A7%D8%A9_%D8%A7%D9%84%D8%AA%D8%B9%D8%AF%D9%8A%D9%86_(1).jpg'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.guide);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' جلسات حوارية ومسجلة ',
                                        url: 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/wfn2teddfaml/70_copy.jpg'),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),

                      InkWell(
                        onTap: () {
                          setState(() {
                            if(section6)
                              section6 = false;
                            else section6 = true;
                          });
                        },
                        child: title_card('المجتمع والمبادرات' , section6,"https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A7%D9%84%D9%85%D8%AC%D8%AA%D9%85%D8%B9%20%D9%88%D8%A7%D9%84%D9%85%D8%A8%D8%A7%D8%AF%D8%B1%D8%A7%D8%AA.png?alt=media&token=a086e4f2-af32-4fe4-9f2e-5d4ac8dd6b9a"),
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
                                      Navigator.pushNamed(
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: 'المبادرات المجتمعية',
                                        url:
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/x33ybf804qm1/74.jpg'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: 'المسؤولية الاجتماعية',
                                        url:
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/x33ybf804qm1/74.jpg'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.soon);
                                    },
                                    child: GoldShimmerCard(
                                        title: ' المنتديات والنقاشات ',
                                        url: 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/mining-market-firebase-ym2dfj/assets/r878vk5z12ae/1-_%D9%82%D9%86%D8%A7%D8%A9_%D8%A7%D9%84%D8%AA%D8%B9%D8%AF%D9%8A%D9%86_(1).jpg'),
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

  Widget appbarTitleWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            Constant.appName,
            fontSize: context.font.large,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
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
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: context.font.small,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container title_card(String title, bool section,String url) {
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

}

Future<void> notificationPermissionChecker() async {
  if (!(await Permission.notification.isGranted)) {
    await Permission.notification.request();
  }
}
