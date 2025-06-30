import 'package:eClassify/data/cubits/profile_setting_cubit.dart';
import 'package:eClassify/data/helper/widgets.dart';
import 'package:eClassify/ui/screens/widgets/animated_routes/blur_page_route.dart';
import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/custom_text.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSettings extends StatefulWidget {
  final String? title;
  final String? param;

  const ProfileSettings({super.key, this.title, this.param});

  @override
  ProfileSettingsState createState() => ProfileSettingsState();

  static Route route(RouteSettings routeSettings) {
    Map? arguments = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => ProfileSettings(
        title: arguments?['title'] as String,
        param: arguments?['param'] as String,
      ),
    );
  }
}

class ProfileSettingsState extends State<ProfileSettings> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      context
          .read<ProfileSettingCubit>()
          .fetchProfileSetting(context, widget.param!, forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.mainGold,
      appBar: UiUtils.buildAppBar(context,
          backgroundColor: context.color.mainGold,
          actions: [
            Container(
              width: 50,
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: context.color.mainBrown,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_forward , color: Colors.white,),
            )
          ]
        // title: widget.title!, showBackButton: true
      ),
      // appBar: Widgets.setAppbar(widget.title!, context, []),
      body: BlocBuilder<ProfileSettingCubit, ProfileSettingState>(
          builder: (context, state) {
            if (state is ProfileSettingFetchProgress) {
              return Center(
                child: UiUtils.progress(
                    normalProgressColor: context.color.mainColor),
              );
            } else if (state is ProfileSettingFetchSuccess) {
              return contentWidget(state, context);
            } else if (state is ProfileSettingFetchFailure) {
              return Widgets.noDataFound(state.errmsg);
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }
}

Widget contentWidget(ProfileSettingFetchSuccess state, BuildContext context) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child:
    Column(
        children:
        [
          Container(
            margin: EdgeInsets.only(bottom: 5 , top : 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText("إنجاز",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w800,
                  fontSize: context.font.large,),

                SizedBox(width: 20,),

                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: UiUtils.getSvg("assets/svg/Logo/placeholder.svg",fit: BoxFit.cover, width: 70 , height: 70 ),
                ),

                CustomText("Enjaz",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w800,
                  fontSize: context.font.large,),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity
                  ,margin: EdgeInsets.symmetric(vertical: 5 , horizontal: 10),
                  padding: EdgeInsets.all(5)
                  ,decoration: BoxDecoration(
                  color: context.color.mainGold,
                  borderRadius: BorderRadius.circular(18),
                ),
                  child: CustomText(
                    " من نحن ",
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w800,
                    fontSize: context.font.large,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    state.data.toString(),
                    onTapUrl: (url) =>
                        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
                    customStylesBuilder: (element) {
                      if (element.localName == 'table') {
                        return {'background-color': 'grey[50]'};
                      }
                      if (element.localName == 'p') {
                        return {'color': context.color.textColorDark.toString()};
                      }
                      if (element.localName == 'p' &&
                          element.children.any((child) => child.localName == 'strong')) {
                        return {
                          'color': context.color.territoryColor.toString(),
                          'font-size': 'larger',
                        };
                      }
                      if (element.localName == 'tr') {
                        // Customize style for `tr`
                        return null; // add your custom styles here if needed
                      }
                      if (element.localName == 'th') {
                        return {
                          'background-color': 'grey',
                          'border-bottom': '1px solid black',
                        };
                      }
                      if (element.localName == 'td') {
                        return {'border': '0.5px solid grey'};
                      }
                      if (element.localName == 'h5') {
                        return {
                          'max-lines': '2',
                          'text-overflow': 'ellipsis',
                        };
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),]
    ),
  );
}
