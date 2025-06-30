import 'package:eClassify/app/routes.dart';
import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/app_icon.dart';
import 'package:eClassify/utils/custom_text.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/hive_keys.dart';
import 'package:eClassify/utils/hive_utils.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Color iconBgColor = Color(0xffFCB917);
Color mainColor = Color(0xff271301);

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.none,
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              Navigator.pushNamed(context, Routes.countriesScreen,
                  arguments: {"from": "home"});
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: iconBgColor,
                  //  color: context.color.secondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: UiUtils.getSvg(
                AppIcons.location,
                fit: BoxFit.none,
                color: mainColor,
                //color: context.color.territoryColor,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ValueListenableBuilder(
              valueListenable: Hive.box(HiveKeys.userDetailsBox).listenable(),
              builder: (context, value, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "locationLbl".translate(context),
                      color: Colors.white,
                      //color: context.color.textColorDark,
                      fontSize: context.font.small,
                    ),
                    CustomText(
                      [
                        HiveUtils.getAreaName(),
                        HiveUtils.getCityName(),
                        HiveUtils.getStateName(),
                        HiveUtils.getCountryName()
                      ]
                              .where((element) =>
                                  element != null && element.isNotEmpty)
                              .join(", ")
                              .isEmpty
                          ? "------"
                          : [
                              HiveUtils.getAreaName(),
                              HiveUtils.getCityName(),
                              HiveUtils.getStateName(),
                              HiveUtils.getCountryName()
                            ]
                              .where((element) =>
                                  element != null && element.isNotEmpty)
                              .join(", "),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      //color: context.color.textColorDark,
                      fontSize: context.font.small,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
