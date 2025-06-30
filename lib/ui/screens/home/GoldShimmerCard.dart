import 'dart:math';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:eClassify/utils/ui_utils.dart';

class GoldShimmerCard extends StatefulWidget {
  final String title;
  final String url;

  const GoldShimmerCard({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  _GoldShimmerCardState createState() => _GoldShimmerCardState();
}

class _GoldShimmerCardState extends State<GoldShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool animationEnded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // أطول شويه ليظهر اللمعان بوضوح
      vsync: this,
    );

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animationEnded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shimmerColor = const Color(0xFFF6E27F); // لون ذهبي فاتح ولمّاع

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final image = UiUtils.imageType("https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/enjaz-apk7iy/assets/nobgwtm6rjei/12-_%D8%A7%D9%84%D8%B9%D9%82%D9%88%D8%AF%D8%A7%D8%AA_%D8%A7%D9%84%D8%AF%D8%A7%D8%AE%D9%84%D9%8A%D8%A9.jpg", fit: BoxFit.cover);

        if (animationEnded) {
          return _buildCard(image); // بعد انتهاء اللمعة، فقط الصورة
        }

        return _buildCard(
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(_animation.value - 0.5, -1),
                end: Alignment(_animation.value + 0.5, 1),
                colors: [
                  Colors.transparent,
                  shimmerColor.withOpacity(0.7),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: image,
          ),
        );
      },
    );
  }

  Widget _buildCard(Widget image) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(child: image),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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
              child: Text(
                 widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: context.font.smaller,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
