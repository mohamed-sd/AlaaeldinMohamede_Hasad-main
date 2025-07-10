import 'package:hasad/ui/theme/theme.dart';
import 'package:hasad/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class Detailes extends StatelessWidget {
  final String title;
  final String flag ;
  const Detailes({Key? key , required this.title , required this.flag }) : super(key: key);

  /// هذا هو الراوت الذي تستدعيه من راوتر خارجي
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>;

    return MaterialPageRoute(
      builder: (_) => Detailes(
        title: args['title'] ?? '',
        flag: args['flag'] ?? '',
      ),
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: context.color.mainGold,
        appBar: AppBar(
          backgroundColor: context.color.mainGold,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: context.color.mainBrown,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(),
            child: Column(
              children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(15, 10, 10, 10),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                                decoration: BoxDecoration(
                                  color: context.color.mainGold,
                                  borderRadius: BorderRadiusDirectional.circular(15),
                                ),
                                child: Text(title , style: TextStyle(
                                  fontWeight: FontWeight.w700
                                ),textAlign: TextAlign.center,),
                              ),
                              Column(
                                children: [


                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                    margin: const EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadiusDirectional.circular(15),
                                    ),
                                    child:  Text(
                                           flag                ,

                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),







                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
