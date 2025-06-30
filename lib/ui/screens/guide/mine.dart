import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<Mine> createState() => _PrivacyScreenWidgetState();

}

class _PrivacyScreenWidgetState extends State<Mine> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final videoUrl = "https://www.youtube.com/watch?v=avrkjlAQJR0";
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    } else {
      debugPrint("❌ فشل استخراج videoId من الرابط.");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ارشادات تشغيل المنجم"),
        backgroundColor: context.color.mainBrown,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "تشغيل المنجم: دليل شامل",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '''تشغيل المنجم هو عملية معقدة تتطلب تخطيطاً دقيقاً وتطبيقاً صارماً لإجراءات السلامة والصحة المهنية، فضلاً عن إدارة فعالة للموارد البشرية والتقنية. تبدأ العملية بدراسة جيولوجية تفصيلية لتحديد مواقع الخام وعمقه ونوعه. بعد ذلك، يتم وضع خطة استخراج تتضمن اختيار الأسلوب الأنسب سواء بالحفر السطحي أو العميق

في البداية، يتم تجهيز الموقع بفتح الطرق وتأمين المداخل والمخارج، وتوفير البنية التحتية الأساسية مثل الكهرباء والمياه والاتصالات. يجب تدريب العاملين على استخدام المعدات الثقيلة مثل الحفارات والناقلات والكسارات بطريقة آمنة وفعالة. كما تُجرى اختبارات دورية على جودة الهواء ومستوى الغبار داخل المنجم لضمان بيئة عمل آمنة.

تشمل العملية كذلك استخدام تقنيات حديثة مثل أجهزة الاستشعار والطائرات بدون طيار لمراقبة الإنتاج وكفاءة العمل. ويعدّ التحكم في المياه الجوفية وتصريفها من أهم التحديات، إذ يجب الحفر بطرق تمنع الانهيارات أو تسرب المياه إلى أماكن غير مرغوب بها.

بجانب ذلك، هناك أهمية كبيرة للرقابة البيئية، حيث يجب اتباع سياسات صارمة للتعامل مع المخلفات وتقليل التأثير البيئي للعملية، بما في ذلك إعادة تأهيل المنطقة بعد انتهاء التعدين.

وأخيراً، يتطلب تشغيل المنجم تنسيقاً يومياً بين الإدارات المختلفة: الإنتاج، الصيانة، الجودة، والسلامة. حيث تعتمد سلامة العمال وكفاءة الإنتاج على هذا التكامل الإداري. إن الاستثمار في التكنولوجيا والتدريب والتخطيط المستدام هو ما يضمن نجاح عمليات تشغيل المناجم على المدى الطويل.

بذلك نرى أن تشغيل المنجم ليس مجرد عملية استخراج معادن، بل هو سلسلة متكاملة من الأنشطة والإجراءات التي تتطلب دقة، التزام، ووعي بيئي ومجتمعي.''',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 24),
              const Text(
                "فيديو توضيحي:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _controller != null
                  ? YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
              )
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
