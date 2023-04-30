import 'package:flutter/material.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {

  List json = [
    {
      'title':'المعلومات التي نجمعها منك',
      'body':'للحصول على تجربة أفضل ، أثناء استخدام خدمتنا ، قد نطلب منك تزويدنا بمعلومات تعريف شخصية معينة ، بما في ذلك كتابة وقراءة وحدة التخزين الخارجية. سيتم الاحتفاظ بالمعلومات التي نطلبها من قبلنا واستخدامها كما هو موضح في سياسة الخصوصية هذه. يستخدم التطبيق خدمات الجهات الخارجية التي قد تجمع المعلومات المستخدمة لتحديد هويتك. رابط لسياسة الخصوصية لمقدمي خدمات الطرف الثالث التي يستخدمها التطبيق',
      'links':[
        'Google Play Services',
        'Google Analytics for Firebase'
      ]
    },
    {
      'title':'تسجيل البيانات',
      'body':'للحصول على تجربة أفضل ، أثناء استخدام خدمتنا ، قد نطلب منك تزويدنا بمعلومات تعريف شخصية معينة ، بما في ذلك كتابة وقراءة وحدة التخزين الخارجية. سيتم الاحتفاظ بالمعلومات التي نطلبها من قبلنا واستخدامها كما هو موضح في سياسة الخصوصية هذه. يستخدم التطبيق خدمات الجهات الخارجية التي قد تجمع المعلومات المستخدمة لتحديد هويتك. رابط لسياسة الخصوصية لمقدمي خدمات الطرف الثالث التي يستخدمها التطبيق',
    },
    {
      'title':'Cookies',
      'body':'ملفات تعريف الارتباط هي ملفات تحتوي على كمية صغيرة من البيانات التي يتم استخدامها بشكل شائع كمعرفات فريدة مجهولة الهوية. يتم إرسالها إلى متصفحك من مواقع الويب التي تزورها ويتم تخزينها على الذاكرة الداخلية لجهازك لا تستخدم هذه الخدمة "ملفات تعريف الارتباط" بشكل صريح. ومع ذلك ، قد يستخدم التطبيق رموزًا ومكتبات خاصة بطرف ثالث تستخدم "ملفات تعريف الارتباط" لجمع المعلومات وتحسين خدماتهم. لديك خيار إما قبول أو رفض ملفات تعريف الارتباط هذه ومعرفة متى يتم إرسال ملف تعريف الارتباط إلى جهازك. إذا اخترت رفض ملفات تعريف الارتباط الخاصة بنا ، فقد لا تتمكن من استخدام بعض أجزاء هذه الخدمة',
    },
    {
      'title':'مقدمي الخدمة',
      'body':'يجوز لنا توظيف شركات وأفراد تابعين لجهات خارجية للأسباب التالية:',
      'services':[
        'لتسهيل خدمتنا',
        'لتقديم الخدمة نيابة عنا',
        'لأداء الخدمات ذات الصلة بالخدمة أو',
        'لمساعدتنا في تحليل كيفية استخدام خدمتنا.'
      ]
    },
    {
      'title':'حماية',
      'body':'نحن نقدر ثقتك في تزويدنا بمعلوماتك الشخصية ، وبالتالي فإننا نسعى جاهدين لاستخدام وسائل مقبولة تجاريًا لحمايتها. لكن تذكر أنه لا توجد طريقة نقل عبر الإنترنت أو طريقة تخزين إلكتروني آمنة وموثوقة بنسبة 100٪ ، ولا يمكننا ضمان أمانها المطلق',
    },
    {
      'title':'روابط لمواقع أخرى',
      'body':'قد تحتوي هذه الخدمة على روابط لمواقع أخرى. إذا قمت بالنقر فوق ارتباط جهة خارجية ، فسيتم توجيهك إلى هذا الموقع. لاحظ أن هذه المواقع الخارجية لا يتم تشغيلها بواسطتنا. لذلك ، ننصحك بشدة بمراجعة سياسة الخصوصية الخاصة بهذه المواقع. ليس لدينا أي سيطرة ولا نتحمل أي مسؤولية عن المحتوى أو سياسات الخصوصية أو الممارسات الخاصة بأي مواقع أو خدمات تابعة لجهات خارجية.'
    },
    {
      'title':'خصوصية الأطفال',
      'body':'لا تتعامل هذه الخدمات مع أي شخص يقل عمره عن 18 عامًا. نحن لا نجمع عن قصد معلومات تعريف شخصية من الأطفال الذين تقل أعمارهم عن 18 عامًا. في حالة اكتشافنا أن طفلًا أقل من 18 عامًا قد زودنا بمعلومات شخصية ، فإننا نحذفها على الفور من خوادمنا. إذا كنت والدًا أو وصيًا وكنت تعلم أن طفلك قد زودنا بمعلومات شخصية ، فيرجى الاتصال بنا حتى نتمكن من القيام بالإجراءات اللازمة.'
    },
    {
      'title':'التغييرات على سياسة الخصوصية الخاصة بنا',
      'body':'سيتم نشر أي تغييرات تطرأ على سياسة الخصوصية الخاصة بنا على موقع الويب ، وعند الاقتضاء ، من خلال إشعار عبر البريد الإلكتروني.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'سياسة الخصوصية',
          style: TextStyle(
              fontSize: 17,
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 12,top: 12),
                child: Text('سياسة خصوصية Canari',style: TextStyle(
                  color: AppColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),),
              ),
             ListView.builder(
               physics:NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 itemCount: json.length,
                 itemBuilder: (context,index){
               return Padding(
                 padding: const EdgeInsets.only(left: 20,right: 20,bottom: 12,top: 12),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Text('${json[index]['title']}',style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 16
                     ),),
                     height(12),
                     Text('${json[index]['body']}'),

                     if(json[index]['links']!=null)

                     Padding(
                       padding: const EdgeInsets.only(top: 10,bottom: 5),
                       child: Text('- ${json[index]['links'][0]}',style: TextStyle(
                           fontWeight: FontWeight.w300,
                           color: Colors.blue,
                           decoration: TextDecoration.underline
                       ),),
                     ),
                     height(0),
                     if(json[index]['links']!=null)
                     Padding(
                       padding: const EdgeInsets.only(top: 0,bottom: 5),
                       child: Text('- ${json[index]['links'][1]}',style: TextStyle(
                           fontWeight: FontWeight.w300,
                           color: Colors.blue,
                         decoration: TextDecoration.underline
                       ),),
                     ),
                     height(0),
                     if(json[index]['services']!=null)
                       ...json[index]['services'].map((e){
                         return Padding(
                           padding: const EdgeInsets.only(top: 5),
                           child: Text('- ${e}'),
                         );
                       }),
                     if(json[index]['services']!=null)
                       height(5),
                     Text('نريد إبلاغ مستخدمي هذه الخدمة أن هذه الأطراف الثالثة لديها حق الوصول إلى معلوماتك الشخصية. والسبب هو أداء المهام الموكلة إليهم نيابة عنا. ومع ذلك ، فهم ملزمون بعدم الكشف عن المعلومات أو استخدامها لأي غرض آخر')
                   ],
                 ),
               );
             })
            ],
          ),
        ),
      ),
    );
  }
}
