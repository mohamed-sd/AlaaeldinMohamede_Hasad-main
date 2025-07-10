import 'package:hasad/app/routes.dart';
import 'package:hasad/data/cubits/fetch_blogs_cubit.dart';
import 'package:hasad/data/model/blog_model.dart';
import 'package:hasad/ui/screens/widgets/errors/no_data_found.dart';
import 'package:hasad/ui/screens/widgets/errors/no_internet.dart';
import 'package:hasad/ui/screens/widgets/errors/something_went_wrong.dart';
import 'package:hasad/ui/screens/widgets/intertitial_ads_screen.dart';
import 'package:hasad/ui/screens/widgets/shimmerLoadingContainer.dart';
import 'package:hasad/ui/theme/theme.dart';
import 'package:hasad/utils/api.dart';
import 'package:hasad/utils/custom_text.dart';
import 'package:hasad/utils/extensions/extensions.dart';
import 'package:hasad/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return const BlogsScreen();
      },
    );
  }

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  final ScrollController _pageScrollController = ScrollController();

  @override
  void initState() {
    AdHelper.loadInterstitialAd();
    if (context.read<FetchBlogsCubit>().state is! FetchBlogsSuccess) {
      context.read<FetchBlogsCubit>().fetchBlogs();
    }
    _pageScrollController.addListener(pageScrollListen);
    super.initState();
  }

  void pageScrollListen() {
    if (_pageScrollController.isEndReached()) {
      if (context.read<FetchBlogsCubit>().hasMoreData()) {
        context.read<FetchBlogsCubit>().fetchBlogsMore();
      }
    }
  }

  @override
  void dispose() {
    _pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdHelper.showInterstitialAd();
    return SafeArea(
      top: false,
      child: RefreshIndicator(
        color: context.color.territoryColor,
        onRefresh: () async {
          context.read<FetchBlogsCubit>().fetchBlogs();
        },
        child: Scaffold(
          backgroundColor: context.color.mainColor,
          appBar: UiUtils.buildAppBar(context,
              showBackButton: true, backgroundColor: Colors.white),
          body: BlocBuilder<FetchBlogsCubit, FetchBlogsState>(
            builder: (context, state) {
              if (state is FetchBlogsInProgress) {
                return buildBlogsShimmer();
              }
              if (state is FetchBlogsFailure) {
                if (state.errorMessage is ApiException) {
                  if (state.errorMessage.error == "no-internet") {
                    return NoInternet(
                      onRetry: () {
                        context.read<FetchBlogsCubit>().fetchBlogs();
                      },
                    );
                  }
                }
                return const SomethingWentWrong();
              }
              if (state is FetchBlogsSuccess) {
                if (state.blogModel.isEmpty) {
                  return const NoDataFound();
                }
                return SingleChildScrollView(
                  child: Stack(
                    // mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1580128660010-fd027e1e587a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHx0cnVtcHxlbnwwfHx8fDE3MzM0MDMxNTJ8MA&ixlib=rb-4.0.3&q=80&w=1080',
                          width: double.infinity,
                          height: 400,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 250, 0, 0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context.color.mainGold,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              10, 3, 10, 3),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                  'وفد امريكي في السودان',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context.color.mainGold,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              10, 3, 10, 3),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'لبحث إستخدام التكنلوجيا',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context.color.mainGold,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              10, 3, 10, 3),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'بمجالات التعدين',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                                controller: _pageScrollController,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                itemCount: state.blogModel.length,
                                itemBuilder: (context, index) {
                                  BlogModel blog = state.blogModel[index];
                                  return buildBlogCard(context, blog);
                                  // return blog(state, index);
                                }),
                          ],
                        ),
                      ),
                      if (state.isLoadingMore) const CircularProgressIndicator(),
                      if (state.loadingMoreError)
                        CustomText("somethingWentWrng".translate(context))
                    ],
                  ),
                );

              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget buildBlogCard(BuildContext context, BlogModel blog) {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.blogDetailsScreenRoute,
              arguments: {
                "model": blog,
              },
            );
          },
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(mainAxisSize: MainAxisSize.max, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            blog.image!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: context.color.mainGold,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                10, 3, 10, 3),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            'اخبار الاقتصاد',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ])))),
                                        Expanded(
                                            child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: context.color.mainGold,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(10, 3, 10, 3),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  1, 0),
                                                          child: Text(
                                                            blog.createdAt
                                                                .toString()
                                                                .substring(
                                                                    0, 10),
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ]))),
                                        )),
                                      ]),
                                  Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(blog.title.toString(),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                                blog.description
                                                            .toString()
                                                            .length <
                                                        200
                                                    ? stripHtmlTags(blog
                                                        .description
                                                        .toString())
                                                    : stripHtmlTags(blog
                                                        .description
                                                        .toString()
                                                        .substring(0, 200)),
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                        ),
                                        Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: context
                                                            .color.mainGold,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(10,
                                                                      3, 10, 3),
                                                          child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  '64',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .favorite_border,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15,
                                                                ),
                                                              ])))),
                                              Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: context
                                                            .color.mainGold,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(10,
                                                                      3, 10, 3),
                                                          child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  '24',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Icon(
                                                                  Icons.message,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15,
                                                                ),
                                                              ])))),
                                              Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: context
                                                            .color.mainGold,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(10,
                                                                      3, 10, 3),
                                                          child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  blog.views
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15,
                                                                ),
                                                              ])))),
                                            ]),
                                      ]),
                                ]),
                          ),
                        ),
                      ]),
                    ],
                  ))),
        ));
  }

  String stripHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String strippedString = htmlString.replaceAll(exp, '');
    return strippedString;
  }

  Widget buildBlogsShimmer() {
    return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                height: 287,
                decoration: BoxDecoration(
                    color: context.color.secondaryColor,
                    border: Border.all(
                        width: 1.5, color: context.color.borderColor)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmer(
                      width: double.infinity,
                      height: 160,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomShimmer(
                        width: 100,
                        height: 10,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomShimmer(
                        width: 160,
                        height: 10,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomShimmer(
                        width: 150,
                        height: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
