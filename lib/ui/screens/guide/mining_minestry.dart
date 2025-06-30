import 'package:eClassify/app/routes.dart';
import 'package:eClassify/ui/screens/guide/detailes.dart';
import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class Mining_minestry extends StatelessWidget {
  final String title;
  final String flag ;
  const Mining_minestry({Key? key , required this.title , required this.flag }) : super(key: key);

  /// هذا هو الراوت الذي تستدعيه من راوتر خارجي
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>;

    return MaterialPageRoute(
      builder: (_) => Mining_minestry(
        title: args['title'] ?? '',
        flag: args['flag'] ?? '',
      ),
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context ) {
    return Scaffold(
      backgroundColor: context.color.mainColor,
      appBar: AppBar(
        backgroundColor: context.color.mainBrown,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListView(
            children: [
              // the title
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: context.color.mainGold,
                      borderRadius: BorderRadiusDirectional.circular(15)),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ),

              // Container
              Padding(
                padding: EdgeInsets.all(10),
                child: Material(
                  color: Colors.transparent,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: 365,
                        height: 143,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/miningmarket-firebase.appspot.com/o/enjaz%2F%D8%A5%D8%AF%D8%A7%D8%B1%D8%A9%20%D8%A7%D9%84%D8%B7%D9%84%D8%A8%D8%A7%D8%AA.png?alt=media&token=cde6bd1b-f856-4d00-b418-437ea6e9dbd7',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
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

              Padding(
                padding: EdgeInsets.all(10),
                child: Material(
                  color: Colors.transparent,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (flag == "1") ...[
                                the_title('استقبال وتسجيل طلبات العملاء'),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'استقبال الطلبات عبر القنوات المختلفة',
                                          'flag':  '''
 •	استقبال الطلبات عبر الهاتف والبريد الإلكتروني وتسجيل تفاصيل العميل وبياناته الأساسية، وتشمل:
 
o	اسم العميل.
o	اسم الشركة.
o	تفاصيل الاتصال (هاتف، بريد إلكتروني).
o	نوع المعدات المطلوبة.
o	الكمية المطلوبة.
o	تاريخ ومدة الاستخدام.
•	مراجعة الطلبات الواردة عبر الأنظمة الإلكترونية.

السياسات:

•	يجب الرد على الطلبات الواردة خلال 15 دقيقة.
•	يلزم استخدام Chatbot للتعامل مع 80% من الاستفسارات الشائعة.
•	يجب تسهيل وصول العملاء لخدمات الشركة عبر عدة قنوات مختلفة، تشمل:
o	تطبيق الجوال.
o	نظام ذكاء اصطناعي (Chatbot) للرد السريع.
o	خدمة العملاء عبر الهاتف.
o	البريد الإلكتروني.

•	يجب إعلام العميل بموعد معالجة طلبه.
•	يلزم إخطار العميل بأي تحديثات يمكن أن تحدث خلال العملية.

                               
                                           '''                    ,

                                        },
                                      );
                                    },
                                    child: light_row(context, 'استقبال الطلبات عبر القنوات المختلفة')),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تسجيل بيانات الطلب في نظام إدارة الطلبات',
                                          'flag':  ''' 
  •	التأكد من تسجيل كافة البيانات الأساسية التالية:
  
o	اسم العميل.
o	اسم الشركة.
o	تفاصيل الاتصال (هاتف، بريد إلكتروني).
o	نوع المعدات المطلوبة.
o	الكمية المطلوبة.
o	تاريخ ومدة الاستخدام.

السياسات:
•	يلزم مراجعة البيانات الأساسية للعميل من قبل موظف آخر وتأكيد تسجيلها بالصورة المطلوبة.
•	يجب تسجيل الطلب في النظام خلال فترة زمنية محددة (30 دقيقة من استلامه).
•	يجب الحفاظ على سرية بيانات العميل وعدم مشاركتها مع أطراف خارجية دون موافقة.
•	يجب توثيق كل طلب بشكل كامل، بما في ذلك:
o	تاريخ الاستلام.
o	الموظف المسؤول.
o	حالة الطلب.

                                        
                                        ''',
                                        },
                                      );
                                    },
                                    child: Dark_row(context, 'تسجيل بيانات الطلب في نظام إدارة الطلبات')),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'إرسال تأكيد أولي للعميل',
                                          'flag':
                                          ''' 
 •	مراجعة البيانات المدخلة في نظام إدارة الطلبات للتأكد من اكتمالها ودقتها.
•	إنشاء رسالة تأكيد موحدة تحتوي على:
o	رقم الطلب المرجعي.
o	ملخص المعدات المطلوبة.
o	موعد الرد المتوقع بشأن توفر المعدات.

السياسات:
•	يلزم إرسال التأكيد الأولي خلال ساعة من استلام الطلب.
•	في حال حدوث تعديل على الطلب بعد تأكيد الاستلام، يجب إبلاغ العميل بشكل واضح بالتغيير.

                                        
                                        ''',
                                        },
                                      );
                                    },
                                    child: light_row(context, 'إرسال تأكيد أولي للعميل')),
                              ],
                              if (flag == "2") ...[
                                the_title('التحقق من توفر المعدات'),
                                InkWell(
                                    onTap: () {

                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'مراجعة نظام إدارة المعدات للتأكد من مدى توفر المعدات',
                                          'flag':
                                          ''' 
•	البحث عن المعدات المطلوبة في سجلات النظام
•	التأكد من حالة المعدة المطلوبة (جاهزة للعمل، تحتاج صيانة، مستأجرة)

السياسات:
•	يلزم مراجعة حالة المعدات وتوافرها بشكل دوري مرة واحدة على الأقل شهريًا
•	يجب توثيق أي ملاحظات أو مشاكل في السجل الخاص بكل قطعة

                                        
                                        ''',
                                        },
                                      );
                                    },
                                    child: light_row(context, 'مراجعة نظام إدارة المعدات للتأكد من مدى توفر المعدات')),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'التواصل مع فريق الصيانة أو التشغيل عند الحاجة للتأكد من جاهزية المعدة',
                                          'flag':
                                          ''' 
•	التحقق من جدول الصيانة الدورية
•	طلب تقرير جاهزية المعدات من الفريق المختص

السياسات:
•	يجب قبل بدء أي عمليات إنتاج أو استخدام المعدات، أن يقوم مشرف التشغيل أو المدير المعني بالتأكد من أن المعدات جاهزة للاستخدام

                                        
                                        ''',
                                        },
                                      );
                                    },
                                    child: Dark_row(context, 'التواصل مع فريق الصيانة أو التشغيل عند الحاجة للتأكد من جاهزية المعدة')),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تحديث حالة الطلب بناءً على التوافر',
                                          'flag':
                                          ''' 
الخطوات:
•	متوفر بالكامل: الانتقال إلى عملية الجدولة
•	غير متوفر جزئيًا/كليًا: تقديم تقرير للعميل يتضمن الخيارات البديلة

السياسات:
•	يجب التأكد من أن المعدات والموارد المطلوبة متوفرة في المخزون
•	يلزم مراجعة المعدات في حال كانت جزءاً من عملية إنتاجية تحتاج إلى قطع غيار أو مواد  
                                        
                                        ''',
                                        },
                                      );
                                    },
                                    child: light_row(context, 'تحديث حالة الطلب بناءً على التوافر')),
                              ],
                              if (flag == "3") ...[
                                the_title('تسعير الخدمات'),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'جمع بيانات الطلب',
                                          'flag':
                                          ''' 
•	مراجعة نموذج الطلب
•	التواصل مع العميل لاستكمال النقص (إن وجد)

السياسات:
•	يُمنع تقديم عرض سعر دون اكتمال البيانات
•	يجب الرد على استفسارات العميل خلال ساعة

                                        ''',
                                        },
                                      );
                                    },
                                    child: Dark_row(context, 'جمع بيانات الطلب')),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تحليل التكاليف',
                                          'flag':
                                          ''' 
•	حساب تكاليف التشغيل (وقود، صيانة، إهلاك)
•	مراجعة أسعار السوق

السياسات:
•	يُطبق هامش ربح لا يقل عن 20% إلا بموافقة مدير المبيعات

                                        
                                        ''',
                                        },
                                      );
                                    },
                                    child: light_row(context, 'تحليل التكاليف')),
                                InkWell(
                                    onTap: () {

                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تحديد السعر النهائي',
                                          'flag':
                                          ''' 
•	تطبيق خصومات للعملاء المميزين
•	إدراج بنود إضافية (تأمين، مشغل)

السياسات:
•	يُمنع تغيير السعر بعد إرسال العرض إلا بموافقة العميل

                                        
                                        ''',
                                        },
                                      );
                                    },
                                    child: Dark_row(context, 'تحديد السعر النهائي')),
                                InkWell(
                                    onTap: () {

                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'إرسال العرض للعميل',
                                          'flag':
                                          ''' 
•	إعداد عرض مكتوب (PDF/Email)
•	إرفاق شروط وأحكام التأجير

السياسات:
•	يُرسل العرض خلال 4 ساعات عمل كحد أقصى

                                        
                                        ''',
                                        },
                                      );
                                    },
                                    child: light_row(context, 'إرسال العرض للعميل')),
                              ],
                              if (flag == "4") ...[
                                the_title('جدولة المعدات'),
                                InkWell(
                                    onTap: () {},
                                    child: Dark_row(context, 'إعداد جدول زمني لتخصيص المعدات المطلوبة')),
                                InkWell(
                                    onTap: () {},
                                    child: light_row(context, 'التحقق من عدم وجود تضارب في الجدولة مع طلبات أخرى')),
                                InkWell(
                                    onTap: () {},
                                    child: Dark_row(context, 'التواصل مع العميل لتأكيد الجدول الزمني')),
                                InkWell(
                                    onTap: () {},
                                    child: light_row(context, 'تحديث نظام إدارة الطلبات بحالة الطلب')),
                              ],
                              if (flag == "5") ...[
                                the_title('إعداد العقود ومراجعتها'),
                                InkWell(
                                    onTap: () {},
                                    child: Dark_row(context, 'إعداد مسودة العقد')),
                                InkWell(
                                    onTap: () {},
                                    child: light_row(context, 'مراجعة العقد داخلياً')),
                                InkWell(
                                    onTap: () {},
                                    child: Dark_row(context, 'إرسال العقد للعميل للمراجعة')),
                                InkWell(
                                    onTap: () {},
                                    child: light_row(context, 'التفاوض على بنود العقد (إذا لزم الأمر)')),
                                InkWell(
                                    onTap: () {},
                                    child: Dark_row(context, 'إعداد النسخة النهائية من العقد')),
                              ],
                              if (flag == "6") ...[
                                the_title('توقيع العقود'),
                                InkWell(
                                    onTap: () {},
                                    child: Dark_row(context, 'تحديد موعد لتوقيع العقد')),
                                InkWell(
                                    onTap: () {},
                                    child: light_row(context, 'توقيع العقد')),
                                InkWell(
                                    onTap: () {},
                                    child: Dark_row(context, 'تسليم نسخة من العقد للعميل')),
                                InkWell(
                                    onTap: () {},
                                    child: light_row(context, 'تحديث نظام إدارة العقود')),
                              ],
                              if (flag == "7") ...[
                                the_title('إدارة تعديلات العقود'),
                                InkWell(
                                    onTap: () {},
                                    child: Dark_row(context, 'استلام طلب التعديل')),
                                InkWell(
                                    onTap: () {},
                                    child: light_row(context, 'تقييم طلب التعديل')),
                                InkWell(
                                    onTap: () {},
                                    child: Dark_row(context, 'الموافقة على التعديل أو رفضه')),
                                InkWell(
                                    onTap: () {},
                                    child: light_row(context, 'إعداد ملحق التعديل')),
                                InkWell(
                                    onTap: () {},
                                    child: Dark_row(context, 'توقيع ملحق التعديل')),
                                InkWell(
                                    onTap: () {},
                                    child: light_row(context, 'تحديث نظام إدارة العقود')),
                              ],



                              if (flag == "11") ...[
                                the_title(' فحص المعدات قبل التسليم'),
                                InkWell(
                                    onTap: () {

                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'إجراء الفحص الميكانيكي الشامل',
                                          'flag':
                                          ''' 
•	فحص المحرك وأنظمة التشغيل.
•	فحص أنظمة الهيدروليك.
•	فحص أنظمة النقل والحركة.
•	فحص أنظمة الفرامل والتوجيه.

السياسات:
•	يجب إجراء الفحص الميكانيكي من قبل فني مؤهل.
•	يجب استخدام قائمة الفحص المعتمدة لكل نوع من المعدات.
•	يجب توثيق نتائج الفحص في نظام إدارة الصيانة.

                                        ''',
                                        },
                                      );
                                    },
                                    child: Dark_row(context, ' إجراء الفحص الميكانيكي الشامل')),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'فحص أنظمة السلامة',
                                          'flag':
                                          ''' 
•	فحص أنظمة الإنذار والتحذير.
•	فحص طفايات الحريق.
•	فحص أحزمة الأمان وأنظمة الحماية.
•	فحص الإضاءة وأنظمة الرؤية.
السياسات:
•	يجب التأكد من سلامة وفعالية جميع أنظمة السلامة قبل التسليم.
•	يُمنع تسليم أي معدة لا تستوفي معايير السلامة الأساسية.
•	يجب إصلاح أي خلل في أنظمة السلامة قبل التسليم.


                                        ''',
                                        },
                                      );

                                    },
                                    child: light_row(context, 'فحص أنظمة السلامة')),

                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'فحص الهيكل الخارجي والداخلي',
                                          'flag':
                                          ''' 
•	فحص الهيكل الخارجي للتأكد من عدم وجود أضرار.
•	فحص المقصورة الداخلية وأدوات التحكم.
•	فحص الإطارات أو السلاسل.
•	توثيق أي خدوش أو أضرار موجودة مسبقاً.
السياسات:
•	يجب توثيق حالة المعدة بالصور قبل التسليم.
•	يجب إصلاح أي أضرار تؤثر على أداء المعدة قبل التسليم.
•	يجب توثيق الأضرار الخارجية الموجودة مسبقاً في نموذج التسليم.


                                        ''',
                                        },
                                      );
                                    },
                                    child: Dark_row(context, 'فحص الهيكل الخارجي والداخلي')),

                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'إعداد تقرير حالة المعدة',
                                          'flag':
                                          ''' 
•	تعبئة نموذج فحص ما قبل التسليم.
•	تحديد أي متطلبات صيانة عاجلة.
•	تقييم الجاهزية العامة للمعدة.
السياسات:
•	يجب توقيع تقرير الفحص من قبل الفني المسؤول ومشرف الصيانة.
•	يجب الاحتفاظ بنسخة من التقرير في ملف المعدة وإرفاق نسخة مع وثائق التسليم.
•	يجب تحديث حالة المعدة في نظام إدارة المعدات.


                                        ''',
                                        },
                                      );
                                    },
                                    child: light_row(context, 'إعداد تقرير حالة المعدة')),


                              ],

                              if (flag == "12") ...[
                                the_title('تعبئة الوقود وتجهيز المعدات'),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تعبئة الوقود والزيوت',
                                          'flag':
                                          ''' 
• تعبئة خزان الوقود بالكمية المناسبة.
• فحص مستويات الزيوت والسوائل وإضافتها عند الحاجة.
• فحص مستوى سائل التبريد.
السياسات:
• يجب تسليم المعدات مع خزان وقود ممتلئ بنسبة لا تقل عن 75%.
• يجب استخدام أنواع الوقود والزيوت المحددة في دليل المصنع.
• يجب توثيق كميات الوقود والزيوت المضافة في سجل المعدة.


                                        ''',
                                        },
                                      );
                                    },
                                    child: Dark_row(context, 'تعبئة الوقود والزيوت')),

                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تنظيف المعدة',
                                          'flag':
                                          ''' 
الخطوات:
• تنظيف الهيكل الخارجي.
• تنظيف المقصورة الداخلية.
• تنظيف الزجاج والمرايا.

السياسات:
• يجب تسليم المعدات في حالة نظيفة تعكس صورة الشركة الاحترافية.
• يجب استخدام مواد التنظيف المناسبة لكل جزء من المعدة.
• يجب التأكد من إزالة أي مخلفات أو أوساخ قد تؤثر على أداء المعدة.


                                        ''',
                                        },
                                      );
                                    },
                                    child: light_row(context, 'تنظيف المعدة')),

                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تركيب الملحقات والمعدات الإضافية',
                                          'flag':
                                          ''' 
الخطوات:
• تركيب الملحقات المطلوبة حسب العقد.
• فحص توافق الملحقات مع المعدة الرئيسية.
• اختبار عمل الملحقات.
السياسات:
• يجب التأكد من أن جميع الملحقات متوافقة مع المعدة الرئيسية.
• يجب فحص واختبار الملحقات قبل التركيب.
• يجب توثيق جميع الملحقات المركبة في نموذج التسليم.


                                        ''',
                                        },
                                      );
                                    },
                                    child: Dark_row(context, 'تركيب الملحقات والمعدات الإضافية')),

                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تجهيز قطع الغيار الأساسية',
                                          'flag':
                                          ''' 
الخطوات:
• تجهيز مجموعة قطع الغيار الأساسية حسب العقد.
• التأكد من سلامة وجودة قطع الغيار.
• إعداد قائمة بقطع الغيار المسلمة.

السياسات:
• يجب تسليم قطع الغيار الأساسية المتفق عليها في العقد.
• يجب توثيق جميع قطع الغيار المسلمة في نموذج التسليم.
• يجب تغليف وتخزين قطع الغيار بشكل مناسب لمنع التلف.


                                        ''',
                                        },
                                      );
                                    },
                                    child: light_row(context, 'تجهيز قطع الغيار الأساسية')),
                              ],

                              if (flag == "13") ...[
                                the_title('تجهيز وثائق التسليم'),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'إعداد نموذج تسليم المعدات',
                                          'flag':
                                          ''' 
الخطوات:
• تعبئة بيانات المعدة (الرقم التسلسلي، الموديل، إلخ).
• تعبئة بيانات العميل والمشروع.
• تحديد تاريخ ووقت التسليم.

السياسات:
• يجب استخدام نموذج التسليم المعتمد من الشركة.
• يجب تعبئة جميع الحقول الإلزامية في النموذج.
• يجب مراجعة النموذج من قبل مشرف العمليات قبل التسليم.


                                        ''',
                                        },
                                      );

                                    },
                                    child: Dark_row(context, 'إعداد نموذج تسليم المعدات')),

                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تجهيز دليل المشغل',
                                          'flag':
                                          ''' 
الخطوات:
• التأكد من توفر دليل المشغل الخاص بالمعدة.
• ترجمة الدليل إلى اللغة المناسبة إذا لزم الأمر.
• إضافة أي تعليمات خاصة بالشركة.

السياسات:
• يجب تسليم دليل المشغل مع كل معدة.
• يجب أن يكون الدليل باللغة التي يفهمها المشغل.
• يجب تحديث الدليل بأي تعديلات أو إضافات تمت على المعدة.


                                        ''',
                                        },
                                      );
                                    },
                                    child: light_row(context, 'تجهيز دليل المشغل')),

                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تجهيز شهادات الفحص والصيانة',
                                          'flag':
                                          ''' 
الخطوات:
• إرفاق شهادة الفحص الفني.
• إرفاق سجل الصيانة الدورية.
• إرفاق شهادات المعايرة إذا لزم الأمر.

السياسات:
• يجب أن تكون جميع الشهادات سارية المفعول.
• يجب توقيع الشهادات من قبل الأشخاص المخولين.
• يجب الاحتفاظ بنسخة من جميع الشهادات في ملف المعدة.
________________________________________


                                        ''',
                                        },
                                      );
                                    },
                                    child: Dark_row(context, 'تجهيز شهادات الفحص والصيانة')),

                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.detailes,
                                        arguments: {
                                          'title': 'تجهيز قائمة الفحص اليومي',
                                          'flag':
                                          ''' 
الخطوات:
• إعداد قائمة الفحص اليومي للمعدة.
• شرح بنود القائمة للعميل أو المشغل.
• توفير نسخ كافية من القائمة.

السياسات:
• يجب تسليم قائمة الفحص اليومي مع كل معدة.
• يجب شرح أهمية الفحص اليومي للعميل أو المشغل.
• يجب متابعة التزام العميل أو المشغل بإجراء الفحص اليومي.


                                        ''',
                                        },
                                      );
                                    },
                                    child: light_row(context, 'تجهيز قائمة الفحص اليومي')),

                              ],

                            ],
                          ),
                        ),

                      ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.color.mainGold,
                  borderRadius: BorderRadiusDirectional.circular(18),
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.link , size: 30, ),
                    SizedBox(width: 10,),
                    Text('زيارة الموقع الرسمي' , style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800
                    ),)
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Align the_title(String title) {
    return Align(
      alignment: AlignmentDirectional(-1, 0),
      child: Padding(
        padding: EdgeInsets.only(right: 5, left: 5, bottom: 5, top: 10),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Padding light_row( BuildContext context , String title) {
    return Padding(
      padding: EdgeInsets.all(5),
        child:
        Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color.fromARGB(184, 220, 219, 218),
                width: 1,
              ),
            ),
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 15,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ))),
    );
  }

  Padding Dark_row(BuildContext context , String title) {
    return Padding(
      padding: EdgeInsets.all(5),
        child:
        Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(184, 220, 219, 218),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color.fromARGB(184, 220, 219, 218),
                width: 0.5,
              ),
            ),
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 15,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ))),
    );
  }
}
