// custom_drawer_widget.dart
import 'package:eClassify/app/routes.dart';
import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/app_icon.dart';
import 'package:eClassify/utils/custom_text.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/hive_utils.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart'; // حسب استخدامك
import 'package:eClassify/ui/screens/widgets/blurred_dialoge_box.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(-1, 0),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.65,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(0),
          ),
          shape: BoxShape.rectangle,
        ),
        alignment: AlignmentDirectional(-1, 0),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: context.color.mainGold,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(50),
              topRight: Radius.circular(0),
            ),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 0),
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Close Drawer Butoom
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Align(
                      alignment: AlignmentDirectional(1, 0),
                      child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 35, 0, 0),
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ),
                  // user Image And User Name
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: context.color.mainBrown,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              width: 70,
                              height: 70,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(18)),
                              child: CircleAvatar(
                                  radius: 0,
                                  child: Image.asset(
                                    'assets/profile.jpg',
                                    width: 70,
                                    height: 100,
                                  )),
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1, 0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 0),
                                      child: HiveUtils.isUserAuthenticated()
                                          ? CustomText(
                                              HiveUtils.getUserDetails().name ??
                                                  '',
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              fontSize: context.font.normal,
                                              fontWeight: FontWeight.w700,
                                            )
                                          : Text(
                                              "مجهول",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800),
                                            ),
                                    ),
                                  ),
                                  Text(
                                    'المدير الإبداعى',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1, 0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 0),
                                      child: HiveUtils.isUserAuthenticated()
                                          ? CustomText(
                                              HiveUtils.getUserDetails()
                                                      .email ??
                                                  '',
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              fontSize: context.font.small,
                                              fontWeight: FontWeight.w700,
                                            )
                                          : Text(
                                              "مجهول",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //Space
                  SizedBox(
                    height: 15,
                  ),

                  // Fast Arrive Links
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.profileScreen);
                        },
                        child: DrawerLinkTow(context, 'حسابي', Icons.person),
                      ),
                      // Links :
                      DrawerLinkTow(context, ' الاداء الشخصي للموظف ',
                          Icons.person_2_sharp),
                      DrawerLinkTow(context, 'من نحن', Icons.info_outline),
                      DrawerLinkTow(context, ' العمليات والمعدات ',
                          Icons.fire_truck_outlined),
                      DrawerLinkTow(context, ' التحفيز والتنافسية ',
                          Icons.slow_motion_video),
                      DrawerLinkTow(context, ' تعزيز الولاء التنافسي ',
                          Icons.smart_button),
                      DrawerLinkTow(context, ' دعم الإبتكار ',
                          Icons.lightbulb_outline_sharp),
                    ],
                  ),

                  SizedBox(
                    height: 100,
                  ),
                  Divider(
                    color: Colors.black,
                  ),

                  // LogOut Buttom
                  HiveUtils.isUserAuthenticated()
                      ? InkWell(
                          onTap: () {
                            // logOutConfirmWidget();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 20, 0, 0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: context.color.mainGold,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: AlignmentDirectional(-1, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 5, 10, 5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 0, 5, 0),
                                              child: Icon(
                                                Icons.logout,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                            ),
                                            Align(
                                              alignment:
                                                  AlignmentDirectional(-1, 0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 8, 5, 8),
                                                child: Text(
                                                  'تسجيل خروج',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding DrawerLinkTow(BuildContext context, String title, IconData icon) {
    return // Generated code for this Container Widget...
        Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: Icon(
                  icon,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
