import 'package:eClassify/app/routes.dart';
import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/constant.dart';
import 'package:eClassify/utils/custom_text.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';


const double sidePadding = 10;

class Eyes extends StatefulWidget {
  final String? from;
  const Eyes({super.key, this.from});

  @override
  EyesState createState() => EyesState();
}

class EyesState extends State<Eyes>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Eyes> {
  @override
  bool get wantKeepAlive => true;

  late final WebViewController _webViewController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  Color mainColor = const Color(0xff271301);

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("http://sudan2.ayunsdn.com/")); // 🔁 غيّر الرابط هنا

    notificationPermissionChecker();
  }

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
        backgroundColor: Colors.white,
        body: WebViewWidget(controller: _webViewController),
      ),
    );
  }

  Widget appbarTitleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CustomText(
          Constant.appName,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget appbarIconWidget(IconData icon, Function callback) {
    return IconButton(
      onPressed: () => callback(),
      icon: Icon(icon),
    );
  }

  List<Widget> appbarActionsWidget() {
    return [
      appbarIconWidget(Icons.favorite_border, () {
        UiUtils.checkUser(
          onNotGuest: () {
            Navigator.pushNamed(context, Routes.favoritesScreen);
          },
          context: context,
        );
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
          context: context,
        );
      }),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

Future<void> notificationPermissionChecker() async {
  if (!(await Permission.notification.isGranted)) {
    await Permission.notification.request();
  }
}
