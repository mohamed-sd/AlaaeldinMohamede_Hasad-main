import 'dart:io';
import 'dart:ui' as ui;

import 'package:eClassify/app/app_theme.dart';
import 'package:eClassify/app/routes.dart';
import 'package:eClassify/data/cubits/auth/authentication_cubit.dart';
import 'package:eClassify/data/cubits/auth/delete_user_cubit.dart';
import 'package:eClassify/data/cubits/chat/blocked_users_list_cubit.dart';
import 'package:eClassify/data/cubits/chat/get_buyer_chat_users_cubit.dart';
import 'package:eClassify/data/cubits/favorite/favorite_cubit.dart';
import 'package:eClassify/data/cubits/report/update_report_items_list_cubit.dart';
import 'package:eClassify/data/cubits/seller/fetch_verification_request_cubit.dart';
import 'package:eClassify/data/cubits/system/app_theme_cubit.dart';
import 'package:eClassify/data/cubits/system/fetch_system_settings_cubit.dart';
import 'package:eClassify/data/cubits/system/user_details.dart';
import 'package:eClassify/data/model/system_settings_model.dart';
import 'package:eClassify/ui/screens/chat/chat_list_screen.dart';
import 'package:eClassify/ui/screens/main_activity.dart';
import 'package:eClassify/ui/screens/widgets/blurred_dialog_box.dart';
import 'package:eClassify/ui/screens/widgets/blurred_dialoge_box.dart';
import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/api.dart';
import 'package:eClassify/utils/app_icon.dart';
import 'package:eClassify/utils/constant.dart';
import 'package:eClassify/utils/custom_text.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/helper_utils.dart';
import 'package:eClassify/utils/hive_keys.dart';
import 'package:eClassify/utils/hive_utils.dart';
import 'package:eClassify/utils/network/api_call_trigger.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  ValueNotifier isDarkTheme = ValueNotifier(false);
  final InAppReview _inAppReview = InAppReview.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isExpanded = false;

  @override
  void initState() {
    var settings = context.read<FetchSystemSettingsCubit>();

    if (HiveUtils.isUserAuthenticated()) {
      context
          .read<FetchVerificationRequestsCubit>()
          .fetchVerificationRequests();
    }
    if (!const bool.fromEnvironment("force-disable-demo-mode",
        defaultValue: false)) {
      Constant.isDemoModeOn =
          settings.getSetting(SystemSetting.demoMode) ?? false;
    }
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    isDarkTheme.value = context.read<AppThemeCubit>().isDarkMode();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    isDarkTheme.dispose();
    super.dispose();
  }

  Widget setIconButtons({
    required String assetName,
    required void Function() onTap,
    Color? color,
    double? height,
    double? width,
  }) {
    return Container(
      height: 36,
      width: 36,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: context.color.textDefaultColor.withValues(alpha: 0.1))),
      child: InkWell(
          onTap: onTap,
          child: SvgPicture.asset(
            assetName,
            height: 24,
            width: 24,
            colorFilter: color == null
                ? ColorFilter.mode(context.color.mainGold, BlendMode.srcIn)
                : ColorFilter.mode(color, BlendMode.srcIn),
          )),
    );
  }

  Widget getProfileImage() {
    if (HiveUtils.isUserAuthenticated()) {
      if ((HiveUtils.getUserDetails().profile ?? "").isEmpty) {
        return UiUtils.getSvg(
          AppIcons.defaultPersonLogo,
          color: context.color.mainGold,
          fit: BoxFit.none,
        );
      } else {
        return UiUtils.getImage(
          height: 100,
          width: 100,
          HiveUtils.getUserDetails().profile!,
          fit: BoxFit.cover,
        );
      }
    } else {
      return UiUtils.getSvg(
        AppIcons.defaultPersonLogo,
        color: context.color.mainGold,
        fit: BoxFit.none,
      );
    }
  }

  String sellerStatus(String status) {
    if (status == 'pending') {
      return 'underReview'.translate(context);
    } else if (status == 'approved') {
      return 'approved'.translate(context);
    } else if (status == 'rejected') {
      return 'rejected'.translate(context);
    } else if (status == 'resubmitted') {
      return 'resubmitted'.translate(context);
    } else {
      return '';
    }
  }

  @override
  bool get wantKeepAlive => true;

  Widget profileHeader() {
    return BlocBuilder<FetchVerificationRequestsCubit,
        FetchVerificationRequestState>(builder: (context, state) {
      return ValueListenableBuilder(
          valueListenable: Hive.box(HiveKeys.userDetailsBox).listenable(),
          builder: (context, Box box, _) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                          width: 85,
                          height: 85,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            // shape: BoxShape.rectangle,
                          ),
                          child: CircleAvatar(
                              backgroundColor: context.color.backgroundColor,
                              radius: 50,
                              child: HiveUtils.isUserAuthenticated()
                                  ? (HiveUtils.getUserDetails().profile ?? "")
                                          .isEmpty
                                      ? UiUtils.getSvg(
                                          AppIcons.defaultPersonLogo,
                                          color: context.color.mainGold,
                                          fit: BoxFit.none,
                                        )
                                      : UiUtils.getImage(
                                          height: 150,
                                          width: 150,
                                          HiveUtils.getUserDetails().profile!,
                                          fit: BoxFit.cover,
                                        )
                                  : UiUtils.getSvg(
                                      AppIcons.defaultPersonLogo,
                                      color: context.color.mainGold,
                                      fit: BoxFit.none,
                                    ))),
                      if (HiveUtils.isUserAuthenticated())
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: () {
                              HelperUtils.goToNextPage(
                                  Routes.completeProfile, context, false,
                                  args: {"from": "profile"});
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: context.color.mainGold,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.transparent)),
                              //alignment: Alignment.center,
                              child: UiUtils.getSvg(AppIcons.editProfileIcon,
                                  width: 18, height: 18, fit: BoxFit.fill),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    width: context.screenWidth * 0.04,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        (state is FetchVerificationRequestInProgress ||
                                state is FetchVerificationRequestInitial ||
                                state is FetchVerificationRequestFail)
                            ? SizedBox()
                            : (HiveUtils.isUserAuthenticated() &&
                                    ((HiveUtils.getUserDetails().isVerified ==
                                            1) ||
                                        (state as FetchVerificationRequestSuccess)
                                                .data
                                                .status ==
                                            "approved"))
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: context.color.forthColor,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        UiUtils.getSvg(AppIcons.verifiedIcon,
                                            width: 14, height: 14),
                                        SizedBox(width: 4),
                                        CustomText(
                                            "verifiedLbl".translate(context),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                        // If none of the conditions are met, return an empty widget

                        SizedBox(
                          height: 5,
                        ),

                        if (HiveUtils.isUserAuthenticated()) ...[
                          SizedBox(
                            width: context.screenWidth * 0.63,
                            child: CustomText(
                              HiveUtils.getUserDetails().name ?? '',
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              color: Colors.white,
                              fontSize: context.font.large,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                            width: context.screenWidth * 0.63,
                            child: CustomText(
                              HiveUtils.getUserDetails().email ?? '',
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              color: Colors.white,
                              fontSize: context.font.small,
                            ),
                          ),
                        ],

                        if (!HiveUtils.isUserAuthenticated()) ...[
                          SizedBox(
                            width: context.screenWidth * 0.4,
                            child: CustomText(
                              "anonymous".translate(context),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              color: Colors.white,
                              fontSize: context.font.large,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                            width: context.screenWidth * 0.4,
                            child: CustomText(
                              "loginFirst".translate(context),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              color: Colors.white,
                              fontSize: context.font.small,
                            ),
                          ),
                        ],

                        (state is FetchVerificationRequestInProgress ||
                                state is FetchVerificationRequestInitial ||
                                state is FetchVerificationRequestFail)
                            ? SizedBox()
                            : (HiveUtils.isUserAuthenticated() &&
                                    (((state as FetchVerificationRequestSuccess)
                                            .data
                                            .status) ==
                                        "rejected"))
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        SizedBox(
                                          height: 7,
                                        ),
                                        SizedBox(
                                          width: context.screenWidth * 0.63,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              // Measure the rendered text
                                              final span = TextSpan(
                                                text:
                                                    "${state.data.rejectionReason!}\t",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: context.font.small,
                                                  color: Colors.red,
                                                ),
                                              );
                                              final tp = TextPainter(
                                                text: span,
                                                maxLines: 2,
                                                // Maximum number of lines before overflow
                                                textDirection:
                                                    TextDirection.ltr,
                                              );
                                              tp.layout(
                                                  maxWidth:
                                                      constraints.maxWidth);

                                              final isOverflowing =
                                                  tp.didExceedMaxLines;

                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: CustomText(
                                                      "${state.data.rejectionReason!}\t",
                                                      maxLines:
                                                          isExpanded ? null : 2,
                                                      softWrap: true,
                                                      overflow: isExpanded
                                                          ? TextOverflow.visible
                                                          : TextOverflow
                                                              .ellipsis,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          context.font.small,
                                                    ),
                                                  ),
                                                  if (isOverflowing) // Conditionally show the button
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .only(start: 3),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            isExpanded =
                                                                !isExpanded; // Toggle the expanded state
                                                          });
                                                        },
                                                        child: CustomText(
                                                          isExpanded
                                                              ? "readLessLbl"
                                                                  .translate(
                                                                      context)
                                                              : "readMoreLbl"
                                                                  .translate(
                                                                      context),
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: context
                                                              .font.small,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      ])
                                : SizedBox.shrink(),

                        (state is FetchVerificationRequestInProgress ||
                                state is FetchVerificationRequestInitial ||
                                state is FetchVerificationRequestFail)
                            ? SizedBox()
                            : (HiveUtils.isUserAuthenticated() &&
                                    (((state as FetchVerificationRequestSuccess)
                                            .data
                                            .status) !=
                                        "approved"))
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color:
                                                        ((state).data.status ==
                                                                'rejected')
                                                            ? Colors.red
                                                            : context
                                                                .color.mainGold,
                                                  ),
                                                  child: CustomText(
                                                    sellerStatus(
                                                        (state).data.status!),
                                                    color: Colors.white,
                                                    fontSize:
                                                        context.font.small,
                                                    fontWeight: FontWeight.w500,
                                                  ))),
                                          if ((state).data.status ==
                                              'rejected') ...[
                                            SizedBox(
                                              width: 12,
                                            ),
                                            InkWell(
                                              child: SizedBox(
                                                  child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: context.color.mainGold,
                                                ),
                                                child: CustomText(
                                                  "resubmit".translate(context),
                                                  color: Colors.white,
                                                  fontSize: context.font.small,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    Routes
                                                        .sellerIntroVerificationScreen,
                                                    arguments: {
                                                      "isResubmitted": true
                                                    }).then((value) {
                                                  if (value == 'refresh') {
                                                    context
                                                        .read<
                                                            FetchVerificationRequestsCubit>()
                                                        .fetchVerificationRequests();
                                                  }
                                                });
                                              },
                                            )
                                          ],
                                        ],
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),

                        (state is FetchVerificationRequestInProgress ||
                                state is FetchVerificationRequestInitial ||
                                state is FetchVerificationRequestSuccess)
                            ? SizedBox()
                            : (HiveUtils.isUserAuthenticated() &&
                                    ((HiveUtils.getUserDetails().isVerified ==
                                            0) ||
                                        (state is FetchVerificationRequestFail))
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      InkWell(
                                        child: SizedBox(
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color:
                                                      context.color.mainBrown,
                                                ),
                                                child: CustomText(
                                                  "getVerificationBadge"
                                                      .translate(context),
                                                  color: context
                                                      .color.secondaryColor,
                                                  fontSize: context.font.small,
                                                  fontWeight: FontWeight.w500,
                                                ))),
                                        onTap: () {
                                          if ((HiveUtils.getUserDetails()
                                                          .email ==
                                                      null ||
                                                  HiveUtils.getUserDetails()
                                                      .email!
                                                      .isEmpty) ||
                                              (HiveUtils.getUserDetails()
                                                          .mobile ==
                                                      null ||
                                                  HiveUtils.getUserDetails()
                                                      .mobile!
                                                      .isEmpty)) {
                                            HelperUtils.showSnackBarMessage(
                                                context,
                                                "pleaseFirstFillYourDetailsInProfile"
                                                    .translate(context));
                                          } else {
                                            Navigator.pushNamed(
                                                context,
                                                Routes
                                                    .sellerIntroVerificationScreen,
                                                arguments: {
                                                  "isResubmitted": false
                                                }).then((value) {
                                              if (value == 'refresh') {
                                                context
                                                    .read<
                                                        FetchVerificationRequestsCubit>()
                                                    .fetchVerificationRequests();
                                              }
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink()),
                      ],
                    ),
                  ),
                  //const Spacer(),
                  if (!HiveUtils.isUserAuthenticated())
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.login, (route) => false);
                        },
                        child: CustomText(
                          "loginLbl".translate(context),
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: context.color.mainColor,
          child: ListView(children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/welcome/profile.jpg"),
                  fit: BoxFit.fitWidth, // لجعل الصورة تغطي المساحة بالكامل
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 9,),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    // child: InkWell(
                    //   onTap: (){
                    //     Navigator.pop(context);
                    //   }
                    //   ,child: Align(
                    //     alignment: Alignment.topRight,
                    //     child:
                    //       InkWell(
                    //           onTap: (){
                    //             Navigator.pop(context);
                    //           },
                    //           child: Icon(Icons.arrow_back , color: Colors.white , size: 30 , weight: 20, )),
                    //
                    //   ),
                    // ),
                  ),
                  SizedBox(
                    height: 65,
                  ),

                  profileHeader(),
                  // الصورة والمعلومات
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
                  //
                  //       Container(
                  //         width: 90,
                  //         height: 90,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(20),
                  //           border: Border.all(width: 2 , color: context.color.mainBrown),
                  //         ),
                  //         child: ClipRRect(
                  //           borderRadius: BorderRadius.circular(20),
                  //           child: Image.asset(
                  //             'assets/map.png',
                  //             width: 103,
                  //             height: 120,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(width: 10),
                  //       Padding(
                  //         padding: const EdgeInsets.only(bottom: 5),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //
                  //             Text(
                  //               ' المستر ',
                  //               style: const TextStyle(
                  //                 fontFamily: 'Rubik',
                  //                 fontSize: 18,
                  //                 fontWeight: FontWeight.w800,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //             Text(
                  //               'user@example.com',
                  //               style: const TextStyle(
                  //                 fontFamily: 'Rubik',
                  //                 fontSize: 13,
                  //                 fontWeight: FontWeight.w800,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              controller: profileScreenController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(children: <Widget>[
                  // profileHeader(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      if (HiveUtils.isUserAuthenticated()) ...[
                        customTile(
                          context,
                          title: " اعلاناتي ".translate(context),
                          svgImagePath: AppIcons.myAdsNav,
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.homeItemsScreen);
                          },
                        ),
                      ],
                      if (HiveUtils.isUserAuthenticated()) ...[
                        customTile(
                          context,
                          title: " الدردشة ".translate(context),
                          svgImagePath: AppIcons.message,
                          onTap: () {
                            Navigator.pushNamed(context, Routes.chatlist);
                          },
                        ),
                      ],

                      customTile(
                        context,
                        title: "myFeaturedAds".translate(context),
                        svgImagePath: AppIcons.promoted,
                        onTap: () async {
                          APICallTrigger.trigger();
                          UiUtils.checkUser(
                              onNotGuest: () {
                                Navigator.pushNamed(
                                    context, Routes.myAdvertisment,
                                    arguments: {});
                              },
                              context: context);
                        },
                      ),

                      customTile(
                        context,
                        title: "subscription".translate(context),
                        svgImagePath: AppIcons.subscription,
                        onTap: () async {
                          //TODO: change it once @End

                          UiUtils.checkUser(
                              onNotGuest: () {
                                Navigator.pushNamed(context,
                                    Routes.subscriptionPackageListRoute);
                              },
                              context: context);
                        },
                      ),

                      customTile(
                        context,
                        title: "transactionHistory".translate(context),
                        svgImagePath: AppIcons.transaction,
                        onTap: () {
                          UiUtils.checkUser(
                              onNotGuest: () {
                                Navigator.pushNamed(
                                    context, Routes.transactionHistory);
                              },
                              context: context);
                        },
                      ),
                      customTile(
                        context,
                        title: "myReview".translate(context),
                        svgImagePath: AppIcons.myReviewIcon,
                        onTap: () {
                          UiUtils.checkUser(
                              onNotGuest: () {
                                Navigator.pushNamed(
                                    context, Routes.myReviewsScreen);
                              },
                              context: context);
                        },
                      ),
                      customTile(
                        context,
                        title: "language".translate(context),
                        svgImagePath: AppIcons.language,
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.languageListScreenRoute);
                        },
                      ),
                      // The Dark Mode Code ************************************
                      // ValueListenableBuilder(
                      //     valueListenable: isDarkTheme,
                      //     builder: (context, v, c) {
                      //       return customTile(
                      //         context,
                      //         title: "darkTheme".translate(context),
                      //         svgImagePath: AppIcons.darkTheme,
                      //         isSwitchBox: true,
                      //         onTapSwitch: (value) {
                      //           context.read<AppThemeCubit>().changeTheme(
                      //               value == true ? AppTheme.dark : AppTheme.light);
                      //           setState(() {
                      //             isDarkTheme.value = value;
                      //           });
                      //         },
                      //         switchValue: v,
                      //         onTap: () {},
                      //       );
                      //     }),
                      customTile(
                        context,
                        title: "notifications".translate(context),
                        svgImagePath: AppIcons.notification,
                        onTap: () {
                          UiUtils.checkUser(
                              onNotGuest: () {
                                Navigator.pushNamed(
                                    context, Routes.notificationPage);
                              },
                              context: context);
                        },
                      ),
                      customTile(
                        context,
                        title: "blogs".translate(context),
                        svgImagePath: AppIcons.articles,
                        onTap: () {
                          UiUtils.checkUser(
                              onNotGuest: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.blogsScreenRoute,
                                );
                              },
                              context: context);
                        },
                      ),
                      customTile(
                        context,
                        title: "favorites".translate(context),
                        svgImagePath: AppIcons.favorites,
                        onTap: () {
                          UiUtils.checkUser(
                              onNotGuest: () {
                                Navigator.pushNamed(
                                    context, Routes.favoritesScreen);
                              },
                              context: context);
                        },
                      ),
                      customTile(
                        context,
                        title: "faqsLbl".translate(context),
                        svgImagePath: AppIcons.faqsIcon,
                        onTap: () {
                          UiUtils.checkUser(
                              onNotGuest: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.faqsScreen,
                                );
                              },
                              context: context);
                        },
                      ),
                      customTile(
                        context,
                        title: "shareApp".translate(context),
                        svgImagePath: AppIcons.shareApp,
                        onTap: shareApp,
                      ),
                      customTile(
                        context,
                        title: "rateUs".translate(context),
                        svgImagePath: AppIcons.rateUs,
                        onTap: rateUs,
                      ),
                      customTile(
                        context,
                        title: "contactUs".translate(context),
                        svgImagePath: AppIcons.contactUs,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.contactUs,
                          );
                          // Navigator.pushNamed(context, Routes.ab);
                        },
                      ),
                      customTile(
                        context,
                        title: "aboutUs".translate(context),
                        svgImagePath: AppIcons.aboutUs,
                        onTap: () {
                          Navigator.pushNamed(context, Routes.profileSettings,
                              arguments: {
                                'title': "aboutUs".translate(context),
                                'param': Api.aboutUs
                              });
                          // Navigator.pushNamed(context, Routes.ab);
                        },
                      ),
                      customTile(
                        context,
                        title: "termsConditions".translate(context),
                        svgImagePath: AppIcons.terms,
                        onTap: () {
                          Navigator.pushNamed(context, Routes.profileSettings,
                              arguments: {
                                'title': "termsConditions".translate(context),
                                'param': Api.termsAndConditions
                              });
                        },
                      ),
                      customTile(
                        context,
                        title: "privacyPolicy".translate(context),
                        svgImagePath: AppIcons.privacy,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.profileSettings,
                            arguments: {
                              'title': "privacyPolicy".translate(context),
                              'param': Api.privacyPolicy
                            },
                          );
                        },
                      ),
                      if (Constant.isUpdateAvailable == true) ...[
                        updateTile(
                          context,
                          isUpdateAvailable: Constant.isUpdateAvailable,
                          title: "update".translate(context),
                          newVersion: Constant.newVersionNumber,
                          svgImagePath: AppIcons.update,
                          onTap: () async {
                            if (Platform.isIOS) {
                              await launchUrl(
                                  Uri.parse(Constant.appstoreURLios));
                            } else if (Platform.isAndroid) {
                              await launchUrl(
                                  Uri.parse(Constant.playstoreURLAndroid));
                            }
                          },
                        ),
                      ],
                      if (HiveUtils.isUserAuthenticated()) ...[
                        customTile(
                          context,
                          title: "deleteAccount".translate(context),
                          svgImagePath: AppIcons.delete,
                          onTap: () {
                            if (Constant.isDemoModeOn) {
                              if (HiveUtils.getUserDetails().mobile !=
                                  null) if (Constant
                                      .demoMobileNumber ==
                                  (HiveUtils.getUserDetails()
                                      .mobile!
                                      .replaceFirst(
                                          "+${HiveUtils.getCountryCode()}",
                                          ""))) {
                                HelperUtils.showSnackBarMessage(
                                    context,
                                    "thisActionNotValidDemo"
                                        .translate(context));
                                return;
                              }
                            }
                            deleteConfirmWidget();
                          },
                        ),
                      ],
                      if (HiveUtils.isUserAuthenticated()) ...[
                        customTile(
                          context,
                          title: "تسجيل خروج".translate(context),
                          svgImagePath: AppIcons.logout,
                          onTap: () {
                            logOutConfirmWidget();
                          },
                        ),
                      ],
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),

                  // profileInfo(),
                  // Expanded(
                  //   child: profileMenus(),
                  // )
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget updateTile(BuildContext context,
      {required String title,
      required String newVersion,
      required bool isUpdateAvailable,
      required String svgImagePath,
      Function(dynamic value)? onTapSwitch,
      dynamic switchValue,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: () {
          if (isUpdateAvailable) {
            onTap.call();
          }
        },
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.color.mainBrown
                    .withValues(alpha: 0.10000000149011612),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FittedBox(
                  fit: BoxFit.none,
                  child: isUpdateAvailable == false
                      ? const Icon(Icons.done)
                      : UiUtils.getSvg(svgImagePath,
                          color: context.color.mainBrown)),
            ),
            SizedBox(
              width: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  isUpdateAvailable == false
                      ? "uptoDate".translate(context)
                      : title,
                  fontWeight: FontWeight.w700,
                  color: context.color.textColorDark,
                ),
                if (isUpdateAvailable)
                  CustomText(
                    "v$newVersion",
                    fontWeight: FontWeight.w300,
                    color: context.color.textColorDark,
                    fontSize: context.font.small,
                    fontStyle: FontStyle.italic,
                  ),
              ],
            ),
            if (isUpdateAvailable) ...[
              const Spacer(),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: context.color.borderColor, width: 1.5),
                  color: context.color.secondaryColor
                      .withValues(alpha: 0.10000000149011612),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FittedBox(
                  fit: BoxFit.none,
                  child: SizedBox(
                    width: 8,
                    height: 15,
                    child: UiUtils.getSvg(
                      AppIcons.arrowRight,
                      color: context.color.textColorDark,
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

//eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3Rlc3Ricm9rZXJodWIud3J0ZWFtLmluL2FwaS91c2VyX3NpZ251cCIsImlhdCI6MTY5Njg1MDQyNCwibmJmIjoxNjk2ODUwNDI0LCJqdGkiOiJxVTNpY1FsRFN3MVJ1T3M5Iiwic3ViIjoiMzg4IiwicHJ2IjoiMWQwYTAyMGFjZjVjNGI2YzQ5Nzk4OWRmMWFiZjBmYmQ0ZThjOGQ2MyIsImN1c3RvbWVyX2lkIjozODh9.Y8sQhZtz6xGROEMvrTwA6gSSfPK-YwuhwDDc7Yahfg4
  Widget customTile(BuildContext context,
      {required String title,
      required String svgImagePath,
      bool? isSwitchBox,
      Function(dynamic value)? onTapSwitch,
      dynamic switchValue,
      required VoidCallback onTap}) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
          /*border: Border.all(
          width: 1.5,
          color: context.color.borderColor,
        ),*/
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 2),
                blurStyle: BlurStyle.normal)
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            absorbing: !(isSwitchBox ?? false),
            child: Row(
              children: [
                if (isSwitchBox != true)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: SizedBox(
                        width: 8,
                        height: 15,
                        child: Directionality(
                          textDirection: Directionality.of(context),
                          child: RotatedBox(
                              quarterTurns: Directionality.of(context) ==
                                      ui.TextDirection.rtl
                                  ? 2
                                  : -4,
                              child: Icon(
                                Icons.double_arrow,
                                color: context.color.mainGold,
                                size: 20,
                              )),
                        ),
                      ),
                    ),
                  ),
                if (isSwitchBox ?? false)
                  // CupertinoSwitch(value: value, onChanged: onChanged)
                  SizedBox(
                    height: 40,
                    width: 30,
                    child: CupertinoSwitch(
                      activeTrackColor: context.color.mainBrown,
                      value: switchValue ?? false,
                      onChanged: (value) {
                        onTapSwitch?.call(value);
                      },
                    ),
                  ),

                SizedBox(
                  width: 25,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title,
                          fontWeight: FontWeight.w800,
                          color: context.color.textColorDark,
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        )
                      ]),
                ),
                // const Spacer(),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.color.mainGold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FittedBox(
                      fit: BoxFit.none,
                      child: UiUtils.getSvg(svgImagePath,
                          height: 24, width: 24, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText("• "),
        SizedBox(width: 3),
        Expanded(
          child: CustomText(
            text,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  void deleteConfirmWidget() {
    UiUtils.showBlurredDialoge(
      context,
      dialoge: BlurredDialogBox(
        title: (_auth.currentUser != null)
            ? "deleteProfileMessageTitle".translate(context)
            : "deleteAlertTitle".translate(context),
        content: _auth.currentUser != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  bulletPoint("yourAdsAndTransactionDelete".translate(context)),
                  bulletPoint("accDetailsCanNotRecovered".translate(context)),
                  bulletPoint("subscriptionsCancelled".translate(context)),
                  bulletPoint(
                      "savedPreferencesAndMessagesLost".translate(context)),
                ],
              )
            : CustomText("deleteRelogin".translate(context),
                textAlign: TextAlign.center),
        cancelButtonName: (_auth.currentUser != null)
            ? 'no'.translate(context)
            : 'cancelLbl'.translate(context),
        acceptButtonName: (_auth.currentUser != null)
            ? "deleteBtnLbl".translate(context)
            : 'logout'.translate(context),
        cancelTextColor: context.color.textColorDark,
        svgImagePath: AppIcons.deleteIcon,
        isAcceptContainerPush: true,
        onAccept: () async {
          (_auth.currentUser != null)
              ? proceedToDeleteProfile()
              : askToLoginAgain();
        },
      ),
    );
  }

  void askToLoginAgain() {
    HelperUtils.showSnackBarMessage(context, 'loginReqMsg'.translate(context));
    HiveUtils.clear();
    Constant.favoriteItemList.clear();
    context.read<UserDetailsCubit>().clear();
    context.read<FavoriteCubit>().resetState();
    context.read<UpdatedReportItemCubit>().clearItem();
    context.read<GetBuyerChatListCubit>().resetState();
    context.read<BlockedUsersListCubit>().resetState();
    HiveUtils.logoutUser(
      context,
      onLogout: () {},
    );
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.login, (route) => false);
  }

  Future<void> signOut(AuthenticationType? type) async {
    if (type == AuthenticationType.google) {
      _googleSignIn.signOut();
    } else {
      _auth.signOut();
    }
  }

  void proceedToDeleteProfile() async {
    //delete user from firebase
    try {
      await _auth.currentUser!.delete().then((value) {
        //delete user prefs from App-local
        context.read<DeleteUserCubit>().deleteUser().then((value) {
          HelperUtils.showSnackBarMessage(context, (value["message"]));
          for (int i = 0; i < AuthenticationType.values.length; i++) {
            if (AuthenticationType.values[i].name ==
                HiveUtils.getUserDetails().type) {
              signOut(AuthenticationType.values[i]).then((value) {
                HiveUtils.clear();
                Constant.favoriteItemList.clear();
                context.read<UserDetailsCubit>().clear();
                context.read<FavoriteCubit>().resetState();
                context.read<UpdatedReportItemCubit>().clearItem();
                context.read<GetBuyerChatListCubit>().resetState();
                context.read<BlockedUsersListCubit>().resetState();

                HiveUtils.logoutUser(
                  context,
                  onLogout: () {},
                );
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(Routes.login, (route) => false);
              });
            }
          }
        });
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == "requires-recent-login") {
        for (int i = 0; i < AuthenticationType.values.length; i++) {
          if (AuthenticationType.values[i].name ==
              HiveUtils.getUserDetails().type) {
            signOut(AuthenticationType.values[i]).then((value) {
              HiveUtils.clear();
              Constant.favoriteItemList.clear();
              context.read<UserDetailsCubit>().clear();
              context.read<FavoriteCubit>().resetState();
              context.read<UpdatedReportItemCubit>().clearItem();
              context.read<GetBuyerChatListCubit>().resetState();
              context.read<BlockedUsersListCubit>().resetState();
              HiveUtils.logoutUser(
                context,
                onLogout: () {},
              );
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.login, (route) => false);
            });
          }
        }
      } else {
        HelperUtils.showSnackBarMessage(context, '${error.message}');
      }
    } catch (e) {
      debugPrint("unable to delete user - ${e.toString()}");
    }
  }

  Widget profileImgWidget() {
    return GestureDetector(
      onTap: () {
        if (HiveUtils.getUserDetails().profile != "" &&
            HiveUtils.getUserDetails().profile != null) {
          UiUtils.showFullScreenImage(
            context,
            provider: NetworkImage(
                context.read<UserDetailsCubit>().state.user?.profile ?? ""),
          );
        }
      },
      child: (context.watch<UserDetailsCubit>().state.user?.profile ?? "")
              .trim()
              .isEmpty
          ? buildDefaultPersonSVG(context)
          : Image.network(
              context.watch<UserDetailsCubit>().state.user?.profile ?? "",
              fit: BoxFit.cover,
              width: 49,
              height: 49,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return buildDefaultPersonSVG(context);
              },
              loadingBuilder: (BuildContext context, Widget? child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child!;
                return buildDefaultPersonSVG(context);
              },
            ),
    );
  }

  Widget buildDefaultPersonSVG(BuildContext context) {
    return Container(
      width: 49,
      height: 49,
      color: context.color.mainGold.withValues(alpha: 0.1),
      child: FittedBox(
        fit: BoxFit.none,
        child: UiUtils.getSvg(AppIcons.defaultPersonLogo,
            color: context.color.mainGold, width: 30, height: 30),
      ),
    );
  }

  void shareApp() {
    try {
      if (Platform.isAndroid) {
        Share.share(
            '${Constant.appName}\n${Constant.playstoreURLAndroid}\n${Constant.shareappText}',
            subject: Constant.appName);
      } else {
        Share.share(
            '${Constant.appName}\n${Constant.appstoreURLios}\n${Constant.shareappText}',
            subject: Constant.appName,
            sharePositionOrigin: Rect.fromLTWH(
                0,
                0,
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height / 2));
      }
    } catch (e) {
      HelperUtils.showSnackBarMessage(context, e.toString());
    }
  }

  Future<void> rateUs() => _inAppReview.openStoreListing(
      appStoreId: Constant.iOSAppId, microsoftStoreId: 'microsoftStoreId');

  void logOutConfirmWidget() {
    UiUtils.showBlurredDialoge(context,
        dialoge: BlurredDialogBox(
            title: "confirmLogoutTitle".translate(context),
            onAccept: () async {
              Future.delayed(
                Duration.zero,
                () {
                  HiveUtils.clear();
                  Constant.favoriteItemList.clear();
                  context.read<UserDetailsCubit>().clear();
                  context.read<FavoriteCubit>().resetState();
                  context.read<UpdatedReportItemCubit>().clearItem();
                  context.read<GetBuyerChatListCubit>().resetState();
                  context.read<BlockedUsersListCubit>().resetState();
                  context.read<AuthenticationCubit>().signOut();
                  HiveUtils.logoutUser(
                    context,
                    onLogout: () {},
                  );
                },
              );
            },
            cancelTextColor: context.color.textColorDark,
            svgImagePath: AppIcons.logoutIcon,
            content: CustomText("confirmLogOutMsg".translate(context))));
  }
}
