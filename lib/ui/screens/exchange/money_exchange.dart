import 'package:eClassify/app/routes.dart';
import 'package:eClassify/ui/screens/item/my_item_tab_screen.dart';
import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/custom_text.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class MoneyExchange extends StatefulWidget {
  const MoneyExchange({Key? key}) : super(key: key);

  @override
  State<MoneyExchange> createState() => _MoneyExchangeState();
}

class _MoneyExchangeState extends State<MoneyExchange> {
  int selectTab = 0;
  final PageController _pageController = PageController();
  late String date;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.mainColor,
        appBar: UiUtils.buildAppBar(
          context,
          title: 'بورصة العملات',
          backgroundColor: context.color.mainBrown,
          bottomHeight: 49,
          bottom: [
            SizedBox(
                width: context.screenWidth,
                height: 45,
                child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsetsDirectional.fromSTEB(18, 5, 18, 2),
                    scrollDirection: Axis.horizontal,
                    children: [
                      customTab(context,
                          isSelected: (selectTab == 0),
                          name: ' السوق الموازي ', onTap: () {
                        selectTab = 0;
                        setState(() {});
                        _pageController.jumpToPage(0);
                      }, onDoubleTap: () {}),
                      SizedBox(
                        width: 8,
                      ),
                      customTab(context,
                          isSelected: (selectTab == 1),
                          name: 'بنك الخرطوم', onTap: () {
                        selectTab = 1;
                        setState(() {});
                        _pageController.jumpToPage(1);
                      }, onDoubleTap: () {}),
                      SizedBox(
                        width: 8,
                      ),
                      customTab(context,
                          isSelected: (selectTab == 2),
                          name: 'بنك الفيصل', onTap: () {
                        selectTab = 2;
                        setState(() {});
                        _pageController.jumpToPage(2);
                      }, onDoubleTap: () {}),
                      SizedBox(
                        width: 8,
                      ),
                    ])),
          ],
        ),
        body: ScrollConfiguration(
          behavior: RemoveGlow(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageView(
              controller: _pageController,
              children: [
                // Tab 1
                SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'السوق الموازي ',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Table Title
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF221400),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 0,
                                            color: Colors.white,
                                            offset: Offset(
                                              0,
                                              1,
                                            ),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              15, 3, 15, 3),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          'اسعار العملات مقابل الجنيه ',
                                                          style: TextStyle(
                                                            color:
                                                                Color(0xFFFEFFFF),
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          )),
                                                    ]),
                                              ),
                                              Expanded(
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(' لليوم $date',
                                                          style: TextStyle(
                                                            color:
                                                                Color(0xFFFEFFFF),
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          )),
                                                    ]),
                                              ),
                                            ],
                                          )),
                                    )),
                                // Table Body
                                material_row(
                                    context,
                                    'دولار امريكي / جنيه سوداني ',
                                    '10:40',
                                    '51372',
                                    '0.91%'),
                                rounded_material_row(
                                    context,
                                    'جنية مصري / جنيه سوداني ',
                                    '10:40',
                                    '51372.4',
                                    '0.90%'),
                                material_row(
                                    context,
                                    'ريال سعودي / جنيه سوداني ',
                                    '10:40',
                                    '37873',
                                    '0.90%'),
                                rounded_material_row(
                                    context,
                                    'ريال قطري / جنيه سوداني',
                                    '10:40',
                                    '65765',
                                    '0.90%'),
                                material_row(context, 'ريال عماني / جنيه سوداني  ',
                                    '10:40', '65757', '0.90%'),
                                rounded_material_row(
                                    context,
                                    'جنية استرليني / جنيه سوداني  ',
                                    '10:40',
                                    '67575',
                                    '0.90%'),
                                material_row(
                                    context,
                                    'ليرة تركية / جنيه سوداني ',
                                    '10:40',
                                    '6576576',
                                    '0.90%'),
                                rounded_material_row(
                                    context,
                                    'يورو / جنيه سوداني ',
                                    '10:40',
                                    '68768',
                                    '0.90%'),
                                material_row(context, 'درهم اماراتي / جنيه سوداني ', '10:40',
                                    '786868', '0.90%'),
                                rounded_material_row(
                                    context,
                                    'دينار كويتي / جنيه سوداني ',
                                    '10:40',
                                    '87676',
                                    '0.90%'),
                                material_row(
                                    context,
                                    'دينار بحريني / جنيه سوداني ',
                                    '10:40',
                                    '75757',
                                    '0.90%'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                // Tab 2
                SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' بنك الخرطوم ',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Table Title
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF221400),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 0,
                                            color: Colors.white,
                                            offset: Offset(
                                              0,
                                              1,
                                            ),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              15, 3, 15, 3),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          'اسعار العملات مقابل الجنيه ',
                                                          style: TextStyle(
                                                            color:
                                                            Color(0xFFFEFFFF),
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                            FontWeight.w800,
                                                          )),
                                                    ]),
                                              ),
                                              Expanded(
                                                child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: [
                                                      Text(' لليوم $date',
                                                          style: TextStyle(
                                                            color:
                                                            Color(0xFFFEFFFF),
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                            FontWeight.w800,
                                                          )),
                                                    ]),
                                              ),
                                            ],
                                          )),
                                    )),
                                // Table Body
                                material_row(
                                    context,
                                    'دولار امريكي / جنيه سوداني',
                                    '10:30',
                                    '50372',
                                    '0.90%'),
                                rounded_material_row(
                                    context,
                                    'جنية مصري / جنيه سوداني',
                                    '10:40',
                                    '51372.4',
                                    '0.90%'),
                                material_row(
                                    context,
                                    'ريال سعودي / جنيه سوداني ',
                                    '10:40',
                                    '37873',
                                    '0.90%'),
                                rounded_material_row(
                                    context,
                                    'ريال قطري / جنيه سوداني',
                                    '10:40',
                                    '65765',
                                    '0.90%'),
                                material_row(context, 'ريال عماني / جنيه سوداني',
                                    '10:40', '65757', '0.90%'),
                                rounded_material_row(
                                    context,
                                    'جنية استرليني / جنيه سوداني ',
                                    '10:40',
                                    '67575',
                                    '0.90%'),
                                material_row(
                                    context,
                                    'ليرة تركية / جنيه سوداني ',
                                    '10:40',
                                    '6576576',
                                    '0.90%'),
                                rounded_material_row(
                                    context,
                                    'يورو / جنيه سوداني ',
                                    '10:40',
                                    '68768',
                                    '0.90%'),
                                material_row(context, 'درهم اماراتي / جنيه سوداني', '10:40',
                                    '786868', '0.90%'),
                                rounded_material_row(
                                    context,
                                    'دينار كويتي / جنيه سوداني ',
                                    '10:40',
                                    '87676',
                                    '0.90%'),
                                material_row(
                                    context,
                                    'دينار بحريني / جنيه سوداني ',
                                    '10:40',
                                    '75757',
                                    '0.90%'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                // Tab 3
                SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' بنك الفيصل ',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Table Title
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF221400),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 0,
                                            color: Colors.white,
                                            offset: Offset(
                                              0,
                                              1,
                                            ),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              15, 3, 15, 3),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          'اسعار العملات مقابل الجنيه ',
                                                          style: TextStyle(
                                                            color:
                                                            Color(0xFFFEFFFF),
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                            FontWeight.w800,
                                                          )),
                                                    ]),
                                              ),
                                              Expanded(
                                                child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: [
                                                      Text(' لليوم $date',
                                                          style: TextStyle(
                                                            color:
                                                            Color(0xFFFEFFFF),
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                            FontWeight.w800,
                                                          )),
                                                    ]),
                                              ),
                                            ],
                                          )),
                                    )),
                                // Table Body
                                material_row(
                                    context,
                                    'دولار امريكي / جنيه سوداني',
                                    '10:30',
                                    '53372',
                                    '0.85%'),
                                rounded_material_row(
                                    context,
                                    'جنية مصري / جنيه سوداني',
                                    '10:40',
                                    '51372.4',
                                    '0.90%'),
                                material_row(
                                    context,
                                    'ريال سعودي / جنيه سوداني ',
                                    '10:40',
                                    '37873',
                                    '0.90%'),
                                rounded_material_row(
                                    context,
                                    'ريال قطري / جنيه سوداني ',
                                    '10:40',
                                    '65765',
                                    '0.90%'),
                                material_row(context, 'ريال عماني / جنيه سوداني',
                                    '10:40', '65757', '0.90%'),
                                rounded_material_row(
                                    context,
                                    'جنية استرليني / جنيه سوداني ',
                                    '10:40',
                                    '67575',
                                    '0.90%'),
                                material_row(
                                    context,
                                    'ليرة تركية / جنيه سوداني ',
                                    '10:40',
                                    '6576576',
                                    '0.90%'),
                                rounded_material_row(
                                    context,
                                    'يورو / جنيه سوداني ',
                                    '10:40',
                                    '68768',
                                    '0.90%'),
                                material_row(context, 'درهم اماراتي / جنيه سوداني ', '10:40',
                                    '786868', '0.90%'),
                                rounded_material_row(
                                    context,
                                    'دينار كويتي / جنيه سوداني ',
                                    '10:40',
                                    '87676',
                                    '0.90%'),
                                material_row(
                                    context,
                                    'دينار بحريني  / جنيه سوداني ',
                                    '10:40',
                                    '75757',
                                    '0.90%'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  Padding material_row(BuildContext context, String name, String time,
      String Value, String persent) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 13,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Row(mainAxisSize: MainAxisSize.max, children: [
                          Icon(
                            Icons.access_time,
                            color: Color(0xFF73B589),
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(time,
                              style: TextStyle(
                                color: Color(0xFF73B589),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              )),
                        ]),
                      ]),
                ),
                Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '',
                                  style: TextStyle(
                                    color: Color(0xFF73B589),
                                    fontSize: 13,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                  )),
                              TextSpan(
                                text: Value,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.arrow_circle_up,
                                color: Color(0xFF73B589),
                                size: 24,
                              ),
                              Text(persent,
                                  style: TextStyle(
                                    color: Color(0xFF73B589),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ]),
                      ]),
                ),
              ]),
        ),
      ),
    );
  }

  Container rounded_material_row(BuildContext context, String name, String time,
      String Value, String persent) {
    return Container(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 13,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Row(mainAxisSize: MainAxisSize.max, children: [
                            Icon(
                              Icons.access_time,
                              color: Color(0xFFDD1F36),
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(time,
                                style: TextStyle(
                                  color: Color(0xFFDD1F36),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ]),
                        ]),
                  ),
                  Expanded(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '',
                                    style: TextStyle(
                                      color: Color(0xFFDD1F36),
                                      fontSize: 13,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w800,
                                    )),
                                TextSpan(
                                  text: Value,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.arrow_circle_down,
                                  color: Color(0xFFDD1F36),
                                  size: 24,
                                ),
                                Text(persent,
                                    style: TextStyle(
                                      color: Color(0xFFDD1F36),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ]),
                        ]),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

Widget customTab(
  BuildContext context, {
  required bool isSelected,
  required String name,
  required Function() onTap,
  required Function() onDoubleTap,
}) {
  return GestureDetector(
    onTap: onTap,
    onDoubleTap: onDoubleTap,
    child: Container(
      constraints: const BoxConstraints(
        minWidth: 110,
      ),
      height: 50,
      decoration: BoxDecoration(
          color: (isSelected
              ? (context.color.mainGold)
              : Color.fromARGB(44, 124, 92, 92)),
          border: Border.all(
            color: isSelected
                ? Colors.black
                : Colors.transparent,
            width: isSelected  ? 1 : 1 ,
          ),
          borderRadius: BorderRadius.circular(11)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            name,
            color: isSelected
                ? Colors.black
                : context.color.textColorDark,
            fontSize: context.font.large,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
