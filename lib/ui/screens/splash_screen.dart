import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hasad/app/routes.dart';
import 'package:hasad/data/cubits/system/fetch_language_cubit.dart';
import 'package:hasad/data/cubits/system/fetch_system_settings_cubit.dart';
import 'package:hasad/data/cubits/system/language_cubit.dart';
import 'package:hasad/data/model/system_settings_model.dart';
import 'package:hasad/settings.dart';
import 'package:hasad/ui/screens/widgets/errors/no_internet.dart';
import 'package:hasad/ui/theme/theme.dart';
import 'package:hasad/utils/app_icon.dart';
import 'package:hasad/utils/constant.dart';
import 'package:hasad/utils/custom_text.dart';
import 'package:hasad/utils/extensions/extensions.dart';
import 'package:hasad/utils/hive_utils.dart';
import 'package:hasad/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({this.itemSlug, super.key, this.sellerId});

  //Used when the app is terminated and then is opened using deep link, in which case
  //the main route needs to be added to navigation stack, previously it directly used to
  //push adDetails route.
  final String? itemSlug;
  final String? sellerId;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isTimerCompleted = false;
  bool isSettingsLoaded = false;
  bool isLanguageLoaded = false;
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool hasInternet = true;

  @override
  void initState() {
    //locationPermission();
    super.initState();

    subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        hasInternet = (!result.contains(ConnectivityResult.none));
      });
      if (hasInternet) {
        context
            .read<FetchSystemSettingsCubit>()
            .fetchSettings(forceRefresh: true);
        startTimer();
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future getDefaultLanguage(String code) async {
    try {
      if (HiveUtils.getLanguage() == null ||
          HiveUtils.getLanguage()?['data'] == null) {
        context.read<FetchLanguageCubit>().getLanguage(code);
      } else if (HiveUtils.isUserFirstTime() == true &&
          code != HiveUtils.getLanguage()?['code']) {
        context.read<FetchLanguageCubit>().getLanguage(code);
      } else {
        isLanguageLoaded = true;
        setState(() {});
      }
    } catch (e) {
      log("Error while load default language $e");
    }
  }

  Future<void> startTimer() async {
    Timer(const Duration(seconds: 1), () {
      isTimerCompleted = true;
      if (mounted) setState(() {});
    });
  }

  void navigateCheck() {
    if (isTimerCompleted && isSettingsLoaded && isLanguageLoaded) {
      navigateToScreen();
    }
  }

  void navigateToScreen() async {
    if (context
            .read<FetchSystemSettingsCubit>()
            .getSetting(SystemSetting.maintenanceMode) ==
        "1") {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(Routes.maintenanceMode);
        }
      });
    }
    else if (HiveUtils.isUserFirstTime() == true)
    {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(Routes.onboarding);
        }
      });
    } else if (HiveUtils.isUserAuthenticated())
    {
      ///User should not navigate automatically to complete profile page after closing the app and re-opening without completing profile
      ///In that case, user should only be set as authenticated when the user has completed his profile
      ///and if not, he should be redirected to login page again
      ///and not complete profile page.
      // if ((HiveUtils.getUserDetails().name == null ||
      //         HiveUtils.getUserDetails().name == "") ||
      //     (HiveUtils.getUserDetails().email == null ||
      //         HiveUtils.getUserDetails().email == "")) {
      //   Future.delayed(
      //     const Duration(seconds: 1),
      //     () {
      //       Navigator.pushReplacementNamed(
      //         context,
      //         Routes.completeProfile,
      //         arguments: {
      //           "from": "login",
      //         },
      //       );
      //     },
      //   );
      // } else {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          //We pass slug only when the user is authenticated otherwise drop the slug
          Navigator.of(context).pushReplacementNamed(Routes.main, arguments: {
            'from': "main",
            "slug": widget.itemSlug,
            "sellerId": widget.sellerId
          });
        }
      });
      //}
    } else
    {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          if (HiveUtils.isUserSkip() == true) {
            Navigator.of(context).pushReplacementNamed(Routes.main, arguments: {
              'from': "main",
              "slug": widget.itemSlug,
              "sellerId": widget.sellerId
            });
          } else {
            Navigator.of(context).pushReplacementNamed(Routes.login);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    navigateCheck();
    return hasInternet
        ? BlocListener<FetchLanguageCubit, FetchLanguageState>(
            listener: (context, state) {
              if (state is FetchLanguageSuccess) {
                Map<String, dynamic> map = state.toMap();

                var data = map['file_name'];
                map['data'] = data;
                map.remove("file_name");

                HiveUtils.storeLanguage(map);
                context.read<LanguageCubit>().changeLanguages(map);
                isLanguageLoaded = true;
                if (mounted) {
                  setState(() {});
                }
              }
            },
            child: BlocListener<FetchSystemSettingsCubit,
                FetchSystemSettingsState>(
              listener: (context, state) {
                if (state is FetchSystemSettingsSuccess) {
                  Constant.isDemoModeOn = context
                      .read<FetchSystemSettingsCubit>()
                      .getSetting(SystemSetting.demoMode);
                  getDefaultLanguage(
                      state.settings['data']['default_language']);
                  isSettingsLoaded = true;
                  setState(() {});
                }
                if (state is FetchSystemSettingsFailure) {
                  log('${state.errorMessage}');
                }
              },
              child: SafeArea(
                bottom: true,
                top: true,
                child: AnnotatedRegion(
                  value: SystemUiOverlayStyle(
                    statusBarColor: context.color.secondaryColor,
                    statusBarIconBrightness: Brightness.dark,
                    systemNavigationBarIconBrightness: Brightness.dark,
                    systemNavigationBarColor: context.color.mainBrown,
                    statusBarBrightness: Brightness.light,
                  ),
                  child: Scaffold(
                    backgroundColor: context.color.mainBrown,
                    // bottomNavigationBar: Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //   child: UiUtils.getSvg(AppIcons.companyLogo),
                    // ),
                    body:
                    SizedBox.expand(
                      child: Image.asset(
                        'assets/home.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Align(
                    //       alignment: AlignmentDirectional.center,
                    //       child: Padding(
                    //         padding: EdgeInsets.only(top: 10.0),
                    //         child: SizedBox(
                    //           width: 150,
                    //           height: 150,
                    //           child: UiUtils.getSvg(AppIcons.splashLogo),
                    //         ),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.only(top: 10.0),
                    //       child: Column(
                    //         children: [
                    //           CustomText(
                    //             AppSettings.applicationName,
                    //             fontSize: context.font.xxLarge,
                    //             color: context.color.secondaryColor,
                    //             textAlign: TextAlign.center,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //           CustomText(
                    //             "\"${"buyAndSellAnything".translate(context)}\"",
                    //             fontSize: context.font.smaller,
                    //             color: context.color.secondaryColor,
                    //             textAlign: TextAlign.center,
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),
            ),
          )
        : NoInternet(
            onRetry: () {
              setState(() {});
            },
          );
  }
}
